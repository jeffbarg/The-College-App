//
//  FTMasterViewController.m
//  The College App
//
//  Created by Jeffrey Barg on 7/6/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import "FTMasterViewController.h"

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
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.5f green:0.0f blue:0.0f alpha:1.0f]];

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
        CGRect bounds = cell.backgroundView.bounds;
        CGRect imgViewRect = CGRectZero;
        imgViewRect.origin = CGPointZero;
        imgViewRect.size = bounds.size;
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:imgViewRect];
        [imgView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [imgView setImage:[[UIImage imageNamed:@"navtopcell.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)]];
        cell.backgroundView = imgView;
        
        NSLog(@"%f", cell.backgroundView.frame.size.height);
        
    } else if (indexPath.row == ([tableView numberOfRowsInSection:indexPath.section] - 1)) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:cell.bounds];
        [imgView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [imgView setImage:[[UIImage imageNamed:@"navbottom.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)]];
        cell.backgroundView = imgView;
    } else {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:cell.bounds];
        [imgView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [imgView setImage:[[UIImage imageNamed:@"navcell.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)]];
        cell.backgroundView = imgView;
    }
    
    [cell.textLabel setTextColor:[UIColor colorWithWhite:0.820 alpha:1.000]];
    [cell.textLabel setShadowColor:[UIColor blackColor]];
    [cell.textLabel setShadowOffset:CGSizeMake(0, -1)];
    
    return cell;
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
