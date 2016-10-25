//
//  MenuTableViewCell.h
//  Qianjituan
//
//  Created by ios-mac on 15/9/25.
//  Copyright © 2015年 ios-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuTableViewCell : UITableViewCell
{
    @private
    UILabel* titleLabel;
}

@property (strong, nonatomic) IBOutlet UILabel* titleLabel;

@end
