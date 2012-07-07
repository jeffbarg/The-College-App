//
//  FTMasterViewController.m
//  The College App
//
//  Created by Jeffrey Barg on 7/6/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import "FTMasterViewController.h"
#import "FTExtracurriclarsViewController.h"
#import "FTCollegeListViewController.h"
#import "FTGradesViewController.h"

@interface FTMasterViewController ()

@end

@implementation FTMasterViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize detailViewController = _detailViewController;

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
    
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0]];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"blacknavbar.png"] forBarMetrics:UIBarMetricsDefault];    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], UITextAttributeTextColor,
                                                                     [UIColor colorWithWhite:0.1 alpha:1.0], UITextAttributeTextShadowColor,
                                                                     [NSValue valueWithUIOffset:UIOffsetMake(0, -1)], UITextAttributeTextShadowOffset
                                                                      , nil]];
    
    [[UIBarButtonItem appearance] setBackgroundImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackgroundImage:[UIImage imageNamed:@"cancelactive.png"] forState:UIControlStateHighlighted    barMetrics:UIBarMetricsDefault];

    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[[UIImage imageNamed:@"backbutton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 14.0, 0.0, 5.0)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    self.clearsSelectionOnViewWillAppear = YES;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setSeparatorColor:[UIColor blackColor]];    

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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return section == 0?5:2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        CGRect bounds = cell.backgroundView.bounds;
        CGRect imgViewRect = CGRectZero;
        imgViewRect.origin = CGPointZero;
        imgViewRect.size = bounds.size;
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:imgViewRect];
        [imgView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        cell.backgroundView = imgView;
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
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    [cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
    
    
    // Configure the cell...
    if (indexPath.row == 0) {
        UIImageView *imgView = (UIImageView *) cell.backgroundView;
        [imgView setImage:[[UIImage imageNamed:@"navtopcell.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)]];
    } else if (indexPath.row == ([tableView numberOfRowsInSection:indexPath.section] - 1)) {
        UIImageView *imgView = (UIImageView *) cell.backgroundView;
        [imgView setImage:[[UIImage imageNamed:@"navbottom.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)]];
    } else {
        UIImageView *imgView = (UIImageView *) cell.backgroundView;
        [imgView setImage:[[UIImage imageNamed:@"navcell.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)]];
    }
    
    [cell.textLabel setTextColor:[UIColor colorWithWhite:0.820 alpha:1.000]];
    [cell.textLabel setShadowColor:[UIColor blackColor]];
    [cell.textLabel setShadowOffset:CGSizeMake(0, -1)];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return section == 0? @"My College Profile":@"Colleges";
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController<UISplitViewControllerDelegate> *newViewController = nil;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
        } else if (indexPath.row == 1) {

        } else if (indexPath.row == 2) {
            FTExtracurricularsViewController *extracurricularViewController = [[FTExtracurricularsViewController alloc] init];
            [extracurricularViewController setManagedObjectContext:self.managedObjectContext];
            
            newViewController = (UIViewController<UISplitViewControllerDelegate> *) extracurricularViewController;
            
        } else if (indexPath.row == 3) {
            FTGradesViewController *gradesViewController = [[FTGradesViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [gradesViewController setManagedObjectContext:self.managedObjectContext];
            
            newViewController = (UIViewController<UISplitViewControllerDelegate> *) gradesViewController;
        } else {
            
        }
    } else {
        if (indexPath.row == 0) {
            
        } else {
            
        }
    }
    
    if ([newViewController class] == [self.detailViewController class])
        newViewController = self.detailViewController;
    
    if (newViewController == nil) return;
    
    if (INTERFACE_IS_PAD) {        
        UINavigationController *viewNavigationController = [[UINavigationController alloc] initWithRootViewController:newViewController];
        [viewNavigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"whitenavbar.png"] forBarMetrics:UIBarMetricsDefault];

        [self.splitViewController setViewControllers:[NSArray arrayWithObjects:self.navigationController,viewNavigationController, nil]];
        [self.splitViewController setDelegate:newViewController];
    } else {
        [self.navigationController pushViewController:newViewController animated:YES];
    }
    
    newViewController.view.backgroundColor = [UIColor colorWithHue:0.574 saturation:0.037 brightness:0.957 alpha:1.000];
    
    self.detailViewController = newViewController;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 34.0f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger) section {
    return 0.0f;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
	// create the parent view that will hold header Label
	UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 34.0)];
	
	// create the button object
	UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.opaque = NO;
	headerLabel.textColor = [UIColor colorWithRed:161.0/255.0 green:161.0/255.0 blue:161.0/255.0 alpha:1.0];
    headerLabel.shadowColor = [UIColor colorWithHue:0.0 saturation:0.0 brightness:0.08 alpha:1.0];
    
	headerLabel.highlightedTextColor = [UIColor whiteColor];
	headerLabel.font = [UIFont boldSystemFontOfSize:16];
    headerLabel.shadowOffset = CGSizeMake(0, 1);
    headerLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:1.0];
	headerLabel.frame = CGRectMake(20.0, 0.0, 280.0, 34.0);
    
	// If you want to align the header text as centered
	// headerLabel.frame = CGRectMake(150.0, 0.0, 300.0, 44.0);
    
	headerLabel.text = [self tableView:tableView titleForHeaderInSection:section]; // i.e. array element
	[customView addSubview:headerLabel];
    
	return customView;
}

@end
