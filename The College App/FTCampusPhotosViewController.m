//
//  FTCampusPhotosViewController.m
//  The College App
//
//  Created by Jeffrey Barg on 7/31/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import "FTCampusPhotosViewController.h"

#import "KSCustomPopoverBackgroundView.h"

#import "CampusPhoto.h"
#import "PhotoData.h"

#import <QuartzCore/QuartzCore.h>

@interface FTCampusPhotosViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    NSInteger _lastDeleteItemIndexAsked;   
    __gm_weak GMGridView *_gmGridView;   
}

@property (nonatomic, strong) UIPopoverController *masterPopoverController;

@end

@implementation FTCampusPhotosViewController

@synthesize managedObjectContext;
@synthesize visitViewController;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize masterPopoverController = _masterPopoverController;

@synthesize visit;

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
    
    NSInteger spacing = INTERFACE_IS_PHONE ? 10 : 16;
    NSInteger minInsets = INTERFACE_IS_PHONE? 10.0: 7.0;
    
    GMGridView *gmGridView = [[GMGridView alloc] initWithFrame:self.view.bounds];
    gmGridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    gmGridView.backgroundColor = [UIColor clearColor];
    _gmGridView = gmGridView;
    
    _gmGridView.style = GMGridViewStyleSwap;
    _gmGridView.itemSpacing = spacing;
    _gmGridView.minEdgeInsets = UIEdgeInsetsMake(10.0, minInsets, 10.0, minInsets);
    _gmGridView.centerGridHorizontally = YES;
    _gmGridView.actionDelegate = self;
    _gmGridView.dataSource = self;
    _gmGridView.allowsHorizontalReordering = NO;
    _gmGridView.centerGridHorizontally = YES;

    _gmGridView.alwaysBounceVertical = yeah;
    _gmGridView.bounces = hellzyeah;
    _gmGridView.enableEditOnLongPress = hellzyeah;
    _gmGridView.disableEditOnEmptySpaceTap = yep;
    
    [self.view addSubview:gmGridView];    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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

#pragma mark - Buttons

