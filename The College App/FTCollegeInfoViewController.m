//
//  FTCollegeInfoViewController.m
//  The College App
//
//  Created by Jeffrey Barg on 7/11/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import "FTCollegeInfoViewController.h"
#import "College.h"

#import "FTRangeIndicator.h"

#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>

#define X_MARGIN 27

#define SCROLLVIEW_THRESHOLD 135.0

#define SCROLLVIEW_HEIGHT 1166.0

#define roundViewColor [UIColor colorWithRed:0.961 green:0.969 blue:0.973 alpha:1.000]

@interface FTCollegeInfoViewController () <UIScrollViewDelegate>

@property(strong) IBOutletCollection(UIView) NSArray *whiteViews;
@property(strong) IBOutletCollection(UIButton) NSArray *urlButtons;

@property (weak, nonatomic) IBOutlet UIView *standardizedTestingContainerView;

@property (weak, nonatomic) IBOutlet UIScrollView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *openInMapsButton;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (weak, nonatomic) IBOutlet UILabel *applicationFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *earlyDeadlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *regularDeadlineLabel;
@property (weak, nonatomic) IBOutlet UIButton *applicationWebsiteLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *numberOfStudentsLabel;

@property (weak, nonatomic) IBOutlet UIView *acceptanceRateContainerView;
@property (weak, nonatomic) IBOutlet UIView *maleFemalRateContainerView;


@property (nonatomic, strong) UIButton *showMapButton;

@end

@implementation FTCollegeInfoViewController

@synthesize whiteViews = _whiteViews;
@synthesize urlButtons = _urlButtons;
@synthesize standardizedTestingContainerView = _standardizedTestingContainerView;
@synthesize containerView = _containerView;

@synthesize openInMapsButton = _openInMapsButton;
@synthesize mapView = _mapView;
@synthesize locationLabel = _locationLabel;
@synthesize applicationFeeLabel = _applicationFeeLabel;
@synthesize earlyDeadlineLabel = _earlyDeadlineLabel;
@synthesize regularDeadlineLabel = _regularDeadlineLabel;
@synthesize applicationWebsiteLabel = _applicationWebsiteLabel;
@synthesize totalPriceLabel = _totalPriceLabel;
@synthesize numberOfStudentsLabel = _numberOfStudentsLabel;
@synthesize maleFemalRateContainerView = _maleFemalRateContainerView;
@synthesize acceptanceRateContainerView = _acceptanceRateContainerView;

@synthesize school = _school;
@synthesize managedObjectContext = _managedObjectContext;

