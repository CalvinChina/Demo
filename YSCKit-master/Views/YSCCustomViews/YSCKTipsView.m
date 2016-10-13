//
//  YSCTipsView.m
//  YSCKit
//
//  Created by YangShengchao on 15/4/12.
//  Copyright (c) 2015年 yangshengchao. All rights reserved.
//

#import "YSCKTipsView.h"

@interface YSCKTipsView ()

@end

@implementation YSCKTipsView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.actionButton.backgroundColor = kDefaultTipViewButtonColor;
    [self resetConstraintOfView];
    [self resetFontSizeOfView];
    
    [UIView makeRoundForView:self.actionButton withRadius:5];
}

+ (instancetype)CreateYSCTipsViewOnView:(UIView *)contentView
                              edgeInsets:(UIEdgeInsets)edgeInsets
                             withMessage:(NSString *)message
                                iconImage:(UIImage *)image
                             buttonTitle:(NSString *)buttonTitle
                            buttonAction:(YSCBlock)buttonAction {
    YSCKTipsView *tipsView = FirstViewInXib(@"YSCKTipsView");
    tipsView.iconImageView.image = image;
    tipsView.messageLabel.text = message;
    [tipsView.actionButton setTitle:buttonTitle forState:UIControlStateNormal];
    if (buttonAction) {
        [tipsView.actionButton bk_addEventHandler:^(id sender) {
            buttonAction();
        } forControlEvents:UIControlEventTouchUpInside];
    }
    tipsView.left = edgeInsets.left;
    tipsView.top = edgeInsets.top;
    tipsView.width = contentView.width - edgeInsets.left - edgeInsets.right;
    tipsView.height = contentView.height - edgeInsets.top - edgeInsets.bottom;
    [contentView addSubview:tipsView];
    return tipsView;
}

- (void)resetFrameWithEdgeInsets:(UIEdgeInsets)edgeInsets {
    UIView *contentView = self.superview;
    self.left = edgeInsets.left;
    self.top = edgeInsets.top;
    self.width = contentView.width - edgeInsets.left - edgeInsets.right;
    self.height = contentView.height - edgeInsets.top - edgeInsets.bottom;
}

@end
