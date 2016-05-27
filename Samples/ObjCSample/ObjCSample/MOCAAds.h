//
//  MOCAAds.h
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

#import <Foundation/Foundation.h>
#import "MOCA.h"

@interface MOCAAds : NSObject

/*
 * Returns a collection of segments the current user belongs to.
 * Format: segmento_moca_1=1;segmento_moca_2=1
 */
+(NSString*)getTarget;

@end