//
//  EditSettingsViewController
//  Beacon Pro
//
//  Created by David Helms on 6/23/15.
//  Copyright (c) 2015 Dojbol LLC. All rights reserved.
//

@import UIKit;
#import "Settings.h"


@interface EditSettingsViewController : UITableViewController
@property (strong, nonatomic) Settings *settings;
@property (strong, nonatomic) RegionSetting *regionSetting;
@property (weak, nonatomic) IBOutlet UITextField *textFieldName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldUUID;
@property (weak, nonatomic) IBOutlet UISwitch *switchEnabled;


- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)update:(id)sender;
- (IBAction)switch:(id)sender;



@end
