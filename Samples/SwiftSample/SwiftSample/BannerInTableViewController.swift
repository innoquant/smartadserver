//
//  BannerInListViewController.swift
//  SwiftSample
//
//  Created by Loïc GIRON DIT METAZ on 05/05/2015.
//  Copyright (c) 2015 Smart AdServer. All rights reserved.
//

import AVFoundation


class BannerInTableViewController: UITableViewController, SASAdViewDelegate {
    
    let banner1Row = 5
    let banner2Row = 15
    let numberOfCells = 30
    
    let defaultCellHeight: CGFloat = 50.0
    
     // Instances of banners (marked as optional since it is created after the initialization of the controller)
    var banner1: SASBannerView?
    var banner2: SASBannerView?
    var banner1Height: CGFloat
    var banner2Height: CGFloat
    
    var statusBarHidden = false
    
    // MARK: - View controller lifecycle
    
    deinit {
        // Banners are automatically released by ARC but the delegate and the modalParentViewController should be set to nil to prevent crashes during fast navigation in the application.
        // This can be made in the deinitializer which will be called automatically by ARC when the controller is released.
        banner1?.delegate = nil
        banner1?.modalParentViewController = nil
        
        banner2?.delegate = nil
        banner2?.modalParentViewController = nil
        
        NSLog("BannerInTableViewController has been deallocated");
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        banner1Height = defaultCellHeight
        banner2Height = defaultCellHeight
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        banner1Height = defaultCellHeight
        banner2Height = defaultCellHeight
        
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            // Setting the audio session to category AVAudioSessionCategoryPlayback with MixWithOthers option allows the SDK
            // to automatically mute the sound of the ad when displayed inline and to unmute it when the video becomes fullscreen, even
            // if the physical silent switch is activated.
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, withOptions: .MixWithOthers)
        } catch _ {
        }
        
        createReloadButton()
        createBanners()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        // The status bar can be hidden by an ad (for instance when the ad is expanded in fullscreen)
        let defaultStatusBarStatus = super.prefersStatusBarHidden()
        return statusBarHidden || defaultStatusBarStatus
    }
    
    func createReloadButton() {
        let loadButton = UIBarButtonItem(title: "Reload", style: .Bordered, target: self, action: "reload")
        navigationItem.rightBarButtonItem = loadButton
    }
    
    // MARK: - Ad management
    
    func reload() {
        self.removeBanners()
        self.createBanners()
    }
    
    func createBanners() {
        self.banner1Height = defaultCellHeight
        self.banner2Height = defaultCellHeight
        self.banner1 = createBanner(Constants.banner1InTableViewPageID())
        self.banner2 = createBanner(Constants.banner2InTableViewPageID())
    }
    
    func createBanner(pageId: String) -> SASBannerView {
        // The instance of the banner is created with a default frame and an appropriate loader.
        let banner = SASBannerView(frame: bannerFrameForView(self.view, height: defaultCellHeight), loader: .ActivityIndicatorStyleWhite)
        
          // Setting the delegate.
        banner.delegate = self
        
        // Setting the modal parent view controller.
        banner.modalParentViewController = self
        
        // Loading the ad (using IDs from the Constants class).
        banner.loadFormatId(Constants.bannerFormatID(), pageId: pageId, master: true, target: nil)
        
        // Since this sample is not defining any autolayout constraints but instead use frame and autoresizing masks, this informations must be
        // translated into constraints.
        // Please note that if you deactivate autoresizing translation (and you create your constraints yourself) on the ad view, it will prevent
        // creatives that resize/reposition the view to work (like toaster or resize banners).
        banner.translatesAutoresizingMaskIntoConstraints = true
        
        return banner
    }
    
    func removeBanners() {
        removeBanner(banner1)
        removeBanner(banner2)
    }
    
    func removeBanner(banner: SASBannerView?) {
        if let actualBanner = banner {
            // Do not forget to set the delegate to nil every time you deallocate an ad view.
            actualBanner.delegate = nil
            actualBanner.modalParentViewController = nil;
            actualBanner.removeFromSuperview()
        }
    }
    
    func bannerFrameForView(view: UIView, height: CGFloat) -> CGRect {
        // Convenient method to reset the frame of a banner
        return CGRect(x: 0, y: 0, width: CGRectGetWidth(view.frame), height: height)
    }
    
    // MARK: - Table View data source & delegate
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height: CGFloat = defaultCellHeight
        
        // If the cell is an ad cell, the cell height should be based on the height computed in adView:didDownloadAd:
        if indexPath.row == banner1Row {
            height = banner1Height
        } else if indexPath.row == banner2Row {
            height = banner2Height
        }
        
        return height
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfCells
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = dequeueCellForIndexPath(indexPath)
        
        if isAdCell(indexPath) {
            // Attach relevant banner to the cell
            switch (indexPath.row) {
            case banner1Row:
                if let banner = self.banner1 {
                    banner.frame = bannerFrameForView(cell, height: self.banner1Height)
                    cell.addSubview(banner)
                }
            case banner2Row:
                if let banner = self.banner2 {
                    banner.frame = bannerFrameForView(cell, height: self.banner2Height)
                    cell.addSubview(banner)
                }
            default:
                NSLog("Error: cell should not be an AdCell")
            }
        } else {
            cell.textLabel?.text = "Lorem ipsum dolor sit amet"
        }
        
        return cell
    }
    
    func dequeueCellForIndexPath(indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        if isAdCell(indexPath) {
            // Each ad is created inside a specific cell to avoid removing the ad view from its superview
            let cellIdentifier = indexPath.row == banner1Row ? "AdCell1" : "AdCell2"
            
            cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell?
            if (cell == nil) {
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
            }
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("ContentCell") as UITableViewCell?
            if (cell == nil) {
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "ContentCell")
            }
        }
        
        return cell!
    }
    
    func isAdCell(indexPath: NSIndexPath) -> Bool {
        // In this sample, ad cells are in fixed positions
        return (indexPath.row == banner1Row || indexPath.row == banner2Row)
    }
    
    func configureAdCellHeight(banner: SASAdView, height: CGFloat) {
        // The cell containing the banner is reloaded so its size and the banner frame are updated
        var cellsToReloadOrNil: [NSIndexPath]?
        if banner == banner1 {
            banner1Height = height
            cellsToReloadOrNil = [NSIndexPath(forRow: banner1Row, inSection: 0)]
        } else if banner == banner2 {
            banner2Height = height
            cellsToReloadOrNil = [NSIndexPath(forRow: banner2Row, inSection: 0)]
        }
        
        if let cellsToReload = cellsToReloadOrNil {
            self.tableView.reloadRowsAtIndexPaths(cellsToReload, withRowAnimation: .Automatic)
        }
    }
    
    // MARK: - SASAdViewDelegate
    
    func adView(adView: SASAdView, didDownloadAd ad: SASAd) {
        NSLog("An ad object has been loaded")
        
        if (!CGSizeEqualToSize(ad.portraitSize, CGSizeZero)) {
            // If the creative size is known, it is possible to compute a more suitable cell height, for instance by setting
            // the ad view width to the cell width and trying to keep the same ratio.
            let width = ad.portraitSize.width
            let height = ad.portraitSize.height
            let screenWidth = CGRectGetWidth(self.view.frame)
            let multiplier = screenWidth / width
            let clampedMultiplier = fmin(2.0, multiplier) //2.0f is the maximum multiplier value
            let adViewHeight = height * clampedMultiplier
            
            configureAdCellHeight(adView, height: adViewHeight)
        }
    }
    
    func adViewDidLoad(adView: SASAdView)  {
        NSLog("Banner has been loaded")
    }
    
    func adView(adView: SASAdView, didFailToLoadWithError error: NSError) {
        NSLog("Banner has failed to load with error: \(error.description)")
        
        // The cell is collapsed if the ad cannot be loaded
        configureAdCellHeight(adView, height: 0)
        removeBanner(adView as? SASBannerView)
    }
    
    func adViewWillExpand(adView: SASAdView) {
        NSLog("Banner will expand")
        
        // When the ad is expanded, hide the status bar
        statusBarHidden = true;
        setNeedsStatusBarAppearanceUpdate()
    }
    
    func adViewWillCloseExpand(adView: SASAdView) {
        NSLog("Banner will close expand")
        
        // When the ad will closed, the status bar should be restored
        statusBarHidden = false;
        setNeedsStatusBarAppearanceUpdate()
    }
    
}
