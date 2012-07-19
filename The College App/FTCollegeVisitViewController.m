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

#import "FTNearbyCollegesViewController.h"

#import "FTCollegeVisitNotesViewController.h"
#import "FTCollegeVisitPhotosViewController.h"
#import "FTCollegeVisitRatingsViewController.h"
#import "FTCollegeInfoViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "Visit.h"
#import "CampusPhoto.h"
#import "PhotoData.h"

#define kLatRadius 0.5
#define kLonRadius 0.5

#define MARGIN_X 15
#define MARGIN_Y 12

#define MARGIN_HEADER 12

#define HEADER_HEIGHT 30

@interface FTCollegeVisitViewController () {
}

@property (nonatomic, strong) FTNearbyCollegesViewController * nearbyCollegesViewController;

@property (nonatomic, strong) FTCollegeVisitNotesViewController *notesViewController;
@property (nonatomic, strong) FTCollegeVisitPhotosViewController *photosViewController;
@property (nonatomic, strong) FTCollegeVisitRatingsViewController *ratingsViewController;

@property (nonatomic, strong) UIView *notesView;
@property (nonatomic, strong) UIView *photosView;
@property (nonatomic, strong) UIView *ratingsView;

@property (nonatomic, strong) UIButton *notesButton;
@property (nonatomic, strong) UIButton *photosButton;
@property (nonatomic, strong) UIButton *ratingsButton;

@property (nonatomic, strong) UIButton *titleButton;

@end

@implementation FTCollegeVisitViewController

@synthesize managedObjectContext;
@synthesize masterPopoverController = _masterPopoverController;

@synthesize nearbyCollegesViewController = _nearbyCollegesViewController;

@synthesize notesViewController = _notesViewController;
@synthesize photosViewController = _photosViewController;
@synthesize ratingsViewController = _ratingsViewController;

@synthesize photosView = _photosView;
@synthesize ratingsView = _ratingsView;
@synthesize notesView = _notesView;

@synthesize photosButton;
@synthesize notesButton;
@synthesize ratingsButton;

@synthesize titleButton = _titleButton;

@synthesize school = _school;
@synthesize visit = _visit;

