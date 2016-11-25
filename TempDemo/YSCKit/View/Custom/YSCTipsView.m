//
//  YSCTipsView.m
//  YSCKit
//
//  Created by YangShengchao on 15/4/12.
//  Copyright (c) 2015年 yangshengchao. All rights reserved.
//

#import "YSCTipsView.h"

@interface YSCTipsView ()
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@end

@implementation YSCTipsView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.actionButton.backgroundColor = [UIColor redColor];//默认按钮背景色
    [self resetSize];
    [self.actionButton addCornerWithRadius:AUTOLAYOUT_LENGTH(5)];
}

#pragma mark - create
+ (instancetype)createYSCTipsViewOnView:(UIView *)contentView {
    return [self createYSCTipsViewOnView:contentView buttonAction:nil];
}
+ (instancetype)createYSCTipsViewOnView:(UIView *)contentView
                           buttonAction:(YSCBlock)buttonAction {
    return [self createYSCTipsViewOnView:contentView edgeInsets:UIEdgeInsetsZero withMessage:nil imageName:nil buttonTitle:nil buttonAction:buttonAction];
}
+ (instancetype)createYSCTipsViewOnView:(UIView *)contentView
                             edgeInsets:(UIEdgeInsets)edgeInsets
                            withMessage:(NSString *)message
                              imageName:(NSString *)imageName
                            buttonTitle:(NSString *)buttonTitle
                           buttonAction:(YSCBlock)buttonAction {
    // 0. 设置默认提示信息
    if ( ! contentView) {
        return nil;
    }
    // 1. 创建tipsview
    YSCTipsView *tipsView = FIRST_VIEW_IN_XIB(@"YSCTipsView");
    [contentView addSubview:tipsView];
    [tipsView resetImageName:imageName];
    [tipsView resetMessage:message];
    [tipsView resetActionWithButtonTitle:buttonTitle buttonAction:buttonAction];
    [tipsView resetFrameWithEdgeInsets:edgeInsets];
    [tipsView _customSubviews];
    return tipsView;
}

// 可以重写该方法设置label 和 button
- (void)_customSubviews {
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self resetFrameWithEdgeInsets:self.edgeInsets];
    [self layoutIfNeeded];
}

#pragma mark - reset
- (void)resetFrameWithEdgeInsets:(UIEdgeInsets)edgeInsets {
    //NOTE: size is zero when put on UITableView !
//    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.edges.insets(edgeInsets);
//    }];
    
    _edgeInsets = edgeInsets;
    CGRect frame = self.superview.bounds;
    frame.origin.x = edgeInsets.left;
    frame.origin.y = edgeInsets.top;
    frame.size.width = CGRectGetWidth(self.superview.bounds) - (edgeInsets.left + edgeInsets.right);
    frame.size.height = CGRectGetHeight(self.superview.bounds) - (edgeInsets.top + edgeInsets.bottom);
    self.frame = frame;
}
- (void)resetImageName:(NSString *)imageName {
    if (OBJECT_IS_EMPTY(TRIM_STRING(imageName))) {
        imageName = YSCConfigDataInstance.defaultImageName;
    }
    @weakiy(self);
    [self.iconImageView ysc_setImageWithURLString:imageName completed:^(UIImage *image, NSError *error) {
        weak_self.iconImageView.backgroundColor = [UIColor clearColor];
    }];//兼容网络图片
}
- (void)resetMessage:(NSString *)message {
    if (OBJECT_IS_EMPTY(TRIM_STRING(message))) {
        message = YSCConfigDataInstance.defaultEmptyMessage;
    }
    self.messageLabel.text = message;
}
- (void)resetActionWithButtonTitle:(NSString *)buttonTitle
                      buttonAction:(YSCBlock)buttonAction {
    if (OBJECT_IS_EMPTY(TRIM_STRING(buttonTitle))) {
        buttonTitle = @"重新加载";
    }
    if (buttonAction) {
        self.actionButton.hidden = NO;
        [self.actionButton setTitle:buttonTitle forState:UIControlStateNormal];
        [self.actionButton reAddTouchUpInsideEventBlock:^(id sender) {
            if (buttonAction) {
                buttonAction();
            }
        }];
    }
    else {
        self.actionButton.hidden = YES;
    }
}

@end
