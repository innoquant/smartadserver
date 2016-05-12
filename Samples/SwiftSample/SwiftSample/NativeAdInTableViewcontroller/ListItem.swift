//
//  ListItem.swift
//  SwiftSample
//
//  Created by Loïc GIRON DIT METAZ on 07/09/2015.
//  Copyright © 2015 Smart AdServer. All rights reserved.
//

import UIKit


// Represents an item in the table view of the NativeAdInTableViewController
protocol ListItem {
    
    func title() -> String
    func subtitle() -> String
    func image() -> String
    
}
