//
//  DKMyCollectionController.m
//  vidIOS
//
//  Created by Daniel Karsh on 2/22/14.
//  Copyright (c) 2014 Daniel Karsh. All rights reserved.
//

#import "DKMyCollectionController.h"

@interface DKMyCollectionController ()
@property (nonatomic,strong) NSArray *allMyProjects;
@end

@implementation DKMyCollectionController



- (void)viewDidLoad
{
    [super viewDidLoad];
    PFQuery *iQuery = [PFQuery queryWithClassName:@"wedeeoProject"];
    [iQuery whereKey:@"creator" equalTo:[PFUser currentUser]];
    
    PFQuery *anotherQuery = [PFQuery queryWithClassName:@"wedeeoProject"];
    NSString *myFBid      = [[PFUser currentUser] objectForKey:kPAPUserFacebookIDKey];
    
    [anotherQuery whereKey:@"invitingFriends" equalTo:myFBid];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[iQuery,anotherQuery]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            self.allMyProjects = objects;
            [self.collectionView reloadData];
            
            // The find succeeded.
            NSLog(@"Successfully retrieved %d scores.", objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

	// Do any additional setup after loading the view.
}

#pragma mark - UICollectionView Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    int a = self.allMyProjects.count;
    
    return a;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // Always one extra cell for the "add" cell
//    NSMutableArray *sectionColorNames = self.allMyProjects[section];
//    return sectionColorNames.count + 1;
    return 1;
}


- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView * view = nil;
    
    PFObject *obj = self.allMyProjects[indexPath.section];
    NSString *name = [obj objectForKey:@"projectName"];
    
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        UICollectionReusableView *header =
        [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                           withReuseIdentifier:@"header"
                                                  forIndexPath:indexPath];

        UILabel *lable;
        if ([header viewWithTag:10])
        {
           lable =(UILabel *)[header viewWithTag:10];
            
        }else{
            lable = [[UILabel alloc]init];
            lable.tag = 10;
            [header addSubview:lable];
        }
        
        lable.text = name;
        
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
//        ColorSectionFooterView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
//                                                                            withReuseIdentifier:NSStringFromClass([ColorSectionFooterView class])
//                                                                                   forIndexPath:indexPath];
//        footer.sectionIndex = indexPath.section;
//        footer.delegate = self;
//        view = footer;
    }
    
    return view;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UICollectionViewCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    PFObject *obj = self.allMyProjects[indexPath.section];
    NSString *name = [[obj objectForKey:@"projectName"]uppercaseString];
    UILabel *lable;
    if ([cell viewWithTag:10])
    {
        lable =(UILabel *)[cell viewWithTag:10];
        
    }else{
        lable = [[UILabel alloc]init];
        lable.tag = 10;
        [cell addSubview:lable];
    }
    
    lable.text = name;

//    [cell.contentView addSubview:label];
    
//    NSArray *colorNames = self.sectionedColorNames[indexPath.section];
//    if (indexPath.row == colorNames.count)
//    {
//        cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([AddCell class])
//                                                         forIndexPath:indexPath];
//    }
//    else
//    {
//        ColorNameCell *cnCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ColorNameCell class])
//                                                                          forIndexPath:indexPath];
//        cnCell.colorName = colorNames[indexPath.item];
//        cell = cnCell;
//    }
    
    return cell;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
