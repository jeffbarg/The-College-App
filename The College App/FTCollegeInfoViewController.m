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
#import "FTPercentageMarker.h"

#import "DDXML.h"

#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>

#define X_MARGIN 27

#define SCROLLVIEW_THRESHOLD (INTERFACE_IS_PAD?115.0:55.0)

#define SCROLLVIEW_HEIGHT (INTERFACE_IS_PAD?1166.0:1433.0)


#define MAP_HIDDEN_HEIGHT (INTERFACE_IS_PAD?-450.0:-200.0)

#define SCROLLVIEW_PEEKAMOUNT (INTERFACE_IS_PAD?240.0:160.0)

#define roundViewColor (INTERFACE_IS_PAD?[UIColor colorWithRed:0.961 green:0.969 blue:0.973 alpha:1.000]:kViewBackgroundColor)

@interface FTCollegeInfoViewController () <UIScrollViewDelegate, UIWebViewDelegate, NSXMLParserDelegate> {
    BOOL _wikiLoaded;
    
    BOOL _isCapturingXML;
    BOOL _isBlockingXML;
    
    BOOL _seekingImage;
    BOOL _foundImage;
    NSInteger _paragraphsParsed;
    NSMutableArray *xmlElements;
}

@property(strong) IBOutletCollection(UIView) NSArray *whiteViews;
@property(strong) IBOutletCollection(UIButton) NSArray *urlButtons;

@property (weak, nonatomic) IBOutlet UIView *standardizedTestingContainerView;

@property (weak, nonatomic) IBOutlet UIScrollView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *openInMapsButton;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (weak, nonatomic) IBOutlet UILabel *collegeNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *applicationFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *earlyDeadlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *regularDeadlineLabel;
@property (weak, nonatomic) IBOutlet UIButton *applicationWebsiteLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *numberOfStudentsLabel;

@property (weak, nonatomic) IBOutlet UIView *acceptanceRateContainerView;
@property (weak, nonatomic) IBOutlet UIView *maleFemalRateContainerView;

@property (weak, nonatomic) IBOutlet UIWebView *wikipediaEntryView;

@property (nonatomic, strong) UIButton *showMapButton;
@property (nonatomic, strong) UIActivityIndicatorView * spinner;

@property (nonatomic, strong) NSXMLParser *wikiParser;
@property (nonatomic, strong) DDXMLElement *formattedWiki;

@property (nonatomic, strong) NSInputStream *wikiInputStream;

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
@synthesize collegeNameLabel = _collegeNameLabel;
@synthesize maleFemalRateContainerView = _maleFemalRateContainerView;
@synthesize acceptanceRateContainerView = _acceptanceRateContainerView;

@synthesize school = _school;
@synthesize managedObjectContext = _managedObjectContext;

@synthesize showMapButton = _showMapButton;

@synthesize wikipediaEntryView = _wikipediaEntryView;
@synthesize spinner = _spinner;

@synthesize wikiParser = _wikiParser;
@synthesize wikiInputStream = _wikiInputStream;

