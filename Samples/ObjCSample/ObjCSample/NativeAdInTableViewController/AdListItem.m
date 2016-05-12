//
//  ListItem.m
//  NativeAdsSample
//
//  Created by Loïc GIRON DIT METAZ on 17/04/2014.
//  Copyright (c) 2014 Smart AdServer. All rights reserved.
//

#import "AdListItem.h"
#import "SASNativeAdImage.h"


@implementation AdListItem

- (void)dealloc {
    if(_ad) {
        // Don't forget to unregister the views when releasing the ad item
        [_ad unregisterViews];
    }
}

- (instancetype)initWithAdPlacement:(SASNativeAdPlacement *)nativeAdPlacement {
	self = [super init];
	
	if (self) {
        // To download a native ad, a native ad manager initialized with the adPlacement object is needed
        _adPlacement = nativeAdPlacement;
        _adManager = [[SASNativeAdManager alloc] initWithPlacement:_adPlacement];
        
        // Launch the ad loading as soon as the object is initialized
        [self loadAd];
    }
	
	return self;
}

 
- (void)loadAd {
    // A native ad can be requested using the ad manager:
    // the ad call will be asynchronous and the result given in a block
    [_adManager requestAd:^(SASNativeAd *ad, NSError *error) {
        
        // If the ad parameter is defined, it means that a valid native ad as been retrieved,
        // otherwise its an error and the error parameter will be defined.
        if (ad) {
            // The ad is saved and the notification is sent so the controller can refresh the table view
            _ad = ad;
            [[NSNotificationCenter defaultCenter] postNotificationName:kNativeAdReadyNotification object:self userInfo:nil];
        } else {
            // If the calls fails, it is possible to log/print the exact reason of the error
            NSLog(@"Unable to load ad: %@", [error description]);
        }
    }];
}


- (NSString *)title {
    return [_ad title];
}


- (NSString *)subtitle {
	return [_ad subtitle];
}


- (NSURL *)imageURL {
    return [[_ad icon] URL];
}


- (NSURL *)coverImageURL {
    return [[_ad coverImage] URL];
}


- (NSString *)callToAction {
    return [_ad callToAction];
}


- (float)rating {
    return _ad.rating;
}


- (BOOL)isReady {
	return _ad != nil;
}


- (void)registerView:(UIView *)view modalParentViewController:(UIViewController *)modalParentViewController {
    if (_ad) {
       [_ad registerView:view modalParentViewController:modalParentViewController];
    }
}

- (void)unregisterViews {
    if (_ad) {
        [_ad unregisterViews];
    }
}


@end
