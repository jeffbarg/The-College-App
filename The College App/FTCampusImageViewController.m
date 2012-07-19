//
//  FTCampusImageViewController.m
//  The College App
//
//  Created by Jeffrey Barg on 7/18/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import "FTCampusImageViewController.h"
#import "PhotoData.h"

@interface FTCampusImageViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UINavigationBar *navBar;

@end

@implementation FTCampusImageViewController

@synthesize image = _image;
@synthesize scrollView;
@synthesize navBar;

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
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [scrollView setMinimumZoomScale:1.0];
    [scrollView setMaximumZoomScale:10.0];
    [scrollView setZoomScale:0.5 animated:YES];

    [scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    
    [self.view addSubview:scrollView];
    
    UIImageView * imgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [scrollView addSubview:imgView];
    [imgView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    
    [imgView setContentMode:UIViewContentModeScaleAspectFit];
    
    [imgView setImage:[self.image image]];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    [scrollView addGestureRecognizer:tapGesture];
    
    navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44.0)];
    [navBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [navBar setTranslucent:YES];
    [navBar setBarStyle:UIBarStyleBlackTranslucent];
    

    [self.view addSubview:navBar];
    [navBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin];
    
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"Campus Photo"];
    
    [navItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButton)]];
    
    [navBar pushNavigationItem:navItem animated:NO];
    
	// Do any additional setup after loading the view.
}


- (void) tapView:(UITapGestureRecognizer *) gesture {
    [UIView animateWithDuration:0.4 animations:^{
        [navBar setHidden:NO];
        [navBar setAlpha:1.0 - navBar.alpha];
    } completion:^(BOOL completed) {
        [navBar setHidden:(navBar.alpha == 0)];
    }];
}

- (void) doneButton {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
//    [scrollView setFrame:self.view.bounds];
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

@end
