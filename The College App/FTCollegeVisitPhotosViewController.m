//
//  FTCollegeVisitPhotosViewController.m
//  The College App
//
//  Created by Jeffrey Barg on 7/13/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import "FTCollegeVisitPhotosViewController.h"
#import "GMGridView.h"
#import "ECSlidingViewController.h"
#import "KSCustomPopoverBackgroundView.h"

#import "Visit.h"
#import "CampusPhoto.h"

#import <QuartzCore/QuartzCore.h>

@interface FTCollegeVisitPhotosViewController ()<NSFetchedResultsControllerDelegate, GMGridViewDataSource, GMGridViewActionDelegate> {
    NSInteger _lastDeleteItemIndexAsked;   
    __gm_weak GMGridView *_gmGridView;   
}

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation FTCollegeVisitPhotosViewController

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext;
@synthesize visitViewController = _visitViewController;
@synthesize visit = _visit;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) loadView {
    [super loadView];
    
    NSInteger spacing = INTERFACE_IS_PHONE? 10 : 10;
    NSInteger minInsets = INTERFACE_IS_PHONE? 5 : 10;
    GMGridView *gmGridView = [[GMGridView alloc] initWithFrame:self.view.bounds];
    gmGridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    gmGridView.backgroundColor = [UIColor clearColor];
    _gmGridView = gmGridView;
    
    _gmGridView.style = GMGridViewStylePush;
    _gmGridView.itemSpacing = spacing;
    _gmGridView.minEdgeInsets = UIEdgeInsetsMake(spacing, minInsets, spacing, minInsets);
    _gmGridView.centerGridHorizontally = YES;
    _gmGridView.actionDelegate = self;
    _gmGridView.dataSource = self;
    _gmGridView.allowsHorizontalReordering = YES;

    _gmGridView.alwaysBounceVertical = yeah;
    _gmGridView.bounces = hellzyeah;
    _gmGridView.enableEditOnLongPress = hellzyeah;
    _gmGridView.disableEditOnEmptySpaceTap = yep;
    
    [self.view addSubview:gmGridView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    _gmGridView.mainSuperView = [UIApplication sharedApplication].keyWindow.rootViewController.view;

    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.925 alpha:1.000]];

    if (INTERFACE_IS_PAD) {
        [self.view.layer setCornerRadius:5.0];
        [self.view.layer setBorderColor:[UIColor colorWithWhite:0.686 alpha:1.000].CGColor];
        [self.view.layer setBorderWidth:1.0];
        

    }
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

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    if (self.visit == nil) return nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CampusPhoto" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:10];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateCreated" ascending:YES];
    //NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    //Edit the Filter Predicates
    
    NSPredicate *combinedPredicate = [NSPredicate predicateWithFormat:@"visit == %@", self.visit];
    [fetchRequest setPredicate:combinedPredicate];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
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
            [_gmGridView insertObjectAtIndex:newIndexPath.row + 1 withAnimation:GMGridViewItemAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            
            //            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            [_gmGridView removeObjectAtIndex:indexPath.row withAnimation:GMGridViewItemAnimationFade];

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
    return [sectionInfo numberOfObjects] + 1; // 1 more for adding photo interface.
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return INTERFACE_IS_PAD? CGSizeMake(186.0, 145.0) : CGSizeMake(300.0, 230.0);
    //return INTERFACE_IS_PHONE ? CGSizeMake(284.0, 204.0f) : CGSizeMake(304.0, 204.0);
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
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        [imgView setContentMode:UIViewContentModeCenter];
        
        [imgView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        cell.contentView = imgView;


    }

    UIImageView *imgView = (UIImageView *) cell.contentView;
    
    if (index != 0) {
        CampusPhoto *photo = (CampusPhoto *) [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:index-1 inSection:0]];
        
        [imgView setImage:[photo thumbnailImage]];
    } else {
        [imgView setImage:[UIImage imageNamed:@"addphoto.png"]];
        [imgView setHighlightedImage:[UIImage imageNamed:@"addphoto.png"]];
    }
    
    [cell setHidden:NO];
    
    return cell;
}


- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index
{
    return (index != 0); //index % 2 == 0;
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewActionDelegate
//////////////////////////////////////////////////////////////

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)index {
    NSLog(@"Did tap at index %d", index);
    if (index == 0) {
        GMGridViewCell *cell = [gridView cellForItemAtIndex:index];
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
        [pickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
        [pickerController setDelegate:self.visitViewController];
        
        if (INTERFACE_IS_PAD) {
            self.visitViewController.masterPopoverController = [[UIPopoverController alloc] initWithContentViewController:pickerController];
            [self.visitViewController.masterPopoverController setPopoverBackgroundViewClass:[KSCustomPopoverBackgroundView class]];
            
            [self.visitViewController.masterPopoverController presentPopoverFromRect:cell.frame inView:gridView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            
        } else {
            [self presentViewController:pickerController animated:YES completion:^{}];
        }
    } else {
        CampusPhoto *photo = (CampusPhoto *)[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:index-1 inSection:0]];
        
        PhotoData *data = [photo photoData];
        
        FTCampusImageViewController *imgViewController = [[FTCampusImageViewController alloc] init];
        [imgViewController setImage:data];
        [imgViewController setModalPresentationStyle:UIModalPresentationFullScreen];
        [self presentViewController:imgViewController animated:YES completion:^{}];
    }
}

- (void)GMGridViewDidTapOnEmptySpace:(GMGridView *)gridView
{
    NSLog(@"Tap on empty space");
    [gridView setEditing:NO animated:hellzyeah];
    
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
        NSManagedObject *objectToBeDeleted = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:_lastDeleteItemIndexAsked - 1 inSection:0]];
        [self.managedObjectContext deleteObject:objectToBeDeleted];
        NSError *err = nil;
        if (![self.managedObjectContext save:&err]) {
            NSLog(@"%@", [err localizedDescription]);
        }
        
        [_gmGridView removeObjectAtIndex:_lastDeleteItemIndexAsked withAnimation:GMGridViewItemAnimationFade];
        [_gmGridView setEditing:NO animated:NO];
    }
}

#pragma mark - Custom Properties

- (void) setVisit:(Visit *)visit {
    _visit = visit;
    _fetchedResultsController = nil;
    NSError *err = nil;

    if (err != nil) {
        NSLog(@"%@", [err localizedDescription]);
    }
    [_gmGridView reloadData];
}

@end