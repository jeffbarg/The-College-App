//
//  FTSearchNearbySchoolsViewController.h
//  The College App
//
//  Created by Jeffrey Barg on 8/15/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FTCollegeVisitingViewController;

@interface FTSearchNearbySchoolsViewController : UITableViewController

@property (nonatomic, strong) FTCollegeVisitingViewController *visitViewController;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
