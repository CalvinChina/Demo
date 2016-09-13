//
//  QRCode.h
//  CalvinUtils
//
//  Created by pisen on 16/2/4.
//  Copyright © 2016年 Calvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QRCode : NSObject

#pragma mark - 生成二维码
+ (UIImage *)createQRCodeImageWithString:(NSString *)str size:(CGSize)size;
+ (UIImage *)addImageLogo:(UIImage *)srcImg centerLogoImage:(UIImage *)LogoImage logoSize:(CGSize)logoSize;

@end
