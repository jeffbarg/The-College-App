//
//  FTAppDelegate.m
//  The College App
//
//  Created by Jeffrey Barg on 7/6/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import "FTAppDelegate.h"
#import "FTMasterViewController.h"
#import "FTCollegeSearchViewController.h"
#import "SBJson.h"
#import "InitialSlidingViewController.h"

#import "College.h"
#import "StandardizedTest.h"
#import "TestSection.h"


@implementation FTAppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize navigationController = _navigationController;
@synthesize slidingViewController = _slidingViewController;

@synthesize masterViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupAmazon];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"FIRST_TIME"] == nil)
        [self initializeData];
    [self configureAppearance];
    [self setupUUID];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    masterViewController = [[FTMasterViewController alloc] initWithStyle:UITableViewStylePlain];
    
    UINavigationController *masterNavigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
    
    FTCollegeSearchViewController *detailViewController = [[FTCollegeSearchViewController alloc] init];
    [detailViewController setManagedObjectContext:self.managedObjectContext];
    
    UINavigationController *detailNavigationController = [[UINavigationController alloc] initWithRootViewController:detailViewController];

    masterViewController.detailViewController = detailViewController;
    
    self.slidingViewController = [[InitialSlidingViewController alloc] init];
    self.slidingViewController.topViewController = detailNavigationController;

    
    self.window.rootViewController = self.slidingViewController;

    masterViewController.managedObjectContext = self.managedObjectContext;
    

    
    [self.window makeKeyAndVisible];

    self.slidingViewController.underLeftViewController = masterNavigationController;

    [self.slidingViewController setAnchorRightRevealAmount:INTERFACE_IS_PAD?280:260];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
    
    NSNotificationCenter *notifCenter = [NSNotificationCenter defaultCenter];
    [notifCenter addObserver:self selector:@selector(didShowMenu) name:ECSlidingViewTopDidAnchorRight object:nil];
    [notifCenter addObserver:self selector:@selector(didDismissMenu) name:ECSlidingViewTopDidReset object:nil];
    
     
    detailViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"] landscapeImagePhone:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStyleDone target:masterViewController action:@selector(slideLeft)];
    
    if (INTERFACE_IS_PAD)
        [detailNavigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"whitenavbar.png"] forBarMetrics:UIBarMetricsDefault];
    else {
        [detailNavigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"blacknavbar.png"] forBarMetrics:UIBarMetricsDefault];
    }
    detailNavigationController.view.backgroundColor = kViewBackgroundColor;
    detailNavigationController.view.layer.shadowOpacity = 0.75f;
    detailNavigationController.view.layer.shadowRadius = 10.0f;
    detailNavigationController.view.layer.shadowColor = [UIColor blackColor].CGColor;
    [detailNavigationController.view addGestureRecognizer:self.slidingViewController.panGesture];   
    
    return YES;
}

- (void) configureAppearance {
    [[UIBarButtonItem appearance] setBackgroundImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackgroundImage:[UIImage imageNamed:@"cancelactive.png"] forState:UIControlStateHighlighted    barMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[[UIImage imageNamed:@"backbutton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 14.0, 0.0, 5.0)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[[UIImage imageNamed:@"backselect.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 14.0, 0.0, 5.0)] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"blacknavbar.png"] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor colorWithWhite:0.2 alpha:1.0], UITextAttributeTextColor,
                                                                     [UIColor whiteColor], UITextAttributeTextShadowColor,
                                                                     [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                                                     nil]];
}

- (void) didShowMenu {
    [self.slidingViewController.topViewController.view addGestureRecognizer:self.slidingViewController.panGesture];
    [masterViewController.detailViewController.navigationController.navigationBar removeGestureRecognizer:self.slidingViewController.panGesture];

}

- (void) didDismissMenu {
    [self.slidingViewController.topViewController.view removeGestureRecognizer:self.slidingViewController.panGesture];
    [masterViewController.detailViewController.navigationController.navigationBar addGestureRecognizer:self.slidingViewController.panGesture];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Data Initialization

- (void) setupAmazon {
    // Logging Control - Do NOT use logging for non-development builds.

}

- (void) setupUUID {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:kUUIDKeyDefaults] == nil) {
        CFUUIDRef theUUID = CFUUIDCreate(NULL);
        CFStringRef string = CFUUIDCreateString(NULL, theUUID);
        CFRelease(theUUID);
        NSString * newUUID =  (__bridge_transfer NSString *)string;
        
        [defaults setValue:newUUID forKey:kUUIDKeyDefaults];

        [defaults synchronize];
    }
}

