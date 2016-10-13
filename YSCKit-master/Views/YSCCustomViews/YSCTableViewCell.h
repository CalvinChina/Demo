//
//  YSCTableViewCell.h
//  YSCKit
//
//  Created by yangshengchao on 14/11/17.
//  Copyright (c) 2014年 yangshengchao. All rights reserved.
//

#import "YSCBaseTableViewCell.h"

#define YSCCellIdentifier       @"YSCCellIdentifier"

typedef NS_ENUM(NSInteger, YSCTableViewCellStyle) {
    YSCTableViewCellStyleTitle              = 1 << 0,        //Default
    YSCTableViewCellStyleIcon               = 1 << 1,
    YSCTableViewCellStyleArrow              = 1 << 2,
    YSCTableViewCellStyleSwitch             = 1 << 3,
    YSCTableViewCellStyleSubtitleRight      = 1 << 4,
    YSCTableViewCellStyleSubtitleBottom     = 1 << 5,
};

typedef void (^StateChanged)(BOOL state);

@interface YSCTableViewCell : YSCBaseTableViewCell

@property (weak, nonatomic) IBOutlet UIView *iconContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconContainerWidth;    //66
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

//subtitle在左边
@property (weak, nonatomic) IBOutlet UIView *subtitleLeftContainerView;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLeftTitleLabel;           //主标题
@property (weak, nonatomic) IBOutlet UILabel *subtitleLeftLabel;                //副标题

//subtitle在下边
@property (weak, nonatomic) IBOutlet UIView *subtitleBottomContainerView;
@property (weak, nonatomic) IBOutlet UILabel *subtitleBottomTitleLabel;         //主标题
@property (weak, nonatomic) IBOutlet UILabel *subtitleBottomLabel;              //副标题

//subtitle在右边
@property (weak, nonatomic) IBOutlet UILabel *subtitleRightLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UISwitch *stateSwitch;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subtitleRightTrail;    //45

@property (assign, nonatomic) YSCTableViewCellStyle style;
@property (copy, nonatomic) StateChanged stateChanged;

@end
