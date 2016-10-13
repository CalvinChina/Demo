//
//  YSCNavigationTitleView.m
//  YSCKit
//
//  Created by yangshengchao on 15/8/21.
//  Copyright (c) 2015年 Builder. All rights reserved.
//

#import "YSCNavigationTitleView.h"

@implementation YSCNavigationTitleView

+ (instancetype)CreateTitleViewByWidth:(CGFloat)width {
    YSCNavigationTitleView *titleView = [[YSCNavigationTitleView alloc] initWithFrame:AUTOLAYOUT_CGRECT(0, 0, width, 75)];
    return titleView;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = kDefaultNaviBarTitleFont;
        self.titleLabel.textColor = kDefaultNaviBarTitleColor;
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@AUTOLAYOUT_LENGTH(45));
        }];
        
        self.subTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.subTitleLabel.backgroundColor = [UIColor clearColor];
        self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.subTitleLabel.font = kDefaultNaviBarSubTitleFont;
        self.subTitleLabel.textColor = kDefaultNaviBarSubTitleColor;
        [self addSubview:self.subTitleLabel];
        [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
        }];
    }
    return self;
}

@end
