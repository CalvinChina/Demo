//
//  TPQRCode.m
//  CalvinUtils
//
//  Created by pisen on 16/2/4.
//  Copyright © 2016年 Calvin. All rights reserved.
//

#import "QRCode.h"

@implementation QRCode

#pragma mark - 生成二维码

/**
 *  生成二维码
 *
 *  @param str  二维码字符串
 *  @param size 二维码图片尺寸
 *
 *  @return 返回生成的图像
 */
+ (UIImage *)createQRCodeImageWithString:(NSString *)str size:(CGSize)size {
    return [QRCode createNonInterpolatedUIImageFormCIImage:[QRCode createQRForString:str] withSize:size.width];
}

#pragma mark - QRCodeGenerator
/**
 *  二维码生成器：将字符串信息写入CIImage图像
 *
 *  @param qrString 二维码所包含的字符串信息
 *
 *  @return 包含字符串信息的CIImage图像
 */
+ (CIImage *)createQRForString:(NSString *)qrString {
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    // 创建filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 设置内容和纠错级别
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    // 返回CIImage
    return qrFilter.outputImage;
}

#pragma mark - InterpolatedUIImage
/**
 *  二维码图片：将包含字符串信息的CIImage图像，转换成UIImage图像
 *
 *  @param image 包含字符串信息的CIImage图像
 *  @param size  二维码图片尺寸
 *
 *  @return 二维码图片
 */
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CGColorSpaceRelease(cs);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    UIImage *aImage = [UIImage imageWithCGImage:scaledImage];
    CGImageRelease(scaledImage);
    return aImage;
}

/**
 *  图像中间加logo图片
 *
 *  @param srcImg    原图像
 *  @param LogoImage logo图像
 *  @param logoSize  logo图像尺寸
 *
 *  @return 加Logo的图像
 */
+ (UIImage *)addImageLogo:(UIImage *)srcImg centerLogoImage:(UIImage *)LogoImage logoSize:(CGSize)logoSize {
    UIGraphicsBeginImageContext(srcImg.size);
    [srcImg drawInRect:CGRectMake(0, 0, srcImg.size.width, srcImg.size.height)];
    
    CGRect rect = CGRectMake(srcImg.size.width/2 - logoSize.width/2, srcImg.size.height/2-logoSize.height/2, logoSize.width, logoSize.height);
    [LogoImage drawInRect:rect];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

@end
