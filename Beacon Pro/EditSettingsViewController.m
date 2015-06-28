//
//  EditSettingsViewController.m
//  Beacon Pro
//
//  Created by David Helms on 6/23/15.
//  Copyright (c) 2015 Dojbol LLC. All rights reserved.
//

#import "EditSettingsViewController.h"



@interface EditSettingsViewController ()

@end

@implementation EditSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Update the view.
    [self configureView];
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewWillDisppear:(BOOL)animated
{
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Managing the detail item

- (void)setRegion:(CLBeaconRegion *)newRegion {
    if (_region != newRegion) {
        _region= newRegion;
    }
}
*/

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.regionSetting) {
        self.textFieldName.text = self.regionSetting.region.identifier;
        self.textFieldUUID.text = self.regionSetting.region.proximityUUID.UUIDString;
        self.switchEnabled.on = self.regionSetting.enabled;
    }
}

#pragma mark - Table view data source

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}
 */

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)save:(id)sender {
    
    if (self.textFieldName.text.length > 0)
    {
        NSString *pattern = @"^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$";
        if ([self validateString:_textFieldUUID.text withPattern:pattern])
        {
            // new region
            NSUUID *newUUID = [[NSUUID alloc]initWithUUIDString:self.textFieldUUID.text];
            CLBeaconRegion *newRegion = [[CLBeaconRegion alloc]initWithProximityUUID: newUUID identifier:self.textFieldName.text];
            
            RegionSetting *newRegionSetting = [[RegionSetting alloc]init];
            newRegionSetting.region = newRegion;
            newRegionSetting.enabled = self.switchEnabled.on;
            
            self.settings = [[Settings alloc]init];
            [self.settings.regionSettings addObject:newRegionSetting];
            [self.settings store];
            
        }
        else
        {
            NSLog(@"invalid UUID string");
        }
    }
    else
    {
        NSLog(@"invalid Name string");
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)update:(id)sender {
    
    if (self.textFieldName.text.length > 0)
    {
        NSString *pattern = @"^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$";
        if ([self validateString:_textFieldUUID.text withPattern:pattern])
        {
            // replace current region with new region
            NSUUID *newUUID = [[NSUUID alloc]initWithUUIDString:self.textFieldUUID.text];
            CLBeaconRegion *newRegion = [[CLBeaconRegion alloc]initWithProximityUUID: newUUID identifier:self.textFieldName.text];
            
            self.regionSetting.region = newRegion;
            self.regionSetting.enabled = self.switchEnabled.on;
            [self.settings store];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            NSLog(@"invalid UUID string");
        }
    }
    else
    {
        NSLog(@"invalid Name string");
    }
    
}

- (IBAction)switch:(id)sender {
}

- (BOOL)validateString:(NSString *)string withPattern:(NSString *)pattern {
    
    BOOL didValidate = FALSE;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSRange textRange = NSMakeRange(0, string.length);
    NSRange matchRange = [regex rangeOfFirstMatchInString:string options:NSMatchingReportProgress range:textRange];
    
    if (matchRange.location != NSNotFound) didValidate = TRUE;
    return didValidate;
}



@end
