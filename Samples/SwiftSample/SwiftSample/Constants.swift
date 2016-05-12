//
//  Constants.swift
//  SwiftSample
//
//  Created by Loïc GIRON DIT METAZ on 22/07/2014.
//  Copyright (c) 2014 Smart AdServer. All rights reserved.
//


// IDs used by the Smart AdServer SDK to retrieve the ads.
class Constants {
	
	class func siteID() -> Int { return 28298 }
	class func baseURL() -> String { return "http://mobile.smartadserver.com" }
	
    class func nativeAdFormatID() -> Int { return 15140 }
	class func bannerFormatID() -> Int { return 12161 }
	class func interstitialFormatID() -> Int { return 12167 }
	
	class func bannerPageID() -> String { return "188761" }
	class func toasterPageID() -> String { return "188762" }
	class func interstitialPageID() -> String { return "188763" }
	class func interstitialDismissalAnimationPageID() -> String { return "188763" }
	class func prefetchInterstitialPageID() -> String { return "297754" }
    class func banner1InTableViewPageID() -> String { return "548316" }
    class func banner2InTableViewPageID() -> String { return "548804" }
    class func nativeAdInTableViewPageID() -> String { return "586114" }
    
}
