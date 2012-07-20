//
//  FTCollegeListViewController.m
//  The College App
//
//  Created by Jeffrey Barg on 7/6/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import "FTCollegeSearchViewController.h"
#import "FTCollegeCellView.h"
#import "KSCustomPopoverBackgroundView.h"
#import "FTCollegeInfoViewController.h"
#import "College.h"
#import <QuartzCore/QuartzCore.h>
#import "FTRangeIndicator.h"
#import "ECSlidingViewController.h"

@interface FTCollegeSearchViewController () {
    NSInteger _lastDeleteItemIndexAsked;   
    __gm_weak GMGridView *_gmGridView;   
}

@property (nonatomic, strong) UIPopoverController *masterPopoverController;

@end

@implementation FTCollegeSearchViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize masterPopoverController = _masterPopoverController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) init {
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) loadView {
    [super loadView];
    
    NSInteger spacing = INTERFACE_IS_PHONE? 10 : 30;
    NSInteger minInsets = INTERFACE_IS_PHONE? 5 : 20;
    GMGridView *gmGridView = [[GMGridView alloc] initWithFrame:self.view.bounds];
    gmGridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    gmGridView.backgroundColor = [UIColor clearColor];
    _gmGridView = gmGridView;

    _gmGridView.style = GMGridViewStyleSwap;
    _gmGridView.itemSpacing = spacing;
    _gmGridView.minEdgeInsets = UIEdgeInsetsMake(spacing, minInsets, spacing, minInsets);
    _gmGridView.centerGridHorizontally = YES;
    _gmGridView.actionDelegate = self;
    _gmGridView.sortingDelegate = self;
    _gmGridView.dataSource = self;
    _gmGridView.allowsHorizontalReordering = YES;
    
    [self.view addSubview:gmGridView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"College List";
    self.view.backgroundColor = [UIColor colorWithHue:0.574 saturation:0.037 brightness:0.957 alpha:1.000];
    // Do any additional setup after loading the view.

    _gmGridView.mainSuperView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    
}

- (void)viewDidUnload
{    
    _gmGridView = nil;

    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (INTERFACE_IS_PAD || !(interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown));
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"College" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"combinedSATAverage" ascending:NO];
    //NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    //Edit the Filter Predicates
    
    //    NSPredicate *combinedPredicate = [NSPredicate predicateWithFormat:@"inCollegeList == %@", self.isCollegeList];
    //    [fetchRequest setPredicate:combinedPredicate];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"COLLEGE_CACHE"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    [self.fetchedResultsController setDelegate:self];
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}   

/*
 NSFetchedResultsController delegate methods to respond to additions, removals and so on.
 */

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{    
    
    
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            //            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            [_gmGridView insertObjectAtIndex:newIndexPath.row animated:YES];
            break;
            
        case NSFetchedResultsChangeDelete:
            
            //            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            break;
            
        case NSFetchedResultsChangeUpdate:
            //            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            //            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            //            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            
            break;
        default:
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            break;
            
        case NSFetchedResultsChangeDelete:
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
}


