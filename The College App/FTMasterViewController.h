//
//  FTMasterViewController.h
//  The College App
//
//  Created by Jeffrey Barg on 7/6/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTMasterViewController : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) UIViewController<UISplitViewControllerDelegate> *detailViewController;

- (void) initializeData;

@end
