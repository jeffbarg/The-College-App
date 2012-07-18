//
//  FTCollegeVisitViewController.h
//  The College App
//
//  Created by Jeffrey Barg on 7/12/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class College;

@interface FTCollegeVisitViewController : UIViewController

@property (nonatomic, strong) College *school;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
