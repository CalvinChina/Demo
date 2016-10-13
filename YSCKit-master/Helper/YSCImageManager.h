//
//  YSCImageManager.h
//  YSCKit
//
//  Created by yangshengchao on 16/1/28.
//  Copyright © 2016年 Builder. All rights reserved.
//


/**
 *  image常用操作
 */

@interface YSCImageManager : NSObject
//判断图片是否是透明的
+ (BOOL)HasAlpha:(UIImage *)image;

//调整图片质量
+ (UIImage *)AdjustImage:(UIImage *)image;
+ (UIImage *)AdjustImage:(UIImage *)image withQuality:(ImageQuality)quality;

//调整图片大小
+ (UIImage *)ResizeImage:(UIImage *)image;
+ (UIImage *)ResizeImage:(UIImage *)image toSize:(CGSize)size;
+ (UIImage *)ResizeImage:(UIImage *)image toSize:(CGSize)size scale:(BOOL)scale;

//拉伸图片
+ (UIImage *)StretchImage:(UIImage *)image withPoint:(CGPoint)point;
+ (UIImage *)StretchImage:(UIImage *)image withEdgeInset:(UIEdgeInsets)edgeInset;

//模糊图片1
+ (UIImage *)BlurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;

//模糊图片2 0.0 to 1.0
+ (UIImage*)BlurryImage1:(UIImage *)image withBlurLevel:(CGFloat)blurAmount;

//后台模糊效果
+ (void)AddBlurEffect;
//移除后台模糊
+ (void)RemoveBlurEffect;
@end
