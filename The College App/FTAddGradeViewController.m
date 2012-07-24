//
//  FTAddGradeViewController.m
//  The College App
//
//  Created by Jeff Barg on 7/5/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import "FTAddGradeViewController.h"
#import "Grade.h"
#import <QuartzCore/QuartzCore.h>

@interface FTAddGradeViewController () {    
    NSNumber * _score;
    NSNumber * _year;
    
    NSNumber * _fullCredit;
    
    NSNumber * _honors;
    
}

@property (nonatomic, strong) UIScrollView *containerView;
@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UITextField *subjectTextField;
@property (nonatomic, strong) UIButton * honorsButton;

@property (nonatomic, strong) NSArray *yearButtons;

@property (nonatomic, strong) NSArray *gradeButtons;

@property (nonatomic, strong) UILabel *yearLabel;
@property (nonatomic, strong) UILabel *gradeLabel;
@property (nonatomic, strong) UILabel *numberOfCreditsLabel;

@property (nonatomic, strong) UIButton *fullCreditButton;
@property (nonatomic, strong) UIButton *halfCreditButton;

@property (nonatomic, strong) Grade *nGrade;


@end


@implementation FTAddGradeViewController

@synthesize containerView = _containerView;
@synthesize headerView = _headerView;

@synthesize subjectTextField = _subjectTextField;
@synthesize honorsButton = _honorsButton;

@synthesize yearButtons = _yearButtons;

@synthesize gradeButtons = _gradeButtons;

@synthesize yearLabel = _yearLabel;
@synthesize gradeLabel = _gradeLabel;
@synthesize numberOfCreditsLabel = _numberOfCreditsLabel;

@synthesize fullCreditButton = _fullCreditButton;
@synthesize halfCreditButton = _halfCreditButton; 

@synthesize managedObjectContext = _managedObjectContext;

@synthesize nGrade = _nGrade;

