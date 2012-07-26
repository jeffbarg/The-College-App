//
//  FTMasterViewController.m
//  The College App
//
//  Created by Jeffrey Barg on 7/6/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import "FTMasterViewController.h"
#import "FTExtracurriclarsViewController.h"
#import "FTCollegeSearchViewController.h"
#import "FTGradesViewController.h"
#import "FTStandardizedTestingViewController.h"
#import "FTCollegeVisitViewController.h"
#import "FTCollegeVisitNotesViewController.h"
#import "FTCollegeVisitRatingsViewController.h"
#import "FTCollegeVisitPhotosViewController.h"
#import "ECSlidingViewController.h"
#import "FTNavigationCell.h"
#import "FTNavigationHeader.h"

@interface FTMasterViewController ()

@property (nonatomic, strong) UIBarButtonItem *backItem;

@end

@implementation FTMasterViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize detailViewController = _detailViewController;
@synthesize backItem = _backItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"College", @"College");
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            self.clearsSelectionOnViewWillAppear = NO;
            self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
        }
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = NSLocalizedString(@"College", @"College");
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            self.clearsSelectionOnViewWillAppear = NO;
            self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.scrollsToTop = YES;
    
    UIView *titleView = [[UIView alloc] initWithFrame:self.navigationController.navigationBar.bounds];
    [titleView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 0, INTERFACE_IS_PAD? 270.0:250.0, 44.0)];
    [titleLabel setTextAlignment:UITextAlignmentCenter];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setShadowColor:[UIColor blackColor]];
    [titleLabel setShadowOffset:CGSizeMake(0, -1)];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:[UIFont labelFontSize]]];
     
    [titleLabel setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight];
    
    [titleView addSubview:titleLabel];
    [titleLabel setText:@"The College App"];
    
    [self.navigationItem setTitleView:titleView];
    
    
    [self.tableView setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0]];
    

    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], UITextAttributeTextColor,
                                                                     [UIColor colorWithWhite:0.1 alpha:1.0], UITextAttributeTextShadowColor,
                                                                     [NSValue valueWithUIOffset:UIOffsetMake(0, -1)], UITextAttributeTextShadowOffset
                                                                      , nil]];
    

    
