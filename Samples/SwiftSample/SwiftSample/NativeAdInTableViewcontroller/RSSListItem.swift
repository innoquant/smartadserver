//
//  RSSListItem.swift
//  SwiftSample
//
//  Created by Loïc GIRON DIT METAZ on 07/09/2015.
//  Copyright © 2015 Smart AdServer. All rights reserved.
//

import UIKit


// Represents a RSS item in the table view of the NativeAdInTableViewController
class RSSListItem: NSObject, ListItem {
    
    private let _title: String
    private let _subtitle: String
    private let _image: String
    private let _link: String
    
    init(title: String, subtitle: String, image: String, link: String) {
        self._title = title
        self._subtitle = subtitle
        self._image = image
        self._link = link
        
        super.init()
    }
    
    func title() -> String {
        return _title
    }
    
    func subtitle() -> String {
        return _subtitle
    }
    
    func image() -> String {
        return _image
    }
    
    func link() -> String {
        return _link
    }
    
}
