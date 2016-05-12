//
//  RssItem.m
//  NativeAdsSample
//
//  Created by Loïc GIRON DIT METAZ on 16/04/2014.
//  Copyright (c) 2014 Smart AdServer. All rights reserved.
//

#import "RSSElement.h"


@implementation RSSElement

- (NSString *)description {
	return [NSString stringWithFormat:@"RSSItem || title:%@ / link:%@ / description:%@",
			self.title, [self.link absoluteString], self.postDescription];
}

@end