//    self.clearsSelectionOnViewWillAppear = YES;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setSeparatorColor:[UIColor blackColor]];    
    
    [self.tableView setRowHeight:INTERFACE_IS_PAD?64.0:50.0];
    
    self.tableView.scrollsToTop = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (INTERFACE_IS_PAD || !(interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown));
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) return 5;
    else if (section == 1) return 2;
    else return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    FTNavigationCell *cell = (FTNavigationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[FTNavigationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //Configure Cell
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            [cell.textLabel setText:@"Awards and Accomplishments"];
            [cell.imageView setImage:[UIImage imageNamed:@"achievements.png"]];
        }
        if (indexPath.row == 1) {
            [cell.textLabel setText:@"Standardized Testing"];
            [cell.imageView setImage:[UIImage imageNamed:@"standardized.png"]];
        }
        if (indexPath.row == 2) {
            [cell.textLabel setText:@"Extracurriculars"];
            [cell.imageView setImage:[UIImage imageNamed:@"extracurriculars.png"]];
        }
        if (indexPath.row == 3) {
            [cell.textLabel setText:@"Grades"];
            [cell.imageView setImage:[UIImage imageNamed:@"grades.png"]];
        }
        if (indexPath.row == 4) {
            [cell.textLabel setText:@"Essay"];
            [cell.imageView setImage:[UIImage imageNamed:@"essays.png"]];
        }
        
    }
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            [cell.textLabel setText:@"College Search"];
            [cell.imageView setImage:[UIImage imageNamed:@"collegesearch.png"]];
        }
        if (indexPath.row == 1) {
            [cell.textLabel setText:@"My College List"];
            [cell.imageView setImage:[UIImage imageNamed:@"collegelist.png"]];
        }
        
    }
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [cell.textLabel setText:@"Colleges Near Me"];
            [cell.imageView setImage:[UIImage imageNamed:@"nearme.png"]];
        }
    }
    
    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero]; 
    
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    [cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
    
    [cell.textLabel setTextColor:[UIColor colorWithWhite:0.820 alpha:1.000]];
    [cell.textLabel setShadowColor:[UIColor blackColor]];
    [cell.textLabel setShadowOffset:CGSizeMake(0, -1)];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) return @"My Profile";
    else if (section == 1) return @"Colleges";
    else return @"College Visits";
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *newViewController = nil;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
        } else if (indexPath.row == 1) {
            FTStandardizedTestingViewController *standardizedTestingController = [[FTStandardizedTestingViewController alloc] init];
            [standardizedTestingController setManagedObjectContext:self.managedObjectContext];
            
            newViewController = (UIViewController *) standardizedTestingController;
        } else if (indexPath.row == 2) {
            FTExtracurricularsViewController *extracurricularViewController = [[FTExtracurricularsViewController alloc] init];
            [extracurricularViewController setManagedObjectContext:self.managedObjectContext];
            
            newViewController = (UIViewController *) extracurricularViewController;
            
        } else if (indexPath.row == 3) {
            FTGradesViewController *gradesViewController = [[FTGradesViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [gradesViewController setManagedObjectContext:self.managedObjectContext];
            [gradesViewController.tableView setBackgroundColor:kViewBackgroundColor];
            
            newViewController = (UIViewController *) gradesViewController;
        } else {
            
        }
    } else if (indexPath.section == 1) {
        FTCollegeSearchViewController *collegeListViewController = [[FTCollegeSearchViewController alloc] init];
        [collegeListViewController setManagedObjectContext:self.managedObjectContext];

        if (indexPath.row == 0) {
            
        } else {
            
        } 
        
        newViewController = (UIViewController *) collegeListViewController;
    } else {
        if (indexPath.row == 0) {
            if (INTERFACE_IS_PAD || INTERFACE_IS_PHONE) {                
                FTCollegeVisitViewController *collegeVisitViewController = [[FTCollegeVisitViewController alloc] init];
                [collegeVisitViewController setManagedObjectContext:self.managedObjectContext];
                
                newViewController = (UIViewController *)collegeVisitViewController;
            }
        }
    }
    
    if ([newViewController class] == [self.detailViewController class])
        newViewController = self.detailViewController;
    
    if (newViewController == nil) return;
    
     
    UINavigationController *viewNavigationController = ((UINavigationController *)self.slidingViewController.topViewController);
    
    if (INTERFACE_IS_PAD)    
        [viewNavigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"whitenavbar.png"] forBarMetrics:UIBarMetricsDefault];

    [UIView animateWithDuration:0.1 animations:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        frame = CGRectOffset(frame, 10, 0);
        self.slidingViewController.topViewController.view.frame = frame;

    } completion:^(BOOL finished) {
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        [viewNavigationController setViewControllers:[NSArray arrayWithObject:newViewController] animated:NO];
        
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
        
        newViewController.navigationItem.leftBarButtonItem = self.backItem;
        
        newViewController.view.backgroundColor = kViewBackgroundColor;
        viewNavigationController.view.layer.shadowOpacity = 0.75f;
        viewNavigationController.view.layer.shadowRadius = 10.0f;
        viewNavigationController.view.layer.shadowColor = [UIColor blackColor].CGColor;
        [viewNavigationController.view addGestureRecognizer:self.slidingViewController.panGesture];   
    }];
    

    
    self.detailViewController = newViewController;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger) section {
    return 0.0f;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    FTNavigationHeader *header = [[FTNavigationHeader alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30.0)];
    [header setTitle:[self tableView:self.tableView titleForHeaderInSection:section]];
    
	return header;
}

#pragma mark - UIScrollView Delegate Methods

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    NSLog(@"%@", @"ok");
    if ([self.slidingViewController underLeftShowing]) return YES;
    
    else {
        if ([self.detailViewController respondsToSelector:@selector(gmGridView)]) {
            GMGridView *gmGridView = [self.detailViewController performSelector:@selector(gmGridView)];
            
            [gmGridView scrollToObjectAtIndex:0 atScrollPosition:GMGridViewScrollPositionTop animated:YES];
        }
        
        return YES;
    }
}

#pragma mark - ECSlidingViewController Stuff

- (void) slideLeft {
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (UIBarButtonItem *) backItem {
    if (_backItem != nil)
        return _backItem;
    
    _backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"] landscapeImagePhone:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStyleDone target:self action:@selector(slideLeft)];
                 
    return _backItem;
}
@end
