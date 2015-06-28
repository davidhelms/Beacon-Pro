//
//  SettingsTableViewCell.m
//  Beacon Scan
//
//  Created by David Helms on 6/27/15.
//  Copyright (c) 2015 Dojbol LLC. All rights reserved.
//

#import "SettingsTableViewCell.h"

@implementation SettingsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)switch:(id)sender {

    UISwitch *aSwitch = (UISwitch *)sender;
    [self.delegate switchDidChangeTo:aSwitch.on sender:self];
}
@end
