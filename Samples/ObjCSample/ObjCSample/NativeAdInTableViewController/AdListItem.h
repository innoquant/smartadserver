//
//  ListItem.h
//  NativeAdsSample
//
//  Created by Loïc GIRON DIT METAZ on 17/04/2014.
//  Copyright (c) 2014 Smart AdServer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListItem.h"
#import "SASNativeAdManager.h"


#define kNativeAdReadyNotification @"kNativeAdReadyNotification"


@interface  AdListItem: NSObject <ListItem> {
    SASNativeAdPlacement *_adPlacement;
	SASNativeAdManager *_adManager;
    SASNativeAd *_ad;
	BOOL _isReady;
}

- (instancetype)initWithAdPlacement:(SASNativeAdPlacement *)nativeAdPlacement;

- (NSURL *)coverImageURL;
- (NSString *)callToAction;
- (float)rating;
- (BOOL)isReady;
- (void)registerView:(UIView *)view modalParentViewController:(UIViewController *)modalParentViewController;
- (void)unregisterViews;

@end
