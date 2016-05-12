//
//  NativeAdPostClickViewController.swift
//  SwiftSample
//
//  Created by Loïc GIRON DIT METAZ on 07/09/2015.
//  Copyright © 2015 Smart AdServer. All rights reserved.
//

import UIKit


class NativeAdPostClickViewController: UIViewController {
    
    @IBOutlet var webView: UIWebView!
    
    var item: RSSListItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.scalesPageToFit = true
    }
    
    override func viewWillAppear(animated: Bool) {
        if let link = self.item?.link() {
            if let URL = NSURL(string: link) {
                self.webView.loadRequest(NSURLRequest(URL: URL))
            }
        }
        super.viewWillAppear(true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        if let URL = NSURL(string: "about:blank") {
            self.webView.loadRequest(NSURLRequest(URL: URL))
        }
        super.viewWillDisappear(true)
    }
    
}
