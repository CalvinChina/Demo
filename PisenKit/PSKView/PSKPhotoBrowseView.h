//
//  PSKPhotoBrowseView.h
//  PisenKit
//
//  Created by 杨胜超 on 16/7/5.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import "PSKGridBrowseView.h"

//====================================
//
//  图片浏览器
//  1. 支持无限数量图片
//  2. 支持图片间隔大小的设置
//  3. 支持水平和垂直两个方向浏览
//  4. 支持
//
//====================================
@interface PSKPhotoBrowseView : PSKGridBrowseView

@property (nonatomic, copy) void (^scrollAtIndex)(NSInteger pageIndex);

- (void)resetCurrentIndex:(NSInteger)index;

@end
