//
//  DKNavigationController.m
//  vidIOS
//
//  Created by Daniel Karsh on 1/9/14.
//  Copyright (c) 2014 Daniel Karsh. All rights reserved.
//

#import "DKNavigationController.h"

@interface DKNavigationController ()

@end

@implementation DKNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
//    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"usersFonts" size:13.0f], NSFontAttributeName, nil] forState:UIControlStateNormal];
      
//    NSDictionary *textAttributes = @{ NSFontAttributeName:[UIFont fontWithName:@"STHeitiSC-Light" size:13.0] };
//    [[UINavigationBar appearance] setTitleTextAttributes: textAttributes];
//
    
    for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"  %@", name);
        }
    }

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
