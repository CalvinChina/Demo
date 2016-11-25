//
//  YSCPhotoBrowseView.h
//  YSCKit
//
//  Created by yangshengchao on 15/8/12.
//  Copyright (c) 2015年 Builder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSCGridBrowseView.h"

//图片浏览器
//1. 支持无限数量图片
//2. 支持图片间隔大小的设置
//3. 支持水平和垂直两个方向浏览
//4. 支持
@interface YSCPhotoBrowseView : YSCGridBrowseView

@property (nonatomic, copy) YSCIntegerErrorBlock scrollAtIndex;

- (void)resetCurrentIndex:(NSInteger)index;

@end
