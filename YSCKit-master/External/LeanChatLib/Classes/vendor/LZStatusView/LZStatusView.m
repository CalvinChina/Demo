//
//  CDNetworkStateView.m
//  LeanChat
//
//  Created by lzw on 15/1/5.
//  Copyright (c) 2015年 LeanCloud. All rights reserved.
//

#import "LZStatusView.h"

static CGFloat kLZStatusImageViewHeight = 20;
static CGFloat kLZHorizontalSpacing = 15;
static CGFloat kLZHorizontalLittleSpacing = 5;

@interface LZStatusView ()

@property (nonatomic, strong) UIImageView *statusImageView;

@property (nonatomic, strong) UILabel *statusLabel;

@end

@implementation LZStatusView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:199 / 255.0 blue:199 / 255.0 alpha:1];
    [self addSubview:self.statusImageView];
    [self addSubview:self.statusLabel];
}

#pragma mark - Propertys

- (UIImageView *)statusImageView {
    if (_statusImageView == nil) {
        _statusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kLZHorizontalSpacing, (kLZStatusViewHight - kLZStatusImageViewHeight) / 2, kLZStatusImageViewHeight, kLZStatusImageViewHeight)];
        _statusImageView.image = [UIImage imageNamed:@"messageSendFail"];
    }
    return _statusImageView;
}

- (UILabel *)statusLabel {
    if (_statusLabel == nil) {
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_statusImageView.frame) + kLZHorizontalLittleSpacing, 0, self.frame.size.width - CGRectGetMaxX(_statusImageView.frame) - kLZHorizontalSpacing - kLZHorizontalLittleSpacing, kLZStatusViewHight)];
        _statusLabel.font = [UIFont systemFontOfSize:15.0];
        _statusLabel.textColor = [UIColor grayColor];
        _statusLabel.text = @"会话断开，请检查网络";
    }
    return _statusLabel;
}

@end
