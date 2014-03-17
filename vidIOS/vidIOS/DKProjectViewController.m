//
//  DKProjectViewController.m
//  vidIOS
//
//  Created by Daniel Karsh on 3/12/14.
//  Copyright (c) 2014 Daniel Karsh. All rights reserved.
//

#import "DKProjectViewController.h"
#import "DKRecorderViewController.h"

@interface DKProjectViewController ()
@end

@implementation DKProjectViewController
@synthesize project;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setProject:(PFObject *)nproject
{
    project = nproject;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [(DKRecorderViewController*)segue.destinationViewController setProject:project];
}



@end