@synthesize isNotepadFocused = _isNotepadFocused;

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
//    //GIVE THIS ITS OWN MANAGED CONTEXT -- NO IDEA IF THIS WILL WORK
//    NSPersistentStoreCoordinator *coordinator = self.managedObjectContext.persistentStoreCoordinator;
//    NSManagedObjectContext *newContext = [[NSManagedObjectContext alloc] init];
//    [newContext setPersistentStoreCoordinator:coordinator];
//    self.managedObjectContext = newContext;
    
    [super viewDidLoad];
    
    self.isNotepadFocused = FALSE;
    
    UIBarButtonItem *cameraItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(takePhoto:)];
  
    self.navigationItem.rightBarButtonItem = cameraItem;
    
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectZero];  
    UIButton *titleButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [titleButton setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [titleView addSubview:titleButton];
    
    [titleButton setBackgroundImage:[[UIImage imageNamed:@"aphonors.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5.0, 0.0, 5.0)] forState:UIControlStateNormal];
    [titleButton addTarget:self action:@selector(showNearbyCollegesSelector:) forControlEvents:UIControlEventTouchUpInside];
    [titleButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    self.titleButton = titleButton;
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    [infoButton addTarget:self action:@selector(showInfo:) forControlEvents:UIControlEventTouchUpInside];
    
    [titleView addSubview:infoButton];
    [titleView setFrame:CGRectMake(0, 0, INTERFACE_IS_PHONE?200.0:320.0, 30)];                           
    
    [infoButton setCenter:CGPointMake(20, 15)];
    
    self.navigationItem.titleView = titleView;
    
    
    
    _photosView = [[UIView alloc] initWithFrame:CGRectZero];
    _ratingsView = [[UIView alloc] initWithFrame:CGRectZero];
    _notesView = [[UIView alloc] initWithFrame:CGRectZero];
    [_photosView setClipsToBounds:YES];
    [_ratingsView setClipsToBounds:YES];
    [_notesView setClipsToBounds:YES];
    
    [self.view addSubview:_photosView];
    [self.view addSubview:_ratingsView];
    [self.view addSubview:_notesView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bringFocusToNotepad)];
    [_notesView addGestureRecognizer:tapGestureRecognizer];
    
    _photosViewController = [[FTCollegeVisitPhotosViewController alloc] init];
    _ratingsViewController = [[FTCollegeVisitRatingsViewController alloc] initWithStyle:UITableViewStylePlain];
    _notesViewController = [[FTCollegeVisitNotesViewController alloc] init];
    
    [_photosViewController setVisitViewController:self];
    [_notesViewController setVisitViewController:self];
    
    [_notesViewController setManagedObjectContext:self.managedObjectContext];
    [_photosViewController setManagedObjectContext:self.managedObjectContext];
    
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
    
    [self performSelector:@selector(showNearbyCollegesSelector:) withObject:self.titleButton afterDelay:0.4];
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

    
    if (self.school == nil) {
        [self.photosView setFrame:CGRectOffset(self.photosView.frame, -CGRectGetMaxX(self.photosView.frame) - 20, 0)];        
        [self.photosButton setFrame:CGRectOffset(self.photosButton.frame, -CGRectGetMaxX(self.photosButton.frame), 0)];        
        
        [self.ratingsView setFrame:CGRectOffset(self.ratingsView.frame, self.view.bounds.size.width - CGRectGetMinX(self.ratingsView.frame) + 20, 0)];
        [self.ratingsButton setFrame:CGRectOffset(self.ratingsButton.frame, self.view.bounds.size.width - CGRectGetMinX(self.ratingsButton.frame), 0)];
        
        [self.notesView setFrame:CGRectOffset(self.notesView.frame, self.view.bounds.size.width - CGRectGetMinX(self.notesView.frame) + 20, 0)];
        [self.notesButton setFrame:CGRectOffset(self.notesButton.frame, self.view.bounds.size.width - CGRectGetMinX(self.notesButton.frame), 0)];

//        [self.photosView setTransform:CGAffineTransformMakeRotation(degreesToRadians(-30))];
//        [self.ratingsView setTransform:CGAffineTransformMakeRotation(degreesToRadians(25))];
//        [self.notesView setTransform:CGAffineTransformMakeRotation(degreesToRadians(35))];        

    } else {
        [self.photosView setTransform:CGAffineTransformMakeRotation(degreesToRadians(0))];
        [self.ratingsView  setTransform:CGAffineTransformMakeRotation(degreesToRadians(0))];
        [self.notesView  setTransform:CGAffineTransformMakeRotation(degreesToRadians(0))];

    }
    

}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)viewDidUnload
{
    self.visit = nil;
    
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (INTERFACE_IS_PAD || !(interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown));
}

#pragma mark - Buttons
- (void) showInfo:(UIButton *) infoButton {
    College *school = self.school;
    
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

- (void) showNearbyCollegesSelector:(UIButton *) titleButton {

    if (self.masterPopoverController != nil && [self.masterPopoverController isPopoverVisible] && [self.masterPopoverController.contentViewController class] != [FTNearbyCollegesViewController class]) return;
    
    FTNearbyCollegesViewController *nearbySchoolsViewController = [[FTNearbyCollegesViewController alloc] initWithStyle:UITableViewStylePlain];
    [nearbySchoolsViewController setManagedObjectContext:self.managedObjectContext];
    [nearbySchoolsViewController setVisitViewController:self];
    
    if (INTERFACE_IS_PAD) {
        UIPopoverController *pController = [[UIPopoverController alloc] initWithContentViewController:nearbySchoolsViewController];
        
        self.masterPopoverController = pController;
        
        [self.masterPopoverController setPopoverBackgroundViewClass:[KSCustomPopoverBackgroundView class]];

        [self.masterPopoverController presentPopoverFromRect:[titleButton.superview convertRect:titleButton.frame toView:self.view] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            
    } else {
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:nearbySchoolsViewController];
        [self presentViewController:navController animated:YES completion:^{}];
        
        [nearbySchoolsViewController.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissViewController)]];
    }
}
- (void) dismissViewController {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void) takePhoto:(UIBarButtonItem *) barButtonItem {
    
    if (self.masterPopoverController != nil && [self.masterPopoverController isPopoverVisible] && [self.masterPopoverController.contentViewController class] == [UIImagePickerController class]) return;
    
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    [pickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
    [pickerController setDelegate:self];
    
    if (INTERFACE_IS_PAD) {
        self.masterPopoverController = [[UIPopoverController alloc] initWithContentViewController:pickerController];
        [self.masterPopoverController setPopoverBackgroundViewClass:[KSCustomPopoverBackgroundView class]];
        
        [self.masterPopoverController presentPopoverFromBarButtonItem:barButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    } else {
        [self presentViewController:pickerController animated:YES completion:^{}];
    }
    
}

#pragma mark - UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *campusImage = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];    
    UIImageWriteToSavedPhotosAlbum(campusImage, nil, nil, nil);

    UIImage *thumb = processImage(campusImage);
    
    CampusPhoto *photoObject = [NSEntityDescription insertNewObjectForEntityForName:@"CampusPhoto" inManagedObjectContext:self.managedObjectContext];
    
    [photoObject setDateCreated:[NSDate date]];    
    [photoObject setThumbnailImage:thumb];
    [photoObject setVisit:self.visit];
    
    PhotoData *data = [NSEntityDescription insertNewObjectForEntityForName:@"PhotoData" inManagedObjectContext:self.managedObjectContext];
    [data setImage:campusImage];
    
    [photoObject setPhotoData:data];
    
    NSError *err = nil;
    if (![self.managedObjectContext save:&err]) {
        NSLog(@"%@", [err localizedDescription]);
    }
    
    //Dismiss Image Picker
    if (INTERFACE_IS_PAD)
        [self.masterPopoverController dismissPopoverAnimated:YES];
    else [self dismissViewControllerAnimated:YES completion:^{}];
    
}

UIImage *processImage(UIImage *campusImage) {
    
    CGSize ctxSize = INTERFACE_IS_PAD? CGSizeMake(186.0, 145.0) : CGSizeMake(300.0, 230.0);
    
    CGFloat imgWidth = campusImage.size.width;
    CGFloat imgHeight = campusImage.size.height;
    
    CGRect fullRect = CGRectMake(0, 0, ctxSize.width, ctxSize.height);
    
    CGRect sourceRect = CGRectZero;
    CGRect destRect = CGRectInset(fullRect, 10.0, 10.0);
    
    CGFloat widthScale = (destRect.size.width / imgWidth);
    CGFloat heightScale = (destRect.size.height / imgHeight);
    
    if (widthScale < heightScale) {
        sourceRect = CGRectMake((imgWidth-destRect.size.width/heightScale) / 2.0, 0, destRect.size.width / heightScale, imgHeight); // Top Middle Crop when horiz>vertical
    } else {
        sourceRect = CGRectMake(0, 0, imgWidth, imgHeight / widthScale); // Top Center crop
    }
    
    UIGraphicsBeginImageContextWithOptions(ctxSize, NO, 0.0); // 0.0 for scale means "correct scale for device's main screen".
    [[UIColor whiteColor] setFill];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(destRect, -5, -5) byRoundingCorners:0 cornerRadii:CGSizeMake(4.0, 4.0)];
    CGContextSaveGState(ctx); {
        CGContextSetShadowWithColor(ctx, CGSizeMake(0, 1), 3.0, [UIColor lightGrayColor].CGColor);
        
        [roundedRect fill];
    } CGContextRestoreGState(ctx);
    
    CGImageRef sourceImg = CGImageCreateWithImageInRect([campusImage CGImage], sourceRect); // cropping happens here.
    UIImage *thumb = [UIImage imageWithCGImage:sourceImg scale:0.0 orientation:campusImage.imageOrientation]; // create cropped UIImage.
    [thumb drawInRect:destRect]; // the actual scaling happens here, and orientation is taken care of automatically.
    CGImageRelease(sourceImg);
    
    CGContextSaveGState(ctx); {
        [roundedRect addClip];
        CGContextTranslateCTM(ctx, ctxSize.width * 5.0 / 6.0, -ctxSize.height/1.5);
        CGContextRotateCTM(ctx, degreesToRadians(45));
        
        //Draw Gloss
        
        //// Gradient Declarations
        [[UIBezierPath bezierPathWithRect:fullRect] addClip];
        
        NSArray* gradientColors = [NSArray arrayWithObjects: 
                                   (id)[UIColor colorWithWhite:1.0 alpha:0.20].CGColor, 
                                   (id)[UIColor colorWithWhite:1.0 alpha:0.075].CGColor, nil];
        CGFloat gradientLocations[] = {0, 1};
        CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
        
        CGContextDrawLinearGradient(ctx, gradient, CGPointMake(0, 0), CGPointMake(fullRect.size.width, 0), 0);
        
        CGGradientRelease(gradient);
        CGColorSpaceRelease(colorSpace);
    } CGContextRestoreGState(ctx);
    
    thumb = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return thumb;
}



#pragma mark - Custom Properties

- (void) setSchool:(College *)school {
    if (school == _school) return;
    self.visit = nil;
    if (_school == nil) {
        _school = school;
        
        self.photosViewController.visit = self.visit;
        self.notesViewController.visit = self.visit;
        self.ratingsViewController.visit = self.visit;
        
        [UIView animateWithDuration:0.6 animations:^{
            [self viewWillLayoutSubviews];
        }];
    } else {
        _school = nil;
        [UIView animateWithDuration:0.4 animations:^{
            [self viewWillLayoutSubviews];
        } completion:^(BOOL completed) {
            self.school = school;
            
            self.photosViewController.visit = self.visit;
            self.notesViewController.visit = self.visit;
            self.ratingsViewController.visit = self.visit;
            
            [UIView animateWithDuration:0.5 animations:^{
                [self viewWillLayoutSubviews];
            }];
        }];
    }
    
    [self.titleButton setTitle:school.name forState:UIControlStateNormal];
}

- (Visit *) visit {
    if (_visit != nil) {
        return _visit;
    } 
    
    if (self.school == nil) return nil;
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[[NSDate alloc] init]];
    
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    NSDate *startDay = [cal dateByAddingComponents:components toDate:[[NSDate alloc] init] options:0]; //This variable should now be pointing at a date object that is the start of today (midnight);
    
    
    [components setHour:24];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *endDay = [cal dateByAddingComponents:components toDate: startDay options:0];
 
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(dateCreated >= %@) AND (dateCreated <= %@) AND college = %@", startDay, endDay, self.school];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Visit"];
    [fetchRequest setPredicate:predicate];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateCreated" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *err = nil;
    NSArray *possibleVisits = [self.managedObjectContext executeFetchRequest:fetchRequest error:&err];
    if (err != nil) {
        NSLog(@"%@", [err localizedDescription]);
    }
    
    if ([possibleVisits count] == 0) {
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Visit" inManagedObjectContext:self.managedObjectContext];
        _visit = [[Visit alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.managedObjectContext];
        _visit.college = self.school;
        _visit.dateCreated = [NSDate date];

    } else {
        _visit = (Visit *)[possibleVisits lastObject];
    }
    
    return _visit;
}

