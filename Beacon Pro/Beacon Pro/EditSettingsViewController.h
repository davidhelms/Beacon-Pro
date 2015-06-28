//
//  EditSettingsViewController
//  Beacon Pro
//
//  Created by David Helms on 6/23/15.
//  Copyright (c) 2015 Dojbol LLC. All rights reserved.
//

@import UIKit;
@import CoreLocation;


@interface EditSettingsViewController : UITableViewController
@property (strong, nonatomic) NSMutableArray *regions;
@property (strong, nonatomic) CLBeaconRegion *region;
@property (weak, nonatomic) IBOutlet UITextField *textFieldName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldUUID;
- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)update:(id)sender;


@end
