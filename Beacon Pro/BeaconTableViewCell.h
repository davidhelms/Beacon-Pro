//
//  BeaconTableViewCell.h
//  Beacon Pro
//
//  Created by David Helms on 6/21/15.
//  Copyright (c) 2015 Dojbol LLC. All rights reserved.
//

@import UIKit;
@import CoreLocation;

@interface BeaconTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelMajor;

@property (weak, nonatomic) IBOutlet UILabel *labelMinor;

@property (weak, nonatomic) IBOutlet UILabel *labelRSSI;





@end
