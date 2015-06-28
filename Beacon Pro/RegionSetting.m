//
//  BeaconRegionSetting.m
//  Beacon Scan
//
//  Created by David Helms on 6/27/15.
//  Copyright (c) 2015 Dojbol LLC. All rights reserved.
//

#import "RegionSetting.h"

@implementation RegionSetting

- (id)initWithCoder:(NSCoder *)coder
{
    if ((self = [super init]))
    {
        // Decode the property values by key,
        // and assign them to the correct ivars
        _region = [coder decodeObjectForKey:@"region"];
        _enabled = [coder decodeBoolForKey:@"enabled"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    // Encode our ivars using string keys
    [coder encodeObject:_region forKey:@"region"];
    [coder encodeBool:_enabled forKey:@"enabled"];
}


@end
