//
//  FTCampusNotesViewController.h
//  The College App
//
//  Created by Jeffrey Barg on 7/31/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FTCollegeVisitingViewController.h"

@interface FTCampusNotesViewController : UIViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) FTCollegeVisitingViewController *visitViewController;

@property (nonatomic, strong) UITextView *textView;

@end
