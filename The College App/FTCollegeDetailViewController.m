//
//  FTCollegeDetailViewController.m
//  The College App
//
//  Created by Jeffrey Barg on 7/10/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import "FTCollegeDetailViewController.h"

@interface FTCollegeDetailViewController ()

@end

@implementation FTCollegeDetailViewController

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
    
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButton:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"modaltab.png"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"whitenavbar.png"] forBarMetrics:UIBarMetricsDefault];
}

- (void) doneButton:(UIBarButtonItem *)barButtonItem {
    [self dismissModalViewControllerAnimated:YES];
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
