//
//  SettingsTableViewCell.h
//  Beacon Scan
//
//  Created by David Helms on 6/27/15.
//  Copyright (c) 2015 Dojbol LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsTableViewCellDelegate;

@interface SettingsTableViewCell : UITableViewCell

@property (nonatomic, weak) id<SettingsTableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UISwitch *switchEnabled;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelUUID;

- (IBAction)switch:(id)sender;


@end

@protocol SettingsTableViewCellDelegate <NSObject>

@optional
-(void)switchDidChangeTo:(BOOL)value sender:(id)sender;

@end // end of delegate protocol
