//
//  FTExtracurriclarsViewController.m
//  The College App
//
//  Created by Jeffrey Barg on 7/6/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import "FTExtracurriclarsViewController.h"
#import "FTAddExtracurricularViewController.h"
#import "KSCustomPopoverBackgroundView.h"
#import "FTExtracurricularCellView.h"
#import "Extracurricular.h"
#import "GMGridView.h"
#import "KSCustomPopoverBackgroundView.h"
#import "ECSlidingViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface FTExtracurricularsViewController () {
    NSInteger _lastDeleteItemIndexAsked;   
    __gm_weak GMGridView *_gmGridView;
    NSInteger _indexNeedsDisplay;
}

@property (nonatomic, strong) UIPopoverController *masterPopoverController;

- (void) customInit;

@end

@implementation FTExtracurricularsViewController

@synthesize masterPopoverController = _masterPopoverController;
@synthesize managedObjectContext = _managedObjectContext;

@synthesize fetchedResultsController = _fetchedResultsController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self customInit];
    }
    return self;
}

- (id) init {
    self = [super init];
    if (self) {
        [self customInit];
    }
    
    return self;
}

- (void) customInit {
    _indexNeedsDisplay = -1;
}

- (void) loadView {
    [super loadView];
    //self.view.backgroundColor = [UIColor colorWithHue:0.574 saturation:0.037 brightness:0.957 alpha:1.000];

    NSInteger spacing = INTERFACE_IS_PHONE ? 0 : 20;
    
    GMGridView *gmGridView = [[GMGridView alloc] initWithFrame:self.view.bounds];
    gmGridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    gmGridView.backgroundColor = [UIColor clearColor];
    _gmGridView = gmGridView;
    
    _gmGridView.style = GMGridViewStyleSwap;
    _gmGridView.itemSpacing = spacing;
    _gmGridView.minEdgeInsets = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
    _gmGridView.centerGrid = NO;
    _gmGridView.actionDelegate = self;
    _gmGridView.sortingDelegate = self;
    _gmGridView.dataSource = self;
    _gmGridView.allowsHorizontalReordering = NO;

    [self.view addSubview:gmGridView];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Extracurriculars";
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addExtracurricular:)];
    [addButton setStyle:UIBarButtonItemStylePlain];
    
    [self.navigationItem setRightBarButtonItem:addButton];
    
    _gmGridView.mainSuperView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
}

