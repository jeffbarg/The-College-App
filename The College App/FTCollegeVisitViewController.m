//
//  FTCollegeVisitViewController.m
//  The College App
//
//  Created by Jeffrey Barg on 7/12/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import "FTCollegeVisitViewController.h"
#import "KSCustomPopoverBackgroundView.h"
#import "ECSlidingViewController.h"

#import "College.h"

#import "FTCollegeVisitNotesViewController.h"
#import "FTCollegeVisitPhotosViewController.h"
#import "FTCollegeVisitRatingsViewController.h"

#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>

#define kLatRadius 0.5
#define kLonRadius 0.5

#define MARGIN_X 15
#define MARGIN_Y 12

#define MARGIN_HEADER 12

#define HEADER_HEIGHT 30

@interface FTCollegeVisitViewController () {
    
}

@property (nonatomic, strong) UIPopoverController *masterPopoverController;

@property (nonatomic, strong) FTCollegeVisitNotesViewController *notesViewController;
@property (nonatomic, strong) FTCollegeVisitPhotosViewController *photosViewController;
@property (nonatomic, strong) FTCollegeVisitRatingsViewController *ratingsViewController;

@property (nonatomic, strong) UIView *notesView;
@property (nonatomic, strong) UIView *photosView;
@property (nonatomic, strong) UIView *ratingsView;

@property (nonatomic, strong) UIButton *notesButton;
@property (nonatomic, strong) UIButton *photosButton;
@property (nonatomic, strong) UIButton *ratingsButton;

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

