//
//  RssItem.h
//  NativeAdsSample
//
//  Created by Loïc GIRON DIT METAZ on 16/04/2014.
//  Copyright (c) 2014 Smart AdServer. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RSSElement : NSObject

@property (strong) NSString *title;
@property (strong) NSString *postDescription;
@property (strong) NSURL *link;
@property (strong) NSURL *imageURL;
@property (strong) NSString *publishedDate;

@end
