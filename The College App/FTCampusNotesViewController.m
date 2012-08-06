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

    if (self.presentingViewController != nil) {
        [self.textView setEditable:YES];
        
        NSNotificationCenter *notifCenter = [NSNotificationCenter defaultCenter];
        [notifCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [notifCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [notifCenter addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        
        if (INTERFACE_IS_PAD) {
            [self.textView setFont:[UIFont boldSystemFontOfSize:20.0]];
        } else {
            [self.textView setFont:[UIFont boldSystemFontOfSize:16.0]];
        }
    } else {
        [self.textView setFont:[UIFont boldSystemFontOfSize:16.0]];
        [self.textView setEditable:NO];
    }

}

- (void) viewWillDisappear:(BOOL)animated {
    
}

- (void) viewWillLayoutSubviews {

    [self.textView setFrame:self.view.bounds];
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

- (void) keyboardWillShow:(NSNotification *)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    

    [self.textView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - kbSize.height)];
}

- (void) keyboardWillHide:(NSNotification *)aNotification {
    

}

- (void) keyboardWillChangeFrame:(NSNotification *)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    
    [self.textView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - kbSize.height)];
    
}
@end
