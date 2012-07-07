//
//  FTGradesViewController.m
//  The College App
//
//  Created by Jeffrey Barg on 7/6/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import "FTGradesViewController.h"
#import "KSCustomPopoverBackgroundView.h"
#import "FTAddGradeViewController.h"
#import "Grade.h"

@interface FTGradesViewController ()

@property (nonatomic, strong) UIPopoverController *masterPopoverController;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation FTGradesViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize masterPopoverController = _masterPopoverController;
@synthesize fetchedResultsController = _fetchedResultsController;

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

    self.title = @"Grades";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView setSeparatorColor:[UIColor colorWithWhite:0.604 alpha:1.000]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
    [self.tableView setRowHeight:64.0];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addGrade:)];
    [addButton setStyle:UIBarButtonItemStylePlain];
    
    [self.navigationItem setRightBarButtonItem:addButton];
    
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 85.0)];
    [headerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin];
    [self.tableView setTableHeaderView:headerView];
    
    CGFloat spacing = INTERFACE_IS_PAD? 41.0: 10.0;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(spacing, 18.0, self.tableView.frame.size.width - 2 * spacing, 54.0)];
    [imgView setImage:[[UIImage imageNamed:@"cumulativegpa.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)]];
    [imgView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];

    [headerView addSubview:imgView];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(spacing + 10.0, 18.0, self.tableView.frame.size.width - 2 * spacing - 10.0, 54.0)];
    [headerView setAutoresizingMask: UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin];

    [textLabel setText:@"Your Cumulative GPA is"];
    [textLabel setTextColor:[UIColor colorWithWhite:0.827 alpha:1.000]];
    [textLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
    [textLabel setTextAlignment:UITextAlignmentLeft];
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [headerView addSubview:textLabel];
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - 
#pragma mark Buttons

- (void) addGrade:(UIBarButtonItem *)barButtonItem {
    
    /* Check that:
     - There is no current popover
     - The popover is not visible
     - The popover is not the same popover we're going to display
     */
    if (self.masterPopoverController != nil && [self.masterPopoverController isPopoverVisible] && [self.masterPopoverController.contentViewController class] != [FTGradesViewController class]) return;
    
    FTAddGradeViewController *viewController = [[FTAddGradeViewController alloc] init];
    [viewController setManagedObjectContext:self.managedObjectContext];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    if (INTERFACE_IS_PAD) {
        UIPopoverController *pController = [[UIPopoverController alloc] initWithContentViewController:navController];
        [pController setPopoverContentSize:CGSizeMake(320.0, 484.0)];
        
        self.masterPopoverController = pController;
        [pController setPopoverBackgroundViewClass:[KSCustomPopoverBackgroundView class]];
        [pController presentPopoverFromBarButtonItem:barButtonItem permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        
    } else {
        [navController.navigationBar setBackgroundImage:[UIImage imageNamed:@"blacknavbar.png"] forBarMetrics:UIBarMetricsDefault];
        [self presentModalViewController:navController animated:YES];
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (INTERFACE_IS_PAD)?YES:(interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Grade" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"fullCredit" ascending:NO];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"subject" ascending:YES];

    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, sortDescriptor2, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    //Edit the Filter Predicates
    
    //    NSPredicate *combinedPredicate = [NSPredicate predicateWithFormat:@"inCollegeList == %@", self.isCollegeList];
    //    [fetchRequest setPredicate:combinedPredicate];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"year" cacheName:@"GRADES_CACHE"];
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
            
            [self configureCellsForInsertion:newIndexPath];
            
            break;
            
        case NSFetchedResultsChangeDelete:
            
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self configureCellsForDeletion:indexPath];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            //COMBINATION OF INSERTION AND DELETION
            
            //INSERTION

            [self configureCellsForInsertion:newIndexPath];
            
//            if (newIndexPath.row == 0) {
//                if ([tableView numberOfSections] < sectionsCount) return;
//                
//                NSIndexPath *secondIndexPath = [NSIndexPath indexPathForRow:1 inSection:newIndexPath.section];
//                [self configureCell:[tableView cellForRowAtIndexPath:newIndexPath] atIndexPath:secondIndexPath];
//                
//            } else {
//                NSIndexPath * possibleLastIndexPath = [NSIndexPath indexPathForRow:newIndexPath.row - 1 inSection:newIndexPath.section];
//                [self configureCell:[tableView cellForRowAtIndexPath:possibleLastIndexPath] atIndexPath:possibleLastIndexPath];
//            }
                            

            //DELETION

            [self configureCellsForDeletion:indexPath];
            
//            sections = [self.fetchedResultsController sections];
//            sectionsCount = [sections count];
//            
//            if (indexPath.row == 0) {
//                if ([tableView numberOfSections] > sectionsCount) return;
//
//                NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:1 inSection:section];
//                [self configureCell:[self.tableView cellForRowAtIndexPath:firstIndexPath] atIndexPath:indexPath];
//                
//            } else {
//                NSIndexPath * possibleLastIndexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
//                [self configureCell:[tableView cellForRowAtIndexPath:possibleLastIndexPath] atIndexPath:possibleLastIndexPath];
//            }
            
            break;
        default:
            break;
    }
}

- (void) configureCellsForInsertion:(NSIndexPath *) indexPath {
    NSArray * sections = [self.fetchedResultsController sections];
    NSInteger sectionsCount = [sections count];
    
    if (indexPath.row == 0) {
        if ([self.tableView numberOfSections] < sectionsCount) return;
        
        NSIndexPath *secondIndexPath = [NSIndexPath indexPathForRow:1 inSection:indexPath.section];
        [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:secondIndexPath];
        
    } else {
        NSIndexPath * possibleLastIndexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
        [self configureCell:[self.tableView cellForRowAtIndexPath:possibleLastIndexPath] atIndexPath:possibleLastIndexPath];
    }
}

- (void) configureCellsForDeletion:(NSIndexPath *) indexPath {
    NSArray * sections = [self.fetchedResultsController sections];
    NSInteger sectionsCount = [sections count];
    
    if (indexPath.row == 0) {
        if ([self.tableView numberOfSections] > sectionsCount) return;
        
        NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:1 inSection:indexPath.section];
        [self configureCell:[self.tableView cellForRowAtIndexPath:firstIndexPath] atIndexPath:indexPath];
        
    } else {
        NSIndexPath * possibleLastIndexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
        [self configureCell:[self.tableView cellForRowAtIndexPath:possibleLastIndexPath] atIndexPath:possibleLastIndexPath];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.backgroundColor = [UIColor colorWithRed:0.890 green:0.918 blue:0.933 alpha:1.000];
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    [cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
    
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    
    
    return cell;
}

// Customize the appearance of table view cells.

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:indexPath.section];
    
    if (indexPath.row == 0) {
        CGRect bounds = cell.backgroundView.bounds;
        CGRect imgViewRect = CGRectZero;
        imgViewRect.origin = CGPointZero;
        imgViewRect.size = bounds.size;
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:imgViewRect];
        [imgView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [imgView setImage:[[UIImage imageNamed:@"gradestopcell.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 9.0, 0.0, 9.0)]];
        //[cell.contentView addSubview:imgView];
        cell.backgroundView = imgView;
        
        NSLog(@"%f", cell.backgroundView.frame.size.height);
        
    } else if (indexPath.row == [sectionInfo numberOfObjects] - 1) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:cell.bounds];
        [imgView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [imgView setImage:[[UIImage imageNamed:@"gradesbottomcell.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 9.0, 0.0, 9.0)]];
        //[cell.contentView addSubview:imgView];
        cell.backgroundView = imgView;
    } else {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:cell.bounds];
        [imgView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [imgView setImage:[[UIImage imageNamed:@"gradecell.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0)]];
        //[cell.contentView addSubview:imgView];
        cell.backgroundView = imgView;
    }
    
    Grade *cellGrade = (Grade *)[self.fetchedResultsController objectAtIndexPath:indexPath];

    
    [cell.textLabel setText:[cellGrade subject]];
    NSArray *titleArray = [NSArray arrayWithObjects:@"A+", @"A", @"A-", @"B+", @"B", @"B-", @"C+", @"C", @"C-", @"D", @"F", @"N/A", nil];

    [cell.detailTextLabel setText:[titleArray objectAtIndex:10 - [[cellGrade score] integerValue]]];
    if ([[cellGrade fullCredit] boolValue]) {
     [cell.imageView setImage:[UIImage imageNamed:@"fullcredit.png"]];
    } else {
     [cell.imageView setImage:[UIImage imageNamed:@"halfcredit.png"]];
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	id <NSFetchedResultsSectionInfo> theSection = [[self.fetchedResultsController sections] objectAtIndex:section];

    
    NSInteger numericSection = [[theSection name] integerValue];
    
	
	NSString *titleString = [NSString stringWithFormat:@"%ith Grade", numericSection];
	
	return titleString;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        Grade *dGrade = (Grade *)[self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.managedObjectContext deleteObject:dGrade];
        NSError *err = nil;
        [self.managedObjectContext save:&err];
        if (err != nil) {
            NSLog(@"%@", [err localizedDescription]);
        }
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.image = [UIImage imageNamed:@"menu.png"];//NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
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
