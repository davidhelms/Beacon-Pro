//
//  Settings.m
//  Beacon Scan
//
//  Created by David Helms on 6/26/15.
//  Copyright (c) 2015 Dojbol LLC. All rights reserved.
//

#import "Settings.h"
@import CoreLocation;

@implementation Settings

- (id)init
{
    // initialize defaults
    NSString *dateKey    = @"dateKey";
    NSDate *lastRead     = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:dateKey];
    if (lastRead == nil)     // App first run: set up user defaults.
    {
        NSDictionary *appDefaults  = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate date], dateKey, nil];
        
        // wendys region
        NSUUID *wendysUUID = [[NSUUID alloc]initWithUUIDString:@"BE58B1B2-0ED3-46BC-484C-FD79CBBC8FBC"];
        CLBeaconRegion *wendysRegion = [[CLBeaconRegion alloc]initWithProximityUUID: wendysUUID identifier:@"WENDYS"];
        
        // radius region
        NSUUID *radiusUUID = [[NSUUID alloc]initWithUUIDString:@"2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6"];
        CLBeaconRegion *radiusRegion = [[CLBeaconRegion alloc]initWithProximityUUID: radiusUUID identifier:@"RADIUS"];
        
        NSData *regionData = [NSKeyedArchiver archivedDataWithRootObject:@[wendysRegion, radiusRegion]];
        
        [[NSUserDefaults standardUserDefaults] setObject:regionData forKey:@"regionDataKey"];
        
        // sync the defaults to disk
        [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // timestamp init
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:dateKey];
    }
    
    [self load];
    return self;
}


- (void)load
{
    // get regions from nsuserdefaults
    NSData *regionData = [[NSUserDefaults standardUserDefaults] objectForKey:@"regionDataKey"];
    self.beaconRegions = [NSKeyedUnarchiver unarchiveObjectWithData:regionData];
}


-(void)store
{
    // archive region data
    NSData *regionData = [NSKeyedArchiver archivedDataWithRootObject:self.beaconRegions];
    [[NSUserDefaults standardUserDefaults] setObject:regionData forKey:@"regionDataKey"];
    
    // sync the defaults to disk
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
