//
//  DKMyCollectionController.m
//  vidIOS
//
//  Created by Daniel Karsh on 2/22/14.
//  Copyright (c) 2014 Daniel Karsh. All rights reserved.
//

#import "DKMyCollectionController.h"
#import "DKMyCollectionCell.h"

@interface DKMyCollectionController ()
@property (nonatomic,strong) NSArray *allMyProjects;
@end

@implementation DKMyCollectionController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.view.backgroundColor =
    
    PFQuery *iQuery = [PFQuery queryWithClassName:@"wedeeoProject"];
    [iQuery whereKey:@"creator" equalTo:[PFUser currentUser]];
    
    PFQuery *anotherQuery = [PFQuery queryWithClassName:@"wedeeoProject"];
    NSString *myFBid      = [[PFUser currentUser] objectForKey:kPAPUserFacebookIDKey];
    
    [anotherQuery whereKey:@"invitingFriends" equalTo:myFBid];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[iQuery,anotherQuery]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            self.allMyProjects = objects;
            [self.collectionView reloadData];
            
            // The find succeeded.
            NSLog(@"Successfully retrieved %d scores.", objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

	// Do any additional setup after loading the view.
}

#pragma mark - UICollectionView Data Source

//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
//{
//    int a = self.allMyProjects.count;
//    return a;
//}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    int a = self.allMyProjects.count;
    return a;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"ShowProject" sender:self];
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    DKMyCollectionCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    PFObject *obj = self.allMyProjects[indexPath.row];
    NSString *name = [[obj objectForKey:@"projectName"]capitalizedString];
    cell.projectLabel.text = name;
    [cell setProject:obj];
    return cell;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
