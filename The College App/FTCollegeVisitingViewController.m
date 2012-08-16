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

#import "FTCollegeInfoViewController.h"

#import "FTSegmentedControllerViewController.h"
#import "FTNearbyCollegesViewController.h"
#import "FTSearchNearbySchoolsViewController.h"

#import "GMGridView.h"
#import "KSCustomPopoverBackgroundView.h"

#import "College.h"

#import <QuartzCore/QuartzCore.h>

#define MARGIN_X 15
#define MARGIN_Y 12

#define MARGIN_HEADER 12

#define HEADER_HEIGHT 30

@interface FTCollegeVisitingViewController ()

@property (nonatomic, strong) FTCampusNotesViewController   * notesViewController;
@property (nonatomic, strong) FTCampusPhotosViewController  * photosViewController;
@property (nonatomic, strong) FTCampusRatingsViewController * ratingsViewController;

@property (nonatomic, strong) FTCollegeInfoViewController   * infoViewController;

@property (nonatomic, strong) UITabBarController *iPhoneTabController;

@property (nonatomic, strong) UIButton *notesButton;
@property (nonatomic, strong) UIButton *photosButton;
@property (nonatomic, strong) UIButton *ratingsButton;

@property (nonatomic, strong) UIButton *titleButton;

@property (nonatomic, strong) UITapGestureRecognizer *notesGestureRecognizer;

@end

@implementation FTCollegeVisitingViewController

@synthesize notesViewController;
@synthesize photosViewController;
@synthesize ratingsViewController;

@synthesize infoViewController;

@synthesize iPhoneTabController;

@synthesize photosButton;
@synthesize notesButton;
@synthesize ratingsButton;

@synthesize titleButton;

@synthesize notesGestureRecognizer;

@synthesize school = _school;

