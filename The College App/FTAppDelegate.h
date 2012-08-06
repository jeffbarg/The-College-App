//
//  FTAppDelegate.h
//  The College App
//
//  Created by Jeffrey Barg on 7/6/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"

@class FTMasterViewController;

@interface FTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void) initializeData;
- (void) configureAppearance;

@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) ECSlidingViewController *slidingViewController;
@property (nonatomic, strong) FTMasterViewController *masterViewController;

@end