- (id) init {
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //SET UP KEYBOARD NOTIFICATIONS
    
    if (INTERFACE_IS_PHONE) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWasShown:)
                                                     name:UIKeyboardDidShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillBeHidden:)
                                                     name:UIKeyboardWillHideNotification object:nil];
    }
    

    //SET UP GRADE TO MODIFY
    
    _score = [NSNumber numberWithInteger:-1];
    _honors = [NSNumber numberWithBool:NO];
    _fullCredit = [NSNumber numberWithBool:YES];
    
    
    //SET UP NAVIGATION BAR



    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
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

    // Do any additional setup after loading the view.
    
    UIColor *borderColor = [UIColor colorWithHue:0.562 saturation:0.041 brightness:0.765 alpha:1.000];
    //    UIColor * yearButtonColor = [UIColor colorWithHue:0.548 saturation:0.045 brightness:0.608 alpha:1.000];
    UIColor *gradeButtonColor = [UIColor colorWithHue:0.583 saturation:0.049 brightness:0.322 alpha:1.000];
    UIColor *greenTextColor = [UIColor colorWithRed:0.000 green:0.651 blue:0.000 alpha:1.000];
    
    
    _containerView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [_containerView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [_containerView setAlwaysBounceVertical:YES];
    
    [self.view addSubview:_containerView];
    
    _headerView = [[UIView alloc] initWithFrame:CGRectZero];
    [_headerView setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth];
    [_headerView.layer setBorderColor:borderColor.CGColor];
    [_headerView.layer setBorderWidth:1.0];
    
    [_containerView addSubview:_headerView];
    
    _subjectTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    [_subjectTextField setFont:[UIFont systemFontOfSize:16.0]];
    //[_subjectTextField setTextColor:[UIColor colorWithHue:0.548 saturation:0.045 brightness:0.608 alpha:1.000]];
    
    [_subjectTextField setPlaceholder:@"Subject"];
    [_subjectTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_subjectTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];

    [_headerView addSubview:_subjectTextField];
    
    _honorsButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [_honorsButton setBackgroundImage:[[UIImage imageNamed:@"aphonors.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 6.0, 0.0, 6.0)] forState:UIControlStateNormal];
    [_honorsButton setBackgroundImage:[[UIImage imageNamed:@"aphonorstapped.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 6.0, 0.0, 6.0)] forState:UIControlStateHighlighted];
    [_honorsButton setTitleColor:[UIColor colorWithHue:0.000 saturation:0.000 brightness:0.247 alpha:1.000] forState:UIControlStateNormal];
    [_honorsButton.titleLabel setShadowColor:nil];
    [_honorsButton.titleLabel setShadowOffset:CGSizeZero];
    
    [_honorsButton setTitleEdgeInsets:UIEdgeInsetsMake(-1.0, 0.0, 0.0, 0.0)];
    
    [_honorsButton setTitle:@"AP/Honors" forState:UIControlStateNormal];
    [_honorsButton.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0]];

    [_honorsButton addTarget:self action:@selector(selectHonors:) forControlEvents:UIControlEventTouchUpInside];
    
    [_headerView addSubview:_honorsButton];
    
    
    NSMutableArray *mButtonArray = [[NSMutableArray alloc] initWithCapacity:4];
    for (int i = 0; i < 4; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
        [button setTitle:[NSString stringWithFormat:@"%i", i + 9] forState:UIControlStateNormal]; // 9 Through 12
        [button setTitleColor:gradeButtonColor forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
        [button setShowsTouchWhenHighlighted:YES];
        
        [button.layer setBorderColor:borderColor.CGColor];
        [button.layer setBorderWidth:1.0];
        
        [button addTarget:self action:@selector(selectYear:) forControlEvents:UIControlEventTouchUpInside];
        
        [_containerView addSubview:button];
        [mButtonArray addObject:button];
    }
    self.yearButtons = [[NSArray alloc] initWithArray:mButtonArray];
    
    mButtonArray = [[NSMutableArray alloc] initWithCapacity:12];
    
    NSArray *titleArray = [NSArray arrayWithObjects:@"A+", @"A", @"A-", @"B+", @"B", @"B-", @"C+", @"C", @"C-", @"D", @"F", @"N/A", nil];
    
    NSLog(@"%i", [titleArray count]);
    for (int i = 0; i < 12; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
        [button setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
        
        [button setTitleColor:gradeButtonColor forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
        [button setShowsTouchWhenHighlighted:YES];
        
        [button.layer setBorderColor:borderColor.CGColor];
        [button.layer setBorderWidth:1.0];
        
        [button addTarget:self action:@selector(selectGrade:) forControlEvents:UIControlEventTouchUpInside];
        
         [_containerView addSubview:button];
        [mButtonArray addObject:button];
    }
    
    self.gradeButtons = [[NSArray alloc] initWithArray:mButtonArray];

    _yearLabel =            [[UILabel alloc] initWithFrame:CGRectZero];
    _gradeLabel =           [[UILabel alloc] initWithFrame:CGRectZero];
    _numberOfCreditsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
    [_yearLabel             setFont:[UIFont boldSystemFontOfSize:12.0]];
    [_gradeLabel            setFont:[UIFont boldSystemFontOfSize:12.0]];
    [_numberOfCreditsLabel  setFont:[UIFont boldSystemFontOfSize:12.0]];
    
    [_yearLabel             setText:@"Year"];
    [_gradeLabel            setText:@"Grade"];
    [_numberOfCreditsLabel  setText:@"Number of Credits"];
    
    [_yearLabel             setTextColor:gradeButtonColor];
    [_gradeLabel            setTextColor:gradeButtonColor];
    [_numberOfCreditsLabel  setTextColor:gradeButtonColor];
    
    [_yearLabel                 setBackgroundColor:[UIColor clearColor]];
    [_gradeLabel                setBackgroundColor:[UIColor clearColor]];
    [_numberOfCreditsLabel      setBackgroundColor:[UIColor clearColor]];

    [_containerView addSubview:_yearLabel];
    [_containerView addSubview:_gradeLabel];
    [_containerView addSubview:_numberOfCreditsLabel];

    _fullCreditButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [_fullCreditButton setImage:[UIImage imageNamed:@"fullcredit.png"] forState:UIControlStateNormal];
    [_fullCreditButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 12.0, 0.0, 0.0)];
    [_fullCreditButton setTitle:@"Full Credit" forState:UIControlStateNormal];
    [_fullCreditButton setTitleColor:greenTextColor forState:UIControlStateNormal];
    [_fullCreditButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    [_fullCreditButton.layer setBorderColor:borderColor.CGColor];
    [_fullCreditButton.layer setBorderWidth:1.0];
    [_fullCreditButton addTarget:self action:@selector(halfFullCreditButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_containerView addSubview:_fullCreditButton];
    
    _halfCreditButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [_halfCreditButton setImage:[UIImage imageNamed:@"halfcredit.png"] forState:UIControlStateNormal];
    [_halfCreditButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 12.0, 0.0, 0.0)];
    [_halfCreditButton setTitle:@"Half Credit" forState:UIControlStateNormal];
    [_halfCreditButton setTitleColor:gradeButtonColor forState:UIControlStateNormal];
    [_halfCreditButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    [_halfCreditButton.layer setBorderColor:borderColor.CGColor];
    [_halfCreditButton.layer setBorderWidth:1.0];
    [_halfCreditButton addTarget:self action:@selector(halfFullCreditButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_containerView addSubview:_halfCreditButton];
    
    [self.view setBackgroundColor:[UIColor colorWithHue:0.567 saturation:0.041 brightness:0.957 alpha:1.000]];

    
}

- (void)viewDidLayoutSubviews {
    [_containerView setContentSize:CGSizeMake(self.view.frame.size.width, 444.0)];
    
    [_containerView setFrame:self.view.bounds];
    [_headerView setFrame:CGRectMake(-1.0, -1.0, self.view.frame.size.width + 2.0, 61.0)];
    
    [_subjectTextField setFrame:CGRectMake(1.0 + 10.0, 1.0, 0.7 * (self.view.bounds.size.width - 20.0), 60.0)];

    [_honorsButton setFrame:CGRectMake(CGRectGetMaxX(_subjectTextField.frame), 1.0 + 15.0, 0.3 * (self.view.bounds.size.width - 20.0), 30.0)];
    
    for (int i = 0; i < 4; i ++) {
        UIButton *button = (UIButton *)[self.yearButtons objectAtIndex:i];
        CGSize frameSize = self.view.frame.size;
        [button setFrame:CGRectMake(-1 + i * frameSize.width / 4.0, 90.0, frameSize.width / 4.0 + (i==3?2.0:1.0), 44.0)];
        
    }
    
    for (int i = 0; i < 12; i ++) {
        UIButton *button = (UIButton *)[self.gradeButtons objectAtIndex:i];
        CGSize frameSize = self.view.frame.size;
        
        CGRect buttonFrame = CGRectZero;
        buttonFrame.size = CGSizeMake(frameSize.width/4.0 + (i >= 9?2.0:1.0), 65.0);
        buttonFrame.origin = CGPointMake(-1 + (i / 3) * frameSize.width / 4.0, 164.0 +  (i%3 * 64.0));
        
        [button setFrame:buttonFrame];
        
    }
    
    [_yearLabel                 setFrame:CGRectMake(10.0, 60.0, self.view.frame.size.width - 20.0, 30.0)];
    [_gradeLabel                setFrame:CGRectMake(10.0, 134.0, self.view.frame.size.width - 20.0, 30.0)];
    [_numberOfCreditsLabel      setFrame:CGRectMake(10.0, 358.0, self.view.frame.size.width - 20.0, 30.0)];

    [_fullCreditButton setFrame:CGRectMake(-1.0, 390.0, self.view.frame.size.width / 2.0 + 1.0, 60.0)];
    [_halfCreditButton setFrame:CGRectMake(CGRectGetMaxX(_fullCreditButton.frame) - 1.0, 390.0, self.view.frame.size.width / 2.0 + 2.0, 60.0)];

}


#pragma mark -
#pragma mark Buttons 

- (void) cancelEntry:(UIBarButtonItem *) barButtonItem {
    [self dismissModalViewControllerAnimated:YES];
}

- (void) saveEntry:(UIBarButtonItem *) barButtonItem { 
    if (_year == nil) return;
    
    self.nGrade = [NSEntityDescription insertNewObjectForEntityForName:@"Grade" inManagedObjectContext:self.managedObjectContext];
    
    [self.nGrade setDateCreated:[NSDate date]];
    [self.nGrade setSubject:[_subjectTextField text]];
    [self.nGrade setYear:_year];
    [self.nGrade setFullCredit:_fullCredit];
    [self.nGrade setHonors:_honors];
    [self.nGrade setScore:_score];
    
    NSError *err = nil;
    [self.managedObjectContext save:&err];
    if (err != nil) {
        NSLog(@"%@", [err localizedDescription]);
    }
        
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{}];
}

- (void) selectHonors:(UIBarButtonItem *) barButtonItem {
    if ([_honors boolValue]) {
        [_honorsButton setBackgroundImage:[[UIImage imageNamed:@"aphonors.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 6.0, 0.0, 6.0)] forState:UIControlStateNormal];
        [_honorsButton setBackgroundImage:[[UIImage imageNamed:@"aphonorstapped.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 6.0, 0.0, 6.0)] forState:UIControlStateHighlighted];
        [_honorsButton setTitleColor:[UIColor colorWithHue:0.000 saturation:0.000 brightness:0.247 alpha:1.000] forState:UIControlStateNormal];
        [_honorsButton.titleLabel setShadowColor:nil];
        [_honorsButton.titleLabel setShadowOffset:CGSizeZero];

    } else {
        [_honorsButton setBackgroundImage:[[UIImage imageNamed:@"aphonorsactive.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 6.0, 0.0, 6.0)] forState:UIControlStateNormal];
        [_honorsButton setBackgroundImage:[[UIImage imageNamed:@"aphonorsactivetapped.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 6.0, 0.0, 6.0)] forState:UIControlStateHighlighted];
        [_honorsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_honorsButton.titleLabel setShadowColor:[UIColor blackColor]];
        [_honorsButton.titleLabel setShadowOffset:CGSizeMake(0, -1)];

    }

    _honors = [NSNumber numberWithBool:![_honors boolValue]];

}
     
    
- (void) selectYear:(UIButton *) yearButton {
    NSInteger index = [_yearButtons indexOfObject:yearButton];
    _year = [NSNumber numberWithInteger:index + 9];
     
     UIColor *textColor = [UIColor colorWithHue:0.583 saturation:0.049 brightness:0.322 alpha:1.000];
     UIColor *purpleTextColor = [UIColor colorWithRed:0.545 green:0.000 blue:0.694 alpha:1.000];
     
     for (UIButton *button in _yearButtons) {
         [button setTitleColor:textColor forState:UIControlStateNormal];

     }
     [yearButton setTitleColor:purpleTextColor forState:UIControlStateNormal];
}

- (void) selectGrade:(UIButton *) gradeButton {
    NSInteger index = [_gradeButtons indexOfObject:gradeButton];
    
    _score = [NSNumber numberWithInteger:10-index];
    
    UIColor *textColor = [UIColor colorWithHue:0.583 saturation:0.049 brightness:0.322 alpha:1.000];
    UIColor *greenTextColor = [UIColor colorWithRed:0.000 green:0.651 blue:0.000 alpha:1.000];
    
    for (UIButton *button in _gradeButtons) {
        [button setTitleColor:textColor forState:UIControlStateNormal];
    }
    
    [gradeButton setTitleColor:greenTextColor forState:UIControlStateNormal];
    
}

- (void) halfFullCreditButton:(UIButton *) button {
    
    UIColor *textColor = [UIColor colorWithHue:0.583 saturation:0.049 brightness:0.322 alpha:1.000];
    UIColor *greenTextColor = [UIColor colorWithRed:0.000 green:0.651 blue:0.000 alpha:1.000];
    
    if (_fullCreditButton == button) {
        _fullCredit = [NSNumber numberWithBool:YES];
        [_fullCreditButton setTitleColor:greenTextColor forState:UIControlStateNormal];
        [_halfCreditButton setTitleColor:textColor forState:UIControlStateNormal];
        
    } else {
        
        _fullCredit = [NSNumber numberWithBool:NO];
        [_halfCreditButton setTitleColor:greenTextColor forState:UIControlStateNormal];
        [_fullCreditButton setTitleColor:textColor forState:UIControlStateNormal];
    }
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
