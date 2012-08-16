//
//  FTSegmentedControllerViewController.m
//  The College App
//
//  Created by Jeffrey Barg on 8/15/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import "FTSegmentedControllerViewController.h"

@interface FTSegmentedControllerViewController ()

@property (nonatomic, weak) UIViewController * selectedViewController;

@end

@implementation FTSegmentedControllerViewController

@synthesize viewControllers;
@synthesize selectedIndex;
@synthesize selectedViewController;


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
	// Do any additional setup after loading the view.
    
    NSMutableArray *mTitles = [[NSMutableArray alloc] init];
    for (UIViewController * viewController in self.viewControllers) {
        NSString * title = viewController.title;
        if (title == nil) {
            title = @"";
        }
        [mTitles addObject:title];
    }
    
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:mTitles];
    
    [segmentControl setBackgroundImage:[[UIImage imageNamed:@"cancel.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [segmentControl setBackgroundImage:[[UIImage imageNamed:@"segmentedselected.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [segmentControl setDividerImage:[UIImage imageNamed:@"segmentdivider.png"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
     [segmentControl setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor colorWithWhite:0.8 alpha:1.0], UITextAttributeTextColor,
                                                                      [UIColor blackColor], UITextAttributeTextShadowColor,
                                                                      [NSValue valueWithUIOffset:UIOffsetMake(0, -1)], UITextAttributeTextShadowOffset,
                                                                      [UIFont boldSystemFontOfSize:14.0], UITextAttributeFont,
                                                                      nil]
                                            forState:UIControlStateNormal];
    [segmentControl setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                    [UIColor colorWithWhite:1.0 alpha:1.0], UITextAttributeTextColor,
                                                                    [UIColor blackColor], UITextAttributeTextShadowColor,
                                                                    [NSValue valueWithUIOffset:UIOffsetMake(0, -1)], UITextAttributeTextShadowOffset,
                                                                    [UIFont boldSystemFontOfSize:14.0], UITextAttributeFont,
                                                                    nil]
                                            forState:UIControlStateSelected];
    
    [segmentControl setFrame:CGRectMake(0, 0, INTERFACE_IS_PAD? 200.0:250.0, 30.0)];
     
    [segmentControl addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView = segmentControl;

    UIViewController * viewController = [self.viewControllers objectAtIndex:0];
    [viewController.view setFrame:self.view.bounds];
    self.selectedViewController = viewController;
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];

    [segmentControl setSelectedSegmentIndex:0];
}

- (void) segmentChanged:(UISegmentedControl *) segmentControl {
    
    UIViewController *viewController = [self.viewControllers objectAtIndex:segmentControl.selectedSegmentIndex];
    [viewController.view setFrame:self.view.bounds];
    
    if (self.selectedViewController == viewController)
        return;
    
    [self.selectedViewController willMoveToParentViewController:nil];
    [self.selectedViewController removeFromParentViewController];
    
    [self addChildViewController:viewController];
    
    [UIView transitionFromView:self.selectedViewController.view toView:viewController.view duration:0.0 options:0 completion:^(BOOL finished){}];
         
    [viewController didMoveToParentViewController:self];
    
    self.selectedViewController = viewController;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
