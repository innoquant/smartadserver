//
//  NativeAdInTableViewController.swift
//  SwiftSample
//
//  Created by Julien Gomez on 03/09/2015.
//  Copyright © 2015 Smart AdServer. All rights reserved.
//

import UIKit


// Example of a native ad integration in an existing table view.
//
// For this integration, we choose to insert a native ad every X items (this number can be set through a variable),
// but it can work the same way with fixed positioned ad banners.
//
// This sample relies on a list of ListItem that can be from to types:
//   - RSSListItem: business object representing an actual content item from your app
//   - AdListItem: an ad object that will load and represents a native ad.
//
// The controller will first load the business items from a RSS feed in this example, then insert AdListItem objects
// in the item list.
// Each AdListItem will instantiate a native ad manager and load its own ad, then warn the controller using the notification.
class NativeAdInTableViewController: UITableViewController, XMLParserDelegate {
    
    // This notification is used to refresh the tableview cells containing ads when they are updated by their respective ad manager
    static let NATIVE_AD_READY_NOTIFICATION = "NativeAdReadyNotification"
    
    // The interval between native ads in the table view
    private let INTERVAL_BETWEEN_NATIVE_ADS = 4

    // Other objects to handle the RSS parsing and the 'article' display
    private let xmlParser = XMLParser()
    private var items = [ListItem]()
    let postClickViewController = NativeAdPostClickViewController(nibName: "NativeAdPostClickViewController", bundle: nil)
    
    // MARK: - View controller lifecycle
    
    deinit {
        // Do not forget to remove your controller from the notification center when it is deallocated
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveRSSFeed()
        createReloadButton()
        
        // Add a notification observer to know when an ad cell needs to be refreshed
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("updateTableView:"), name: NativeAdInTableViewController.NATIVE_AD_READY_NOTIFICATION, object: nil)
    }
    
    private func retrieveRSSFeed() {
        let url = NSURL(string: "http://blog.smartadserver.com/feed/")
        xmlParser.delegate = self
        xmlParser.startParsingWithContentsOfURL(url)
    }
    
    func createReloadButton() {
        let loadButton = UIBarButtonItem(title: "Reload", style: .Bordered, target: self, action: "reload")
        navigationItem.rightBarButtonItem = loadButton
    }
    
    func reload() {
        items.removeAll()
        self.tableView.reloadData()
        
        retrieveRSSFeed()
    }

    // MARK: - XMLParserDelegate method implementation
    
    func parser(parser: XMLParser, didFinishParsing results: [Dictionary<String, String>]) {
        items.removeAll()
        
        // Each business item retrieved through the RSS feed is converted in a RSSListItem and inserted in the items list
        var i = 0
        for result in results {
            
            // Every X items, an AdListItem is inserted
            if (i % INTERVAL_BETWEEN_NATIVE_ADS == 0) {
                
                // The config object is used to represent the placement of the banner.
                // The information provided are almost the same than the information you need to provide to a classic display banner,
                // except for the 'master' parameter that does not exist for native ads.
                let adPlacement = SASNativeAdPlacement(baseURL: NSURL(string: Constants.baseURL())!, siteID: Constants.siteID(), pageID: Constants.nativeAdInTableViewPageID(), formatID: Constants.nativeAdFormatID(), target: "")
                
                // The ad item is created with the configuration and added to the items list
                let adItem = AdListItem(adPlacement: adPlacement)
                items.append(adItem)
            }
            
            if let title = result[XMLParser.TITLE_KEY], let subtitle = result[XMLParser.DESCRIPTION_KEY], let image = result[XMLParser.URL_KEY], let link = result[XMLParser.LINK_KEY] {
                let RSSItem = RSSListItem(title: title, subtitle: subtitle, image: image, link: link)
                items.append(RSSItem)
            }
            
            ++i
        }
        
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    func updateTableView(notification: NSNotification) {
        tableView.beginUpdates()
        
        // When an ad notification is received, ad cells needs to be reloaded.
        var indexPaths = [NSIndexPath]()
        for var i = 0; i < items.count; i = i + 1 + INTERVAL_BETWEEN_NATIVE_ADS {
            indexPaths.append(NSIndexPath(forRow: i, inSection: 0))
        }
        tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
        
        tableView.endUpdates()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = items[indexPath.row] is AdListItem ? "NativeAdCell" : "NewsItemCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! ListItemCell
        
        if let title = cell.viewWithTag(1) as? UILabel, let subtitle = cell.viewWithTag(2) as? UILabel, let image = cell.viewWithTag(3) as? UIImageView {
            
            // Since an ad and a RSS item are representing using the same kind of class, it is easy to fill a cell for a given row.
            let item = items[indexPath.row]
            title.text = item.title()
            subtitle.text = item.subtitle()
            image.setImageWithURL(NSURL(string: item.image()), placeholderImage: UIImage(named: "NewsIcon.png"))
            image.contentMode = UIViewContentMode.ScaleAspectFit
            
            // Unregister previous ad if needed
            if let previousItem = cell.adItem {
                previousItem.unregisterViews()
            }
            
            // IMPORTANT: you have to indicate clearly that the item is an ad to comply with the law in most countries.
            //            Please check your local legislation for more details.
            if let item = (item as? AdListItem) where item.isReady(), let button = cell.viewWithTag(4) as? UIButton {
                button .setTitle(item.callToAction(), forState: UIControlState.Normal)
                cell.adItem = item
                
                // The views used by the native ads must be registered on the native ad as soon as they are ready and displayed.
                // This will ensure that the impression is counted and will handle click automatically.
                // Registered views must be unregistered using the unregisterViews method before being released or reuse for another
                // ad (be careful with table view cells).
                item.registerView(cell, modalParentViewController: self)
            } else {
                cell.adItem = nil
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let item = items[indexPath.row]
        if item is AdListItem && !(item as! AdListItem).isReady() {
            // Hide the ad cell if it's not ready
            return 0
        } else {
            return 70
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let item = items[indexPath.row]
        if item is RSSListItem {
            // Since the click is handled automatically for native ads, you need to check that the cell clicked is
            // a RSS item and not an ad before displaying the article.
            postClickViewController.item = item as? RSSListItem
            navigationController?.pushViewController(postClickViewController, animated: true)
        }
    }

}
