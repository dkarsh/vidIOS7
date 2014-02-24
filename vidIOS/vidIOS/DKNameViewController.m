//
//  DKNameViewController.m
//  vidIOS
//
//  Created by Daniel Karsh on 1/12/14.
//  Copyright (c) 2014 Daniel Karsh. All rights reserved.
//

#import "DKNameViewController.h"
#import "DKFriendViewCell.h"

@interface DKNameViewController ()

@property (nonatomic,strong) NSMutableArray *allMyFriends;
@property (nonatomic,strong) NSMutableArray *invitingFriends;

@end

@implementation DKNameViewController
@synthesize profileImage;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.topItem.title = @"";
    self.allMyFriends = [NSMutableArray arrayWithArray:[[PAPCache sharedCache] facebookFriends]];
    self.invitingFriends = [NSMutableArray array];
    
    PFFile *imageFile = [[PFUser currentUser] objectForKey:kPAPUserProfilePicMediumKey];
    PFImageView *repImageView = [[PFImageView alloc]initWithFrame:profileImage.frame];

    CALayer *layer = [repImageView layer];
    layer.cornerRadius = 14.0f;
    layer.masksToBounds = YES;
    
    [self.view addSubview:repImageView];
    if (imageFile) {
        [repImageView setFile:imageFile];
        [repImageView loadInBackground:^(UIImage *image, NSError *error) {
            if (!error) {
                [UIView animateWithDuration:0.200f animations:^{
                    //                    profilePictureBackgroundView.alpha = 1.0f;
                    //                    profilePictureStrokeImageView.alpha = 1.0f;
                    //                    profilePictureImageView.alpha = 1.0f;
                }];
            }
        }];
    }

	// Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self performSegueWithIdentifier:@"saveStart" sender:nil];
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PFObject *wedeeoObject = [PFObject objectWithClassName:@"wedeeoProject"];
    [wedeeoObject setObject:self.invitingFriends            forKey:@"invitingFriends"];
    [wedeeoObject setObject:[PFUser currentUser]            forKey:@"creator"];
    [wedeeoObject setObject:self.videoNameTextField.text    forKey:@"projectName"];
//    segue.destinationViewController 
    [wedeeoObject saveEventually:^(BOOL succeeded, NSError *error) {
        
    }];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    int n = 0;
    if (collectionView == _friendsCollectionView) {
        n = [self.allMyFriends count];
    }
    
    if (collectionView == _invitedCollectionView) {
        n = [self.invitingFriends count];
    }
    return n;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier =@"Cell";
    
    DKFriendViewCell *cell =
    (DKFriendViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier
                                                                  forIndexPath:indexPath];
    
    NSString *facebookID;
    if (collectionView == _friendsCollectionView) {
        facebookID = [self.allMyFriends objectAtIndex:indexPath.row];
    }
    if (collectionView == _invitedCollectionView) {
       facebookID = [self.invitingFriends  objectAtIndex:indexPath.row];
    }

    [cell setFriend:facebookID];
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *facebookID;
    if (collectionView == _friendsCollectionView) {
        facebookID = [self.allMyFriends objectAtIndex:indexPath.row];
        [self.allMyFriends removeObjectAtIndex:indexPath.row];
        [self.invitingFriends addObject:facebookID];
        [self.friendsCollectionView reloadData];
        [self.invitedCollectionView reloadData];
        NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:self.invitingFriends.count-1 inSection:0];
        [self.invitedCollectionView selectItemAtIndexPath:lastIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionLeft];
    }
    return YES;
}
@end
