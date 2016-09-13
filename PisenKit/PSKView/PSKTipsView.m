//
//  PSKTipsView.m
//  PisenKit
//
//  Created by 杨胜超 on 16/7/1.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import "PSKTipsView.h"

@interface PSKTipsView ()
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@end

@implementation PSKTipsView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor blueColor];
    self.iconImageView.backgroundColor = [UIColor orangeColor];
    self.actionButton.backgroundColor = [UIColor redColor];//默认按钮背景色
    [self psk_resetFontSize];
    [self psk_resetConstraint];
    [self.actionButton psk_addCornerWithRadius:4];
}

#pragma mark - create
+ (instancetype)createPSKTipsViewOnView:(UIView *)contentView {
    return [self createPSKTipsViewOnView:contentView buttonAction:nil];
}
+ (instancetype)createPSKTipsViewOnView:(UIView *)contentView
                           buttonAction:(PSKBlock)buttonAction {
    return [self createPSKTipsViewOnView:contentView edgeInsets:UIEdgeInsetsZero withMessage:nil imageName:nil buttonTitle:nil buttonAction:buttonAction];
}
+ (instancetype)createPSKTipsViewOnView:(UIView *)contentView
                             edgeInsets:(UIEdgeInsets)edgeInsets
                            withMessage:(NSString *)message
                              imageName:(NSString *)imageName
                            buttonTitle:(NSString *)buttonTitle
                           buttonAction:(PSKBlock)buttonAction {
    // 0. 设置默认提示信息
    if ( ! contentView) {
        return nil;
    }
    // 1. 创建tipsview
    PSKTipsView *tipsView = nil;
    if (IS_NIB_EXISTS(@"PSKTipsView")) {
        tipsView = [PSKTipsView psk_loadFromNib];
    }
    else {
        tipsView = [PSKTipsView new];
    }
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
        imageName = PSKConfigManagerInstance.defaultImageName;
    }
    @weakiy(self);
    [self.iconImageView psk_setImageWithURLString:imageName completed:^(UIImage *image, NSError *error) {
        weak_self.iconImageView.backgroundColor = [UIColor clearColor];
    }];//兼容网络图片
}
- (void)resetMessage:(NSString *)message {
    if (OBJECT_IS_EMPTY(TRIM_STRING(message))) {
        message = PSKConfigManagerInstance.defaultEmptyMessage;
    }
    self.messageLabel.text = message;
}
- (void)resetActionWithButtonTitle:(NSString *)buttonTitle
                      buttonAction:(PSKBlock)buttonAction {
    if (OBJECT_IS_EMPTY(TRIM_STRING(buttonTitle))) {
        buttonTitle = @"重新加载";
    }
    if (buttonAction) {
        self.actionButton.hidden = NO;
        [self.actionButton setTitle:buttonTitle forState:UIControlStateNormal];
        [self.actionButton psk_reAddTouchUpInsideEventBlock:^(id sender) {
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
