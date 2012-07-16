//
//  FTCollegeVisitViewController.m
//  The College App
//
//  Created by Jeffrey Barg on 7/12/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import "FTCollegeVisitViewController.h"
#import "KSCustomPopoverBackgroundView.h"
#import "College.h"

#import "FTCollegeVisitNotesViewController.h"
#import "FTCollegeVisitPhotosViewController.h"
#import "FTCollegeVisitRatingsViewController.h"

#import <CoreLocation/CoreLocation.h>

#define kLatRadius 0.5
#define kLonRadius 0.5

@interface FTCollegeVisitViewController () {
    
}

@property (nonatomic, strong) UIPopoverController *masterPopoverController;

@property (nonatomic, strong) FTCollegeVisitNotesViewController *notesViewController;
@property (nonatomic, strong) FTCollegeVisitPhotosViewController *photosViewController;
@property (nonatomic, strong) FTCollegeVisitRatingsViewController *ratingsViewController;

@property (nonatomic, strong) UIView *notesView;
@property (nonatomic, strong) UIView *photosView;
@property (nonatomic, strong) UIView *ratingsView;

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *bestEffortAtLocation;

@property (nonatomic, strong) NSArray *nearbySchools;

- (void)stopUpdatingLocation:(NSString *)state;

@end

@implementation FTCollegeVisitViewController

@synthesize managedObjectContext;
@synthesize masterPopoverController = _masterPopoverController;

@synthesize notesViewController = _notesViewController;
@synthesize photosViewController = _photosViewController;
@synthesize ratingsViewController = _ratingsViewController;

@synthesize photosView = _photosView;
@synthesize ratingsView = _ratingsView;
@synthesize notesView = _notesView;

@synthesize bestEffortAtLocation;
@synthesize locationManager;