@synthesize photosButton;
@synthesize notesButton;
@synthesize ratingsButton;

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
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"] landscapeImagePhone:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStyleDone target:nil action:nil];
//    
//    UIBarButtonItem *cameraItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:nil action:nil];
//    
//    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backButton, [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], nil];
//    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], cameraItem, nil];
    
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"aphonors.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)]];
                         

    [titleView setFrame:CGRectMake(0, 0, 150.0, 30)];                           
    self.navigationItem.titleView = titleView;
    
	// Do any additional setup after loading the view.
    CLLocationManager *manager = [[CLLocationManager alloc] init];

    manager.delegate = self;
    manager.desiredAccuracy = kCLLocationAccuracyBest;

    self.locationManager = manager;
    
    [locationManager startUpdatingLocation];
    
    _photosView = [[UIView alloc] initWithFrame:CGRectZero];
    _ratingsView = [[UIView alloc] initWithFrame:CGRectZero];
    _notesView = [[UIView alloc] initWithFrame:CGRectZero];

    [self.view addSubview:_photosView];
    [self.view addSubview:_ratingsView];
    [self.view addSubview:_notesView];
    
    _photosViewController = [[FTCollegeVisitPhotosViewController alloc] init];
    _ratingsViewController = [[FTCollegeVisitRatingsViewController alloc] initWithStyle:UITableViewStylePlain];
    _notesViewController = [[FTCollegeVisitNotesViewController alloc] init];
    
    if (INTERFACE_IS_PAD) {
        [self.photosViewController willMoveToParentViewController:self];
        [self addChildViewController:self.photosViewController];
        [self.photosView addSubview:self.photosViewController.view];
        [self.photosViewController.view setFrame:CGRectZero];
        [self.photosViewController.view setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        [self.photosViewController didMoveToParentViewController:self];
        
        [self.ratingsViewController willMoveToParentViewController:self];
        [self addChildViewController:self.ratingsViewController];
        [self.ratingsView addSubview:self.ratingsViewController.tableView];
        [self.ratingsViewController.view setFrame:CGRectZero];
        [self.ratingsViewController.view setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        [self.ratingsViewController didMoveToParentViewController:self];
        
        [self.notesViewController willMoveToParentViewController:self];
        [self addChildViewController:self.notesViewController];
        [self.notesView addSubview:self.notesViewController.view];
        [self.notesViewController.view setFrame:CGRectZero];
        [self.notesViewController.view setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        [self.notesViewController didMoveToParentViewController:self];
        
        
        UIColor *textColor = [UIColor colorWithWhite:0.322 alpha:1.000];
        UIFont *textFont = [UIFont boldSystemFontOfSize:14.0];
        
        ratingsButton = [[UIButton alloc] initWithFrame:CGRectZero];
        photosButton = [[UIButton alloc] initWithFrame:CGRectZero];
        notesButton = [[UIButton alloc] initWithFrame:CGRectZero];

        [self.view addSubview:ratingsButton];
        [self.view addSubview:photosButton];
        [self.view addSubview:notesButton];
        
        [ratingsButton setTitleColor:textColor forState:UIControlStateNormal];
        [ratingsButton setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal];
        [ratingsButton.titleLabel setShadowOffset:CGSizeMake(0, 0)];
        [ratingsButton.titleLabel setFont:textFont];
        [ratingsButton.titleLabel setTextAlignment:UITextAlignmentLeft];
        [ratingsButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [ratingsButton setContentEdgeInsets:UIEdgeInsetsMake(0.0, 15.0, 0.0, 0.0)];
        [ratingsButton setTitle:@"Ratings" forState:UIControlStateNormal];
        
//        [ratingsButton.layer setShadowOpacity:0.1];
//        [ratingsButton.layer setShadowColor:[UIColor blackColor].CGColor];
//        [ratingsButton.layer setShadowOffset:CGSizeMake(0, 1)];
        
        [ratingsButton setBackgroundImage:[[UIImage imageNamed:@"visitsectionheader.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)] forState:UIControlStateNormal];
        [ratingsButton setBackgroundImage:[[UIImage imageNamed:@"visitsectionheader.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)] forState:UIControlStateHighlighted];
         
        [photosButton setTitleColor:textColor forState:UIControlStateNormal];
        [photosButton setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal];
        [photosButton.titleLabel setShadowOffset:CGSizeMake(0, 0)];
        [photosButton.titleLabel setFont:textFont];
        [photosButton.titleLabel setTextAlignment:UITextAlignmentLeft];
        [photosButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [photosButton setContentEdgeInsets:UIEdgeInsetsMake(0.0, 15.0, 0.0, 0.0)];
        [photosButton setTitle:@"Photos" forState:UIControlStateNormal];
        
//        [photosButton.layer setShadowOpacity:0.1];
//        [photosButton.layer setShadowColor:[UIColor blackColor].CGColor];
//        [photosButton.layer setShadowOffset:CGSizeMake(0, 1)];
        
        [photosButton setBackgroundImage:[[UIImage imageNamed:@"visitsectionheader.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)] forState:UIControlStateNormal];
        [photosButton setBackgroundImage:[[UIImage imageNamed:@"visitsectionheader.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)] forState:UIControlStateHighlighted];
        
        [notesButton setTitleColor:textColor forState:UIControlStateNormal];
        [notesButton setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal];
        [notesButton.titleLabel setShadowOffset:CGSizeMake(0, 0)];
        [notesButton.titleLabel setFont:textFont];
        [notesButton.titleLabel setTextAlignment:UITextAlignmentLeft];
        [notesButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [notesButton setContentEdgeInsets:UIEdgeInsetsMake(0.0, 15.0, 0.0, 0.0)];
        [notesButton setTitle:@"Notes" forState:UIControlStateNormal];
        
//        [notesButton.layer setShadowOpacity:0.1];
//        [notesButton.layer setShadowColor:[UIColor blackColor].CGColor];
//        [notesButton.layer setShadowOffset:CGSizeMake(0, 1)];
        
        [notesButton setBackgroundImage:[[UIImage imageNamed:@"visitsectionheader.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)] forState:UIControlStateNormal];
        [notesButton setBackgroundImage:[[UIImage imageNamed:@"visitsectionheader.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)] forState:UIControlStateHighlighted];

        
    } else {
        UITabBarController *tabBarController = [[UITabBarController alloc] init];

        
        [tabBarController setViewControllers:[NSArray arrayWithObjects:_photosViewController, _ratingsViewController, _notesViewController, nil]];
        
        [tabBarController.view setFrame:self.view.bounds];
        [tabBarController.view setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        [tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"iphonetab.png"]];
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(floorf(self.view.frame.size.width / 3.0) + 2, 50.0), YES, 0.0);
        [[[UIImage imageNamed:@"iphoneactivetab.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(24.0, 13.0, 24.0, 13.0)] drawInRect:CGRectMake(0, 0, floorf(self.view.frame.size.width / 3.0) + 2, 50.0)];
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [tabBarController.tabBar setSelectionIndicatorImage:img];

        [tabBarController willMoveToParentViewController:self];
        [self addChildViewController:tabBarController];
        [self.view addSubview:tabBarController.view];
        [tabBarController didMoveToParentViewController:self];
    }
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    //Let's hope to god I don't have to rewrite this.  just change defines.
    [self.photosView setFrame:CGRectMake(MARGIN_X,  MARGIN_Y + HEADER_HEIGHT + MARGIN_HEADER, self.view.frame.size.width - 320 - 3 * MARGIN_X, self.view.frame.size.height - (2 * MARGIN_Y + HEADER_HEIGHT + MARGIN_HEADER))];
    
    [self.ratingsView setFrame:CGRectMake(self.view.frame.size.width - 320 - MARGIN_X, MARGIN_Y + HEADER_HEIGHT + MARGIN_HEADER, 320, (self.view.frame.size.height - 2 * HEADER_HEIGHT - 3 * MARGIN_HEADER - 2*  MARGIN_Y) / 2.0)];

    [self.notesView setFrame:CGRectMake(self.view.frame.size.width - 320 - MARGIN_X, CGRectGetMaxY(self.ratingsView.frame) + 2 * MARGIN_HEADER + HEADER_HEIGHT, 320, (self.view.frame.size.height - 2 * HEADER_HEIGHT - 3 * MARGIN_HEADER - 2 * MARGIN_Y) / 2.0)];

    [self.photosButton setFrame:CGRectMake(MARGIN_X, MARGIN_Y, CGRectGetWidth(self.photosView.frame), HEADER_HEIGHT)];
    [self.ratingsButton setFrame:CGRectMake(CGRectGetMaxX(self.photosView.frame) + MARGIN_X, MARGIN_Y, CGRectGetWidth(self.ratingsView.frame), HEADER_HEIGHT)];
    [self.notesButton setFrame:CGRectMake(CGRectGetMaxX(self.photosView.frame) + MARGIN_X, MARGIN_HEADER + CGRectGetMaxY(self.ratingsView.frame), CGRectGetWidth(self.ratingsView.frame), HEADER_HEIGHT)];    

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
    
//    NSError *err = nil;
//    NSArray *objects = [self.managedObjectContext executeFetchRequest:request error:&err];
//    if (err != nil) {
//        NSLog(@"%@", [err localizedDescription]);
//    }
//    NSArray *sortedObjs = [objects sortedArrayWithOptions:NSSortConcurrent | NSSortStable usingComparator:^NSComparisonResult(id obj1, id obj2) {
//        College *school1 = (College *) obj1;
//        College *school2 = (College *) obj2;
//        
//        CLLocation *loc = [[CLLocation alloc] initWithLatitude:[[school1 lat] doubleValue] longitude:[[school1 lon] doubleValue]];
//        CLLocationDistance dist1 = [self.bestEffortAtLocation distanceFromLocation:loc];
//        loc = [[CLLocation alloc] initWithLatitude:[[school2 lat] doubleValue] longitude:[[school2 lon] doubleValue]];
//        CLLocationDistance dist2 = [self.bestEffortAtLocation distanceFromLocation:loc];
//        
//        if (dist1 > dist2) return NSOrderedDescending;
//        if (dist1 < dist2) return NSOrderedAscending;
//        else return NSOrderedSame;
//    }];
//    
//    self.nearbySchools = [sortedObjs subarrayWithRange:NSMakeRange(0, 10)];
     
    [self updateNearbySchoolsView];
}

- (void) updateNearbySchoolsView {
    
    
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

@end
