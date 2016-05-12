//
//  AdListItem.m
//  ObjCSample
//
//  Created by Julien Gomez on 11/09/2015.
//  Copyright © 2015 Smart AdServer. All rights reserved.
//

#import "ListItem.h"

@implementation ListItem

- (NSString *)title {
    if (_isAd) {
        return [_nativeAd title];
    } else {
        return [_rssElement title];
    }
}


- (NSString *)subtitle {
    if (_isAd) {
        return [_nativeAd subtitle];
    } else {
        return [_rssElement postDescription];
    }
}


- (NSURL *)link {
    if (_isAd) {
        return nil;
    } else {
        return [_rssElement link];
    }
}


- (NSURL *)imageURL {
    if (_isAd) {
        return [[_nativeAd icon] URL];
    } else {
        return [_rssElement imageURL];
    }
}

- (NSString *)publishedDate {
    if (_isAd) {
        return nil;
    } else {
        return [_rssElement publishedDate];
    }
}

@end
