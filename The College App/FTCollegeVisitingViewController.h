//
//  FTCollegeVisitingViewController.h
//  The College App
//
//  Created by Jeffrey Barg on 7/31/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class College;
@class Visit;

@interface FTCollegeVisitingViewController : UIViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) College *school;
@property (nonatomic, strong) Visit *visit;

@property (nonatomic, strong) UIPopoverController * masterPopoverController;

@end
