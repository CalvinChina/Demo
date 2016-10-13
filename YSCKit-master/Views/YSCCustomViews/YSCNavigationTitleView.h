//
//  YSCNavigationTitleView.h
//  YSCKit
//
//  Created by yangshengchao on 15/8/21.
//  Copyright (c) 2015年 Builder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSCNavigationTitleView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;

+ (instancetype)CreateTitleViewByWidth:(CGFloat)width;

@end
