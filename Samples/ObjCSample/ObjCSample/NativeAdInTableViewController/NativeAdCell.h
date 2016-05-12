//
//  NativeAdCell.h
//  ObjCSample
//
//  Created by Julien Gomez on 08/09/2015.
//  Copyright © 2015 Smart AdServer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdListItem.h"

@interface NativeAdCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *adTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *adIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *adDescriptionLabel ;

@property (weak, nonatomic) IBOutlet UIButton *adCallToActionButton;
@property (weak, nonatomic) IBOutlet UIImageView *adCoverImageView;

@property (weak, nonatomic) AdListItem *adItem;


@end
