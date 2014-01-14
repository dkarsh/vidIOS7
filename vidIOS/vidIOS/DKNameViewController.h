//
//  DKNameViewController.h
//  vidIOS
//
//  Created by Daniel Karsh on 1/12/14.
//  Copyright (c) 2014 Daniel Karsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DKNameViewController : UIViewController
<UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate>


@property (weak, nonatomic) IBOutlet PFImageView *profileImage;
@property (weak, nonatomic) IBOutlet UITextField *videoNameTextField;
@property (weak, nonatomic) IBOutlet UICollectionView *friendsCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *invitedCollectionView;


@end