- (void) viewDidLayoutSubviews {
    [_gmGridView setFrame:self.view.bounds];
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

- (void) addExtracurricular:(UIBarButtonItem *)barButtonItem {
     
    /* Check that:
        - There is no current popover
        - The popover is not visible
        - The popover is not the same popover we're going to display
     */
    if (self.masterPopoverController != nil && [self.masterPopoverController isPopoverVisible] && [self.masterPopoverController.contentViewController class] != [FTExtracurricularsViewController class]) return;
    
    FTAddExtracurricularViewController *viewController = [[FTAddExtracurricularViewController alloc] init];
    [viewController setManagedObjectContext:self.managedObjectContext];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    if (INTERFACE_IS_PAD) {
        UIPopoverController *pController = [[UIPopoverController alloc] initWithContentViewController:navController];
        //      [pController setPopoverContentSize:CGSizeMake(320.0, 484.0)];
        [pController setPopoverContentSize:CGSizeMake(320.0, 349.0)];
        
        self.masterPopoverController = pController;
        [pController setPopoverBackgroundViewClass:[KSCustomPopoverBackgroundView class]];
        [pController presentPopoverFromBarButtonItem:barButtonItem permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        
    } else {
        [navController.navigationBar setBackgroundImage:[UIImage imageNamed:@"blacknavbar.png"] forBarMetrics:UIBarMetricsDefault];
        [self presentModalViewController:navController animated:YES];
    }
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Extracurricular" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
    //NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    //Edit the Filter Predicates
    
    //    NSPredicate *combinedPredicate = [NSPredicate predicateWithFormat:@"inCollegeList == %@", self.isCollegeList];
    //    [fetchRequest setPredicate:combinedPredicate];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"EXTRACURRICULARS_CACHE"];
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
    //return INTERFACE_IS_PHONE ? CGSizeMake(284.0, 204.0f) : CGSizeMake(304.0, 204.0);
    if (INTERFACE_IS_PHONE) 
    {
        if (UIInterfaceOrientationIsLandscape(orientation)) 
        {
            return CGSizeMake(480.0, 132.0);
        }
        else
        {
            return CGSizeMake(320.0, 132.0);
        }
    }
    else
    {
        if (UIInterfaceOrientationIsLandscape(orientation)) 
        {
            //return CGSizeMake(663.0, 132.0);
            return CGSizeMake(983.0, 132.0);
        }
        else
        {
            return CGSizeMake(728.0, 132.0);
        }
    }
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    
    //NSLog(@"Creating view indx %d", index);
    
    CGSize size = [self GMGridView:gridView sizeForItemsInInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
            
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    
    if (!cell)
    {
        cell = [[GMGridViewCell alloc] init];
        cell.deleteButtonIcon = [UIImage imageNamed:@"close_x.png"];
        cell.deleteButtonOffset = CGPointMake(-15, -15);
        
        FTExtracurricularCellView *view = [[FTExtracurricularCellView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        
        [view setOpaque:INTERFACE_IS_PHONE];
        [view setManagedObjectContext:self.managedObjectContext];
        [view setContentMode:UIViewContentModeRedraw];
        [view setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        //[view setBackgroundColor:[UIColor clearColor]];
        cell.contentView = view;
        
    }
    [cell setHidden:NO];
    
    Extracurricular *object = (Extracurricular *)[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    
    FTExtracurricularCellView *view = (FTExtracurricularCellView *) cell.contentView;
    [view updateCellIndex:index animated:NO];
    [view setActivity:object];
    [view setNeedsDisplay];
    
    
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
}

- (void)GMGridView:(GMGridView *)gridView didEndMovingCell:(GMGridViewCell *)cell {
    [cell.layer setShadowOffset:CGSizeZero];
    [cell.layer setShadowOpacity:0.0];
    
    if (_indexNeedsDisplay != -1) {
        //        [((FTExtracurricularCell *)cell.contentView) setCellIndex:[NSNumber numberWithInteger:_indexNeedsDisplay]];
        //        [cell.contentView setNeedsDisplay];
        FTExtracurricularCellView *eCell = (FTExtracurricularCellView *)cell.contentView;
        
        [eCell updateCellIndex:_indexNeedsDisplay animated:YES];
        _indexNeedsDisplay = -1;
        
    }
    
    NSError *err = nil;
    [self.managedObjectContext save:&err];
    if (err != nil) {
        NSLog(@"%@", [err localizedDescription]);
    }   
}

- (BOOL)GMGridView:(GMGridView *)gridView shouldLetCell:(GMGridViewCell *)cell returnToPositionWithTouchLocation:(CGPoint) loc {
    
    return YES;
}

- (void)GMGridView:(GMGridView *)gridView updatedMovingCell:(GMGridViewCell *)cell withGestureRecognizer:(UIGestureRecognizer *) gesture {
    if (_indexNeedsDisplay != -1) {
        //        [((FTExtracurricularCell *)cell.contentView) setCellIndex:[NSNumber numberWithInteger:_indexNeedsDisplay]];
        //        [cell.contentView setNeedsDisplay];
        FTExtracurricularCellView *eCell = (FTExtracurricularCellView *)cell.contentView;
        
        [eCell updateCellIndex:_indexNeedsDisplay animated:YES];
        _indexNeedsDisplay = -1;
        
    }
}


- (BOOL)GMGridView:(GMGridView *)gridView shouldAllowShakingBehaviorWhenMovingCell:(GMGridViewCell *)cell atIndex:(NSInteger)index
{
    return NO;
}

- (void)GMGridView:(GMGridView *)gridView moveItemAtIndex:(NSInteger)oldIndex toIndex:(NSInteger)newIndex
{
    //    NSObject *object = [_currentData objectAtIndex:oldIndex];
    //    [_currentData removeObject:object];
    //    [_currentData insertObject:object atIndex:newIndex];
    GMGridViewCell *cell1 = [_gmGridView cellForItemAtIndex:newIndex];
    
    FTExtracurricularCellView *eCell1 = (FTExtracurricularCellView *)[cell1 contentView];
    
    [eCell1 setCellIndex:[NSNumber numberWithInteger:newIndex]];
    [eCell1 setNeedsDisplay];
    
    _indexNeedsDisplay = YES;
    
    if (oldIndex < newIndex) {
        for (int i = oldIndex + 1; i <= newIndex; i ++) {
            Extracurricular *object = (Extracurricular *)[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            [object setIndex:[NSNumber numberWithInteger:i-1]];
        }
    } else {
        for (int i = newIndex; i < oldIndex; i ++) {
            Extracurricular *object = (Extracurricular *)[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            [object setIndex:[NSNumber numberWithInteger:i+1]];
        }
    }
    
    Extracurricular *object = (Extracurricular *)[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:oldIndex inSection:0]];
    [object setIndex:[NSNumber numberWithInteger:newIndex]];
    
}

- (void)GMGridView:(GMGridView *)gridView exchangeItemAtIndex:(NSInteger)index1 withItemAtIndex:(NSInteger)index2
{
    GMGridViewCell *cell1 = [_gmGridView cellForItemAtIndex:index1];
    GMGridViewCell *cell2 = [_gmGridView cellForItemAtIndex:index2];
    
    FTExtracurricularCellView *eCell1 = (FTExtracurricularCellView *)[cell1 contentView];
    FTExtracurricularCellView *eCell2 = (FTExtracurricularCellView *)[cell2 contentView];
    
    [eCell1 setCellIndex:[NSNumber numberWithInteger:index1]];
    [eCell2 setCellIndex:[NSNumber numberWithInteger:index2]];
    
    if (eCell1 != nil)
        [eCell1 updateCellIndex:index1 animated:YES];
    if (eCell2 != nil)
        [eCell2 updateCellIndex:index2 animated:YES];
    
    
    _indexNeedsDisplay = cell1==nil?index1:cell2==nil?index2:-1; //Whichever index does not return a real cell - pass that as the dirty index.
    
    Extracurricular *object1 = (Extracurricular *)[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:index1 inSection:0]];
    Extracurricular *object2 = (Extracurricular *)[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:index2 inSection:0]];
    NSLog(@"%i %i", index1, index2);
    [object1 setIndex:[NSNumber numberWithInteger:index2]];
    [object2 setIndex:[NSNumber numberWithInteger:index1]];    

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

@end
