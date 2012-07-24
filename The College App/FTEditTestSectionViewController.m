//
//  FTEditTestSectionViewController.m
//  The College App
//
//  Created by Jeffrey Barg on 7/23/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import "FTEditTestSectionViewController.h"
#import "FTStandardizedTestView.h"

#import "TestSection.h"

@interface FTEditTestSectionViewController ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) NSArray *buttonArray;

@end

@implementation FTEditTestSectionViewController

@synthesize button, testView, testSection, managedObjectContext, pController;

@synthesize imgView = _imgView;
@synthesize textLabel = _textLabel;
@synthesize buttonArray;

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
    
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveEntry:)];
    [saveItem setBackgroundImage:[[UIImage imageNamed:@"save.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [self.navigationItem setRightBarButtonItem:saveItem];
    
	// Do any additional setup after loading the view.
    _imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_imgView setImage:[[UIImage imageNamed:@"testsectioninput.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)]];
    
    [self.view addSubview:_imgView];
    
    _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _textLabel.textColor = [UIColor whiteColor];
    _textLabel.font = [UIFont boldSystemFontOfSize:70.0];
    _textLabel.textAlignment = UITextAlignmentRight;
    _textLabel.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_textLabel];
    
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 310.0);
    
    NSMutableArray *mButtonArray = [[NSMutableArray alloc] initWithCapacity:12];
    
    for (int i = 0; i < 12; i ++) {
        UIButton *numberButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [numberButton setBackgroundImage:[UIImage imageNamed:@"numbutton.png"] forState:UIControlStateNormal];
        [numberButton setBackgroundImage:[UIImage imageNamed:@"numbuttonactive.png"] forState:UIControlStateHighlighted];
        if (i != 9) {
            [numberButton setTitle:[NSString stringWithFormat:@"%i",(i+1)%11] forState:UIControlStateNormal];
            [numberButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
            [numberButton addTarget:self action:@selector(numberButton:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 11) {
                [numberButton setTitle:@"◀" forState:UIControlStateNormal];
                [numberButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20.0]];

            }
        } else {
            [numberButton setEnabled:NO];
        }
        [self.view addSubview:numberButton];
        [mButtonArray addObject:numberButton];
    }
    self.buttonArray = [NSArray arrayWithArray:mButtonArray];
    
    self.title = self.testSection.sectionName;
}

- (void) numberButton:(UIButton *)numberButton {
    NSInteger index = [self.buttonArray indexOfObject:numberButton];
    NSInteger inputValue = (index+1)%11;
    
    NSInteger length = [self.textLabel.text length];

    //Deal With Backspace 
    if (index == 11) {
        if (length == 0) return;
        NSString *newStr = [NSString stringWithFormat:@"%@", [self.textLabel.text substringToIndex:length-1]];
        self.textLabel.text = newStr;
        return;
    }
    
    NSString *newStr = [NSString stringWithFormat:@"%@%i", length==0?@"":self.textLabel.text, inputValue];
    NSInteger intValue = [newStr integerValue];
    if (intValue > [self.testSection.maxScore integerValue])
        return;
    
    self.textLabel.text = newStr;
}

- (void) saveEntry:(UIBarButtonItem *)barButtonItem {
    NSInteger score = [self.textLabel.text integerValue];
    if (score > [self.testSection.maxScore integerValue] || score < [self.testSection.minScore integerValue]) {
        
    } else {
        [self.testSection setScore:[NSNumber numberWithInteger:score]];
        [self.testView setNeedsDisplay];
    }
    
    [self.pController dismissPopoverAnimated:YES];
}

- (void) viewWillLayoutSubviews {
    [self.imgView setFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 90.0)];
    [self.textLabel setFrame:CGRectMake(15.0, 0.0, self.view.frame.size.width-30.0, 90.0)];
    for (int i = 0; i < 12; i ++) {
        UIButton *numbutton = [self.buttonArray objectAtIndex:i];
        [numbutton setFrame:CGRectMake(-1.0 + 106 * (i%3), 90 + 54.0 * (i/3), 108, 55)];
    }
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.button setSelected:NO]; 
    [self.testView setNeedsDisplayInRect:self.button.frame];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
