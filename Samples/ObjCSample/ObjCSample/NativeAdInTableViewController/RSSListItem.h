//
//  RssItem.h
//  NativeAdsSample
//
//  Created by Loïc GIRON DIT METAZ on 16/04/2014.
//  Copyright (c) 2014 Smart AdServer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListItem.h"


@interface RSSListItem : NSObject <ListItem>

- (instancetype) initWithTitle:(NSString*)title subtitle:(NSString*)subtitle imageURL:(NSURL*)imageURL linkURL:(NSURL*) linkURL publishedDate:(NSString*)date;
    
- (NSURL *)link;
- (NSString *)publishedDate;

@end
