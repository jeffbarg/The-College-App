//
//  FTCollegeVisitNotesViewController.m
//  The College App
//
//  Created by Jeffrey Barg on 7/13/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import "FTCollegeVisitNotesViewController.h"
#import <QuartzCore/QuartzCore.h>

#define MARGIN_X 5
#define MARGIN_Y 8

@interface FTCollegeVisitNotesViewController () <UITextViewDelegate> {
}

@property (nonatomic, strong) UIBarButtonItem *currentBarButtonItem;

@end

@implementation FTCollegeVisitNotesViewController

@synthesize textView = _textView;
@synthesize visitViewController = _visitViewController;
@synthesize managedObjectContext;
@synthesize visit = _visit;
@synthesize currentBarButtonItem = _currentBarButtonItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Notes" image:[UIImage imageNamed:@"notes.png"] tag:2634];
        
        self.textView = [[UITextView alloc] initWithFrame:CGRectZero];
        UIColor *textColor = [UIColor colorWithWhite:0.125 alpha:1.000];
        
        [self.textView setTextColor:textColor];
        [self.textView setBackgroundColor:self.view.backgroundColor];
        [self.textView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [self.textView setEditable:NO];
        [self.textView setDataDetectorTypes:UIDataDetectorTypeAll];
        [self.textView setAlwaysBounceVertical:hellzyeah];
        [self.textView setDelegate:self];
        
        [self.textView setDelegate:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithHue:0.562 saturation:0.032 brightness:0.976 alpha:1.000]];

    [self.view addSubview:self.textView];
    
    [self.textView setText:self.visit.notes];
    
    self.currentBarButtonItem = self.visitViewController.navigationItem.rightBarButtonItem;
    
    UIBarButtonItem *dismissItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(returnToVisit:)];
    self.navigationItem.leftBarButtonItem = dismissItem;
    
	// Do any additional setup after loading the view.
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    if (INTERFACE_IS_PAD && self.presentingViewController != nil) {
        [self.textView setFont:[UIFont boldSystemFontOfSize:20.0]];
        
        [self.view.layer setCornerRadius:0.0];
        [self.view.layer setBorderColor:nil];
        [self.view.layer setBorderWidth:0.0];
        [self.textView setEditable:YES];
    } else {
        [self.textView setFont:[UIFont boldSystemFontOfSize:14.0]];
        [self.textView setEditable:NO];

        if (INTERFACE_IS_PAD) {
            [self.view.layer setCornerRadius:5.0];
            [self.view.layer setBorderColor:[UIColor colorWithRed:0.651 green:0.725 blue:0.788 alpha:1.000].CGColor];
            [self.view.layer setBorderWidth:1.0];
            [self.textView setEditable:NO];
            
        } else {
            [self.textView setEditable:YES];

        }
    }    
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.textView setFrame:CGRectMake(MARGIN_X, MARGIN_Y, self.view.frame.size.width - MARGIN_X * 2, self.view.frame.size.height - MARGIN_Y * 2)];   
}

- (void) dismissKeyboard:(UIBarButtonItem *)doneButton {
    [self.textView resignFirstResponder];
}
- (void) textViewDidChangeSelection:(UITextView *)textView {
    [self.visit setNotes:[textView text]];
}

-(void) textViewDidBeginEditing:(UITextView *)textView {
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyboard:)];
    
    [self.visitViewController.navigationItem setRightBarButtonItem:doneButton animated:YES];
}

- (void) textViewDidEndEditing:(UITextView *)textView {
    [self.visitViewController.navigationItem setRightBarButtonItem:_currentBarButtonItem animated:YES];
}

- (void) viewWillDisappear:(BOOL)animated {
    [self.visitViewController.navigationItem setRightBarButtonItem:_currentBarButtonItem animated:NO];
    NSError *err = nil;
    if ([self.managedObjectContext hasChanges] && ![self.managedObjectContext save:&err]) {
        NSLog(@"%@", [err description]);
    }   
}
- (void) returnToVisit:(UIBarButtonItem *)doneButton {
    NSError *err = nil;
    if ([self.managedObjectContext hasChanges] && ![self.managedObjectContext save:&err]) {
        NSLog(@"%@", [err description]);
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.visitViewController != nil)
            [self.visitViewController unfocusNotepad];   
    }];
    
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

#pragma mark - UITextViewDelegate Methods


@end
