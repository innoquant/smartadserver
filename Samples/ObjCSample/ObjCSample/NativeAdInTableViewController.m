//
//  NativeAdInTableTableViewController.m
//  ObjCSample
//
//  Created by Julien Gomez on 01/09/2015.
//  Copyright (c) 2015 Smart AdServer. All rights reserved.
//

#import "NativeAdInTableViewController.h"
#import "ListItem.h"
#import "RSSListItem.h"
#import "AdListItem.h"
#import "UIImageView+AFNetworking.h"
#import "DetailViewController.h"
#import "SASNativeAdManager.h"
#import "NewsItemCell.h"
#import "NativeAdCell.h"
#import "RatingView.h"

#define kIntervalBetweenNativeAds 4


@interface NativeAdInTableViewController () {
    NSMutableArray *_listItems;
    RSSFeedXMLParser *_XMLParser;
    BOOL _fullMode;
}
@end


@implementation NativeAdInTableViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil fullMode:(BOOL)fullMode {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        if (fullMode) {
            [self.tableView registerNib:[UINib nibWithNibName:@"NativeAdFullCell" bundle:nil] forCellReuseIdentifier:@"NativeAdCell"];
            [self.tableView registerNib:[UINib nibWithNibName:@"NewsItemFullCell" bundle:nil] forCellReuseIdentifier:@"NewsItemCell"];
        } else {
            [self.tableView registerNib:[UINib nibWithNibName:@"NativeAdCell" bundle:nil] forCellReuseIdentifier:@"NativeAdCell"];
            [self.tableView registerNib:[UINib nibWithNibName:@"NewsItemCell" bundle:nil] forCellReuseIdentifier:@"NewsItemCell"];
        }
        _fullMode = fullMode;
    }
    
    return self;
}


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil fullMode:NO];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableView:) name:kNativeAdReadyNotification object:nil];
    
     self.title = @"Native Ad";
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
    
    _listItems = nil;
    [self refresh];
}


- (void)refresh {
    [self loadRSSFeed:[NSURL URLWithString:@"http://blog.smartadserver.com/feed/"]];
}

#pragma mark - RSS Request Manager

- (void)loadRSSFeed:(NSURL *)feedURL {
    if(_XMLParser == nil) {
        _XMLParser = [[RSSFeedXMLParser alloc] init];
        _XMLParser.delegate = self;
    }
    [_XMLParser startParsingWithContentsOfURL:feedURL];
}


- (void) xmlParser:(RSSFeedXMLParser *)parser didDownloadRSSItems:(NSArray *)rssItems withFeedURL:(NSURL *)feedURL {
   
    _listItems = [NSMutableArray array];
    
    for (int i = 0; i < [rssItems count]; i++) {
        
        //Every kIntervalBetweenNativeAds items, insert a native ad in the list
        if (i % kIntervalBetweenNativeAds == 0) {
            
            // The config object is used to represent the placement of the banner.
            // The information provided are almost the same than the information you need to provide to a classic display banner,
            // except for the 'master' parameter that does not exist for native ads.
            SASNativeAdPlacement *adPlacement = [SASNativeAdPlacement nativeAdPlacementWithBaseURL:[NSURL URLWithString:@"http://mobile.smartadserver.com"] siteID: 28298 pageID:@"586114" formatID:15140 target:@""];

            AdListItem *adItem = [[AdListItem alloc] initWithAdPlacement:adPlacement];
            [_listItems addObject:adItem];
        }
        
        RSSListItem *rssListItem = rssItems[i];
        [_listItems addObject:rssListItem];
    }
    
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];

}


#pragma mark - Table View

- (void)updateTableView:(NSNotification *)notification {
    [self.tableView beginUpdates];
    
    //Reload all cells containing ads (one cell every kIntervalBetweenNativeAds cells)
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (int i = 0; i < [_listItems count]; i = i + 1 + kIntervalBetweenNativeAds) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self.tableView endUpdates];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 70;
    if (_fullMode) {
        height = 220;
    }
    
    if ([_listItems[indexPath.row] isKindOfClass:[AdListItem class]]) {
        AdListItem *item = _listItems[indexPath.row];
        if ([item isReady]) {
            return height;
        } else {
            return 0;
        }
    } else {
        return height;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _listItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *NewsItemCellIdentifier = @"NewsItemCell";
    static NSString *AdCellIdentifier = @"NativeAdCell";
    
    UITableViewCell *cell;
    
    if ([_listItems[indexPath.row] isKindOfClass:[AdListItem class]]) {
        AdListItem *item = _listItems[indexPath.row];
        NativeAdCell *adCell = (NativeAdCell *)[tableView dequeueReusableCellWithIdentifier:AdCellIdentifier];
        if ([item isReady]) {
            if (adCell.adItem) {
                // Unregister previous ad if needed
                [adCell.adItem unregisterViews];
            }
            adCell.adItem = item;
        
            adCell.adTitleLabel.text = item.title;
            adCell.adDescriptionLabel.text = item.subtitle;
   
            [adCell.adCallToActionButton setTitle:item.callToAction forState:UIControlStateNormal];
            [adCell.adIconImageView setImageWithURL:item.imageURL placeholderImage:[UIImage imageNamed:@"NewsIcon.png"]];
            [adCell.adCoverImageView setImageWithURL:item.coverImageURL placeholderImage:nil];
            
            UIView *view = (UIView *)[adCell viewWithTag:100];
            UIView *previousRatingView = (UIView *)[adCell viewWithTag:101];
            if (previousRatingView) {
                [previousRatingView removeFromSuperview];
            }
            
            if (item.rating != SASRatingUndefined) {
                RatingView *ratingView = [[RatingView alloc] initWithFrame:CGRectMake(0, 0, 55, 10) andRating:item.rating];
                ratingView.tag = 101;
                
                [view addSubview:ratingView];
            }
            
            [item registerView:adCell modalParentViewController:self];
        
            [cell setHidden:NO];
        } else {
            [cell setHidden:YES];
        }
        
        cell = (UITableViewCell *)adCell;
    } else {
        RSSListItem *item = _listItems[indexPath.row];
        NewsItemCell *newsItemCell = [tableView dequeueReusableCellWithIdentifier:NewsItemCellIdentifier];
        newsItemCell.newsItemTitleLabel.text = item.title;
        newsItemCell.newsItemDescriptionLabel.text = item.subtitle;
        [newsItemCell.newsItemIconImageView setImageWithURL:item.imageURL placeholderImage:[UIImage imageNamed:@"NewsIcon.png"]];
        newsItemCell.publishedDateLabel.text = item.publishedDate;
       
        cell = (UITableViewCell *)newsItemCell;
    }
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_listItems[indexPath.row] isKindOfClass:[RSSListItem class]]) {
        DetailViewController *controller = [[DetailViewController alloc] init];
        [controller setListItem:_listItems[indexPath.row]];
        [self.navigationController pushViewController:controller animated:YES];
    }
}


@end
