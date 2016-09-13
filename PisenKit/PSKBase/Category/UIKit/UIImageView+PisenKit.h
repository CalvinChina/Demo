//
//  UIImageView+PisenKit.h
//  PisenKit
//
//  Created by 杨胜超 on 16/6/30.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef kPathAppResUrl
    #define kPathAppResUrl          kPathDomain     // 资源文件前缀
#endif

//==============================================================================
//
//  显示网络图片
//
//==============================================================================
@interface UIImageView (PisenKit)
- (void)psk_setImageWithURLString:(NSString *)urlString;
- (void)psk_setImageWithURLString:(NSString *)urlString
                        completed:(void(^)(UIImage *image, NSError *error))complete;
- (void)psk_setImageWithURLString:(NSString *)urlString
                        animation:(BOOL)animation;
- (void)psk_setImageWithURLString:(NSString *)urlString
                        animation:(BOOL)animation
                        completed:(void(^)(UIImage *image, NSError *error))complete;

- (void)psk_setImageWithURLString:(NSString *)urlString
                 placeholderImage:(UIImage *)holderImage;
- (void)psk_setImageWithURLString:(NSString *)urlString
                 placeholderImage:(UIImage *)holderImage
                        completed:(void(^)(UIImage *image, NSError *error))complete;
- (void)psk_setImageWithURLString:(NSString *)urlString
                 placeholderImage:(UIImage *)holderImage
                        animation:(BOOL)animation;
- (void)psk_setImageWithURLString:(NSString *)urlString
                 placeholderImage:(UIImage *)holderImage
                        animation:(BOOL)animation
                        completed:(void(^)(UIImage *image, NSError *error))complete;
@end
