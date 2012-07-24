//
//  FTAddStandardizedTestViewController.m
//  The College App
//
//  Created by Jeff Barg on 7/20/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import "FTAddStandardizedTestViewController.h"
#import "ELTextFieldTableViewCell.h"

@interface FTAddStandardizedTestViewController () {
    NSInteger _selectedIndex;
}

@end

@implementation FTAddStandardizedTestViewController

@synthesize managedObjectContext;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _selectedIndex = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.separatorColor = kAddViewBorderColor;
    self.tableView.backgroundColor = kAddViewBackgroundColor;
    
    self.tableView.rowHeight = 64.0;
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    if (!INTERFACE_IS_PAD) {
        UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelEntry:)];
        self.navigationItem.leftBarButtonItem = cancelBarButtonItem;
        [cancelBarButtonItem setBackgroundImage:[[UIImage imageNamed:@"cancel.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [cancelBarButtonItem setBackgroundImage:[[UIImage imageNamed:@"cancelactive.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    }
    
    UIBarButtonItem *saveBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveEntry:)];
    self.navigationItem.rightBarButtonItem = saveBarButtonItem;
    [saveBarButtonItem setBackgroundImage:[[UIImage imageNamed:@"save.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [saveBarButtonItem setBackgroundImage:[[UIImage imageNamed:@"saveactive.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    self.navigationItem.title = @"New Entry";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (INTERFACE_IS_PAD || !(interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown));
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ELTextFieldTableViewCell *cell = (ELTextFieldTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ELTextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    
    if (indexPath.row != 3)
        cell.editEnabled = YES;
    else cell.editEnabled = nahhz;
    
    [cell setBackgroundColor:kAddViewBackgroundColor];
    
    if (indexPath.row == 0) {
        [cell.textLabel setText:@"Math"];
    } else if (indexPath.row == 1) {
        [cell.textLabel setText:@"Reading"];
    } else if (indexPath.row == 2) {
        [cell.textLabel setText:@"Writing"];
    } else if (indexPath.row == 3) {
        [cell.textLabel setText:@"Combined Score"];
        [cell.textField setTextColor:[UIColor colorWithRed:0.000 green:0.553 blue:0.180 alpha:1.000]];
    }
    
    cell.textField.textAlignment = UITextAlignmentRight;
    if (indexPath.row != 0 && INTERFACE_IS_PAD)
    cell.textField.inputView = [self numberPad];
    return cell;
}

- (UIView *) numberPad {
    UIView *numberPad = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 353)];
    
    [numberPad setBackgroundColor:[UIColor grayColor]];
    
    CGFloat frameWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat frameHeight = 353;
    
    CGFloat padWidth = 450;
    CGFloat padHeight = frameHeight - 20.0;
    
    CGFloat startX = (frameWidth - padWidth) / 2.0;
    CGFloat startY = (frameHeight - padHeight) / 2.0;

    CGFloat buttonWidth = 113;
    CGFloat buttonHeight = 80.0;
    
    CGFloat buttonMarginX = (padWidth - 3 * buttonWidth) / 2.0; // 3 buttons per row = 2 spacings
    CGFloat buttonMarginY = (padHeight - 4 * buttonHeight) / 3.0; // 4 rows = 3 spacings
    
    for (int i = 0; i < 12; i ++) {
        if (i == 9 || i == 11) continue;
        
        UIButton *key = [[UIButton alloc] initWithFrame:CGRectMake(startX + (i%3) * (buttonWidth + buttonMarginX),
                                                                   startY + (buttonMarginY + buttonHeight) * (i/3),
                                                                   buttonWidth,
                                                                   buttonHeight)];
        
        NSLog(@"%@", NSStringFromCGRect(key.frame));
        [key setBackgroundImage:[UIImage imageNamed:@"keylandscape"] forState:UIControlStateNormal];
        
        [numberPad addSubview:key];
    }
    numberPad.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    return numberPad;
}






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

#pragma mark - Buttons

- (void) cancelEntry:(UIBarButtonItem *) barButtonItem {
    [self dismissModalViewControllerAnimated:YES];
}

- (void) saveEntry:(UIBarButtonItem *) barButtonItem { 
        
    //Make and configure Object
    
    NSError *err = nil;
    [self.managedObjectContext save:&err];
    if (err != nil) {
        NSLog(@"%@", [err localizedDescription]);
    }
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{}];
}

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
