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

@interface FTCollegeVisitNotesViewController () <UITextViewDelegate>

@end

@implementation FTCollegeVisitNotesViewController

@synthesize textView = _textView;
@synthesize visitViewController = _visitViewController;

@synthesize visit = _visit;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.textView = [[UITextView alloc] initWithFrame:CGRectZero];
        UIColor *textColor = [UIColor colorWithWhite:0.125 alpha:1.000];
        
        [self.textView setTextColor:textColor];
        [self.textView setBackgroundColor:self.view.backgroundColor];
        [self.textView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [self.textView setEditable:NO];
        [self.textView setDataDetectorTypes:UIDataDetectorTypeAll];
        [self.textView setAlwaysBounceVertical:hellzyeah];
        [self.textView setDelegate:self];
        
        self.title = @"Notes";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.925 alpha:1.000]];

    [self.view addSubview:self.textView];
    
    [self.textView setText:@"Etiam porta sem malesuada magna mollis euismod. Curabitur blandit tempus porttitor. Nulla vitae elit libero, a pharetra augue. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam quis risus eget urna mollis ornare vel eu leo.Etiam porta sem malesuada magna mollis euismod. Curabitur blandit tempus porttitor. Nulla vitae elit libero, a pharetra augue. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam quis risus eget urna mollis ornare vel eu leo.Etiam porta sem malesuada magna mollis euismod. Curabitur blandit tempus porttitor. Nulla vitae elit libero, a pharetra augue. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam quis risus eget urna mollis ornare vel eu leo.Etiam porta sem malesuada magna mollis euismod. Curabitur blandit tempus porttitor. Nulla vitae elit libero, a pharetra augue. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam quis risus eget urna mollis ornare vel eu leo.Etiam porta sem mEtiam porta sem malesuada magna mollis euismod. Curabitur blandit tempus porttitor. Nulla vitae elit libero, a pharetra augue. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam quis risus eget urna mollis ornare vel eu leo.Etiam porta sem malesuada magna mollis euismod. Curabitur blandit tempus porttitor. Nulla vitae elit libero, a pharetra augue. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam quis risus eget urna mollis ornare vel eu leo.Etiam porta sem malesuada magna mollis euismod. Curabitur blandit tempus porttitor. Nulla vitae elit libero, a pharetra augue. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam quis risus eget urna mollis ornare vel eu leo.alesuada magna mollis euismod. Curabitur blandit tempus porttitor. Nulla vitae elit libero, a pharetra augue. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam quis risus eget urna mollis ornare vel eu leo."];
    
    
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
        [self.view.layer setCornerRadius:5.0];
        [self.view.layer setBorderColor:[UIColor colorWithWhite:0.686 alpha:1.000].CGColor];
        [self.view.layer setBorderWidth:1.0];
        [self.textView setEditable:NO];
    }    
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.textView setFrame:CGRectMake(MARGIN_X, MARGIN_Y, self.view.frame.size.width - MARGIN_X * 2, self.view.frame.size.height - MARGIN_Y * 2)];   
}


- (void) returnToVisit:(UIBarButtonItem *)doneButton {
    
    
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