@synthesize formattedWiki;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Info" image:[UIImage imageNamed:@"info.png"] tag:50];
        self.tabBarItem = tabBarItem;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [self.school name];
    self.tabBarItem.title = @"Info";
    
    self.view.backgroundColor = kViewBackgroundColor;

    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButton:)];
    self.navigationItem.leftBarButtonItem = doneButton;
    
    UIButton *starButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 34.0, 44.0)];

    [starButton setImage:[UIImage imageNamed:@"collegelistnotadded.png"] forState:UIControlStateNormal];
    [starButton setImage:[UIImage imageNamed:@"collegelistaddedalt.png"] forState:UIControlStateHighlighted];    
    
    UIBarButtonItem *starButtonItem = [[UIBarButtonItem alloc] initWithCustomView:starButton];
    
    [starButtonItem setBackgroundImage:nil forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = starButtonItem;
    
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
    

    
    


    _containerView.contentInset = UIEdgeInsetsMake(SCROLLVIEW_PEEKAMOUNT, 0.0, 0.0, 0.0);
    [self.view addSubview:_containerView];

    CGRect contentRect = _containerView.bounds;
    _containerView.frame = self.view.bounds;
    _containerView.contentSize = contentRect.size;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentRect.size.width, contentRect.size.height*2)];
    [_containerView.layer setShadowOpacity:0.5];
    [_containerView.layer setShadowColor:[UIColor blackColor].CGColor];
    [_containerView.layer setShadowRadius:10.0];
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, contentRect.size.width, 20.0)];
    [_containerView.layer setShadowPath:bezierPath.CGPath];
    
    [bgView setBackgroundColor:kViewBackgroundColor];
    [bgView setClipsToBounds:YES];
    [_containerView insertSubview:bgView atIndex:0];
    [_containerView setDelegate:self];
    
    if (INTERFACE_IS_PAD)
        [self setupWhiteViews];
    
    [self setupWikiArticle];
    [self setupStandardizedTesting];
    [self setupMap];
    [self setupLabels];
    
    
    [self.openInMapsButton setBackgroundImage:[[UIImage imageNamed:@"aphonors.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)] forState:UIControlStateNormal];
    
    self.wikipediaEntryView.backgroundColor = roundViewColor;
    
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    [self.containerView setContentSize:CGSizeMake(self.view.frame.size.width, SCROLLVIEW_HEIGHT)];
    
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

- (void) setupWikiArticle {
 	// Do any additional setup after loading the view.
//    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://en.wikipedia.org/wiki/Wesleyan_University"] cachePolicy:NSURLCacheStorageAllowed timeoutInterval:30.0];
    
    NSURL *wikiURL = [NSURL URLWithString:@"http://en.wikipedia.org/wiki/Yale"];
    //_wikiInputStream = [[NSInputStream alloc] initWithURL:wikiURL];

    [self.wikipediaEntryView setDelegate:self];

    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        NSError *err = nil;
        NSData *data = [NSData dataWithContentsOfURL:wikiURL options:NSDataReadingMappedIfSafe error:&err];
        if (err != nil)
            NSLog(@"%@", [err description]);
        

        //Parse XML
        
        self.wikiParser = [[NSXMLParser alloc] initWithData:data];
        [self.wikiParser setDelegate:self];
        
        //This might not thread right...
        [self.wikiParser parse];            
        
        NSLog(@"%@", [self.formattedWiki XMLString]);
    }];

    
    
    UIImageView * falloffImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.wikipediaEntryView.frame.origin.x, CGRectGetMaxY(self.wikipediaEntryView.frame) - 56.0, self.wikipediaEntryView.frame.size.width, 56.0)];
    
    [falloffImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [falloffImageView setImage:[[UIImage imageNamed:@"wikifalloff.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)]];
    [self.wikipediaEntryView.superview insertSubview:falloffImageView aboveSubview:self.wikipediaEntryView];
    
    [self.wikipediaEntryView setHidden:YES];
    self.wikipediaEntryView.backgroundColor = roundViewColor;
    self.wikipediaEntryView.opaque = FALSE;
    
    
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.spinner setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin];
    
    [self.wikipediaEntryView.superview insertSubview:self.spinner aboveSubview:self.wikipediaEntryView];
    [self.spinner setCenter:self.wikipediaEntryView.center];
    [self.spinner startAnimating];   
}

- (void) setupLabels {
    // Create formatter
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];  
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    [self.applicationFeeLabel setText:[NSString stringWithFormat:@"$%@", [self.school applicationFee]]];
    [self.totalPriceLabel setText:[NSString stringWithFormat:@"$%@", [formatter stringFromNumber:[self.school tuitionAndFees]]]];
    [self.totalPriceLabel setText:[NSString stringWithFormat:@"$%@", [formatter stringFromNumber:[self.school totalPriceOutState]]]];
    [self.numberOfStudentsLabel setText:[NSString stringWithFormat:@"%@", [formatter stringFromNumber:[self.school enrolledTotal]]]];
    [self.collegeNameLabel setText:[self.school name]];
    
    for (UIButton *urlButton in self.urlButtons) {
        [urlButton setContentEdgeInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)];
        [urlButton.titleLabel setNumberOfLines:0];
        [urlButton.titleLabel setTextAlignment:UITextAlignmentCenter];
        [urlButton setTitleColor:[UIColor colorWithWhite:91.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    
    
    FTPercentageMarker *acceptancePercentView = [[FTPercentageMarker alloc] initWithFrame:CGRectMake(20.0, 64.0 + 7.0, self.acceptanceRateContainerView.frame.size.width - 40.0, 30.0)];
    [acceptancePercentView setPercent:[[self.school admissionsTotal] doubleValue] / [[self.school applicantsTotal] doubleValue]];
    [acceptancePercentView setLeftColor:[UIColor colorWithHue:0.270 saturation:0.726 brightness:0.573 alpha:1.000]];
    [acceptancePercentView setRightColor:[UIColor colorWithHue:0.000 saturation:0.000 brightness:0.275 alpha:1.000]];
    [acceptancePercentView setCenterText:[NSString stringWithFormat:@"%i%%", (NSInteger)(acceptancePercentView.percent*100.0)]];
    
    [self.acceptanceRateContainerView addSubview:acceptancePercentView];
    
    
    FTPercentageMarker *maleFemaleRatio = [[FTPercentageMarker alloc] initWithFrame:CGRectMake(20.0, 64.0 + 7.0, self.acceptanceRateContainerView.frame.size.width - 40.0, 30.0)];
    [maleFemaleRatio setPercent:[[self.school enrolledMen] doubleValue] / [[self.school enrolledTotal] doubleValue]];
    [maleFemaleRatio setLeftColor:[UIColor colorWithRed:0.024 green:0.329 blue:0.647 alpha:1.000]];
    [maleFemaleRatio setRightColor:[UIColor colorWithRed:0.514 green:0.792 blue:1.000 alpha:1.000]];
    [maleFemaleRatio setLeftText:[NSString stringWithFormat:@"%i%%", (NSInteger)(maleFemaleRatio.percent*100.0)]];
    [maleFemaleRatio setRightText:[NSString stringWithFormat:@"%i%%", 100 - (NSInteger)(maleFemaleRatio.percent*100.0)]];
      
    [self.maleFemalRateContainerView addSubview:maleFemaleRatio];
    
    
}

- (void) setupMap {

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
    //[self.mapView selectAnnotation:schoolAnnotation animated:YES];
    
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
        if (offset < -SCROLLVIEW_PEEKAMOUNT - SCROLLVIEW_THRESHOLD) {
            self.showMapButton.transform = CGAffineTransformIdentity;
        } else {
            self.showMapButton.transform = flip;
        }
    }];
}   

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat offset = scrollView.contentOffset.y;
    if (offset < -SCROLLVIEW_PEEKAMOUNT - SCROLLVIEW_THRESHOLD) {
        

        
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

            [self.mapView setFrame:CGRectMake(0, MAP_HIDDEN_HEIGHT, self.mapView.frame.size.width, self.mapView.frame.size.height)];
                                              
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

#pragma mark - UIWebViewDelegate

- (void) webViewDidFinishLoad:(UIWebView *)webView {

    
    if (!_wikiLoaded) {
        
        NSString *js = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"extractwiki" withExtension:@"js"] encoding:NSUTF8StringEncoding error:nil];
            
        NSString *newStr = [webView stringByEvaluatingJavaScriptFromString:js];
    
        [webView loadHTMLString:newStr baseURL:[NSURL URLWithString:@"http://en.wikipedia.org/wiki/Wesleyan_University"]];                
    } else {
         [self.spinner removeFromSuperview];   
         webView.hidden = FALSE;
    }
    
    _wikiLoaded = TRUE;
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [[[UIAlertView alloc] initWithTitle:@"Error!" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    [self.spinner removeFromSuperview];
}

- (void) webViewDidStartLoad:(UIWebView *)webView {
    
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
    if ([internetAddress length] <= 4) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mission Statement" message:[self.school missionStatement] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (![[internetAddress substringToIndex:4] isEqualToString:@"http"]) {
        internetAddress = [NSString stringWithFormat:@"http://%@", internetAddress];
    }
    NSURL *url = [NSURL URLWithString:internetAddress];
    
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)collegeWebsite:(id)sender {
    NSString *internetAddress = [self.school internetAddress];
    if ([internetAddress length] <= 4)
        return;
    
    if (![[internetAddress substringToIndex:4] isEqualToString:@"http"]) {
        internetAddress = [NSString stringWithFormat:@"http://%@", internetAddress];
    }
    NSURL *url = [NSURL URLWithString:internetAddress];
    
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)financialAidWebsite:(id)sender {
    NSString *internetAddress = [self.school financialAidInternetAddress];
    if ([internetAddress length] <= 4)
        return;
    if (![[internetAddress substringToIndex:4] isEqualToString:@"http"]) {
        internetAddress = [NSString stringWithFormat:@"http://%@", internetAddress];
    }
    NSURL *url = [NSURL URLWithString:internetAddress];
    
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)wikipediaArticle:(id)sender {
    NSString *internetAddress = @"http://en.wikipedia.org/wiki/Harvard";
    if ([internetAddress length] <= 4)
        return;
    
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

#pragma mark - NSXML Parsing Delegate

- (void) parserDidStartDocument:(NSXMLParser *)parser {
    _paragraphsParsed = 0;
    _seekingImage = FALSE;
    _foundImage = INTERFACE_IS_PHONE;
    
    self.formattedWiki = [[DDXMLElement alloc] initWithName:@"div"];
    
    NSString *ipadStyles = @"background-color:rgba(0,0,0,0);  padding:0px; margin:0px;  height:220px; overflow:hidden; line-height:20px; font-family:\"Paletino\", serif;";
    NSString *iPhoneStyles = @"background-color:rgba(0,0,0,0);  padding:0px; margin:0px;  height:276px; overflow:hidden; line-height:20px; font-family:\"Paletino\", serif;";
    DDXMLNode * style = [DDXMLNode attributeWithName:@"style" stringValue:INTERFACE_IS_PAD?ipadStyles:iPhoneStyles];
    
    
    [self.formattedWiki addAttribute:style];
    
    xmlElements = [[NSMutableArray alloc] init];
    
//    [xmlElements addObject:self.formattedWiki];
}

- (void) parserDidEndDocument:(NSXMLParser *)parser {
    _wikiLoaded = YES;
    
    DDXMLElement *body = [DDXMLElement elementWithName:@"body"];
    
    NSString *ipadStyles = @"padding:0px; margin:auto;";
    DDXMLNode * style = [DDXMLNode attributeWithName:@"style" stringValue:ipadStyles];
    [body addAttribute:style];
    
    [body addChild:self.formattedWiki];
    NSString *htmlValue = [body XMLString];
    NSLog(@"%@", htmlValue);
    [self.wikipediaEntryView loadHTMLString:htmlValue baseURL:[NSURL URLWithString:@"http://en.wikipedia.org/wiki/Brown_University"]];
}


- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    if (!_foundImage && [[attributeDict objectForKey:@"class"] isEqualToString:@"image"]) {
        _seekingImage = TRUE;
    }
    if (_seekingImage && [elementName isEqualToString:@"img"]) {
        DDXMLElement *img = [DDXMLElement elementWithName:@"img"];
        DDXMLNode * style = [DDXMLNode attributeWithName:@"style" stringValue:
                             @"max-height:200px; max-width:200px; height:auto; width:auto; float:right; position:relative; top:10px; right:0px;"];
        DDXMLNode * src = [DDXMLNode attributeWithName:@"src" stringValue:[attributeDict objectForKey:@"src"]];
        
        [img addAttribute:style];
        [img addAttribute:src];

        [self.formattedWiki addChild:img];
        
        _seekingImage = FALSE;
        _foundImage = TRUE;
    }
    
        
    DDXMLElement *el = [[DDXMLElement alloc] initWithName:elementName stringValue:@""];
    
    if ([elementName isEqualToString:@"span"] || [elementName isEqualToString:@"sup"] || [elementName isEqualToString:@"table"]) {
        
    } else {

        
        if ([elementName isEqualToString:@"p"]) {
            BOOL _shouldAdd = TRUE;
            
            for (DDXMLElement *iterEl in xmlElements) {
                if ([[iterEl name] isEqualToString:@"span"] || [[iterEl name] isEqualToString:@"sup"] || [[iterEl name] isEqualToString:@"table"]) {
                    _shouldAdd = FALSE;
                }
            }   
            
            if (_shouldAdd)
                [self.formattedWiki addChild:el];
        }
        else if ([xmlElements count] > 0)
            [((DDXMLElement *)[xmlElements lastObject]) addChild:el];
        else 
            [xmlElements addObject:el];
    }
    
    [xmlElements addObject:el];
    
    
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *) characters {

    DDXMLElement *el = (DDXMLElement *)[xmlElements lastObject];
    [el setStringValue:[NSString stringWithFormat:@"%@%@", el.stringValue, characters]];

}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    [xmlElements removeLastObject];
   
    
    if ([elementName isEqualToString:@"p"]) {
        _paragraphsParsed ++;
        if (_paragraphsParsed >= 5) {
            [parser abortParsing];
            [self parserDidEndDocument:parser];
        }
    }


}





@end