- (void) setVisit:(Visit *)visit {
    //Check if old visit is worth saving -- else delete.
    Visit *oldVisit = _visit;
    _visit = visit;
    
    if (oldVisit == nil) return;
    
    if ([oldVisit notes] == nil && [oldVisit campusPhotos] == nil && [oldVisit campusRatings] == nil) {
        [self.managedObjectContext deleteObject:oldVisit];
    } 
}

#pragma mark - Quasi-Delegate Stuff

- (void) bringFocusToNotepad {
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.notesView setFrame:CGRectOffset(self.notesView.frame, 0, self.view.bounds.size.height - CGRectGetMinY(self.notesView.frame) + HEADER_HEIGHT + MARGIN_HEADER + 20)];
        [self.notesButton setFrame:CGRectOffset(self.notesButton.frame, 0, self.view.bounds.size.height - CGRectGetMinY(self.notesButton.frame) + 20)];
        
    }completion:^(BOOL completed) {
//        FTCollegeVisitNotesViewController *newViewController = [[FTCollegeVisitNotesViewController alloc] init];
//        [newViewController setVisitViewController:self];
            
        [self.notesViewController removeFromParentViewController];
        [self.notesViewController.view removeFromSuperview];
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.notesViewController];
        [navController setModalPresentationStyle:UIModalPresentationPageSheet];
        
        [self presentModalViewController:navController animated:YES];
    }];
}

- (void) unfocusNotepad {
    self.isNotepadFocused = FALSE;

    [self.notesViewController willMoveToParentViewController:self];
    [self addChildViewController:self.notesViewController];
    [self.notesView addSubview:self.notesViewController.view];
    [self.notesViewController.view setFrame:self.notesView.bounds];
    [self.notesViewController.view setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [self.notesViewController didMoveToParentViewController:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self viewWillLayoutSubviews];
    }];
}

@end
