//
//  DetailViewController.m
//  NativAdsSample
//
//  Created by Loïc GIRON DIT METAZ on 16/04/2014.
//  Copyright (c) 2014 Smart AdServer. All rights reserved.
//

#import "DetailViewController.h"


@interface DetailViewController ()

- (void)configureView;

@end


@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setListItem:(RSSListItem *)newDetailItem {
    if (_listItem != newDetailItem) {
        _listItem = newDetailItem;
        
        [self configureView];
    }
}


- (void)configureView {
	if (self.listItem) {
		[self.articleWebView loadRequest:[NSURLRequest requestWithURL:[self.listItem link]]];
		self.navigationItem.title = [self.listItem title];
	}
}


- (void)viewDidLoad {
    [super viewDidLoad];
	[self configureView];
}



@end
