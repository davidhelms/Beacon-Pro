//
//  Settings.m
//  Beacon Scan
//
//  Created by David Helms on 6/26/15.
//  Copyright (c) 2015 Dojbol LLC. All rights reserved.
//

#import "Settings.h"

#define MODEL_VERSION @"0.0.4"

@implementation Settings

- (id)init
{
    // initialize defaults
    NSString *versionKey    = @"versionKey";
    NSString *lastVersion     = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:versionKey];
    if (![lastVersion isEqualToString:MODEL_VERSION])
    {
        NSDictionary *appDefaults  = [NSDictionary dictionaryWithObjectsAndKeys:MODEL_VERSION, versionKey, nil];
        
        // wendys region setting
        RegionSetting *wendysRegionSetting = [[RegionSetting alloc]init];
        NSUUID *wendysUUID = [[NSUUID alloc]initWithUUIDString:@"BE58B1B2-0ED3-46BC-484C-FD79CBBC8FBC"];
        CLBeaconRegion *wendysRegion = [[CLBeaconRegion alloc]initWithProximityUUID: wendysUUID identifier:@"WENDYS"];
        wendysRegionSetting.region = wendysRegion;
        wendysRegionSetting.enabled = YES;
        
        // radius region
        RegionSetting *radiusRegionSetting = [[RegionSetting alloc]init];
        NSUUID *radiusUUID = [[NSUUID alloc]initWithUUIDString:@"2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6"];
        CLBeaconRegion *radiusRegion = [[CLBeaconRegion alloc]initWithProximityUUID: radiusUUID identifier:@"RADIUS"];
        radiusRegionSetting.region = radiusRegion;
        radiusRegionSetting.enabled = YES;
        
        NSData *regionSettingData = [NSKeyedArchiver archivedDataWithRootObject:@[wendysRegionSetting, radiusRegionSetting]];
        
        [[NSUserDefaults standardUserDefaults] setObject:regionSettingData forKey:@"regionSettingDataKey"];
        
        // sync the defaults to disk
        [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // version init
        [[NSUserDefaults standardUserDefaults] setObject:MODEL_VERSION forKey:versionKey];
        NSLog(@"settings initializes at version %@", MODEL_VERSION);
    }
    
    [self load];
    return self;
}


- (void)load
{
    // get regions from nsuserdefaults
    NSData *regionSettingData = [[NSUserDefaults standardUserDefaults] objectForKey:@"regionSettingDataKey"];
    NSArray *theRegionSettings = [NSKeyedUnarchiver unarchiveObjectWithData:regionSettingData];
    self.regionSettings = [NSMutableArray arrayWithArray:theRegionSettings];
}


-(void)store
{
    // archive region data
    NSData *regionSettingData = [NSKeyedArchiver archivedDataWithRootObject:self.regionSettings];
    [[NSUserDefaults standardUserDefaults] setObject:regionSettingData forKey:@"regionSettingDataKey"];
    
    // sync the defaults to disk
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
