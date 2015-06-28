//
//  BeaconTableViewSectionHeader.h
//  Beacon Scan
//
//  Created by David Helms on 6/24/15.
//  Copyright (c) 2015 Dojbol LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeaconTableViewSectionHeader : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelUUID;


@end
