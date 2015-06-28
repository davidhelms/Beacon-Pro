//
//  Settings.h
//  Beacon Scan
//
//  Created by David Helms on 6/26/15.
//  Copyright (c) 2015 Dojbol LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegionSetting.h"

@interface Settings : NSObject
@property (strong, nonatomic) NSMutableArray *regionSettings;

-(void)load;
-(void)store;
@end
