//
//  FTCampusNotesViewController.m
//  The College App
//
//  Created by Jeffrey Barg on 7/31/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import "FTCampusNotesViewController.h"

@interface FTCampusNotesViewController ()

@end

@implementation FTCampusNotesViewController

@synthesize managedObjectContext;
@synthesize visitViewController;

@synthesize textView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        textView = [[UITextView alloc] initWithFrame:CGRectZero];
        [textView setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:textView];
    
    self.title = @"Notes";
	// Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];

    if (INTERFACE_IS_PAD && self.presentingViewController != nil) {
        [self.textView setFont:[UIFont boldSystemFontOfSize:20.0]];
        [self.textView setEditable:YES];
    } else {
        [self.textView setFont:[UIFont boldSystemFontOfSize:16.0]];
        [self.textView setEditable:NO];
    }
}

- (void) viewWillLayoutSubviews {

    [self.textView setFrame:CGRectInset(self.view.bounds, 10, 10)];
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
