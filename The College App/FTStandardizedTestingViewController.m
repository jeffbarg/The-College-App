//
//  FTStandardizedTestingViewController.m
//  The College App
//
//  Created by Jeffrey Barg on 7/16/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import "KSCustomPopoverBackgroundView.h"

#import "FTStandardizedTestingViewController.h"
#import "FTStandardizedTestView.h"
#import "FTStandardizedTestHeader.h"
#import "FTStandardizedTestTableViewCell.h"
#import "FTAddStandardizedTestViewController.h"
#import "FTEditTestSectionViewController.h"

#import "StandardizedTest.h"
#import "TestSection.h"

#define MARGIN_X 20
#define MARGIN_Y 15

@interface FTStandardizedTestingViewController () <NSFetchedResultsControllerDelegate>

@end

@implementation FTStandardizedTestingViewController

@synthesize managedObjectContext;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize masterPopoverController = _masterPopoverController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"Standardized Testing";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.rowHeight = 150.0;
    
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundView  = nil;
    self.tableView.backgroundColor = kViewBackgroundColor;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addStandardizedTest:)];
    [addButton setStyle:UIBarButtonItemStylePlain];
    
    [self.navigationItem setRightBarButtonItem:addButton];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (INTERFACE_IS_PAD || !(interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown));
}


#pragma mark - Buttons

- (void) addStandardizedTest:(UIBarButtonItem *)barButtonItem {
    
    /* Check that:
     - There is no current popover
     - The popover is not visible
     - The popover is not the same popover we're going to display
     */
    if (self.masterPopoverController != nil && [self.masterPopoverController isPopoverVisible] && [self.masterPopoverController.contentViewController class] != [FTAddStandardizedTestViewController class]) return;
    
    FTAddStandardizedTestViewController *viewController = [[FTAddStandardizedTestViewController alloc] initWithStyle:UITableViewStylePlain];
    [viewController setManagedObjectContext:self.managedObjectContext];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    if (INTERFACE_IS_PAD) {
        UIPopoverController *pController = [[UIPopoverController alloc] initWithContentViewController:navController];
        //      [pController setPopoverContentSize:CGSizeMake(320.0, 484.0)];
        [pController setPopoverContentSize:CGSizeMake(320.0, 349.0)];
        
        self.masterPopoverController = pController;
        [pController setPopoverBackgroundViewClass:[KSCustomPopoverBackgroundView class]];
        [navController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];

        [pController presentPopoverFromBarButtonItem:barButtonItem permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        
    } else {
        [navController.navigationBar setBackgroundImage:[UIImage imageNamed:@"blacknavbar.png"] forBarMetrics:UIBarMetricsDefault];
        [self presentModalViewController:navController animated:YES];
    }
}

- (void) presentEditPopoverFromButton:(UIButton *) button fromTestView:(FTStandardizedTestView *)testView {
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:NO];
        self.masterPopoverController = nil;
    }
    FTEditTestSectionViewController *testSectionViewController = [[FTEditTestSectionViewController alloc] init];
    [testSectionViewController setManagedObjectContext:self.managedObjectContext];
    [testSectionViewController setButton:button];
    NSInteger index = [testView.buttonArray indexOfObject:button];
    [testSectionViewController setTestSection:[testView.test.testSections objectAtIndex:index]];
    [testSectionViewController setTestView:testView];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:testSectionViewController];
    [navController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    self.masterPopoverController = [[UIPopoverController alloc] initWithContentViewController:navController];
    [testSectionViewController setPController:self.masterPopoverController];
    
    [self.masterPopoverController setPopoverBackgroundViewClass:[KSCustomPopoverBackgroundView class]];

    [self.masterPopoverController setPassthroughViews:self.tableView.visibleCells];
    [self.masterPopoverController presentPopoverFromRect:[self.view convertRect:button.frame fromView:button.superview] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}
#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"StandardizedTest" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sectionPriority" ascending:NO];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"type" ascending:YES];
    NSSortDescriptor *sortDescriptor3 = [[NSSortDescriptor alloc] initWithKey:@"dateTaken" ascending:YES];
    NSSortDescriptor *sortDescriptor4 = [[NSSortDescriptor alloc] initWithKey:@"dateCreated" ascending:YES];

    
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, sortDescriptor2, sortDescriptor3, sortDescriptor4, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    //Edit the Filter Predicates
    
    //    NSPredicate *combinedPredicate = [NSPredicate predicateWithFormat:@"inCollegeList == %@", self.isCollegeList];
    //    [fetchRequest setPredicate:combinedPredicate];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"type" cacheName:@"STANDARDIZED_TESTING_CACHE"];
    
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
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
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    /* FOR THIS WHOLE METHOD:
     
     TABLEVIEW HAS NOT UPDATED YET - IT IS IN EDITING MODE
     INDICES FROM TABLEVIEW WILL NOT CHANGE.
     
     SELF.MANAGEDOBJECTCONTEXT IS FULLY UP-TO-DATE.  OBJECTS HAVE CORRECT INDICES AFTER DELETION IN COREDATA
     */
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            break;
        default:
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
	return [[self.fetchedResultsController sections] count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects]; //+ _addingCell?1:0; // Extra Cell when adding.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    FTStandardizedTestTableViewCell *cell = (FTStandardizedTestTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[FTStandardizedTestTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setViewController:self];
    }
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    
    
    return cell;
}

// Customize the appearance of table view cells.

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    StandardizedTest *test = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [((FTStandardizedTestTableViewCell *) cell).testView setTest:test];
    [((FTStandardizedTestTableViewCell *) cell) setViewController:self];

}


- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1.0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44+MARGIN_Y)];
    
    id <NSFetchedResultsSectionInfo> theSection = [[self.fetchedResultsController sections] objectAtIndex:section];

    FTStandardizedTestHeader *testHeader = [[FTStandardizedTestHeader alloc] initWithFrame:CGRectMake(MARGIN_X - 4.0, MARGIN_Y + 1.0, 88.0, 44.0)];
    [testHeader.titleLabel setText:[theSection name]];
     
    [headerView setClipsToBounds:NO];
    [headerView addSubview:testHeader];
    return headerView;


}

@end
