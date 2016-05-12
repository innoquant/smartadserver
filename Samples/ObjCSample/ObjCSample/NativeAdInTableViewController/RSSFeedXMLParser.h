//
//  XMLParser.h
//  ObjCSample
//
//  Created by Julien Gomez on 07/09/2015.
//  Copyright © 2015 Smart AdServer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RSSFeedXMLParser;
@protocol RSSFeedXMLParserDelegate

    - (void) xmlParser:(RSSFeedXMLParser *)parser didDownloadRSSItems:(NSArray *)rssItems withFeedURL:(NSURL *)feedURL;

@end


@interface RSSFeedXMLParser : NSObject <NSXMLParserDelegate>

@property (nonatomic,weak) id<RSSFeedXMLParserDelegate> delegate;

- (void) startParsingWithContentsOfURL:(NSURL *)rssURL;

@end