- (void) addPhoto:(UIView *) buttonView {
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [pickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        [pickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    [pickerController setDelegate:self];
    
    if (INTERFACE_IS_PAD) {
        if (_masterPopoverController && [self.masterPopoverController isPopoverVisible])
            [self.masterPopoverController dismissPopoverAnimated:NO];
        
        [pickerController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        
        _masterPopoverController = [[UIPopoverController alloc] initWithContentViewController:pickerController];
        [_masterPopoverController setPopoverBackgroundViewClass:[KSCustomPopoverBackgroundView class]];
        
        [_masterPopoverController presentPopoverFromRect:buttonView.frame inView:buttonView.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    } else {
        [self presentViewController:pickerController animated:YES completion:^{}];
        
        
    }
}

#pragma mark - UIImagePickerController Delegate

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    CampusPhoto * photo = [NSEntityDescription insertNewObjectForEntityForName:@"CampusPhoto" inManagedObjectContext:self.managedObjectContext];

    [photo setDateCreated:[NSDate date]];
    
    CGSize ctxSize = [self GMGridView:_gmGridView sizeForItemsInInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    CGRect ctxFrame = CGRectZero;
    ctxFrame.size = ctxSize;
    [photo setThumbnailImage:processImage(image, ctxFrame)];
    
    NSOperationQueue *bgQueue = [[NSOperationQueue alloc] init];
    [bgQueue addOperationWithBlock:^{
        
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            PhotoData * photoData = [NSEntityDescription insertNewObjectForEntityForName:@"PhotoData" inManagedObjectContext:self.managedObjectContext];
            [photoData setImage:data];
            [photoData setCampusPhoto:photo];
            
            NSError *err = nil;
            if ([self.managedObjectContext hasChanges] && ![self.managedObjectContext save:&err]) {
                NSLog(@"%@", [err description]);
            }
        }];
    }];
    
    
    if (INTERFACE_IS_PAD) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
    
}

UIImage * processImage(UIImage *image, CGRect ctxFrame) {
    CGSize ctxSize = ctxFrame.size;
    UIGraphicsBeginImageContextWithOptions(ctxSize, NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    CGRect roundedRectFrame = CGRectInset(ctxFrame, 4.0, 4.0);
    
    CGRect picFrame = CGRectInset(roundedRectFrame, 6.0, 6.0);

    UIBezierPath *roundedRectPath = [UIBezierPath bezierPathWithRoundedRect:roundedRectFrame byRoundingCorners:0 cornerRadii:CGSizeMake(4.0, 4.0)];

    CGContextSaveGState(ctx); {
        CGContextSetShadowWithColor(ctx , CGSizeMake(0.0, 1.0), 3.0, [UIColor colorWithWhite:0.5 alpha:1.0].CGColor);
        
        [roundedRectPath setLineWidth:1.0];
        [[UIColor whiteColor] setFill];
        [roundedRectPath fill];
        
    } CGContextRestoreGState(ctx);
    
    CGSize imgSize = image.size;
    
    CGFloat widthScale = imgSize.width / picFrame.size.width;
    CGFloat heightScale = imgSize.height / picFrame.size.height;
    
    CGContextSaveGState(ctx); {
        UIBezierPath *imgPath = [UIBezierPath bezierPathWithRect:picFrame];
        [imgPath addClip];
        
        CGRect imgRect = CGRectZero;

        if (widthScale < heightScale) {
             //Width is fully represented
            imgRect.size.height = imgSize.height / widthScale;
            imgRect.size.width = picFrame.size.width;
            
            imgRect.origin.y = picFrame.origin.y;
            imgRect.origin.x = picFrame.origin.x;
            
        } else {
            //Height is fully represented
            imgRect.size.height = picFrame.size.height;
            imgRect.size.width = imgSize.width / heightScale;
            
            imgRect.origin.y = picFrame.origin.y;
            imgRect.origin.x = picFrame.origin.x - (imgRect.size.width - picFrame.size.width)/2.0;
        }
        
        [image drawInRect:imgRect];
        
    } CGContextRestoreGState(ctx);

    CGContextSaveGState(ctx); {
        [roundedRectPath addClip];
        
        CGContextTranslateCTM(ctx, ctxSize.width * 5.0 / 6.0, -ctxSize.height/1.5);
        CGContextRotateCTM(ctx, degreesToRadians(45));
        
        //Draw Gloss
        
        //// Gradient Declarations
        [[UIBezierPath bezierPathWithRect:ctxFrame] addClip];
        
        NSArray* gradientColors = [NSArray arrayWithObjects: 
                                   (id)[UIColor colorWithWhite:1.0 alpha:0.20].CGColor, 
                                   (id)[UIColor colorWithWhite:1.0 alpha:0.075].CGColor, nil];
        CGFloat gradientLocations[] = {0, 1};
        CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
        
        CGContextDrawLinearGradient(ctx, gradient, CGPointMake(0, 0), CGPointMake(ctxFrame.size.width, 0), 0);
        
        CGGradientRelease(gradient);
        CGColorSpaceRelease(colorSpace);
    } CGContextRestoreGState(ctx);
    
    UIImage *retVal = UIGraphicsGetImageFromCurrentImageContext();
    
    //Cleanup
    
    UIGraphicsEndImageContext();
    
    return retVal;
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CampusPhoto" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateCreated" ascending:NO];
    //NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    //Edit the Filter Predicates
    
    //    NSPredicate *combinedPredicate = [NSPredicate predicateWithFormat:@"inCollegeList == %@", self.isCollegeList];
    //    [fetchRequest setPredicate:combinedPredicate];
    
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
            [_gmGridView insertObjectAtIndex:newIndexPath.row + 1 withAnimation:GMGridViewItemAnimationFade];
            
            //            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
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
            //[_gmGridView exchangeSubviewAtIndex:indexPath.row + 1 withSubviewAtIndex:newIndexPath.row + 1];
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
    return [sectionInfo numberOfObjects] + 1.0; //+ _addingCell?1:0; // Extra Cell when adding.
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return INTERFACE_IS_PAD? CGSizeMake(186.0, 145.0) : CGSizeMake(300.0, 230.0);
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    
    //NSLog(@"Creating view indx %d", index);
    
    CGSize size = [self GMGridView:gridView sizeForItemsInInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    UIImageView *imgView = nil;

    if (!cell)
    {
        cell = [[GMGridViewCell alloc] init];
        cell.deleteButtonIcon = [UIImage imageNamed:@"close_x.png"];
        cell.deleteButtonOffset = CGPointMake(-15, -15);
        
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        [imgView setContentMode:UIViewContentModeCenter];
        
        cell.contentView = imgView;
    } else {
        imgView = (UIImageView *) cell.contentView;
    }
    
    if (index == 0)
        [imgView setImage:[UIImage imageNamed:@"addphoto.png"]];
    else {
        CampusPhoto *photo = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:index-1 inSection:0]];
        [imgView setImage:photo.thumbnailImage];
    }
        
    return cell;
}


- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index
{
    return index != 0; //index % 2 == 0;
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewActionDelegate
//////////////////////////////////////////////////////////////

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)index {
    NSLog(@"Did tap at index %d", index);
    
    if (index == 0) {
        [self addPhoto:[gridView cellForItemAtIndex:index]];
        
    }
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
}

@end