//////////////////////////////////////////////////////////////
#pragma mark GMGridViewDataSource
//////////////////////////////////////////////////////////////

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:0];
    return [sectionInfo numberOfObjects]; //+ _addingCell?1:0; // Extra Cell when adding.
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return CGSizeMake(300.0, 132.0);
    //return INTERFACE_IS_PHONE ? CGSizeMake(284.0, 204.0f) : CGSizeMake(304.0, 204.0);
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    
    //NSLog(@"Creating view indx %d", index);
    
    CGSize size = [self GMGridView:gridView sizeForItemsInInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    
    FTCollegeCellView *view = nil;
    
    if (!cell)
    {
        cell = [[GMGridViewCell alloc] init];
        cell.deleteButtonIcon = [UIImage imageNamed:@"close_x.png"];
        cell.deleteButtonOffset = CGPointMake(-15, -15);
        
        view = [[FTCollegeCellView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        //        view.backgroundColor = [UIColor redColor];
        //        view.layer.masksToBounds = NO;
        //        view.layer.cornerRadius = 8;
        //        

        cell.contentView = view;
    }
    
    if (view == nil) {
        view = (FTCollegeCellView *) cell.contentView;
    }
    
    College *school = (College *)[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    
    [view.titleLabel setText:[school name]];
    NSDictionary *stateDict = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@"AL", @"AK", @"AZ", @"AR", @"CA", @"CO", @"CT", @"DE", @"FL", @"GA", @"HI", @"ID", @"IL", @"IN", @"IA", @"KS", @"KY", @"LA", @"ME", @"MD", @"MA", @"MI", @"MN", @"MS", @"MO", @"MT", @"NE", @"NV", @"NH", @"NJ", @"NM", @"NY", @"NC", @"ND", @"OH", @"OK", @"OR", @"PA", @"RI", @"SC", @"SD", @"TN", @"TX", @"UT", @"VT", @"VA", @"WA", @"WV", @"WI", @"WY", nil] forKeys:[NSArray arrayWithObjects:@"Alabama", @"Alaska", @"Arizona", @"Arkansas", @"California", @"Colorado", @"Connecticut", @"Delaware", @"Florida", @"Georgia", @"Hawaii", @"Idaho", @"Illinois", @"Indiana", @"Iowa", @"Kansas", @"Kentucky", @"Louisiana", @"Maine", @"Maryland", @"Massachusetts", @"Michigan", @"Minnesota", @"Mississippi", @"Missouri", @"Montana", @"Nebraska", @"Nevada", @"New Hampshire", @"New Jersey", @"New Mexico", @"New York", @"North Carolina", @"North Dakota", @"Ohio", @"Oklahoma", @"Oregon", @"Pennsylvania", @"Rhode Island", @"South Carolina", @"South Dakota", @"Tennessee", @"Texas", @"Utah", @"Vermont", @"Virginia", @"Washington", @"West Virginia", @"Wisconsin", @"Wyoming", nil]];
    
    NSString *stateAbbreviation = [school stateAbbreviation];
    if ([stateAbbreviation length] != 2) {
        stateAbbreviation = [stateDict objectForKey:stateAbbreviation];
    }
    
    [view.subtitleLabel setText:[NSString stringWithFormat:@" • %@ • %@", [school city], stateAbbreviation]];
        
    NSString *satScoreText = [NSString stringWithFormat:@"%i - %i", 
                              [[school readingSAT25] integerValue] + [[school writingSAT25] integerValue] + [[school mathSAT25] integerValue],
                              [[school readingSAT75] integerValue] + [[school writingSAT75] integerValue] + [[school mathSAT75] integerValue]];
    
    [view.satScore setText:satScoreText];
    
    NSString *actScoreText = [NSString stringWithFormat:@"%i - %i",
                                [[school compositeACT25] integerValue],
                                [[school compositeACT75] integerValue]];
    
    [view.actScore setText:actScoreText];
    
    [view.locationIndicatorView setImage:[UIImage imageNamed:@"shitty.png"]];

    [cell setHidden:NO];
    
    return cell;
}


- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index
{
    return YES; //index % 2 == 0;
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewActionDelegate
//////////////////////////////////////////////////////////////

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)index {
    NSLog(@"Did tap at index %d", index);
    
    College *school = (College *) [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    
    FTCollegeInfoViewController *infoViewController = [[FTCollegeInfoViewController alloc] initWithNibName:@"FTCollegeInfoViewController" bundle:[NSBundle mainBundle]];
    
    [infoViewController setSchool:school];
    [infoViewController setManagedObjectContext:self.managedObjectContext];
    
    UINavigationController *infoNavController = [[UINavigationController alloc] initWithRootViewController:infoViewController];
    [infoNavController.navigationBar setBackgroundImage:[UIImage imageNamed:@"whitenavbar.png"] forBarMetrics:UIBarMetricsDefault];

    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    [tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"modaltab.png"]];
    [tabBarController.tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"activetab.png"]];

    [tabBarController setViewControllers:[NSArray arrayWithObjects:infoNavController, nil]];
    [tabBarController setSelectedViewController:infoNavController];
    
    [tabBarController setModalPresentationStyle:UIModalPresentationFormSheet];
    
    [self presentModalViewController:tabBarController animated:YES];
    NSLog(@"%@", [school name]);

}

- (void)GMGridViewDidTapOnEmptySpace:(GMGridView *)gridView
{
    NSLog(@"Tap on empty space");
}

- (void)GMGridView:(GMGridView *)gridView processDeleteActionForItemAtIndex:(NSInteger)index
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Are you sure you want to delete this item?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    
    [alert show];
    
    _lastDeleteItemIndexAsked = index;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [alertView cancelButtonIndex]) 
    {
        //TODO: Delete Item from Data Source
        //[_currentData removeObjectAtIndex:_lastDeleteItemIndexAsked];
        [_gmGridView removeObjectAtIndex:_lastDeleteItemIndexAsked withAnimation:GMGridViewItemAnimationFade];
    }
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewSortingDelegate
//////////////////////////////////////////////////////////////

- (void)GMGridView:(GMGridView *)gridView didStartMovingCell:(GMGridViewCell *)cell
{
    [cell.layer setShadowOffset:CGSizeMake(0, 1)];
    [cell.layer setShadowColor:[UIColor grayColor].CGColor];
    [cell.layer setShadowOpacity:0.5];
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0.5 , 0.5, cell .frame.size.width - 1.0, cell.frame.size.height - 1.0)
                                                   byRoundingCorners:UIRectCornerAllCorners
                                                         cornerRadii:CGSizeMake(5.0f, 5.0f)];
    [cell.layer setShadowPath:clipPath.CGPath];
    
    [self.view removeGestureRecognizer:self.slidingViewController.panGesture];
}

- (void)GMGridView:(GMGridView *)gridView didEndMovingCell:(GMGridViewCell *)cell {
    [cell.layer setShadowOffset:CGSizeZero];
    [cell.layer setShadowOpacity:0.0];
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];

}

- (BOOL)GMGridView:(GMGridView *)gridView shouldLetCell:(GMGridViewCell *)cell returnToPositionWithTouchLocation:(CGPoint) loc {
    
    return YES;
}

- (void)GMGridView:(GMGridView *)gridView updatedMovingCell:(GMGridViewCell *)cell withGestureRecognizer:(UIGestureRecognizer *) gesture {

}


- (BOOL)GMGridView:(GMGridView *)gridView shouldAllowShakingBehaviorWhenMovingCell:(GMGridViewCell *)cell atIndex:(NSInteger)index
{
    return YES;
}

- (void)GMGridView:(GMGridView *)gridView moveItemAtIndex:(NSInteger)oldIndex toIndex:(NSInteger)newIndex
{
    //    NSObject *object = [_currentData objectAtIndex:oldIndex];
    //    [_currentData removeObject:object];
    //    [_currentData insertObject:object atIndex:newIndex];

}

- (void)GMGridView:(GMGridView *)gridView exchangeItemAtIndex:(NSInteger)index1 withItemAtIndex:(NSInteger)index2
{

    
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