@synthesize showMapButton = _showMapButton;

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
    self.title = [self.school name];

	// Do any additional setup after loading the view.
    

    self.view.backgroundColor = kViewBackgroundColor;

    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButton:)];
    self.navigationItem.leftBarButtonItem = doneButton;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor colorWithWhite:0.2 alpha:1.0], UITextAttributeTextColor,
                                                                     [UIColor whiteColor], UITextAttributeTextShadowColor,
                                                                     [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                                                     nil]];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor colorWithRed:0.031 green:0.333 blue:0.643 alpha:1.000], UITextAttributeTextColor,
                                                       [UIColor whiteColor], UITextAttributeTextShadowColor,
                                                       [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                                       nil] forState:UIControlStateSelected];
    
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Info" image:[UIImage imageNamed:@"info.png"] tag:50];
    self.tabBarItem = tabBarItem;
    
    


    _containerView.contentInset = UIEdgeInsetsMake(260.0, 0.0, 0.0, 0.0);
    [self.view addSubview:_containerView];

    CGRect contentRect = _containerView.bounds;
    _containerView.frame = self.view.bounds;
    _containerView.contentSize = contentRect.size;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentRect.size.width, contentRect.size.height*2)];
    [_containerView.layer setShadowOpacity:0.75];
    [_containerView.layer setShadowColor:[UIColor blackColor].CGColor];
    [_containerView.layer setShadowRadius:20.0];
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, contentRect.size.width, 40.0)];
    [_containerView.layer setShadowPath:bezierPath.CGPath];
    
    [bgView setBackgroundColor:kViewBackgroundColor];
    [bgView setClipsToBounds:YES];
    [_containerView insertSubview:bgView atIndex:0];
    [_containerView setDelegate:self];
    
    [self setupWhiteViews];
    [self setupStandardizedTesting];
    [self setupMap];
    
    
    // Create formatter
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];  
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    [self.applicationFeeLabel setText:[NSString stringWithFormat:@"$%@", [self.school applicationFee]]];
    [self.totalPriceLabel setText:[NSString stringWithFormat:@"$%@", [formatter stringFromNumber:[self.school tuitionAndFees]]]];
    [self.totalPriceLabel setText:[NSString stringWithFormat:@"$%@", [formatter stringFromNumber:[self.school totalPriceOutState]]]];
    


    for (UIButton *urlButton in self.urlButtons) {
        [urlButton setContentEdgeInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)];
        [urlButton.titleLabel setNumberOfLines:0];
        [urlButton.titleLabel setTextAlignment:UITextAlignmentCenter];
        [urlButton setTitleColor:[UIColor colorWithWhite:91.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    
    [self.openInMapsButton setBackgroundImage:[[UIImage imageNamed:@"aphonors.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)] forState:UIControlStateNormal];
    

    
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    if (_containerView.frame.origin.y == 0) {
//        [self.containerView setFrame:CGRectMake(0,0,self.view.frame.size.width, SCROLLVIEW_HEIGHT)];
        [self.containerView setContentSize:CGSizeMake(self.view.frame.size.width, SCROLLVIEW_HEIGHT)];
        

    } else {
   
    }
    
    NSLog(@"%@", NSStringFromCGRect(self.mapView.frame));
    
    CLLocationCoordinate2D schoolLocation = CLLocationCoordinate2DMake([[self.school lat] doubleValue], [[self.school lon] doubleValue]);
    [self.mapView setCenterCoordinate:schoolLocation];
}

#pragma mark - Setup Functions

- (void) setupWhiteViews {
    for (UIView *whiteView in self.whiteViews) {
        
        CGRect whiteFrame = whiteView.frame;
        whiteFrame = CGRectInset(whiteFrame, -4.0, -4.0);
        whiteFrame.size.height += 1.0;
        
        
        [whiteView setFrame:whiteFrame];
        
        [whiteView setBackgroundColor:roundViewColor];
        [whiteView setOpaque:YES];
        
    }
}

- (void) setupMap {
    if (INTERFACE_IS_PAD) {
        [self.mapView setMapType:MKMapTypeHybrid];
    } else {
        [self.mapView setMapType:MKMapTypeStandard];
    }
    
//    [self.mapView.layer setShadowColor:[UIColor blackColor].CGColor];
//    [self.mapView.layer setShadowOffset:CGSizeMake(0, 1)];
//    [self.mapView.layer setShadowOpacity:1.0];
    
    CLLocationCoordinate2D schoolLocation = CLLocationCoordinate2DMake([[self.school lat] doubleValue], [[self.school lon] doubleValue]);
    
    [self.mapView setRegion:MKCoordinateRegionMake(schoolLocation, MKCoordinateSpanMake(0.04, 0.04)) animated:YES];
    MKPointAnnotation *schoolAnnotation = [[MKPointAnnotation alloc] init];
    [schoolAnnotation setCoordinate:schoolLocation];
    [schoolAnnotation setTitle:self.school.name];
    [schoolAnnotation setSubtitle:[NSString stringWithFormat:@"%@, %@ %@", self.school.streetAddress, self.school.stateAbbreviation, self.school.zipcode]];
    
    [self.mapView addAnnotation:schoolAnnotation];
    [self.mapView selectAnnotation:schoolAnnotation animated:YES];
    
    _showMapButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66.0, 66.0)];
    [_showMapButton setBackgroundImage:[UIImage imageNamed:@"flippy.png"] forState:UIControlStateNormal];
    [_showMapButton setBackgroundImage:[UIImage imageNamed:@"flippyactive.png"] forState:UIControlStateHighlighted];
    CGAffineTransform flip = CGAffineTransformMakeRotation(degreesToRadians(180));
    [_showMapButton setTransform:flip];
    [_containerView addSubview:_showMapButton];
    [_showMapButton setCenter:CGPointMake(self.containerView.frame.size.width / 2.0, - 40.0)];
    [_showMapButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin];
    
    [_showMapButton addTarget:self action:@selector(displayMap:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) setupStandardizedTesting {
    UIColor *textColor = [UIColor colorWithWhite:84.0/255.0 alpha:1.000];
    
    UILabel *mathLabel = [[UILabel alloc] initWithFrame:CGRectMake(X_MARGIN, 20.0, self.standardizedTestingContainerView.frame.size.width - 2 * X_MARGIN, 20.0)];
    [mathLabel setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth];
    
    [mathLabel setBackgroundColor:roundViewColor];
    [mathLabel setOpaque:YES];
    [mathLabel setText:@"SAT Mathematics Middle 50%"];
    [mathLabel setTextAlignment:UITextAlignmentLeft];
    [mathLabel setTextColor:textColor];
    [mathLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
    
    
    FTRangeIndicator *mathIndicator = [[FTRangeIndicator alloc] initWithFrame:CGRectMake(X_MARGIN, 40.0, self.standardizedTestingContainerView.frame.size.width - 2 * X_MARGIN, 60.0)];
    [mathIndicator setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth];
    [mathIndicator setMaxValue:[[self.school mathSAT75] floatValue]];
    [mathIndicator setMinValue:[[self.school mathSAT25] floatValue]];
    [mathIndicator setLowerBound:200.0];
    [mathIndicator setUpperBound:800.0];
    
    [mathIndicator setValue: 800.0];
    
    UILabel *readingLabel = [[UILabel alloc] initWithFrame:CGRectMake(X_MARGIN, 100.0, self.standardizedTestingContainerView.frame.size.width - 2 * X_MARGIN, 20.0)];
    [readingLabel setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth];
    
    [readingLabel setBackgroundColor:roundViewColor];
    [readingLabel setOpaque:YES];
    [readingLabel setText:@"SAT Reading Middle 50%"];
    [readingLabel setTextAlignment:UITextAlignmentLeft];
    [readingLabel setTextColor:textColor];
    [readingLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
    
    
    FTRangeIndicator *readingIndicator = [[FTRangeIndicator alloc] initWithFrame:CGRectMake(X_MARGIN, 120.0, self.standardizedTestingContainerView.frame.size.width - 2 * X_MARGIN, 60.0)];
    [readingIndicator setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth];
    
    [readingIndicator setMaxValue:[[self.school readingSAT75] floatValue]];
    [readingIndicator setMinValue:[[self.school readingSAT25] floatValue]];
    [readingIndicator setLowerBound:200.0];
    [readingIndicator setUpperBound:800.0];
    
    [readingIndicator setValue: 760.0];
    
    
    UILabel *writingLabel = [[UILabel alloc] initWithFrame:CGRectMake(X_MARGIN, 180.0, self.standardizedTestingContainerView.frame.size.width - 2 * X_MARGIN, 20.0)];
    [writingLabel setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth];
    
    [writingLabel setBackgroundColor:roundViewColor];
    [writingLabel setOpaque:YES];
    [writingLabel setText:@"SAT Writing Middle 50%"];
    [writingLabel setTextAlignment:UITextAlignmentLeft];
    [writingLabel setTextColor:textColor];
    [writingLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
    
    FTRangeIndicator *writingIndicator = [[FTRangeIndicator alloc] initWithFrame:CGRectMake(X_MARGIN, 200.0, self.standardizedTestingContainerView.frame.size.width - 2 * X_MARGIN, 60.0)];
    [writingIndicator setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth];

    
    [writingIndicator setMaxValue:[[self.school writingSAT75] floatValue]];
    [writingIndicator setMinValue:[[self.school writingSAT25] floatValue]];
    [writingIndicator setLowerBound:200.0];
    [writingIndicator setUpperBound:800.0];
    
    [writingIndicator setValue: 760.0];
    
    UILabel *actLabel = [[UILabel alloc] initWithFrame:CGRectMake(X_MARGIN, 260.0, self.standardizedTestingContainerView.frame.size.width - 2 * X_MARGIN, 20.0)];
    [actLabel setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth];
    
    [actLabel setBackgroundColor:roundViewColor];
    [actLabel setOpaque:YES];
    [actLabel setText:@"ACT Composite Middle 50%"];
    [actLabel setTextAlignment:UITextAlignmentLeft];
    [actLabel setTextColor:textColor];
    [actLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
    
    FTRangeIndicator *actIndicator = [[FTRangeIndicator alloc] initWithFrame:CGRectMake(X_MARGIN, 280.0, self.standardizedTestingContainerView.frame.size.width - 2 * X_MARGIN, 60.0)];
    [actIndicator setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth];
    
    [actIndicator setMaxValue:[[self.school compositeACT75] floatValue]];
    [actIndicator setMinValue:[[self.school compositeACT25] floatValue]];
    [actIndicator setLowerBound:10.0];
    [actIndicator setUpperBound:36.0];
    
    [actIndicator setValue: 760.0];
    
    [self.standardizedTestingContainerView addSubview:mathLabel];
    [self.standardizedTestingContainerView addSubview:mathIndicator];
    [self.standardizedTestingContainerView addSubview:readingIndicator];
    [self.standardizedTestingContainerView addSubview:readingLabel];
    [self.standardizedTestingContainerView addSubview:writingIndicator];
    [self.standardizedTestingContainerView addSubview:writingLabel];
    [self.standardizedTestingContainerView addSubview:actIndicator];
    [self.standardizedTestingContainerView addSubview:actLabel];
    
    [self.standardizedTestingContainerView setNeedsDisplay];
    [self.standardizedTestingContainerView setBackgroundColor:roundViewColor];
}

#pragma mark - UIScrollViewDelegate

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    CGAffineTransform flip = CGAffineTransformMakeRotation(degreesToRadians(180));
    CGFloat offset = scrollView.contentOffset.y;
    
    if (scrollView.frame.origin.y != 0) return;
    
    [UIView animateWithDuration:0.2 animations:^{
        if (offset < -260.0 - SCROLLVIEW_THRESHOLD) {
            self.showMapButton.transform = CGAffineTransformIdentity;
        } else {
            self.showMapButton.transform = flip;
        }
    }];
}   

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat offset = scrollView.contentOffset.y;
    if (offset < -260.0 - SCROLLVIEW_THRESHOLD) {
        

        
        [UIView animateWithDuration:0.5  animations:^{
            [self displayMap:self.showMapButton];
        }];
    }
}

- (void) displayMap:(UIButton *) button {
    if (self.containerView.frame.origin.y != 0) {
        
        [_showMapButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin];

        CGRect buttonRect = self.showMapButton.frame;
        [self.showMapButton removeFromSuperview];
        [self.containerView addSubview:self.showMapButton];
        [self.showMapButton setFrame:[self.containerView convertRect:buttonRect fromView:self.view]];
        
        [UIView animateWithDuration:0.5  animations:^{

            [self.mapView setFrame:CGRectMake(0, -450.0, self.mapView.frame.size.width, self.mapView.frame.size.height)];
                                              
            self.containerView.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height);
            
            [self.showMapButton setCenter:CGPointMake(self.view.frame.size.width / 2.0, -40.0)];
            

        }];
        
        
        [UIView animateWithDuration:0.2 animations:^{
            self.showMapButton.transform = CGAffineTransformMakeRotation(degreesToRadians(180));
        }];
        
    } else {
        
        [_showMapButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin];

        CGRect buttonRect = self.showMapButton.frame;
        [self.showMapButton removeFromSuperview];
        [self.view addSubview:self.showMapButton];
        [self.showMapButton setFrame:[self.containerView convertRect:buttonRect toView:self.view]];
        
        [UIView animateWithDuration:0.5  animations:^{
                        
            [self.mapView setCenter:self.view.center];

            self.containerView.frame = CGRectMake(0, self.view.frame.size.height, self.containerView.frame.size.width, self.containerView.frame.size.height);

            
            [self.showMapButton setCenter:CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height - 40.0)];
        }];
        
        [UIView animateWithDuration:0.2 animations:^{
            self.showMapButton.transform = CGAffineTransformIdentity;
        }];
    }
}

#pragma mark - Buttons

- (IBAction)applicationWebsite:(id)sender {
    NSString *internetAddress = [self.school onlineApplicationInternetAddress];
    if (![[internetAddress substringToIndex:4] isEqualToString:@"http"]) {
        internetAddress = [NSString stringWithFormat:@"http://%@", internetAddress];
    }
    NSURL *url = [NSURL URLWithString:internetAddress];
    
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)missionStatementWebsite:(id)sender {
    NSString *internetAddress = [self.school missionStatementInternetAddress];
    if (![[internetAddress substringToIndex:4] isEqualToString:@"http"]) {
        internetAddress = [NSString stringWithFormat:@"http://%@", internetAddress];
    }
    NSURL *url = [NSURL URLWithString:internetAddress];
    
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)collegeWebsite:(id)sender {
    NSString *internetAddress = [self.school internetAddress];
    if (![[internetAddress substringToIndex:4] isEqualToString:@"http"]) {
        internetAddress = [NSString stringWithFormat:@"http://%@", internetAddress];
    }
    NSURL *url = [NSURL URLWithString:internetAddress];
    
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)financialAidWebsite:(id)sender {
    NSString *internetAddress = [self.school financialAidInternetAddress];
    if (![[internetAddress substringToIndex:4] isEqualToString:@"http"]) {
        internetAddress = [NSString stringWithFormat:@"http://%@", internetAddress];
    }
    NSURL *url = [NSURL URLWithString:internetAddress];
    
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)openInMaps:(id)sender {
    NSURL *url = [NSURL URLWithString:[self.school internetAddress]];
    [[UIApplication sharedApplication] openURL:url];
}

- (void) doneButton:(UIBarButtonItem *) barButtonItem {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


@end
