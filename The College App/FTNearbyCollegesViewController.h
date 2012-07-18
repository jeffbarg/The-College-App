//
//  FTNearbyCollegesViewController.h
//  The College App
//
//  Created by Jeffrey Barg on 7/17/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>

#import "EGORefreshTableHeaderView.h"

@interface FTNearbyCollegesViewController : UITableViewController<CLLocationManagerDelegate> {
    EGORefreshTableHeaderView *_refreshHeaderView;   
}

@property (nonatomic, strong) NSManagedObjectContext * managedObjectContext;

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *bestEffortAtLocation;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end
