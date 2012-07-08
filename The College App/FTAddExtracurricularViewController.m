//
//  FTAddExtracurricularViewController.m
//  The College App
//
//  Created by Jeff Barg on 7/5/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import "FTAddExtracurricularViewController.h"
#import "Extracurricular.h"

#import <QuartzCore/QuartzCore.h>

@interface FTAddExtracurricularViewController () {
    NSNumber * _gradesInvolved;

}

@property (nonatomic, strong) UIScrollView *containerView;
@property (nonatomic, strong) UIView *headerView1;
@property (nonatomic, strong) UIView *headerView2;

@property (nonatomic, strong) UITextField *activityTextField;
@property (nonatomic, strong) UITextField *positionTextField;

@property (nonatomic, strong) UILabel *yearLabel;

@property (nonatomic, strong) NSArray *yearButtons;

@property (nonatomic, strong) UIView *hoursPerWeekContainer;
@property (nonatomic, strong) UIView *weeksPerYearContainer;

@property (nonatomic, strong) UILabel *hoursPerWeekLabel;
@property (nonatomic, strong) UILabel *weeksPerYearLabel;

@property (nonatomic, strong) UITextField *hoursPerWeekTextField;
@property (nonatomic, strong) UITextField *weeksPerYearTextField;

@property (nonatomic, strong) Extracurricular * activity;


@end

@implementation FTAddExtracurricularViewController

@synthesize containerView = _containerView;
@synthesize headerView1 = _headerView1;
@synthesize headerView2 = _headerView2;

@synthesize activityTextField = _activityTextField;
@synthesize positionTextField = _positionTextField;

@synthesize yearLabel = _yearLabel;

@synthesize yearButtons = _yearButtons;

@synthesize hoursPerWeekContainer = _hoursPerWeekContainer;
@synthesize weeksPerYearContainer = _weeksPerYearContainer;

@synthesize hoursPerWeekLabel = _hoursPerWeekLabel;
@synthesize weeksPerYearLabel = _weeksPerYearLabel;

@synthesize hoursPerWeekTextField = _hoursPerWeekTextField;
@synthesize weeksPerYearTextField = _weeksPerYearTextField;

@synthesize managedObjectContext = _managedObjectContext;

