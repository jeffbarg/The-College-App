//
//  FTCampusRatingsViewController.h
//  The College App
//
//  Created by Jeffrey Barg on 7/31/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FTCollegeVisitingViewController.h"

#import "Visit.h"

@interface FTCampusRatingsViewController : UITableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) FTCollegeVisitingViewController *visitViewController;
@property (nonatomic, strong) Visit *visit;

@end
