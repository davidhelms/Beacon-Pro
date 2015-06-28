//
//  BeaconRegionSetting.h
//  Beacon Scan
//
//  Created by David Helms on 6/27/15.
//  Copyright (c) 2015 Dojbol LLC. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface RegionSetting : NSObject <NSCoding>
@property (strong,nonatomic) CLBeaconRegion *region;
@property BOOL enabled;

@end
