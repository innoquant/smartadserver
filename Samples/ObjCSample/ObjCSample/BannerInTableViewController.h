//
//  BannerInTableViewController.h
//  ObjCSample
//
//  Created by Julien Gomez on 29/04/2015.
//  Copyright (c) 2015 Smart AdServer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SASTableBannerView.h"

@interface BannerInTableViewController : UITableViewController <SASAdViewDelegate> {
    SASTableBannerView *_banner1;
    SASTableBannerView *_banner2;

    
    BOOL _statusBarHidden;
}

@end
