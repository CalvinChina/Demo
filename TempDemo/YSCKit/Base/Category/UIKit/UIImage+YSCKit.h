//
//  UIImage+YSCKit.h
//  YSCKit
//
//  Created by  YangShengchao on 14-7-28.
//  Copyright (c) 2014年 YSHCH_TEAM. All rights reserved.
//

#import <UIKit/UIKit.h>
 
@interface UIImage (YSCKit)
// 旋转
- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees;

// 调整大小
- (UIImage*)resizedImageToSize:(CGSize)dstSize;
- (UIImage*)resizedImageToFitInSize:(CGSize)boundingSize scaleIfSmaller:(BOOL)scale;

// 截取部分图像
-(UIImage*)getSubImage:(CGRect)rect;
// 等比例缩放 注意：此方法会导致UIImageView的contentMode不起作用
-(UIImage*)scaleToSize:(CGSize)size;

// 判断图片是否是透明的
- (BOOL)hasAlpha;

// 拉伸图片
- (UIImage *)stretchImageWithPoint:(CGPoint)point;
- (UIImage *)stretchImageWithEdgeInset:(UIEdgeInsets)edgeInset;

// 模糊图片 (0.0-1.0)
- (UIImage *)blurryImageWithBlurLevel:(CGFloat)blur;
- (UIImage*)blurryImage1WithBlurLevel:(CGFloat)blurAmount;

// 后台模糊效果
+ (void)addScreenBlurEffect;
// 移除后台模糊
+ (void)removeScreenBlurEffect;
@end