@synthesize masterPopoverController;

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
            
            [viewController.view setClipsToBounds:YES];
            
            [self addChildViewController:viewController];
            [self.view addSubview:viewController.view];
            [viewController didMoveToParentViewController:self];
        } else {
            iPhoneTabController = [[UITabBarController alloc] init];
            
            infoViewController = [[FTCollegeInfoViewController alloc] initWithNibName:@"FTCollegeInfoViewController" bundle:[NSBundle mainBundle]];
            [infoViewController setSchool:nil];
            [infoViewController setManagedObjectContext:self.managedObjectContext];
            
            [iPhoneTabController setViewControllers:[NSArray arrayWithObjects:photosViewController, ratingsViewController, notesViewController, infoViewController, nil]];
            
            [iPhoneTabController.view setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
            [iPhoneTabController.tabBar setBackgroundImage:[UIImage imageNamed:@"iphonetab.png"]];
            
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(floorf(self.view.frame.size.width / 4.0) + 2, 50.0), YES, 0.0);
            [[[UIImage imageNamed:@"iphoneactivetab.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(24.0, 13.0, 24.0, 13.0)] drawInRect:CGRectMake(0, 0, floorf(self.view.frame.size.width / 4.0) + 4, 50.0)];
            UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            [iPhoneTabController.tabBar setSelectionIndicatorImage:img];
            
            
            [self addChildViewController:iPhoneTabController];
            [self.view addSubview:iPhoneTabController.view];
            
            [iPhoneTabController didMoveToParentViewController:self];
            
            [iPhoneTabController.view setFrame:self.view.bounds];
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
        [button setContentEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0)];
        
        [button setBackgroundImage:[[UIImage imageNamed:@"visitsectionheader.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)] forState:UIControlStateNormal];
        [button setBackgroundImage:[[UIImage imageNamed:@"visitsectionheader.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)] forState:UIControlStateHighlighted];
    }

    notesGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bringFocusToNotepad)];
    if (INTERFACE_IS_PAD)
        [self.notesViewController.view addGestureRecognizer:notesGestureRecognizer];
    
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, INTERFACE_IS_PAD? 340.0 : 260.0, 30.0)];
    titleButton = [[UIButton alloc] initWithFrame:titleView.bounds];
    
    if (INTERFACE_IS_PAD) {
        [titleButton setBackgroundImage:[[UIImage imageNamed:@"infotitle.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)] forState:UIControlStateNormal];
        [titleButton setBackgroundImage:[[UIImage imageNamed:@"infotitleactive.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)] forState:UIControlStateHighlighted];
    } else {
        [titleButton setBackgroundImage:[[UIImage imageNamed:@"cancel.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)] forState:UIControlStateNormal];
        [titleButton setBackgroundImage:[[UIImage imageNamed:@"cancelactive.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)] forState:UIControlStateHighlighted];

    }
    [titleButton setTitle:@"" forState:UIControlStateNormal];
    [titleButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
    
    if (INTERFACE_IS_PAD) {
        [titleButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [titleButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [titleButton.titleLabel setShadowOffset:CGSizeMake(0.0, 1.0)];

    } else {
        [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [titleButton setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
        [titleButton.titleLabel setShadowOffset:CGSizeMake(0.0, -1.0)];

    }
    [titleButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 15.0, 0.0, 15.0)];
    [titleButton addTarget:self action:@selector(showNearbyCollegesSelector:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = titleView;
    
    [titleView addSubview:titleButton];
    
    [self performSelector:@selector(showNearbyCollegesSelector:) withObject:self.titleButton afterDelay:0.4];
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
        
        if (self.school == nil) {
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

- (void) showCollegeInfo {
    
}

- (void) showNearbyCollegesSelector:(UIButton *) _titleButton {
    
    if (self.masterPopoverController != nil && [self.masterPopoverController isPopoverVisible] && [self.masterPopoverController.contentViewController class] != [FTNearbyCollegesViewController class]) return;
    

    FTNearbyCollegesViewController *nearbySchoolsViewController = [[FTNearbyCollegesViewController alloc] initWithStyle:UITableViewStylePlain];
    [nearbySchoolsViewController setManagedObjectContext:self.managedObjectContext];
    [nearbySchoolsViewController setVisitViewController:self];
    
    FTSearchNearbySchoolsViewController *searchViewController  = [[FTSearchNearbySchoolsViewController alloc] initWithStyle:UITableViewStylePlain];
    [searchViewController setManagedObjectContext:self.managedObjectContext];
    [searchViewController setVisitViewController:self];
   
    FTSegmentedControllerViewController *segmentViewController = [[FTSegmentedControllerViewController alloc] init];
    [segmentViewController setViewControllers:[NSArray arrayWithObjects:nearbySchoolsViewController, searchViewController, nil]];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:segmentViewController];
    
    if (INTERFACE_IS_PAD) {
        [navController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        
        UIPopoverController *pController = [[UIPopoverController alloc] initWithContentViewController:navController];
        
        self.masterPopoverController = pController;
        
        [self.masterPopoverController setPopoverBackgroundViewClass:[KSCustomPopoverBackgroundView class]];
        
        [self.masterPopoverController presentPopoverFromRect:[titleButton.superview convertRect:titleButton.frame toView:self.view] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    } else {
        [self presentViewController:navController animated:YES completion:^{}];
        [segmentViewController.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissViewController)]];
    }
}

- (void) dismissViewController {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

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

#pragma mark - Custom Properties

- (void) setSchool:(College *)school {
    if (school == _school) return;
    
    if (_school == nil) {
        _school = school;
        
        self.photosViewController.school = self.school;
        self.notesViewController.school = self.school;
        self.ratingsViewController.school = self.school;
        
        if (INTERFACE_IS_PHONE) {
            infoViewController = [[FTCollegeInfoViewController alloc] initWithNibName:@"FTCollegeInfoViewController" bundle:[NSBundle mainBundle]];
            [infoViewController setManagedObjectContext:self.managedObjectContext];
            [infoViewController setSchool:self.school];
            
            [self.iPhoneTabController setViewControllers:[NSArray arrayWithObjects:self.photosViewController, self.ratingsViewController, self.notesViewController, infoViewController, nil]];
        }
            
        [UIView animateWithDuration:0.6 animations:^{
            [self viewWillLayoutSubviews];
        }];
            
    } else {
        _school = nil;
        [UIView animateWithDuration:0.4 animations:^{
            [self viewWillLayoutSubviews];
        } completion:^(BOOL completed) {
            self.school = school;
            
            self.photosViewController.school = self.school;
            self.notesViewController.school = self.school;
            self.ratingsViewController.school = self.school;
            
            if (INTERFACE_IS_PHONE) {
                infoViewController = [[FTCollegeInfoViewController alloc] initWithNibName:@"FTCollegeInfoViewController" bundle:[NSBundle mainBundle]];
                [infoViewController setManagedObjectContext:self.managedObjectContext];
                [infoViewController setSchool:self.school];
                
                [self.iPhoneTabController setViewControllers:[NSArray arrayWithObjects:self.photosViewController, self.ratingsViewController, self.notesViewController, infoViewController, nil]];
            }   
            
            [UIView animateWithDuration:0.4 animations:^{
                [self viewWillLayoutSubviews];
            }];
        }];
    }
    
    [self.titleButton setTitle:school.name forState:UIControlStateNormal];
}

//- (Visit *) visit {
//    if (_visit != nil) {
//        return _visit;
//    } 
//    
//    if (self.school == nil) return nil;
//    
//    NSCalendar *cal = [NSCalendar currentCalendar];
//    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[[NSDate alloc] init]];
//    
//    [components setHour:-[components hour]];
//    [components setMinute:-[components minute]];
//    [components setSecond:-[components second]];
//    NSDate *startDay = [cal dateByAddingComponents:components toDate:[[NSDate alloc] init] options:0]; //This variable should now be pointing at a date object that is the start of today (midnight);
//    
//    
//    [components setHour:24];
//    [components setMinute:0];
//    [components setSecond:0];
//    NSDate *endDay = [cal dateByAddingComponents:components toDate: startDay options:0];
//    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(dateCreated >= %@) AND (dateCreated <= %@) AND college = %@", startDay, endDay, self.school];
//    
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Visit"];
//    [fetchRequest setPredicate:predicate];
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateCreated" ascending:YES];
//    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
//    
//    NSError *err = nil;
//    NSArray *possibleVisits = [self.managedObjectContext executeFetchRequest:fetchRequest error:&err];
//    if (err != nil) {
//        NSLog(@"%@", [err localizedDescription]);
//    }
//    
//    if ([possibleVisits count] == 0) {
//        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Visit" inManagedObjectContext:self.managedObjectContext];
//        _visit = [[Visit alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.managedObjectContext];
//        _visit.college = self.school;
//        _visit.dateCreated = [NSDate date];
//        
//    } else {
//        _visit = (Visit *)[possibleVisits lastObject];
//    }
//    
//    return _visit;
//}
//
//- (void) setVisit:(Visit *)visit {
//    //Check if old visit is worth saving -- else delete.
//    Visit *oldVisit = _visit;
//    _visit = visit;
//    
//    if (oldVisit == nil) return;
//    
//    if ([oldVisit notes] == nil && [oldVisit campusPhotos] == nil && [oldVisit campusRatings] == nil) {
//        [self.managedObjectContext deleteObject:oldVisit];
//    } 
//}

@end
