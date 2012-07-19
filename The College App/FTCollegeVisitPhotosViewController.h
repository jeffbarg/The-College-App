//
//  FTCollegeVisitPhotosViewController.h
//  The College App
//
//  Created by Jeffrey Barg on 7/13/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FTCollegeVisitViewController.h"
#import "FTCampusImageViewController.h"

#import "Visit.h"

@interface FTCollegeVisitPhotosViewController : UIViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) Visit *visit;
@property (nonatomic, strong) FTCollegeVisitViewController * visitViewController;

@end
