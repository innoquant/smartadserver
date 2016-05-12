//
//  RssItem.m
//  NativeAdsSample
//
//  Created by Loïc GIRON DIT METAZ on 16/04/2014.
//  Copyright (c) 2014 Smart AdServer. All rights reserved.
//

#import "RSSListItem.h"

// Represents a RSS item in the table view of the NativeAdInTableViewController
@implementation RSSListItem {
    NSString *_title;
    NSString *_subtitle;
    NSURL *_imageURL;
    NSURL *_linkURL;
    NSString *_publishedDate;
}

- (instancetype) initWithTitle:(NSString*)title subtitle:(NSString*)subtitle imageURL:(NSURL*)imageURL linkURL:(NSURL*) linkURL publishedDate:(NSString*)date {
    
    self = [super init];
    
    if(self ) {
        _title = title;
        _subtitle = subtitle;
        _imageURL = imageURL;
        _linkURL = linkURL;
        _publishedDate = date;
    }
    
    return self;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"RSSItem || title:%@ / link:%@ / description:%@",
			self.title, [self.link absoluteString], self.subtitle];
}

- (NSString *)title {
    return _title;
}

- (NSString *)subtitle {
    return _subtitle;
}

- (NSURL *)link {
    return _linkURL;
}

- (NSURL *)imageURL {
    return _imageURL;
}

- (NSString *)publishedDate {
    return _publishedDate;
}

@end
