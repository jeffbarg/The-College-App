//
//  FTCollegeVisitingViewController.m
//  The College App
//
//  Created by Jeffrey Barg on 7/31/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import "FTCollegeVisitingViewController.h"

#import "FTCampusNotesViewController.h"
#import "FTCampusPhotosViewController.h"
#import "FTCampusRatingsViewController.h"

#import "GMGridView.h"

#import <QuartzCore/QuartzCore.h>

#define MARGIN_X 15
#define MARGIN_Y 12

#define MARGIN_HEADER 12

#define HEADER_HEIGHT 30

@interface FTCollegeVisitingViewController ()

@property (nonatomic, strong) FTCampusNotesViewController   * notesViewController;
@property (nonatomic, strong) FTCampusPhotosViewController  * photosViewController;
@property (nonatomic, strong) FTCampusRatingsViewController * ratingsViewController;

@property (nonatomic, strong) UIButton *notesButton;
@property (nonatomic, strong) UIButton *photosButton;
@property (nonatomic, strong) UIButton *ratingsButton;

@property (nonatomic, strong) UITapGestureRecognizer *notesGestureRecognizer;

@end

@implementation FTCollegeVisitingViewController

@synthesize notesViewController;
@synthesize photosViewController;
@synthesize ratingsViewController;

@synthesize photosButton;
@synthesize notesButton;
@synthesize ratingsButton;

@synthesize notesGestureRecognizer;

@synthesize school;

