//
//  SettingTableViewCell.h
//  PisenMarket
//
//  Created by ios-mac on 15/9/25.
//  Copyright © 2015年 ios-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView* headerImageView;

@property (weak, nonatomic) IBOutlet UILabel* titleLabel;

@property (weak, nonatomic) IBOutlet UILabel* midCoverTitleLabel;

@property (weak, nonatomic) IBOutlet UIImageView* tailImageView;

@end
