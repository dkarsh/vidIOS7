//
//  DKMyCollectionCell.h
//  vidIOS
//
//  Created by Daniel Karsh on 2/22/14.
//  Copyright (c) 2014 Daniel Karsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DKMyCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *allInvitesCollection;
@property (weak, nonatomic) IBOutlet UILabel *projectLabel;
@property (weak, nonatomic) IBOutlet PFImageView *repImageView;
@property (strong,nonatomic) PFObject *project;
@property (nonatomic,copy) returnProjectBlock cellTappedReturnProject ;
-(void)waitForTap:(returnProjectBlock)tap;
@end
