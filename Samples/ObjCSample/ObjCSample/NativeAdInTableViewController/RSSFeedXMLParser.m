//
//  XMLParser.m
//  ObjCSample
//
//  Created by Julien Gomez on 07/09/2015.
//  Copyright © 2015 Smart AdServer. All rights reserved.
//

#import "RSSFeedXMLParser.h"
#import "RSSListItem.h"



@implementation RSSFeedXMLParser {
    NSURL *_rssURL;
    NSMutableArray *_parsedRSSItems;
    BOOL *_isInItem;
    NSString *_currentElement;
    NSString *_foundCharacters;
    
    
    NSURL *_foundLink;
    NSString *_foundTitle;
    NSString *_foundSubtitle;
    NSURL *_foundImageURL;
    NSString *_publishedDate;
    
}

- (void)startParsingWithContentsOfURL:(NSURL *)rssURL {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^() {
        _parsedRSSItems = [NSMutableArray new];
        _foundCharacters = @"";
        _isInItem = NO;
        
        NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:rssURL];
        _rssURL = rssURL;
        parser.delegate = self;
        [parser parse];
    });
    
}

#pragma mark - NSXMLParserDelegate method implementation

- (void) parserDidEndDocument:(NSXMLParser *)parser {
    if (self.delegate) {
        dispatch_async(dispatch_get_main_queue(), ^() {
            [self.delegate xmlParser:self didDownloadRSSItems:[NSArray arrayWithArray:_parsedRSSItems] withFeedURL:_rssURL];
        });
    }
}


- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    _currentElement = elementName;
    if([elementName isEqualToString:@"item"]) {
        _isInItem = YES;
    }
}


- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if (_isInItem) {
        if([elementName isEqualToString:@"item"]) {
            _isInItem = NO;
            
            [_parsedRSSItems addObject:[[RSSListItem alloc] initWithTitle:_foundTitle
                                                                 subtitle:_foundSubtitle
                                                                 imageURL:_foundImageURL
                                                                  linkURL:_foundLink publishedDate:_publishedDate]];
        }
        
        if ([elementName isEqualToString:@"link"]) {
             _foundLink = [NSURL URLWithString:[_foundCharacters substringFromIndex:3]];
        }
        
        if ([elementName isEqualToString:@"title"]) {
            _foundTitle = _foundCharacters;
        }
        
        if ([elementName isEqualToString:@"description"]) {
              _foundSubtitle = _foundCharacters;
        }
        
        if ([elementName isEqualToString:@"pubDate"]) {
            _publishedDate = [_foundCharacters stringByReplacingOccurrencesOfString:@" +0000" withString:@""];
        }
    }
    _foundCharacters = @"";

}


- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ((_isInItem && [_currentElement isEqualToString:@"title"])
        || (_isInItem && [_currentElement isEqualToString:@"description"])
        || [_currentElement isEqualToString:@"link"]
        || [_currentElement isEqualToString:@"pubDate"]) {
        _foundCharacters =  [_foundCharacters stringByAppendingString:string];
    }
}


- (void) parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock {
    if ((_isInItem && [_currentElement isEqualToString:@"description"])) {
        // extract image from description and keep url
        NSString *dataString = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
        if (dataString) {
            NSRange startPos = [dataString rangeOfString:@"src=\""];
            if (startPos.location != NSNotFound) {
                NSRange endPos = [dataString rangeOfString:@"\"" options: NSCaseInsensitiveSearch range:NSMakeRange(startPos.location+5,dataString.length-startPos.location-5)];
                if (endPos.location != NSNotFound) {
                    _foundImageURL = [NSURL URLWithString:[dataString substringWithRange:NSMakeRange(startPos.location+5, endPos.location-startPos.location-5)]];
                }
                
                NSRange startDescPos = [dataString rangeOfString:@"/>"];
                if (startDescPos.location != NSNotFound) {
                    _foundCharacters = [_foundCharacters stringByAppendingString:[dataString substringWithRange:NSMakeRange(startDescPos.location+2, dataString.length - startDescPos.location-2)]];
                }
     
            }
        }
    }
}

@end
