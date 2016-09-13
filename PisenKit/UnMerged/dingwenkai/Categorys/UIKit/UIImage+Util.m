//
//  UIImage+Util.m
//  CalvinUtils
//
//  Created by pisen on 16/2/4.
//  Copyright © 2016年 Calvin. All rights reserved.
//

#import "UIImage+Util.h"

@implementation UIImage (Util)

- (UIImage *)imageMaskedWithColor:(UIColor *)maskColor {
    NSParameterAssert(maskColor != nil);
    
    CGRect imageRect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
    UIImage *newImage = nil;
    
    UIGraphicsBeginImageContextWithOptions(imageRect.size, NO, self.scale);
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextScaleCTM(context, 1.0f, -1.0f);
        CGContextTranslateCTM(context, 0.0f, -(imageRect.size.height));
        
        CGContextClipToMask(context, imageRect, self.CGImage);
        CGContextSetFillColorWithColor(context, maskColor.CGColor);
        CGContextFillRect(context, imageRect);
        
        newImage = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return newImage;
}


- (UIImage *)cropToRect:(CGRect)rect {
    CGImageRef imageRef   = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return croppedImage;
}

// 对图片尺寸进行压缩
- (UIImage *)imageScaledToSize:(CGSize)newSize {
    // 使用新的尺寸，创建一个新的图形编辑环境
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // 将旧图片放入新的图形编辑环境中进行绘制
    // Tell the old image to draw in this new context, with the desired new size
    [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // 从新的图形编辑环境中得到新图片
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 结束图形编辑环境
    // End the context
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)compressed {
    CGSize imageSize = self.size;
    imageSize.width =375;
    imageSize.height =imageSize.width*self.size.height/self.size.width;
    if (imageSize.height >300) {
        imageSize.height =320;
    }
    return [self imageScaledToSize:imageSize];
}

@end
