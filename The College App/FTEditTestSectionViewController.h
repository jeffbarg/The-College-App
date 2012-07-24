//
//  FTEditTestSectionViewController.h
//  The College App
//
//  Created by Jeffrey Barg on 7/23/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FTStandardizedTestView;
@class TestSection;

@interface FTEditTestSectionViewController : UIViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, weak) UIButton *button;
@property (nonatomic, weak) FTStandardizedTestView *testView;
@property (nonatomic, weak) TestSection *testSection;
@property (nonatomic, weak) UIPopoverController *pController;

@end

