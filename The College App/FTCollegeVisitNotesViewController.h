//
//  FTCollegeVisitNotesViewController.h
//  The College App
//
//  Created by Jeffrey Barg on 7/13/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FTCollegeVisitViewController.h"

#import "Visit.h"

@interface FTCollegeVisitNotesViewController : UIViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) FTCollegeVisitViewController *visitViewController;

@property (nonatomic, strong) Visit *visit;

@end
