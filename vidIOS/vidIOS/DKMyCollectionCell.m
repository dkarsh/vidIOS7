//
//  DKMyCollectionCell.m
//  vidIOS
//
//  Created by Daniel Karsh on 2/22/14.
//  Copyright (c) 2014 Daniel Karsh. All rights reserved.
//

#import "DKMyCollectionCell.h"
#import "DKFriendViewCell.h"

@implementation DKMyCollectionCell
@synthesize project;
@synthesize repImageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setProject:(PFObject *)tproject
{
    project = tproject;
    PFUser *creator = [project objectForKey:@"creator"];
    [creator fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        PFFile *imageFile = [object objectForKey:kPAPUserProfilePicMediumKey];

        CALayer *layer = [repImageView layer];
        layer.cornerRadius = 14.0f;
        layer.masksToBounds = YES;

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
        
    }];


}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    int n = [[project objectForKey:kPAInvitingFriends]count];
    return n;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier =@"nCell";
    
    DKFriendViewCell *cell =
    (DKFriendViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier
                                                                  forIndexPath:indexPath];
    
    NSString *facebookID = [[project objectForKey:kPAInvitingFriends] objectAtIndex:indexPath.row];
    [cell setFriend:facebookID];
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
//    NSString *facebookID;
//    if (collectionView == _friendsCollectionView) {
//        facebookID = [self.allMyFriends objectAtIndex:indexPath.row];
//        [self.allMyFriends removeObjectAtIndex:indexPath.row];
//        [self.invitingFriends addObject:facebookID];
//        [self.friendsCollectionView reloadData];
//        [self.invitedCollectionView reloadData];
//        NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:self.invitingFriends.count-1 inSection:0];
//        [self.invitedCollectionView selectItemAtIndexPath:lastIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionLeft];
//    }
    return YES;
}


@end
