//
//  FTNearbyCollegesViewController.m
//  The College App
//
//  Created by Jeffrey Barg on 7/17/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import "FTNearbyCollegesViewController.h"

#import "FTNearbyCollegeCell.h"

#import "College.h"

#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>

#define kLatRadius 0.5
#define kLonRadius 0.5

@interface FTNearbyCollegesViewController () <EGORefreshTableHeaderDelegate>

@property (nonatomic, strong) NSArray *nearbySchoolsIDs;


- (void)stopUpdatingLocation:(NSString *)state;

@end

@implementation FTNearbyCollegesViewController

@synthesize visitViewController = _visitViewController;

@synthesize managedObjectContext;

@synthesize bestEffortAtLocation;
@synthesize locationManager;

@synthesize nearbySchoolsIDs = _nearbySchoolsIDs;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    manager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    
    self.locationManager = manager;
    
    [locationManager startUpdatingLocation];
    
    [self.tableView setRowHeight:75.0];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    

    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
		
	}
    
    [_refreshHeaderView setBackgroundColor:[UIColor colorWithHue:0.562 saturation:0.032 brightness:0.986 alpha:1.000]];
    [self.tableView setBackgroundColor:[UIColor colorWithHue:0.562 saturation:0.032 brightness:0.986 alpha:1.000]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    //  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    
    
    [_refreshHeaderView setStartLoading:self.tableView];
    
    self.title = @"Nearby Colleges";
    
}

- (void)viewDidUnload
{
    if (self.locationManager) 
        [self.locationManager stopUpdatingLocation];
    self.locationManager = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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

    if (bestEffortAtLocation == nil || bestEffortAtLocation.horizontalAccuracy > newLocation.horizontalAccuracy ) {
    
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
    

    NSOperationQueue *bgQueue = [[NSOperationQueue alloc] init];
    
    NSPersistentStoreCoordinator * persistentStoreCoordinator = self.managedObjectContext.persistentStoreCoordinator;
    
    [bgQueue addOperationWithBlock:^{
        
        NSManagedObjectContext *bgObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [bgObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];
        
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
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        [request setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
        
        NSError *err = nil;
        NSArray *objects = [bgObjectContext executeFetchRequest:request error:&err];
        if (err != nil) {
            NSLog(@"%@", [err localizedDescription]);
        }

        
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
       
        NSMutableArray * nearbySchoolsIDs = [[NSMutableArray alloc] initWithCapacity:10];
        for (College * school in [sortedObjs subarrayWithRange:NSMakeRange(0, MIN([sortedObjs count], 10))]) {
            [nearbySchoolsIDs addObject:[school objectID]];
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.nearbySchoolsIDs = [NSArray arrayWithArray:nearbySchoolsIDs];
            
            [self.tableView reloadData];
            
            [self doneLoadingTableViewData];
        }];
    }];
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.nearbySchoolsIDs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    FTNearbyCollegeCell *cell = (FTNearbyCollegeCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[FTNearbyCollegeCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    
//    College *school = (College *)[self.nearbySchools objectAtIndex:indexPath.row];
    College *school = (College *)[self.managedObjectContext objectWithID:((NSManagedObjectID *)[self.nearbySchoolsIDs objectAtIndex:indexPath.row])];
    
    [cell.textLabel setText:[school name]];
    
    CLLocation * schoolLoc = [[CLLocation alloc] initWithLatitude:[[school lat] doubleValue] longitude:[[school lon] doubleValue]];
    
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%2.4f", [schoolLoc distanceFromLocation:self.bestEffortAtLocation]]];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    College *school = (College *)[self.managedObjectContext objectWithID:((NSManagedObjectID *)[self.nearbySchoolsIDs objectAtIndex:indexPath.row])];
    
    if (self.visitViewController) {
        [self.visitViewController setSchool:school];
        
        if (INTERFACE_IS_PAD) {
            [self.visitViewController.masterPopoverController dismissPopoverAnimated:YES];
        } else {
            [self dismissViewControllerAnimated:YES completion:^{}];
        }
     }
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
    // should return if data source model is reloading
	return (!self.bestEffortAtLocation);
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"LAST_UPDATED"] == nil) {
        return [NSDate date]; // should return date data source was last changed
    } else {
        return (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"LAST_UPDATED"];
    }
	
    
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	
    //_reloading = YES;
    
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    self.bestEffortAtLocation = nil;
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
    
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	
}

@end
