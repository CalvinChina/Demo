//
//  YSCTableViewCell.m
//  YSCKit
//
//  Created by yangshengchao on 14/11/17.
//  Copyright (c) 2014年 yangshengchao. All rights reserved.
//

#import "YSCTableViewCell.h"

@implementation YSCTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.style = YSCTableViewCellStyleTitle;
    self.stateSwitch.on = NO;
    self.subtitleLeftLabel.text = @"";
    self.subtitleBottomLabel.text = @"";
    self.subtitleRightLabel.text = @"";
    self.subtitleLeftTitleLabel.text = @"";
    self.subtitleBottomTitleLabel.text = @"";
}

+ (CGFloat)heightOfCellByObject:(NSObject *)object {
    return AUTOLAYOUT_LENGTH(80);
}

/**
 *  左边只支持以下几种显示格式：
 *  1. 只有title
 *  2. title + icon
 *  3. title + subtitle
 *  4. title + subtitle + icon
 *  右边只支持以下几种显示格式：
 *  1. 无
 *  2. 只有switch
 *  3. 只有arrow
 *  4. 只有subtitle
 *  5. arrow + subtitle
 *
 *  @param style
 */
- (void)setStyle:(YSCTableViewCellStyle)style {
    _style = style;
    
    //--------------------------
    //
    //  控制cell左边的显示
    //
    //--------------------------
    //控制icon是否显示
    if (YSCTableViewCellStyleIcon == (YSCTableViewCellStyleIcon & style)) {
        self.iconContainerWidth.constant = AUTOLAYOUT_LENGTH(66);
        self.iconContainerView.hidden = NO;
    }
    else {
        self.iconContainerWidth.constant = AUTOLAYOUT_LENGTH(0);
        self.iconContainerView.hidden = YES;
    }
    
    //控制副标题是否显示在主标题的下方
    if (YSCTableViewCellStyleSubtitleBottom == (YSCTableViewCellStyleSubtitleBottom & style)) {
        self.subtitleBottomContainerView.hidden = NO;
        self.subtitleLeftContainerView.hidden = YES;
    }
    else {
        self.subtitleBottomContainerView.hidden = YES;
        self.subtitleLeftContainerView.hidden = NO;
    }
    
    //--------------------------
    //
    //  控制cell右边的显示
    //
    //--------------------------
    //控制switch是否显示
    if (YSCTableViewCellStyleSwitch == (YSCTableViewCellStyleSwitch & style)) {
        self.stateSwitch.hidden = NO;
        self.arrowImageView.hidden = YES;
        self.subtitleRightLabel.hidden = YES;
    }
    else {
        self.stateSwitch.hidden = YES;
        self.subtitleRightLabel.hidden = YES;
        self.stateChanged = nil;
        
        //控制arrow是否显示
        if (YSCTableViewCellStyleArrow == (YSCTableViewCellStyleArrow & style)) {
            self.arrowImageView.hidden = NO;
        }
        else {
            self.arrowImageView.hidden = YES;
        }
        
        //控制右边subtitle的显示位置
        if (YSCTableViewCellStyleSubtitleRight == (YSCTableViewCellStyleSubtitleRight & style)) {
            self.subtitleRightLabel.hidden = NO;
            if (YSCTableViewCellStyleArrow == (YSCTableViewCellStyleArrow & style)) {
                self.subtitleRightTrail.constant = AUTOLAYOUT_LENGTH(45);
            }
            else {
                self.subtitleRightTrail.constant = AUTOLAYOUT_LENGTH(20);
            }
        }
    }
}

- (IBAction)stateChanged:(id)sender {
    if (YSCTableViewCellStyleSwitch == (YSCTableViewCellStyleSwitch & self.style) && self.stateChanged) {
        self.stateChanged(self.stateSwitch.on);
    }
}

@end
