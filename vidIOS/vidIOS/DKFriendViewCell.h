//
//  DKFriendViewCell.h
//  vidIOS
//
//  Created by Daniel Karsh on 1/12/14.
//  Copyright (c) 2014 Daniel Karsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DKFriendViewCell : UICollectionViewCell
@property (nonatomic,copy) returnProjectBlock cellTappedReturnProject ;
- (void)setFriend:(NSString*)friendID;
- (void)waitForTap:(returnProjectBlock)tap;
@end