@synthesize activity = _activity;

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
    
    //SET UP KEYBOARD NOTIFICATIONS
    
    if (INTERFACE_IS_PHONE) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWasShown:)
                                                     name:UIKeyboardDidShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillBeHidden:)
                                                     name:UIKeyboardWillHideNotification object:nil];
    }
    
    //SET UP EXTRACURRICULAR TO MODIFY
    
    _gradesInvolved = [NSNumber numberWithInteger:0];
    
    
    //VIEW BACKGROUND
    
    [self.view setBackgroundColor:[UIColor colorWithHue:0.567 saturation:0.041 brightness:0.957 alpha:1.000]];

    //NAVIGATION BAR
    if (!INTERFACE_IS_PAD) {
        UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelEntry:)];
        self.navigationItem.leftBarButtonItem = cancelBarButtonItem;
        [cancelBarButtonItem setBackgroundImage:[[UIImage imageNamed:@"cancel.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [cancelBarButtonItem setBackgroundImage:[[UIImage imageNamed:@"cancelactive.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    }
    
    UIBarButtonItem *saveBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveEntry:)];
    self.navigationItem.rightBarButtonItem = saveBarButtonItem;
    [saveBarButtonItem setBackgroundImage:[[UIImage imageNamed:@"save.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [saveBarButtonItem setBackgroundImage:[[UIImage imageNamed:@"saveactive.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    
    self.navigationItem.title = @"New Entry";
    
    //VIEW CONTENT
    
    UIColor *borderColor = [UIColor colorWithHue:0.562 saturation:0.041 brightness:0.765 alpha:1.000];
    UIColor *textColor = [UIColor colorWithHue:0.583 saturation:0.049 brightness:0.322 alpha:1.000];
    
    _containerView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [_containerView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    
    [self.view addSubview:_containerView];
    
    _headerView1 = [[UIView alloc] initWithFrame:CGRectZero];
    [_headerView1 setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth];
    [_headerView1.layer setBorderColor:borderColor.CGColor];
    [_headerView1.layer setBorderWidth:1.0];
    
    [_containerView addSubview:_headerView1];
    
    _headerView2 = [[UIView alloc] initWithFrame:CGRectZero];
    [_headerView2 setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth];
    [_headerView2.layer setBorderColor:borderColor.CGColor];
    [_headerView2.layer setBorderWidth:1.0];
    
    [_containerView addSubview:_headerView2];
    
    
    _activityTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    [_activityTextField setFont:[UIFont systemFontOfSize:16.0]];
    
    [_activityTextField setPlaceholder:@"Activity"];
    [_activityTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_activityTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    
    [_headerView1 addSubview:_activityTextField];
    
    _positionTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    [_positionTextField setFont:[UIFont systemFontOfSize:16.0]];
    
    [_positionTextField setPlaceholder:@"Position"];
    [_positionTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_positionTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    
    [_headerView2 addSubview:_positionTextField];
    
    
    NSMutableArray *mButtonArray = [[NSMutableArray alloc] initWithCapacity:4];
    for (int i = 0; i < 4; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
        [button setTitle:[NSString stringWithFormat:@"%i", i + 9] forState:UIControlStateNormal]; // 9 Through 12
        [button setTitleColor:textColor forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
        [button setShowsTouchWhenHighlighted:YES];
        
        [button.layer setBorderColor:borderColor.CGColor];
        [button.layer setBorderWidth:1.0];
        
        [button addTarget:self action:@selector(yearButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [_containerView addSubview:button];
        [mButtonArray addObject:button];
    }
    self.yearButtons = [[NSArray alloc] initWithArray:mButtonArray];
    
    _yearLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_yearLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    [_yearLabel setText:@"Year(s)"];
    [_yearLabel setTextColor:textColor];
    [_yearLabel setBackgroundColor:[UIColor clearColor]];

    [_containerView addSubview:_yearLabel];
    
    
    _hoursPerWeekLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_hoursPerWeekLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    [_hoursPerWeekLabel setTextColor:textColor];
    [_hoursPerWeekLabel setBackgroundColor:[UIColor clearColor]];
    [_hoursPerWeekLabel setText:@"Hours Per Week"];
    
    _hoursPerWeekContainer = [[UIView alloc] initWithFrame:CGRectZero];
    [_hoursPerWeekContainer.layer setBorderColor:borderColor.CGColor];
    [_hoursPerWeekContainer.layer setBorderWidth:1.0];
    
    [_hoursPerWeekContainer addSubview:_hoursPerWeekLabel];
    [_containerView addSubview:_hoursPerWeekContainer];
    
    
    _weeksPerYearLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_weeksPerYearLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    [_weeksPerYearLabel setTextColor:textColor];
    [_weeksPerYearLabel setBackgroundColor:[UIColor clearColor]];
    [_weeksPerYearLabel setText:@"Weeks Per Year"];
    
    _weeksPerYearTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    [_weeksPerYearTextField setPlaceholder:@"Weeks"];
    [_weeksPerYearTextField setKeyboardType:UIKeyboardTypePhonePad];
    [_weeksPerYearTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_weeksPerYearTextField setTextAlignment:UITextAlignmentRight];
    
    _weeksPerYearContainer = [[UIView alloc] initWithFrame:CGRectZero];
    [_weeksPerYearContainer.layer setBorderColor:borderColor.CGColor];
    [_weeksPerYearContainer.layer setBorderWidth:1.0];
    
    [_weeksPerYearContainer addSubview:_weeksPerYearTextField];
    [_weeksPerYearContainer addSubview:_weeksPerYearLabel];
    [_containerView addSubview:_weeksPerYearContainer];
}


- (void)viewDidLayoutSubviews {
    [_containerView setContentSize:CGSizeMake(self.view.frame.size.width, 310.0)];
    
    [_containerView setFrame:self.view.bounds];
    [_headerView1 setFrame:CGRectMake(-1.0, -1.0, self.view.frame.size.width + 2.0, 61.0)];
    [_headerView2 setFrame:CGRectMake(-1.0, -1.0 + CGRectGetMaxY(_headerView1.frame), self.view.frame.size.width + 2.0, 61.0)];
    
    [_activityTextField setFrame:CGRectMake(1.0 + 10.0, 1.0, self.view.bounds.size.width - 20.0, 60.0)];
    [_positionTextField setFrame:CGRectMake(1.0 + 10.0, 1.0, self.view.bounds.size.width - 20.0, 60.0)];

    [_yearLabel                 setFrame:CGRectMake(10.0, 120.0, self.view.frame.size.width - 20.0, 30.0)];

    [_hoursPerWeekContainer setFrame:CGRectMake(-1.0, 194.0 - 1.0, self.view.frame.size.width + 2.0, 60.0)];
    [_hoursPerWeekLabel setFrame:CGRectMake(10.0, 0.0, 150.0, 60.0)];

    [_weeksPerYearContainer setFrame:CGRectMake(-1.0, CGRectGetMaxY(_hoursPerWeekContainer.frame) - 1.0, self.view.frame.size.width + 2.0, 60.0)];
    [_weeksPerYearLabel setFrame:CGRectMake(10.0, 0.0, 150.0, 60.0)];
    [_weeksPerYearTextField setFrame:CGRectMake(self.view.frame.size.width - 10.0 - 150.0, 0.0, 150, 60.0)];
    
    for (int i = 0; i < 4; i ++) {
        UIButton *button = (UIButton *)[self.yearButtons objectAtIndex:i];
        CGSize frameSize = self.view.frame.size;
        [button setFrame:CGRectMake(-1 + i * frameSize.width / 4.0, 150.0, frameSize.width / 4.0 + (i==3?2.0:1.0), 44.0)];
        
    }
    
    
}


#pragma mark -
#pragma mark Buttons

- (void) yearButton:(UIButton *) yearButton {
    NSInteger yearMask = 1 << [_yearButtons indexOfObject:yearButton];
    
    _gradesInvolved = [NSNumber numberWithInteger:[_gradesInvolved integerValue] ^ yearMask];
    UIColor *textColor = [UIColor colorWithHue:0.583 saturation:0.049 brightness:0.322 alpha:1.000];
    UIColor *purpleTextColor = [UIColor colorWithRed:0.545 green:0.000 blue:0.694 alpha:1.000];

    NSLog(@"%i", [_gradesInvolved integerValue]);

    if ((yearMask & [_gradesInvolved integerValue]) == 0) {
        [yearButton setTitleColor:textColor forState:UIControlStateNormal];
    } else {
        [yearButton setTitleColor:purpleTextColor forState:UIControlStateNormal];

    }
}

- (void) cancelEntry:(UIBarButtonItem *) barButtonItem {
    [self dismissModalViewControllerAnimated:YES];
}

- (void) saveEntry:(UIBarButtonItem *) barButtonItem { 
    
    self.activity = [NSEntityDescription insertNewObjectForEntityForName:@"Extracurricular" inManagedObjectContext:self.managedObjectContext];
    
    
    [self.activity setGradesInvolved:_gradesInvolved];
    [self.activity setName:[_activityTextField text]];
    [self.activity setPosition:[_positionTextField text]];
    [self.activity setWeeks:[NSNumber numberWithInteger:5]];
    [self.activity setHours:[NSNumber numberWithInteger:5]];

    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Extracurricular" inManagedObjectContext:self.managedObjectContext]];
    
    [request setIncludesSubentities:NO]; //Omit subentities. Default is YES (i.e. include subentities)
    
    NSError *err = nil;
    NSUInteger count = [self.managedObjectContext countForFetchRequest:request error:&err];
    if(count == NSNotFound || err != nil) {
        //Handle error
        NSLog(@"%@", [err localizedDescription]);
        [self dismissModalViewControllerAnimated:YES];
    }
    
    [self.activity setIndex:[NSNumber numberWithInteger:count]];
    
    err = nil;
    [self.managedObjectContext save:&err];
    if (err != nil) {
        NSLog(@"%@", [err localizedDescription]);
    }
        
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{}];
}


#pragma mark -
#pragma mark Keyboard Notifications

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);

    _containerView.contentInset = contentInsets;
    _containerView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
//    CGRect aRect = self.view.frame;
//    aRect.size.height -= kbSize.height;
//    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
//        CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y-kbSize.height);
//        [scrollView setContentOffset:scrollPoint animated:YES];
//    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _containerView.contentInset = contentInsets;
    _containerView.scrollIndicatorInsets = contentInsets;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (INTERFACE_IS_PAD)?YES:(interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
