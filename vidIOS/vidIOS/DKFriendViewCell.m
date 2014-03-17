//
//  DKFriendViewCell.m
//  vidIOS
//
//  Created by Daniel Karsh on 1/12/14.
//  Copyright (c) 2014 Daniel Karsh. All rights reserved.
//

#import "DKFriendViewCell.h"
#import "UIImageView+AFNetworking.h"


@interface DKFriendViewCell ()
@property(nonatomic, weak) IBOutlet UIImageView *photoImageView;
@end

@implementation DKFriendViewCell

- (void) setFriend:(NSString*)friendID
{
    NSString *imageURLString  =
    [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=200&height=200",friendID];
    NSMutableURLRequest *request =
    [NSMutableURLRequest requestWithURL:[NSURL URLWithString:imageURLString]];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
  
    CALayer *layer = [_photoImageView layer];
    
    
    CALayer *rightBorder = [CALayer layer];
    rightBorder.borderColor = [UIColor blackColor].CGColor;//[UIColor colorWithRed:7/256.f green:159/256.f blue:117/256.f alpha:100].CGColor;
    rightBorder.borderWidth = 1;
    rightBorder.frame = CGRectMake(0, 0, CGRectGetWidth(_photoImageView.frame), CGRectGetHeight(_photoImageView.frame));
    rightBorder.cornerRadius = 14.0f;
    rightBorder.borderWidth = 1.f;
    layer.cornerRadius = 14.0f;
    layer.masksToBounds = YES;
    [layer addSublayer:rightBorder];
    
    self.photoImageView.image = nil;
    [self.photoImageView setImageWithURLRequest:request
                               placeholderImage:nil
                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                            self.photoImageView.image = image;
                                        }
                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                        }];
}

-(void)waitForTap:(returnProjectBlock)tap
{
    _cellTappedReturnProject = tap;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
{
    _cellTappedReturnProject(nil);
}


@end
