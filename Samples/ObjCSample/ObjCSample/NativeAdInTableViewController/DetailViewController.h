//
//  DetailViewController.h
//  NativAdsSample
//
//  Created by Loïc GIRON DIT METAZ on 16/04/2014.
//  Copyright (c) 2014 Smart AdServer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSListItem.h"


@interface DetailViewController : UIViewController

@property (strong, nonatomic) RSSListItem *listItem;
@property (weak, nonatomic) IBOutlet UIWebView *articleWebView;

@end
