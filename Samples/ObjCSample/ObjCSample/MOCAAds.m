//
//  MOCAAds.m
//
//  MOCA iOS SDK
//  Version 1.9
//
//  This module is part of MOCA Platform.
//
//  Copyright (c) 2016 InnoQuant Strategic Analytics, S.L.
//  All rights reserved.
//
//  All rights to this software by InnoQuant are owned by InnoQuant
//  and only limited rights are provided by the licensing or contract
//  under which this software is provided.
//
//  Any use of the software for any commercial purpose without
//  the written permission of InnoQuant is prohibited.
//  You may not alter, modify, or in any way change the appearance
//  and copyright notices on the software. You may not reverse compile
//  the software or publish any protected intellectual property embedded
//  in the software. You may not distribute, sell or make copies of
//  the software available to any entities without the explicit written
//  permission of InnoQuant.
//

#import "MOCAAds.h"
#import "SASAdView.h"

#define UPDATE_TARGET_EVERY_SECONDS 60.0
#define MAX_LOCATION_AGE_SECONDS -300.0

@interface MOCAAds()
{
    CLLocation  * _lastLocation;
}
@end

@implementation MOCAAds

static MOCAAds * _shared = nil;


+(id)shared
{
    if (!_shared)
    {
        @synchronized(self)
        {
            if (!_shared)
            {
                _shared = [[MOCAAds alloc] init];
                // register location delegate with MOCA
            }
        }
    }
    return _shared;
}

+(void)updateLocation
{
    CLLocation* loc = [MOCA lastKnownLocation];
    
    if(loc && loc.timestamp){
        NSTimeInterval interval = [loc.timestamp timeIntervalSinceNow];
        if(interval < MAX_LOCATION_AGE_SECONDS){
            //too ,old
            return;
        }
        [SASAdView setLocation:loc];
    }
}

+(NSString*)getTarget
{
    if (![MOCA initialized]) return nil;
    NSArray* stringSegments = [[MOCA currentInstance] allSegments];
    if (!stringSegments) return nil;
    NSMutableString * target = [[NSMutableString alloc] init];
    NSString * sep = @"";
    for(NSString * seg in stringSegments){
        //segmentA=1;segmentB=1
        [target appendString:[NSString stringWithFormat: @"%@%@=1",sep, seg]];
        sep = @";";
    }
    [self updateLocation];
    NSLog(@"✅ MOCA Target: %@", target);
    return target;
}


@end