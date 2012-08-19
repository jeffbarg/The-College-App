//
//  FTCampusNotesViewController.m
//  The College App
//
//  Created by Jeffrey Barg on 7/31/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import "FTCampusNotesViewController.h"

@interface FTCampusNotesViewController () {
    CGSize keyboardSize;
}

@end

@implementation FTCampusNotesViewController

@synthesize managedObjectContext;
@synthesize visitViewController;

@synthesize textView;

@synthesize school = _school;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        textView = [[UITextView alloc] initWithFrame:CGRectZero];
        [textView setBackgroundColor:[UIColor clearColor]];

        [self.textView setAutoresizingMask:UIViewAutoresizingNone];
        
        UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Notes" image:[UIImage imageNamed:@"notes.png"] tag:511];
        self.tabBarItem = tabBarItem;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:textView];
    if (INTERFACE_IS_PHONE) {
        UIView *accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44.0)];
        [accessoryView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
        
        UIButton * resignButton = [[UIButton alloc] initWithFrame:CGRectMake(accessoryView.frame.size.width - 55.0
                                                                             , 0, 55.0, 44.0)];
        [accessoryView addSubview:resignButton];
        
        [resignButton addTarget:self.textView action:@selector(resignFirstResponder) forControlEvents:UIControlEventTouchUpInside];
        [resignButton setImage:[UIImage imageNamed:@"dismiss.png"] forState:UIControlStateNormal];
        [resignButton setImage:[UIImage imageNamed:@"dismissactive.png"] forState:UIControlStateHighlighted];
        
        [self.textView setInputAccessoryView:accessoryView];
    }
    
    self.title = @"Notes";
	// Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];

    if (self.presentingViewController != nil) {
        [self.textView setEditable:YES];
        
        NSNotificationCenter *notifCenter = [NSNotificationCenter defaultCenter];
        [notifCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
        [notifCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardDidHideNotification object:nil];
        [notifCenter addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
        
        if (INTERFACE_IS_PAD) {
            [self.textView setFont:[UIFont boldSystemFontOfSize:20.0]];
        } else {
            [self.textView setFont:[UIFont boldSystemFontOfSize:16.0]];
        }
    } else {
        [self.textView setFont:[UIFont boldSystemFontOfSize:16.0]];
        if (INTERFACE_IS_PAD) {
            [self.textView setEditable:NO];
        } else {
            [self.textView setEditable:YES];
        }
    }

}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.school setNotes:self.textView.text];
    
    NSError *err = nil;
    if ([self.managedObjectContext hasChanges] && ![self.managedObjectContext save:&err]) {
        NSLog(@"%@", [err description]);
    }
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    if (![self.textView isFirstResponder])
        [self.textView setFrame:CGRectInset(self.view.bounds,4,4)];
    else {
        [self.textView setFrame:CGRectInset(CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - keyboardSize.height),4,4)];
        NSLog(@"%@", NSStringFromCGRect(self.textView.frame));
    }
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
    CGSize kbSize = [[info objectForKey:UIKeyboardBoundsUserInfoKey] CGRectValue].size;
    keyboardSize = kbSize;
}

- (void) keyboardWillHide:(NSNotification *)aNotification {
    keyboardSize = CGSizeZero;
}

- (void) keyboardWillChangeFrame:(NSNotification *)aNotification {
    NSDictionary* info = [aNotification userInfo];

    CGSize kbSize = [[info objectForKey:UIKeyboardBoundsUserInfoKey] CGRectValue].size;

    keyboardSize = kbSize;
    
    [self viewWillLayoutSubviews];
}

#pragma mark - Custom Setters

- (void) setSchool:(College *)school {
    _school = school;
    
    self.textView.text = school.notes;
}
@end
