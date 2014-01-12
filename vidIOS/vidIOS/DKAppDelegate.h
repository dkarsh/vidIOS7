//
//  DKAppDelegate.h
//  vidIOS
//
//  Created by Daniel Karsh on 1/9/14.
//  Copyright (c) 2014 Daniel Karsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DKAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, readonly) int networkStatus;

@end
