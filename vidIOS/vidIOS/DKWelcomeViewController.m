//
//  DKWellcomViewController.m
//  vidIOS
//
//  Created by Daniel Karsh on 1/10/14.
//  Copyright (c) 2014 Daniel Karsh. All rights reserved.
//

#import "DKWelcomeViewController.h"
#import "DKLogInViewController.h"
#import "MBProgressHUD.h"

@interface DKWelcomeViewController ()
{
    NSMutableData *_data;
    BOOL firstLaunch;
}

@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) NSTimer *autoFollowTimer;

@end

@implementation DKWelcomeViewController
@synthesize hud;
@synthesize autoFollowTimer;

#pragma mark - PFLoginViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // If not logged in, present login view controller
    if (![PFUser currentUser]) {
        [self performSegueWithIdentifier:@"login" sender:nil];
        return;
    }else{
        [self performSegueWithIdentifier:@"cool" sender:nil];
    }
    // Refresh current user with server side data -- checks if user is still valid and so on
//    [[PFUser currentUser] refreshInBackgroundWithTarget:self
//                                               selector:@selector(refreshCurrentUserCallbackWithResult:error:)];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"login"]) {
        DKLogInViewController *loginViewController = segue.destinationViewController;
        [loginViewController setDelegate:self];
        loginViewController.fields = PFLogInFieldsFacebook;
        loginViewController.facebookPermissions = @[ @"user_about_me" ];
    }
}

- (BOOL)shouldProceedToMainInterface:(PFUser *)user
{
    if ([PAPUtility userHasValidFacebookData:[PFUser currentUser]]) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self saveMyImage];
        
        
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
         UIRemoteNotificationTypeAlert|
         UIRemoteNotificationTypeSound];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        return YES;
    }
    return NO;
}

- (void)saveMyImage
{
    NSURL *profilePictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [[PFUser currentUser] objectForKey:kPAPUserFacebookIDKey]]];
    NSURLRequest *profilePictureURLRequest = [NSURLRequest requestWithURL:profilePictureURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f]; // Facebook profile picture cache policy: Expires in 2 weeks
    [NSURLConnection connectionWithRequest:profilePictureURLRequest delegate:self];
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _data = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [PAPUtility processFacebookProfilePictureData:_data];
}

#pragma mark - PFLoginViewController

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    // user has logged in - we need to fetch all of their Facebook data before we let them in
    if (![self shouldProceedToMainInterface:user]) {
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.labelText = NSLocalizedString(@"Loading", nil);
        self.hud.dimBackground = YES;
    }
    
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            [self facebookRequestDidLoad:result];
        } else {
            [self facebookRequestDidFailWithError:error];
        }
    }];
}

