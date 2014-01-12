//
//  DKFirstViewController.m
//  vidIOS
//
//  Created by Daniel Karsh on 1/9/14.
//  Copyright (c) 2014 Daniel Karsh. All rights reserved.
//

#import "DKFirstViewController.h"

@interface DKFirstViewController ()

@end

@implementation DKFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"00_loading_screen"]];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"usersFonts" size:20.0f], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"  %@", name);
        }
    }
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
