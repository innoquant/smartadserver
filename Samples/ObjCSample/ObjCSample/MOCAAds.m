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

+(CLLocation*)getLocation
{
    MOCAAds * ads = [MOCAAds shared];
    return ads ? ads->_lastLocation : nil;
}

+(NSString*)getTarget
{
    if (![MOCA initialized]) return nil;
    
    // update every 60 seconds
    MOCAInstance * instance = [MOCA currentInstance];
    NSArray * segmentNames = nil; // instance ? [instance matchingSegments] : nil;
    if (segmentNames)
    {
        // encode as list
        // { segment1=1;segment2=1, ...., segmentN=1 } list.
        // TODO
        return @"";
    }
    return nil;
}

-(void)didUpdateLocation:(CLLocation*)location
{
    [SASAdView setLocation:location];
}

@end