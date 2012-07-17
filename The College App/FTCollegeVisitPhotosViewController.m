//
//  FTCollegeVisitPhotosViewController.m
//  The College App
//
//  Created by Jeffrey Barg on 7/13/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import "FTCollegeVisitPhotosViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface FTCollegeVisitPhotosViewController ()

@end

@implementation FTCollegeVisitPhotosViewController

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
    
    [self.view setBackgroundColor:[UIColor blueColor]];

    if (INTERFACE_IS_PAD) {
        [self.view.layer setCornerRadius:5.0];
        [self.view.layer setBorderColor:[UIColor colorWithWhite:0.686 alpha:1.000].CGColor];
        [self.view.layer setBorderWidth:1.0];
        

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

@end