@synthesize nearbySchools = _nearbySchools;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    CLLocationManager *manager = [[CLLocationManager alloc] init];

    manager.delegate = self;
    manager.desiredAccuracy = kCLLocationAccuracyBest;

    self.locationManager = manager;
    
    [locationManager startUpdatingLocation];
    
    _photosView = [[UIView alloc] initWithFrame:CGRectZero];
    _ratingsView = [[UIView alloc] initWithFrame:CGRectZero];
    _notesView = [[UIView alloc] initWithFrame:CGRectZero];

    [self.view addSubview:self.photosView];
    [self.view addSubview:self.ratingsView];
    [self.view addSubview:self.notesView];
    
    
    _photosViewController = [[FTCollegeVisitPhotosViewController alloc] init];
    [self.photosViewController willMoveToParentViewController:self];
    [self addChildViewController:self.photosViewController];
    [self.photosView addSubview:self.photosViewController.view];
    [self.photosViewController.view setFrame:CGRectZero];
    [self.photosViewController.view setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [self.photosViewController didMoveToParentViewController:self];
    
    _ratingsViewController = [[FTCollegeVisitRatingsViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.ratingsViewController willMoveToParentViewController:self];
    [self addChildViewController:self.ratingsViewController];
    [self.ratingsView addSubview:self.ratingsViewController.tableView];
    [self.ratingsViewController.view setFrame:CGRectZero];
    //[self.ratingsViewController.view setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [self.ratingsViewController didMoveToParentViewController:self];

    _ratingsViewController = [[FTCollegeVisitRatingsViewController alloc] init];
    [self.ratingsViewController willMoveToParentViewController:self];
    [self addChildViewController:self.ratingsViewController];
    [self.ratingsView addSubview:self.ratingsViewController.view];
    [self.ratingsViewController.view setFrame:CGRectZero];
    [self.ratingsViewController.view setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [self.ratingsViewController didMoveToParentViewController:self];
    
    _notesViewController = [[FTCollegeVisitNotesViewController alloc] init];
    [self.notesViewController willMoveToParentViewController:self];
    [self addChildViewController:self.notesViewController];
    [self.notesView addSubview:self.notesViewController.view];
    [self.notesViewController.view setFrame:CGRectZero];
    [self.notesViewController.view setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [self.notesViewController didMoveToParentViewController:self];
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self.photosView setFrame:CGRectMake(0.0, 100.0, self.view.frame.size.width - 320, self.view.frame.size.height - 100.0)];
    
    [self.ratingsView setFrame:CGRectMake(self.view.frame.size.width - 320, 100.0, 320, self.view.frame.size.height / 2.0 - 50.0)];

    [self.notesView setFrame:CGRectMake(self.view.frame.size.width - 320, self.view.frame.size.height / 2.0 + 50.0, 320, self.view.frame.size.height / 2.0 - 50.0)];
}

#pragma mark Location Manager Interactions 

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
}


/*
 * We want to get and store a location measurement that meets the desired accuracy. For this example, we are
 *      going to use horizontal accuracy as the deciding factor. In other cases, you may wish to use vertical
 *      accuracy, or both together.
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    // test the age of the location measurement to determine if the measurement is cached
    // in most cases you will not want to rely on cached measurements
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0) return;
    // test that the horizontal accuracy does not indicate an invalid measurement
    if (newLocation.horizontalAccuracy < 0) return;
    // test the measurement to see if it is more accurate than the previous measurement
    if (bestEffortAtLocation == nil || bestEffortAtLocation.horizontalAccuracy > newLocation.horizontalAccuracy) {
        // store the location as the "best effort"
        self.bestEffortAtLocation = newLocation;
        // test the measurement to see if it meets the desired accuracy
        //
        // IMPORTANT!!! kCLLocationAccuracyBest should not be used for comparison with location coordinate or altitidue 
        // accuracy because it is a negative value. Instead, compare against some predetermined "real" measure of 
        // acceptable accuracy, or depend on the timeout to stop updating. This sample depends on the timeout.
        //
        if (newLocation.horizontalAccuracy <= locationManager.desiredAccuracy) {
            // we have a measurement that meets our requirements, so we can stop updating the location
            // 
            // IMPORTANT!!! Minimize power usage by stopping the location manager as soon as possible.
            //
            [self stopUpdatingLocation:NSLocalizedString(@"Acquired Location", @"Acquired Location")];
            // we can also cancel our previous performSelector:withObject:afterDelay: - it's no longer necessary
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopUpdatingLocation:) object:nil];
        }
    }
    
    // update the display with the new location data
    CGFloat lat = [self.bestEffortAtLocation coordinate].latitude;
    CGFloat lon = [self.bestEffortAtLocation coordinate].longitude;
    
    NSLog(@"%f, %f", lon, lat);
    CGFloat latMax = lat + kLatRadius;
    CGFloat latMin = lat - kLatRadius;
    CGFloat lngMax = lon + kLonRadius;
    CGFloat lngMin = lon - kLonRadius;
    
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"lat > %f and lat < %f and lon > %f and lon < %f",
                              latMin, latMax, lngMin, lngMax];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"College"];
    [request setPredicate:predicate];
    
    [request setFetchLimit:0];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"unitID" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *err = nil;
    NSArray *objects = [self.managedObjectContext executeFetchRequest:request error:&err];
    NSLog(@"%i", [objects count]);
    if (err != nil) {
        NSLog(@"%@", [err localizedDescription]);
    }
    NSLog(@"%@", objects);
    NSArray *sortedObjs = [objects sortedArrayWithOptions:NSSortConcurrent | NSSortStable usingComparator:^NSComparisonResult(id obj1, id obj2) {
        College *school1 = (College *) obj1;
        College *school2 = (College *) obj2;
        
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:[[school1 lat] doubleValue] longitude:[[school1 lon] doubleValue]];
        CLLocationDistance dist1 = [self.bestEffortAtLocation distanceFromLocation:loc];
        loc = [[CLLocation alloc] initWithLatitude:[[school2 lat] doubleValue] longitude:[[school2 lon] doubleValue]];
        CLLocationDistance dist2 = [self.bestEffortAtLocation distanceFromLocation:loc];
        
        if (dist1 > dist2) return NSOrderedDescending;
        if (dist1 < dist2) return NSOrderedAscending;
        else return NSOrderedSame;
    }];
    
    self.nearbySchools = [sortedObjs subarrayWithRange:NSMakeRange(0, 10)];
    NSLog(@"%@", sortedObjs);
    NSLog(@"%@", self.nearbySchools);
    
    [self updateNearbySchoolsView];
}

- (void) updateNearbySchoolsView {
    UIView *schoolContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120.0, 64.0)];
    
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // The location "unknown" error simply means the manager is currently unable to get the location.
    // We can ignore this error for the scenario of getting a single location fix, because we already have a 
    // timeout that will stop the location manager to save power.
    if ([error code] != kCLErrorLocationUnknown) {
        [self stopUpdatingLocation:NSLocalizedString(@"Error", @"Error")];
    }
}

- (void)stopUpdatingLocation:(NSString *)state {
    [locationManager stopUpdatingLocation];
    locationManager.delegate = nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (INTERFACE_IS_PAD || !(interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown));
}


#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.image = [UIImage imageNamed:@"menu.png"];//NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    [popoverController setPopoverBackgroundViewClass:[KSCustomPopoverBackgroundView class]];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    if (self.masterPopoverController != nil && [self.masterPopoverController isPopoverVisible])
        [self.masterPopoverController dismissPopoverAnimated:YES];
    self.masterPopoverController = nil;
}

-(BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation 
{ 
    return YES; 
}

@end
