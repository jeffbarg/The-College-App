//
//  FTStandardizedTestingViewController.h
//  The College App
//
//  Created by Jeffrey Barg on 7/16/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTStandardizedTestingViewController : UITableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end
