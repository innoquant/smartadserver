//
//  NativeAdInTableTableViewController.h
//  ObjCSample
//
//  Created by Julien Gomez on 01/09/2015.
//  Copyright (c) 2015 Smart AdServer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSFeedXMLParser.h"


@interface NativeAdInTableViewController : UITableViewController <RSSFeedXMLParserDelegate>

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil fullMode:(BOOL)fullMode;
    
@end
