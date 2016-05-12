//
//  NewsItemTableViewCell.h
//  ObjCSample
//
//  Created by Julien Gomez on 09/09/2015.
//  Copyright © 2015 Smart AdServer. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewsItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *newsItemIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *newsItemTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *newsItemDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *publishedDateLabel;

@end
