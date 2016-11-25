//
//  UIImageView+YSCKit.h
//  YSCKit
//
//  Created by  YangShengchao on 14-7-28.
//  Copyright (c) 2014年 YSHCH_TEAM. All rights reserved.
//  FORMATED!
//

#import <UIKit/UIKit.h>

typedef void(^SetImageCompletionBlock)(UIImage *image, NSError *error);

@interface UIImageView (YSCKit)

@end


/**
 *  网络图片缓存处理
 */
@interface UIImageView (Cache)
- (void)ysc_setImageWithURLString:(NSString *)urlString;
- (void)ysc_setImageWithURLString:(NSString *)urlString completed:(SetImageCompletionBlock)complete;
- (void)ysc_setImageWithURLString:(NSString *)urlString withFadeIn:(BOOL)withAnimate;
- (void)ysc_setImageWithURLString:(NSString *)urlString withFadeIn:(BOOL)withAnimate completed:(SetImageCompletionBlock)complete;

- (void)ysc_setImageWithURLString:(NSString *)urlString placeholderImageName:(NSString *)placeholderImageName;
- (void)ysc_setImageWithURLString:(NSString *)urlString placeholderImageName:(NSString *)placeholderImageName completed:(SetImageCompletionBlock)complete;
- (void)ysc_setImageWithURLString:(NSString *)urlString placeholderImageName:(NSString *)placeholderImageName withFadeIn:(BOOL)withAnimate;

- (void)ysc_setImageWithURLString:(NSString *)urlString placeholderImage:(UIImage *)holderImage;
- (void)ysc_setImageWithURLString:(NSString *)urlString placeholderImage:(UIImage *)holderImage completed:(SetImageCompletionBlock)complete;
- (void)ysc_setImageWithURLString:(NSString *)urlString placeholderImage:(UIImage *)holderImage withFadeIn:(BOOL)withAnimate;
@end