- (void)facebookRequestDidLoad:(id)result {
    // This method is called twice - once for the user's /me profile, and a second time when obtaining their friends. We will try and handle both scenarios in a single method.
    PFUser *user = [PFUser currentUser];
    NSArray *data = [result objectForKey:@"data"];
    
    if (data) {
        // we have friends data
        NSMutableArray *facebookIds = [[NSMutableArray alloc] initWithCapacity:[data count]];
        for (NSDictionary *friendData in data) {
            if (friendData[@"id"]) {
                [facebookIds addObject:friendData[@"id"]];
            }
        }
        
        // cache friend data
        [[PAPCache sharedCache] setFacebookFriends:facebookIds];
        
        if (user) {
//            if (![user objectForKey:kPAPUserAlreadyAutoFollowedFacebookFriendsKey]) {
//                self.hud.labelText = NSLocalizedString(@"Following Friends", nil);
//                firstLaunch = YES;
//                
//                [user setObject:@YES forKey:kPAPUserAlreadyAutoFollowedFacebookFriendsKey];
//                NSError *error = nil;
//                
//                // find common Facebook friends already using Anypic
//                PFQuery *facebookFriendsQuery = [PFUser query];
//                [facebookFriendsQuery whereKey:kPAPUserFacebookIDKey containedIn:facebookIds];
//                
//                // auto-follow Parse employees
//                PFQuery *autoFollowAccountsQuery = [PFUser query];
//                [autoFollowAccountsQuery whereKey:kPAPUserFacebookIDKey containedIn:kPAPAutoFollowAccountFacebookIds];
//                
//                // combined query
//                PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:autoFollowAccountsQuery,facebookFriendsQuery, nil]];
//                
//                NSArray *anypicFriends = [query findObjects:&error];
//                
//                if (!error) {
//                    [anypicFriends enumerateObjectsUsingBlock:^(PFUser *newFriend, NSUInteger idx, BOOL *stop) {
//                        PFObject *joinActivity = [PFObject objectWithClassName:kPAPActivityClassKey];
//                        [joinActivity setObject:user forKey:kPAPActivityFromUserKey];
//                        [joinActivity setObject:newFriend forKey:kPAPActivityToUserKey];
//                        [joinActivity setObject:kPAPActivityTypeJoined forKey:kPAPActivityTypeKey];
//                        
//                        PFACL *joinACL = [PFACL ACL];
//                        [joinACL setPublicReadAccess:YES];
//                        joinActivity.ACL = joinACL;
//                        
//                        // make sure our join activity is always earlier than a follow
//                        [joinActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                            [PAPUtility followUserInBackground:newFriend block:^(BOOL succeeded, NSError *error) {
//                                // This block will be executed once for each friend that is followed.
//                                // We need to refresh the timeline when we are following at least a few friends
//                                // Use a timer to avoid refreshing innecessarily
//                                if (self.autoFollowTimer) {
//                                    [self.autoFollowTimer invalidate];
//                                }
//                                
//                                self.autoFollowTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(autoFollowTimerFired:) userInfo:nil repeats:NO];
//                            }];
//                        }];
//                    }];
//                }
//                
//                if (![self shouldProceedToMainInterface:user]) {
//                    [self logOut];
//                    return;
//                }
//                
//                if (!error) {
//                    [MBProgressHUD hideHUDForView:self.view animated:NO];
//                    if (anypicFriends.count > 0) {
//                        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
//                        self.hud.dimBackground = YES;
//                        self.hud.labelText = NSLocalizedString(@"Following Friends", nil);
//                    } else {
////                        [self.homeViewController loadObjects];
//                    }
//                }
//            }
//            [user saveEventually];
        }
        
        else {
            NSLog(@"No user session found. Forcing logOut.");
            [self logOut];
        }
    } else {
        self.hud.labelText = NSLocalizedString(@"Creating Profile", nil);
        
        if (user) {
            NSString *facebookName = result[@"name"];
            if (facebookName && [facebookName length] != 0) {
                [user setObject:facebookName forKey:kPAPUserDisplayNameKey];
            } else {
                [user setObject:@"Someone" forKey:kPAPUserDisplayNameKey];
            }
            
            NSString *facebookId = result[@"id"];
            if (facebookId && [facebookId length] != 0) {
                [user setObject:facebookId forKey:kPAPUserFacebookIDKey];
            }
            
            [user saveEventually];
        }
        
        [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                [self facebookRequestDidLoad:result];
            } else {
                [self facebookRequestDidFailWithError:error];
            }
        }];
    }
}

- (void)autoFollowTimerFired:(NSTimer *)aTimer {
//    [MBProgressHUD hideHUDForView:self.navController.presentedViewController.view animated:YES];
//    [MBProgressHUD hideHUDForView:self.homeViewController.view animated:YES];
//    [self.homeViewController loadObjects];
}



- (void)facebookRequestDidFailWithError:(NSError *)error {
    NSLog(@"Facebook error: %@", error);
    
    if ([PFUser currentUser]) {
        if ([[error userInfo][@"error"][@"type"] isEqualToString:@"OAuthException"]) {
            NSLog(@"The Facebook token was invalidated. Logging out.");
            [self logOut];
        }
    }
}


- (void)logOut {
    // clear cache
    [[PAPCache sharedCache] clear];
    
    // clear NSUserDefaults
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPAPUserDefaultsCacheFacebookFriendsKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPAPUserDefaultsActivityFeedViewControllerLastRefreshKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Unsubscribe from push notifications by removing the user association from the current installation.
    [[PFInstallation currentInstallation] removeObjectForKey:kPAPInstallationUserKey];
    [[PFInstallation currentInstallation] saveInBackground];
    
    // Clear all caches
    [PFQuery clearAllCachedResults];
    
    // Log out
    [PFUser logOut];
    
    // clear out cached data, view controllers, etc
//    [self.navController popToRootViewControllerAnimated:NO];
//    
//    [self presentLoginViewController];
//    
//    self.homeViewController = nil;
//    self.activityViewController = nil;
}


#pragma mark - ()

- (void)refreshCurrentUserCallbackWithResult:(PFObject *)refreshedObject error:(NSError *)error {
    // A kPFErrorObjectNotFound error on currentUser refresh signals a deleted user
    if (error && error.code == kPFErrorObjectNotFound) {
        NSLog(@"User does not exist.");
        [self logOut];
        return;
    }
    
    // Check if user is missing a Facebook ID
    if ([PAPUtility userHasValidFacebookData:[PFUser currentUser]]) {
        // User has Facebook ID.
        
        // refresh Facebook friends on each launch
        [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                [self facebookRequestDidLoad:result];
            }else{
                [self facebookRequestDidFailWithError:error];
            }
        }];
    } else {
        NSLog(@"Current user is missing their Facebook ID");
        [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                [self facebookRequestDidLoad:result];
            }else{
                [self facebookRequestDidFailWithError:error];
            }
        }];
    }
}





- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
