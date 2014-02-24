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
    layer.cornerRadius = 14.0f;
    layer.masksToBounds = YES;
    self.photoImageView.image = nil;
    [self.photoImageView setImageWithURLRequest:request
                               placeholderImage:nil
                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                            self.photoImageView.image = image;
                                        }
                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                        }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
{
    NSLog(@"touchME");
}


@end