- (void) initializeData {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@"OVER" forKey:@"FIRST_TIME"];
    [defaults synchronize];
    
    for (int i = 0; i < 3; i ++) {
        StandardizedTest *sat = [NSEntityDescription insertNewObjectForEntityForName:@"StandardizedTest" inManagedObjectContext:self.managedObjectContext];
        [sat setSectionPriority:[NSNumber numberWithInt:2000]];
        [sat setDateTaken:[NSDate date]];
        [sat setType:@"SAT"];
        [sat setHasComposite:[NSNumber numberWithBool:NO]];
        

            TestSection *section = [NSEntityDescription insertNewObjectForEntityForName:@"TestSection" inManagedObjectContext:self.managedObjectContext];
            [section setSectionName:@"Math"];
            [section setScore:[NSNumber numberWithInt:760]];
            [section setMinScore:[NSNumber numberWithInteger:200]];
            [section setMaxScore:[NSNumber numberWithInteger:800]];
            
            [section setStandardizedTest:sat];

        section = [NSEntityDescription insertNewObjectForEntityForName:@"TestSection" inManagedObjectContext:self.managedObjectContext];
        [section setSectionName:@"Critical Reading"];
        [section setScore:[NSNumber numberWithInt:710]];
        [section setMinScore:[NSNumber numberWithInteger:200]];
        [section setMaxScore:[NSNumber numberWithInteger:800]];
        
        [section setStandardizedTest:sat];
        
        TestSection *section3 = [NSEntityDescription insertNewObjectForEntityForName:@"TestSection" inManagedObjectContext:self.managedObjectContext];
        [section3 setSectionName:@"Writing"];
        [section3 setScore:[NSNumber numberWithInt:720]];
        [section3 setMinScore:[NSNumber numberWithInteger:200]];
        [section3 setMaxScore:[NSNumber numberWithInteger:800]];
        
        [section3 setStandardizedTest:sat];
    }
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    NSError *err = nil;
    NSString *str = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"collegedatajuly12" ofType:@"json"] encoding:NSUTF8StringEncoding error:&err];
    if(err) {
        NSLog(@"%@", [err description]);
    }
    NSArray *objects = (NSArray *)[parser objectWithString:str];
    NSLog(@"%@", [objects objectAtIndex:500]);
    
    for (NSDictionary *dict in objects) {
        
        if ([extractStringFromDict(@"instnm", dict) isEqualToString:@""] || [[dict valueForKey:@"year"] isEqual:@"0"] || [[dict valueForKey:@"year"] isEqual:@""]) continue;
        
        if([[extractStringFromDict(@"instnm", dict) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) 
            continue;
        
        College *school = [NSEntityDescription insertNewObjectForEntityForName:@"College" inManagedObjectContext:self.managedObjectContext];
        
        [school setName:extractStringFromDict(@"instnm", dict)];
        [school setUnitID:extractIntegerFromDict(@"unitid", dict)];

        
        [school setUndergraduatePopulation:extractIntegerFromDict(@"drvef122011.undupug:VL-12-month unduplicated headcount- undergraduate: 2010-11", dict)];
        
        [school setApplicationFee:extractIntegerFromDict(@"ic2011.applfeeu:VL-Undergraduate application fee", dict)];
        
        [school setTuitionAndFees:extractIntegerFromDict(@"drvic2011.tufeyr3:VL-Tuition and fees- 2011-12", dict)];
        [school setStreetAddress:extractStringFromDict(@"hd2011.addr:VL-Street address or post office box", dict)];
        [school setTotalPriceInState:extractIntegerFromDict(@"drvic2011.cinson:VL-Total price for in-state students living on campus 2011-12", dict)];
        [school setTotalPriceOutState:extractIntegerFromDict(@"drvic2011.cotson:VL-Total price for out-of-state students living on campus 2011-12", dict)];

        [school setEnrolledMen:extractIntegerFromDict(@"ic2011.enrlm:VL-Enrolled  men", dict)];
        [school setEnrolledWomen:extractIntegerFromDict(@"ic2011.enrlw:VL-Enrolled  women", dict)];
        [school setEnrolledTotal:extractIntegerFromDict(@"ic2011.enrlt:VL-Enrolled total", dict)];
        
        [school setApplicantsTotal:extractIntegerFromDict(@"ic2011.applcn:VL-Applicants total", dict)];
        [school setAdmissionsTotal:extractIntegerFromDict(@"ic2011.admssn:VL-Admissions total", dict)];
        
        [school setAdmissionsInternetAddress:extractStringFromDict(@"hd2011.adminurl:VL-Admissions office web address", dict)];
        [school setInternetAddress:extractStringFromDict(@"hd2011.webaddr:VL-Institution^s internet website address", dict)];
        [school setFinancialAidInternetAddress:extractStringFromDict(@"hd2011.faidurl:VL-Financial aid office web address", dict)];
        [school setOnlineApplicationInternetAddress:extractStringFromDict(@"hd2011.applurl:VL-Online application web address", dict)];
        [school setMissionStatementInternetAddress:extractStringFromDict(@"ic2011mission.missionurl:VL-Mission statement URL (if mission statement not provided)", dict)];
        
        [school setCompositeACT25:extractIntegerFromDict(@"ic2011.actcm25:VL-ACT Composite 25th percentile score", dict)];
        [school setCompositeACT75:extractIntegerFromDict(@"ic2011.actcm75:VL-ACT Composite 75th percentile score", dict)];
        
        [school setMathSAT25:extractIntegerFromDict(@"ic2011.satmt25:VL-SAT Math 25th percentile score", dict)];
        [school setMathSAT75:extractIntegerFromDict(@"ic2011.satmt75:VL-SAT Math 75th percentile score", dict)];
        [school setReadingSAT25:extractIntegerFromDict(@"ic2011.satvr25:VL-SAT Critical Reading 25th percentile score", dict)];
        [school setReadingSAT75:extractIntegerFromDict(@"ic2011.satvr75:VL-SAT Critical Reading 75th percentile score", dict)];
        [school setWritingSAT25:extractIntegerFromDict(@"ic2011.satwr25:VL-SAT Writing 25th percentile score", dict)];
        [school setWritingSAT75:extractIntegerFromDict(@"ic2011.satwr75:VL-SAT Writing 75th percentile score", dict)];
        
        [school setCalendarSystem:extractStringFromDict(@"ic2011.calsys:VL-Calendar system", dict)];
        
        [school setHasROTC:extractBooleanFromDict(@"ic2011.slo5:VL-ROTC", dict)];
        [school setOpenAdmissionPolicy:extractBooleanFromDict(@"ic2011.openadmp:VL-Open admission policy", dict)];
        
        [school setLat:extractDoubleFromDict(@"hd2011.latitude:VL-Latitude location of institution", dict)];
        [school setLon:extractDoubleFromDict(@"hd2011.longitud:VL-Longitude location of institution", dict)];
        
        [school setCity:extractStringFromDict(@"hd2011.city:VL-City location of institution", dict)];
        [school setStateAbbreviation:extractStringFromDict(@"hd2011.stabbr:VL-State abbreviation", dict)];
        [school setZipcode:extractIntegerFromDict(@"hd2011.zip:VL-ZIP code", dict)];
        
        
        //Calculated Values
        
        NSInteger sum = 0;
        sum += [[school mathSAT25] integerValue] + [[school mathSAT75] integerValue];
        sum += [[school readingSAT25] integerValue] + [[school readingSAT75] integerValue];
        sum += [[school writingSAT25] integerValue] + [[school writingSAT75] integerValue];
        
        [school setCombinedSATAverage:[NSNumber numberWithInteger:sum/2]];
    }
    
    err = nil;
    [self.managedObjectContext save:&err];
    
    if (err) {
        NSLog(@"%@", [err localizedDescription]);
    }
}

NSNumber * extractIntegerFromDict(NSString *key, NSDictionary * dict) {
    NSInteger val = [[dict valueForKey:key] integerValue];
    return [[NSNumber alloc] initWithInteger:val];
}

NSNumber * extractDoubleFromDict (NSString *key, NSDictionary * dict) {
    double val = [[dict valueForKey:key] doubleValue];
    return [[NSNumber alloc] initWithDouble:val];
}

NSNumber * extractBooleanFromDict (NSString *key, NSDictionary * dict) {
    BOOL val = [[dict valueForKey:key] boolValue];
    return [[NSNumber alloc] initWithBool:val];
}


NSString * extractStringFromDict(NSString *key, NSDictionary * dict) {
    NSObject *obj = (NSObject *)[dict objectForKey:key];

    if (obj == [NSNull null])
        return @"";
    
    return [((NSString *)obj) copy];
}
                                                    
#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"The_College_App" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"The_College_App.sqlite"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // If the expected store doesn’t exist, copy the default store.
    if (![fileManager fileExistsAtPath:[storeURL absoluteString]]) {

        
        //        NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"CoreData" ofType:@"sqlite"];
//        if (defaultStorePath) {
//            [fileManager copyItemAtPath:defaultStorePath toPath:[storeURL absoluteString] error:NULL];
//        }
    }
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */

        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
