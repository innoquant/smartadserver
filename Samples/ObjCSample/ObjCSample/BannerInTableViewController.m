//
//  BannerInTableViewController.m
//  ObjCSample
//
//  Created by Julien Gomez on 29/04/2015.
//  Copyright (c) 2015 Smart AdServer. All rights reserved.
//

#import "BannerInTableViewController.h"
#import "SASAd.h"
#import "MOCAAds.h"

#define kBanner1Position    4
#define kBanner2Position    14
#define kDefaultCellHeight  50
#define kBannerViewTag      0


@interface BannerInTableViewController ()

@end

@implementation BannerInTableViewController

#pragma mark - Object lifecycle

- (void)dealloc {
    // End device notification events
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //The banners are released automatically by ARC but the delegate and the modalParentViewController should be set to nil to prevent crashes during fast navigation in the application.
    //This can be made in the dealloc method which will be called automatically by ARC when the controller will be released.
    _banner1.delegate = nil;
    _banner1.modalParentViewController = nil;
    _banner2.delegate = nil;
    _banner2.modalParentViewController = nil;
    
    NSLog(@"BannerInTableViewController has been deallocated");
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(createBanners)
                  forControlEvents:UIControlEventValueChanged];
    
    self.title = @"Pull to refresh";
    
    // Create the banners
    [self createBanners];
    
    // Start device notification events
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(viewDidRotate:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}


- (void)viewDidRotate:(NSNotification *)notification {
    // Reload the tableview during rotation to update ad views frames
    [self.tableView reloadData];
}


- (void)createBanners {
    // Remove banners if exist
    [self removeBanner:_banner1];
    [self removeBanner:_banner2];
    _banner1 = [self createBanner:@"548316"];
    _banner2 = [self createBanner:@"548804"];
}


- (SASTableBannerView *)createBanner:(NSString*) pageID {
    SASTableBannerView *banner = [[SASTableBannerView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), kDefaultCellHeight)];
    banner.autoresizingMask = UIViewAutoresizingNone;
    banner.tag = kBannerViewTag;
    banner.delegate = self;
    banner.modalParentViewController = self;
    [banner loadFormatId:12161 pageId:pageID master:YES target:[MOCAAds getTarget]];
    
    return banner;
}


- (void) removeBanner:(SASTableBannerView *) banner {
    banner.delegate = nil;
    banner.modalParentViewController = nil;
    [banner removeFromSuperview];
    banner.loaded = NO;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (kBanner1Position == indexPath.row) {
        return _banner1.height;
    } else if (kBanner2Position == indexPath.row) {
        return _banner2.height;
    } else {
        return kDefaultCellHeight;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (kBanner1Position == indexPath.row) {
        return [self tableView:tableView adView:_banner1 cellForIdentifier:@"banner1Cell"];
    } else if (kBanner2Position == indexPath.row) {
        return [self tableView:tableView adView:_banner2 cellForIdentifier:@"banner2Cell"];
    } else {
        NSString *dummyCellIdentifier = @"dummyCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dummyCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dummyCellIdentifier];
        }
        cell.textLabel.text = @"Lorem ipsum dolor sit amet";
        return cell;
    }
}


// Method to get the right cell of the corresponding banner
- (UITableViewCell *)tableView:(UITableView *)tableView adView:(SASTableBannerView *) banner cellForIdentifier:(NSString *) bannerCellIdentifier {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:bannerCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bannerCellIdentifier];
    }
    [[cell viewWithTag:kBannerViewTag] removeFromSuperview];
    banner.frame = CGRectMake(0, 0, CGRectGetWidth(cell.frame), banner.height);
    [cell.contentView addSubview:banner];

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - SASAdView delegate

- (void)adView:(SASAdView *)adView didDownloadAd:(SASAd *)ad {
    // Calculate height of banner depending on size returned by ad object
    if (!CGSizeEqualToSize(ad.portraitSize, CGSizeZero)) {
        SASTableBannerView *banner = (SASTableBannerView *)adView;
        
        float width = ad.portraitSize.width;
        float height = ad.portraitSize.height;
        float screenWidth = CGRectGetWidth(self.view.frame);
        float multiplier = screenWidth / width;
        float clampedMultiplier = fmin(2.0, multiplier); //2.0f is the maximum multiplier value
        // update height of banner cell
        banner.height = height * clampedMultiplier;
        
        NSIndexPath *bannerPath = [NSIndexPath indexPathForRow:banner.position inSection:0];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:bannerPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


- (void)adViewDidLoad:(SASAdView *)adView {
    NSLog(@"Banner has been loaded");
    SASTableBannerView *banner = (SASTableBannerView *)adView;
    banner.loaded = YES;
    
    if (_banner1.loaded && _banner2.loaded) {
        // Hide refresh control when both _banner1 & _banner2 are fully loaded
        [self.refreshControl endRefreshing];
    }
    
    [self.tableView reloadData];
}


- (void)adView:(SASAdView *)adView didFailToLoadWithError:(NSError *)error {
    NSLog(@"Banner has failed to load with error: %@", [error description]);
    SASTableBannerView *banner = (SASTableBannerView *)adView;
    banner.loaded = YES;
    
    if (_banner1.loaded && _banner2.loaded) {
        // Hide refresh control when both _banner1 & _banner2 are fully loaded
        [self.refreshControl endRefreshing];
    }
}


- (void)adViewWillExpand:(SASAdView *)adView {
    NSLog(@"Banner will expand");
    [self setStatusBarHidden:YES];
}


- (void)adViewWillCloseExpand:(SASAdView *)adView {
    NSLog(@"Banner will close expand");
    [self setStatusBarHidden:NO];
}

#pragma mark - iOS 7+ status bar handling

- (void)setStatusBarHidden:(BOOL)hidden {
    _statusBarHidden = hidden;
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}


- (BOOL)prefersStatusBarHidden {
    return _statusBarHidden || [super prefersStatusBarHidden];
}

@end