@synthesize managedObjectContext;

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
    
    notesViewController = [[FTCampusNotesViewController alloc] init];
    ratingsViewController = [[FTCampusRatingsViewController alloc] init];
    photosViewController = [[FTCampusPhotosViewController alloc] init];
    
    [notesViewController setManagedObjectContext:self.managedObjectContext];
    [ratingsViewController setManagedObjectContext:self.managedObjectContext];
    [photosViewController setManagedObjectContext:self.managedObjectContext];
    
    [notesViewController setVisitViewController:self];
    [ratingsViewController setVisitViewController:self];
    [photosViewController setVisitViewController:self];
    
    
    NSArray *viewControllers = [[NSArray alloc] initWithObjects:notesViewController, ratingsViewController, photosViewController, nil];
    
    for (UIViewController *viewController in viewControllers) {

        [viewController.view setBackgroundColor:[UIColor colorWithHue:0.574 saturation:0.037 brightness:0.970 alpha:1.000]];        
        
        if (INTERFACE_IS_PAD) {
            [viewController.view.layer setBorderColor:[UIColor colorWithHue:0.574 saturation:0.037 brightness:0.766 alpha:1.000].CGColor];
            [viewController.view.layer setBorderWidth:1.0];
            [viewController.view.layer setCornerRadius:5.0];
            
            [self addChildViewController:viewController];
            [self.view addSubview:viewController.view];
            [viewController didMoveToParentViewController:self];
        } else {
            UITabBarController *tabbarController = [[UITabBarController alloc] init];
            
            [tabbarController setViewControllers:[NSArray arrayWithObjects:photosViewController, ratingsViewController, notesViewController, nil]];
            
            [tabbarController.view setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
            [tabbarController.tabBar setBackgroundImage:[UIImage imageNamed:@"iphonetab.png"]];
            
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(floorf(self.view.frame.size.width / 3.0) + 2, 50.0), YES, 0.0);
            [[[UIImage imageNamed:@"iphoneactivetab.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(24.0, 13.0, 24.0, 13.0)] drawInRect:CGRectMake(0, 0, floorf(self.view.frame.size.width / 3.0) + 2, 50.0)];
            UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            [tabbarController.tabBar setSelectionIndicatorImage:img];
            
            
            [self addChildViewController:tabbarController];
            [self.view addSubview:tabbarController.view];
            
            [tabbarController didMoveToParentViewController:self];
            
            [tabbarController.view setFrame:self.view.bounds];
        }
    }
    
    ratingsButton = [[UIButton alloc] initWithFrame:CGRectZero];
    photosButton = [[UIButton alloc] initWithFrame:CGRectZero];
    notesButton = [[UIButton alloc] initWithFrame:CGRectZero];

    [ratingsButton setTitle:@"Ratings" forState:UIControlStateNormal];
    [photosButton setTitle:@"Photos" forState:UIControlStateNormal];
    [notesButton setTitle:@"Notes" forState:UIControlStateNormal];

    UIColor *textColor = [UIColor colorWithWhite:0.322 alpha:1.000];
    UIFont *textFont = [UIFont boldSystemFontOfSize:14.0];
    
    NSArray *sectionButtons = [[NSArray alloc] initWithObjects:ratingsButton, photosButton, notesButton, nil];
    for (UIButton *button in sectionButtons) {
        [self.view addSubview:button];
        
        [button setTitleColor:textColor forState:UIControlStateNormal];
        [button setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal];
        [button.titleLabel setShadowOffset:CGSizeMake(0, 0)];
        [button.titleLabel setFont:textFont];
        [button.titleLabel setTextAlignment:UITextAlignmentLeft];
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [button setContentEdgeInsets:UIEdgeInsetsMake(0.0, 15.0, 0.0, 0.0)];
        
        [button setBackgroundImage:[[UIImage imageNamed:@"visitsectionheader.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)] forState:UIControlStateNormal];
        [button setBackgroundImage:[[UIImage imageNamed:@"visitsectionheader.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)] forState:UIControlStateHighlighted];
    }

    notesGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bringFocusToNotepad)];
    if (INTERFACE_IS_PAD)
        [self.notesViewController.view addGestureRecognizer:notesGestureRecognizer];
    
    
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    if (INTERFACE_IS_PAD) {
        UIView * photosView = self.photosViewController.view;
        UIView * notesView = self.notesViewController.view;
        UIView * ratingsView = self.ratingsViewController.view;

        //Let's hope to god I don't have to rewrite this.  just change defines.
        [photosView setFrame:CGRectMake(MARGIN_X,  MARGIN_Y + HEADER_HEIGHT + MARGIN_HEADER, self.view.frame.size.width - 320 - 3 * MARGIN_X, self.view.frame.size.height - (2 * MARGIN_Y + HEADER_HEIGHT + MARGIN_HEADER))];

        [ratingsView setFrame:CGRectMake(self.view.frame.size.width - 320 - MARGIN_X, MARGIN_Y + HEADER_HEIGHT + MARGIN_HEADER, 320, (self.view.frame.size.height - 2 * HEADER_HEIGHT - 3 * MARGIN_HEADER - 2*  MARGIN_Y) / 2.0)]; 

        [self.photosButton setFrame:CGRectMake(MARGIN_X, MARGIN_Y, CGRectGetWidth(photosView.frame), HEADER_HEIGHT)];
        [self.ratingsButton setFrame:CGRectMake(CGRectGetMaxX(photosView.frame) + MARGIN_X, MARGIN_Y, CGRectGetWidth(ratingsView.frame), HEADER_HEIGHT)];

        if (self.notesViewController.parentViewController == self) {
            [notesView setFrame:CGRectMake(self.view.frame.size.width - 320 - MARGIN_X, CGRectGetMaxY(ratingsView.frame) + 2 * MARGIN_HEADER + HEADER_HEIGHT, 320, (self.view.frame.size.height - 2 * HEADER_HEIGHT - 3 * MARGIN_HEADER - 2 * MARGIN_Y) / 2.0)];
            [self.notesButton setFrame:CGRectMake(CGRectGetMaxX(photosView.frame) + MARGIN_X, MARGIN_HEADER + CGRectGetMaxY(ratingsView.frame), CGRectGetWidth(ratingsView.frame), HEADER_HEIGHT)];   
        }
        
        if (self.school != nil) {
            [photosView setFrame:CGRectOffset(photosView.frame, -CGRectGetMaxX(photosView.frame) - 20, 0)];        
            [self.photosButton setFrame:CGRectOffset(self.photosButton.frame, -CGRectGetMaxX(self.photosButton.frame), 0)];        
            
            [ratingsView setFrame:CGRectOffset(ratingsView.frame, self.view.bounds.size.width - CGRectGetMinX(ratingsView.frame) + 20, 0)];
            [self.ratingsButton setFrame:CGRectOffset(self.ratingsButton.frame, self.view.bounds.size.width - CGRectGetMinX(self.ratingsButton.frame), 0)];
            
            [notesView setFrame:CGRectOffset(notesView.frame, self.view.bounds.size.width - CGRectGetMinX(notesView.frame) + 20, 0)];
            [self.notesButton setFrame:CGRectOffset(self.notesButton.frame, self.view.bounds.size.width - CGRectGetMinX(self.notesButton.frame), 0)];     
            
        } else {
            [photosView setTransform:CGAffineTransformMakeRotation(degreesToRadians(0))];
            [ratingsView  setTransform:CGAffineTransformMakeRotation(degreesToRadians(0))];
            [notesView  setTransform:CGAffineTransformMakeRotation(degreesToRadians(0))];
        }
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

#pragma mark - Buttons

- (void) bringFocusToNotepad {
    [self.notesViewController.view removeGestureRecognizer:self.notesGestureRecognizer];
    
    [UIView animateWithDuration:0.4 animations:^{
        [self.notesViewController.view setFrame:CGRectMake(self.view.frame.size.width - 320 - MARGIN_X, self.view.frame.size.height, 320, (self.view.frame.size.height - 2 * HEADER_HEIGHT - 3 * MARGIN_HEADER - 2 * MARGIN_Y) / 2.0)];
        [self.notesButton setFrame:CGRectMake(self.view.frame.size.width - 320 - MARGIN_X, self.view.frame.size.height, 320, HEADER_HEIGHT)];   

    } completion:^ (BOOL completed) {
        [self.notesViewController willMoveToParentViewController:nil];
        [self.notesViewController removeFromParentViewController];
        [self.notesViewController.view removeFromSuperview];
        
        [self.notesViewController.view.layer setBorderColor:nil];
        [self.notesViewController.view.layer setBorderWidth:0.0];
        [self.notesViewController.view.layer setCornerRadius:0.0];
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.notesViewController];
        [navController setModalPresentationStyle:UIModalPresentationPageSheet];
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(returnFromNotepad)];
        [doneButton setBackgroundImage:[UIImage imageNamed:@"notesdone.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [doneButton setBackgroundImage:[UIImage imageNamed:@"notesdoneactive.png"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        
        self.notesViewController.navigationItem.leftBarButtonItem = doneButton;
        
        [navController.navigationBar setBackgroundImage:[UIImage imageNamed:@"notesnav.png"] forBarMetrics:UIBarMetricsDefault];
        
        [navController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                         [UIColor whiteColor], UITextAttributeTextColor,
                                                                         [UIColor blackColor], UITextAttributeTextShadowColor,
                                                                         [NSValue valueWithUIOffset:UIOffsetMake(0, -1)], UITextAttributeTextShadowOffset,
                                                                         nil]];
        
        [self presentViewController:navController animated:YES completion:^{}];
    }];
    

}

- (void) returnFromNotepad {
    
    [self.notesViewController dismissViewControllerAnimated:YES completion:^{
        [self.notesViewController.view addGestureRecognizer:self.notesGestureRecognizer];
        
        [self.notesViewController.view.layer setBorderColor:[UIColor colorWithHue:0.574 saturation:0.037 brightness:0.766 alpha:1.000].CGColor];
        [self.notesViewController.view.layer setBorderWidth:1.0];
        [self.notesViewController.view.layer setCornerRadius:5.0];
        
        [self addChildViewController:self.notesViewController];
        [self.view addSubview:self.notesViewController.view];
        [self.notesViewController didMoveToParentViewController:self];
        
        [self.notesButton setFrame:CGRectMake(self.view.frame.size.width - 320 - MARGIN_X, self.view.frame.size.height, 320, HEADER_HEIGHT)];   
        [self.notesViewController.view setFrame:CGRectMake(self.view.frame.size.width - 320 - MARGIN_X, self.view.frame.size.height + HEADER_HEIGHT + MARGIN_HEADER, 320, (self.view.frame.size.height - 2 * HEADER_HEIGHT - 3 * MARGIN_HEADER - 2 * MARGIN_Y) / 2.0)];
        
        [UIView animateWithDuration:0.4 animations:^{
            [self viewWillLayoutSubviews];
        }];

        
    }];
}

@end
