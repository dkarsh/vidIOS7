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
    [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=square",friendID];
    NSMutableURLRequest *request =
    [NSMutableURLRequest requestWithURL:[NSURL URLWithString:imageURLString]];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    [self.photoImageView setImageWithURLRequest:request
                               placeholderImage:[UIImage imageNamed:@"heart"]
                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                            self.photoImageView.image = image;
                                        }
                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                        }];
}


@end
