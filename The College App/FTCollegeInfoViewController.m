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

@interface FTCollegeInfoViewController ()

@property(retain) IBOutletCollection(UIView) NSArray *whiteViews;

@property (weak, nonatomic) IBOutlet UIButton *openInMapsButton;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (weak, nonatomic) IBOutlet UILabel *applicationFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *earlyDeadlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *regularDeadlineLabel;
@property (weak, nonatomic) IBOutlet UIButton *applicationWebsiteLabel;
@end

@implementation FTCollegeInfoViewController
@synthesize whiteViews = _whiteViews;

@synthesize openInMapsButton = _openInMapsButton;
@synthesize mapView = _mapView;
@synthesize locationLabel = _locationLabel;
@synthesize applicationFeeLabel = _applicationFeeLabel;
@synthesize earlyDeadlineLabel = _earlyDeadlineLabel;
@synthesize regularDeadlineLabel = _regularDeadlineLabel;
@synthesize applicationWebsiteLabel = _applicationWebsiteLabel;

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
    
    
	// Do any additional setup after loading the view.
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButton:)];
    self.navigationItem.leftBarButtonItem = doneButton;
    
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Info" image:[UIImage imageNamed:@"info.png"] tag:50];
    self.tabBarItem = tabBarItem;
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor colorWithRed:0.031 green:0.333 blue:0.643 alpha:1.000], UITextAttributeTextColor,
                                                       [UIColor whiteColor], UITextAttributeTextShadowColor,
                                                       [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                                       nil] forState:UIControlStateSelected];
    
    
    self.title = [self.school name];
    
//    FTRangeIndicator *mathIndicator = [[FTRangeIndicator alloc] initWithFrame:CGRectMake(20.0, 20.0, 500.0, 60.0)];
//    [mathIndicator setMaxValue:[[self.school mathSAT75] floatValue]];
//    [mathIndicator setMinValue:[[self.school mathSAT25] floatValue]];
//    [mathIndicator setLowerBound:200.0];
//    [mathIndicator setUpperBound:800.0];
//    
//    [mathIndicator setValue: 800.0];
//    
//    FTRangeIndicator *readingIndicator = [[FTRangeIndicator alloc] initWithFrame:CGRectMake(20.0, 90.0, 500.0, 60.0)];
//    [readingIndicator setMaxValue:[[self.school readingSAT75] floatValue]];
//    [readingIndicator setMinValue:[[self.school readingSAT25] floatValue]];
//    [readingIndicator setLowerBound:200.0];
//    [readingIndicator setUpperBound:800.0];
//    
//    [readingIndicator setValue: 760.0];
//    
//    FTRangeIndicator *writingIndicator = [[FTRangeIndicator alloc] initWithFrame:CGRectMake(20.0, 160.0, 500.0, 60.0)];
//    [writingIndicator setMaxValue:[[self.school writingSAT75] floatValue]];
//    [writingIndicator setMinValue:[[self.school writingSAT25] floatValue]];
//    [writingIndicator setLowerBound:200.0];
//    [writingIndicator setUpperBound:800.0];
//    
//    [writingIndicator setValue: 760.0];
//        
//    [self.view addSubview:mathIndicator];
//    [self.view addSubview:readingIndicator];
//    [self.view addSubview:writingIndicator];
    for (UIView *whiteView in self.whiteViews) {
        [whiteView.layer setCornerRadius:5.0];
        [whiteView.layer setShadowOffset:CGSizeMake(0, 1)];
        [whiteView.layer setShadowColor:[UIColor blackColor].CGColor];
        [whiteView.layer setShadowOpacity:0.4];
    }

    
    
}

#pragma mark - Buttons

- (IBAction)applicationWebsite:(id)sender {

}

- (IBAction)missionStatementWebsite:(id)sender {
}

- (IBAction)collegeWebsite:(id)sender {
}

- (IBAction)financialAidWebsite:(id)sender {
}

- (IBAction)openInMaps:(id)sender {
}

- (void) doneButton:(UIBarButtonItem *) barButtonItem {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [self setOpenInMapsButton:nil];
    [self setMapView:nil];
    [self setLocationLabel:nil];
    [self setWhiteViews:nil];
    [self setApplicationFeeLabel:nil];
    [self setEarlyDeadlineLabel:nil];
    [self setRegularDeadlineLabel:nil];
    [self setApplicationWebsiteLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
