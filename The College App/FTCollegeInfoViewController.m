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

#define X_MARGIN 22

@interface FTCollegeInfoViewController ()

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

@property (weak, nonatomic) IBOutlet UILabel *tuitionLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

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
@synthesize tuitionLabel = _tuitionLabel;
@synthesize totalPriceLabel = _totalPriceLabel;

@synthesize school = _school;
@synthesize managedObjectContext = _managedObjectContext;

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
    NSLog(@"%@", self.school);
    self.title = [self.school name];

	// Do any additional setup after loading the view.
    
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
    

    
    
    UIColor *textColor = [UIColor colorWithWhite:84.0/255.0 alpha:1.000];
    
    UILabel *mathLabel = [[UILabel alloc] initWithFrame:CGRectMake(X_MARGIN, 20.0, 460.0, 20.0)];
    [mathLabel setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin];

    [mathLabel setBackgroundColor:[UIColor whiteColor]];
    [mathLabel setOpaque:YES];
    [mathLabel setText:@"SAT Mathematics Middle 50%"];
    [mathLabel setTextAlignment:UITextAlignmentLeft];
    [mathLabel setTextColor:textColor];
    [mathLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
    
    
    FTRangeIndicator *mathIndicator = [[FTRangeIndicator alloc] initWithFrame:CGRectMake(X_MARGIN, 40.0, 460.0, 60.0)];
    [mathIndicator setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin];
    [mathIndicator setMaxValue:[[self.school mathSAT75] floatValue]];
    [mathIndicator setMinValue:[[self.school mathSAT25] floatValue]];
    [mathIndicator setLowerBound:200.0];
    [mathIndicator setUpperBound:800.0];
    
    [mathIndicator setValue: 800.0];
    
    UILabel *readingLabel = [[UILabel alloc] initWithFrame:CGRectMake(X_MARGIN, 100.0, 460.0, 20.0)];
    [readingLabel setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin];

    [readingLabel setBackgroundColor:[UIColor whiteColor]];
    [readingLabel setOpaque:YES];
    [readingLabel setText:@"SAT Reading Middle 50%"];
    [readingLabel setTextAlignment:UITextAlignmentLeft];
    [readingLabel setTextColor:textColor];
    [readingLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
    
    
    FTRangeIndicator *readingIndicator = [[FTRangeIndicator alloc] initWithFrame:CGRectMake(X_MARGIN, 120.0, 460.0, 60.0)];
    [readingIndicator setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin];

    [readingIndicator setMaxValue:[[self.school readingSAT75] floatValue]];
    [readingIndicator setMinValue:[[self.school readingSAT25] floatValue]];
    [readingIndicator setLowerBound:200.0];
    [readingIndicator setUpperBound:800.0];
    
    [readingIndicator setValue: 760.0];
    
    
    UILabel *writingLabel = [[UILabel alloc] initWithFrame:CGRectMake(X_MARGIN, 180.0, 460.0, 20.0)];
    [writingLabel setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin];

    [writingLabel setBackgroundColor:[UIColor whiteColor]];
    [writingLabel setOpaque:YES];
    [writingLabel setText:@"SAT Writing Middle 50%"];
    [writingLabel setTextAlignment:UITextAlignmentLeft];
    [writingLabel setTextColor:textColor];
    [writingLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
    
    FTRangeIndicator *writingIndicator = [[FTRangeIndicator alloc] initWithFrame:CGRectMake(X_MARGIN, 200.0, 460.0, 60.0)];
    [writingIndicator setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin];

    [writingIndicator setMaxValue:[[self.school writingSAT75] floatValue]];
    [writingIndicator setMinValue:[[self.school writingSAT25] floatValue]];
    [writingIndicator setLowerBound:200.0];
    [writingIndicator setUpperBound:800.0];
    
    [writingIndicator setValue: 760.0];
        
    UILabel *actLabel = [[UILabel alloc] initWithFrame:CGRectMake(X_MARGIN, 260.0, 460.0, 20.0)];
    [actLabel setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin];

    [actLabel setBackgroundColor:[UIColor whiteColor]];
    [actLabel setOpaque:YES];
    [actLabel setText:@"ACT Composite Middle 50%"];
    [actLabel setTextAlignment:UITextAlignmentLeft];
    [actLabel setTextColor:textColor];
    [actLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
    
    FTRangeIndicator *actIndicator = [[FTRangeIndicator alloc] initWithFrame:CGRectMake(X_MARGIN, 280.0, 460.0, 60.0)];
    [actIndicator setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin];

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

    if (INTERFACE_IS_PAD) {
        CGRect mapFrame = self.mapView.superview.frame;
        UIView *supersuperview = self.mapView.superview.superview;
        [self.mapView removeFromSuperview];
        [supersuperview addSubview:self.mapView];
        [self.mapView setFrame:mapFrame];
        
        [self.mapView.layer setCornerRadius:5.0];

        
        [self.mapView setMapType:MKMapTypeHybrid];
    } else {
        [self.mapView setMapType:MKMapTypeStandard];
    }
    
    [self.mapView.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.mapView.layer setShadowOffset:CGSizeMake(0, 1)];
    [self.mapView.layer setShadowOpacity:1.0];
    
    CLLocationCoordinate2D schoolLocation = CLLocationCoordinate2DMake([[self.school lat] doubleValue], [[self.school lon] doubleValue]);
    
    [self.mapView setRegion:MKCoordinateRegionMake(schoolLocation, MKCoordinateSpanMake(0.01, 0.01)) animated:YES];
    MKPointAnnotation *schoolAnnotation = [[MKPointAnnotation alloc] init];
    [schoolAnnotation setCoordinate:schoolLocation];
    [schoolAnnotation setTitle:self.school.name];
    [schoolAnnotation setSubtitle:[NSString stringWithFormat:@"%@, %@ %@", self.school.streetAddress, self.school.stateAbbreviation, self.school.zipcode]];

    [self.mapView addAnnotation:schoolAnnotation];
    [self.mapView selectAnnotation:schoolAnnotation animated:YES];

    // Create formatter
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];  
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    [self.applicationFeeLabel setText:[NSString stringWithFormat:@"$%@", [self.school applicationFee]]];
    [self.tuitionLabel setText:[NSString stringWithFormat:@"$%@", [formatter stringFromNumber:[self.school tuitionAndFees]]]];
    [self.totalPriceLabel setText:[NSString stringWithFormat:@"$%@", [formatter stringFromNumber:[self.school totalPriceOutState]]]];
    
    for (UIView *whiteView in self.whiteViews) {
//        [whiteView.layer setCornerRadius:5.0];
//        [whiteView.layer setShadowOffset:CGSizeMake(0, 1)];
//        [whiteView.layer setShadowColor:[UIColor colorWithWhite:0.4 alpha:1.0].CGColor];
//        [whiteView.layer setShadowOpacity:1.0];
        
        CGRect whiteFrame = whiteView.frame;
        whiteFrame = CGRectInset(whiteFrame, -4.0, -4.0);
        whiteFrame.size.height += 1.0;
        
        
        [whiteView setFrame:whiteFrame];
        
        [whiteView setBackgroundColor:[UIColor whiteColor]];
        [whiteView setOpaque:YES];
        
    }

    for (UIButton *urlButton in self.urlButtons) {
        [urlButton setContentEdgeInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)];
        [urlButton.titleLabel setNumberOfLines:0];
        [urlButton.titleLabel setTextAlignment:UITextAlignmentCenter];
        [urlButton setTitleColor:[UIColor colorWithWhite:91.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    
    [self.openInMapsButton setBackgroundImage:[[UIImage imageNamed:@"aphonors.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)] forState:UIControlStateNormal];
    [self.containerView setContentSize:CGSizeMake(540.0, 1115.0)];
    

    
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
    [self setTuitionLabel:nil];
    [self setTotalPriceLabel:nil];

    [self setOpenInMapsButton:nil];
    [self setMapView:nil];
    [self setLocationLabel:nil];
    [self setWhiteViews:nil];
    [self setUrlButtons:nil];
    [self setApplicationFeeLabel:nil];
    [self setEarlyDeadlineLabel:nil];
    [self setRegularDeadlineLabel:nil];
    [self setApplicationWebsiteLabel:nil];
    [self setContainerView:nil];
    [self setStandardizedTestingContainerView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


@end
