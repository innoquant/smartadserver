//
//  AdListItem.swift
//  SwiftSample
//
//  Created by Loïc GIRON DIT METAZ on 07/09/2015.
//  Copyright © 2015 Smart AdServer. All rights reserved.
//

import UIKit


// Represents an ad item in the table view of the NativeAdInTableViewController
class AdListItem: NSObject, ListItem {
    
    private let adPlacement: SASNativeAdPlacement
    private let adManager: SASNativeAdManager
    private var ad: SASNativeAd?
    
    deinit {
        if let ad = ad {
            // Don't forget to unregister the views when releasing the ad item
            ad.unregisterViews()
        }
    }
    
    init(adPlacement: SASNativeAdPlacement) {
        // To download a native ad, a native ad manager initialized with the adPlacement object is needed
        self.adPlacement = adPlacement
        self.adManager = SASNativeAdManager(placement: adPlacement)
        
        super.init()
        
        // Launch the ad loading as soon as the object is initialized
        loadAd()
    }
    
    private func loadAd() {
        // A native ad can be requested using the ad manager:
        // the ad call will be asynchronous and the result given in a block
        adManager.requestAd({ (ad: SASNativeAd?, error: NSError?) -> () in
            
            // If the ad parameter is defined, it means that a valid native ad as been retrieved,
            // otherwise its an error and the error parameter will be defined.
            if let ad = ad {
                // The ad is saved and the notification is sent so the controller can refresh the table view
                self.ad = ad
                NSNotificationCenter.defaultCenter().postNotificationName(NativeAdInTableViewController.NATIVE_AD_READY_NOTIFICATION, object: nil)
            } else {
                // If the calls fails, it is possible to log/print the exact reason of the error
                NSLog("Unable to load ad: \(error?.description)")
            }
            
        })
    }
    
    func isReady() -> Bool {
        // The ad item is considered as ready if a native ad instance is available
        return ad != nil
    }
    
    func title() -> String {
        if let ad = ad, let title = ad.title {
            return title
        } else {
            return ""
        }
    }
    
    func subtitle() -> String {
        if let ad = ad, let subtitle = ad.subtitle {
            return subtitle
        } else {
            return ""
        }
    }
    
    func callToAction() -> String {
        if let ad = ad, let callToAction = ad.callToAction {
            return callToAction
        } else {
            return ""
        }
    }
    
    func image() -> String {
        if let ad = ad, let icon = ad.icon {
            return icon.URL.absoluteString
        } else {
            return ""
        }
    }
    
    func registerView(view: UIView, modalParentViewController: UIViewController) {
        if let ad = ad {
            // The view of the native ad needs to be registered to allow click on the ad and impression counting
            ad.registerView(view, modalParentViewController: modalParentViewController)
        }
    }
    
    func unregisterViews() {
        if let ad = ad {
            // The views of the native ad needs to be unregistered before they are released or before they are reused for another native ad
            ad.unregisterViews()
        }
    }
    
}
