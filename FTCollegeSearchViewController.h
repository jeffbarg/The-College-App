//
//  FTCollegeListViewController.h
//  The College App
//
//  Created by Jeffrey Barg on 7/6/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMGridView.h"

@interface FTCollegeSearchViewController : UIViewController <UISplitViewControllerDelegate, NSFetchedResultsControllerDelegate, GMGridViewDataSource, GMGridViewActionDelegate, GMGridViewSortingDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, strong) UISearchBar *searchBar;

@end
