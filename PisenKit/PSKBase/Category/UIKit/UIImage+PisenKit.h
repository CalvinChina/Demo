//
//  UIImage+PisenKit.h
//  PisenKit
//
//  Created by 杨胜超 on 16/6/30.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import <UIKit/UIKit.h>

//==============================================================================
//
//  常用方法
//
//==============================================================================
@interface UIImage (PisenKit)
// 旋转
- (UIImage*)psk_imageRotatedByDegrees:(CGFloat)degrees;

// 调整大小
- (UIImage*)psk_resizedImageToSize:(CGSize)dstSize;
- (UIImage*)psk_resizedImageToFitInSize:(CGSize)boundingSize scaleIfSmaller:(BOOL)scale;

// 截取部分图像
- (UIImage*)psk_getSubImage:(CGRect)rect;
// 等比例缩放 注意：此方法会导致UIImageView的contentMode不起作用
- (UIImage*)psk_scaleToSize:(CGSize)size;

// 拉伸图片
- (UIImage *)psk_stretchImageWithPoint:(CGPoint)point;
- (UIImage *)psk_stretchImageWithEdgeInset:(UIEdgeInsets)edgeInset;

// 模糊图片 (0.0-1.0)
- (UIImage *)psk_blurryImageWithBlurLevel:(CGFloat)blur;
- (UIImage *)psk_blurryImage1WithBlurLevel:(CGFloat)blur;

// APP进入后台时添加模糊效果
+ (void)psk_addScreenBlurEffect;
// APP从后台恢复运行时移除模糊效果
+ (void)psk_removeScreenBlurEffect;
@end
