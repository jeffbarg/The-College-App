//
//  FTCollegeVisitRatingsViewController.h
//  The College App
//
//  Created by Jeffrey Barg on 7/13/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Visit.h"

@interface FTCollegeVisitRatingsViewController : UITableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) Visit * visit;

@end
