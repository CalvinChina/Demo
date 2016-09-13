//
//  UIImage+Util.h
//  CalvinUtils
//
//  Created by pisen on 16/2/4.
//  Copyright © 2016年 Calvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Util)

- (UIImage *)imageMaskedWithColor:(UIColor *)maskColor;
- (UIImage *)cropToRect:(CGRect)rect;

// 压缩图片
- (UIImage *)imageScaledToSize:(CGSize)newSize;

// 压缩图片为预设大小
- (UIImage *)compressed;

@end
