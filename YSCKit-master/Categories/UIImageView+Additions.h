//
//  UIImageView+Additions.h
//  YSCKit
//
//  Created by  YangShengchao on 14-7-28.
//  Copyright (c) 2014年 YSHCH_TEAM. All rights reserved.
//  FORMATED!
//

#import <UIKit/UIKit.h>

typedef void(^SetImageCompletionBlock)(UIImage *image, NSError *error);

@interface UIImageView (Additions)

@end


/**
 *  网络图片缓存处理
 */
@interface UIImageView (Cache)

/**
 *  加载网络图片
 *
 *  @param urlString 图片的完整url地址
 */
- (void)setImageWithURLString:(NSString *)urlString;
- (void)setImageWithURLString:(NSString *)urlString completed:(SetImageCompletionBlock)complete;
- (void)setImageWithURLString:(NSString *)urlString withFadeIn:(BOOL)withAnimate;

- (void)setImageWithURLString:(NSString *)urlString placeholderImageName:(NSString *)placeholderImageName;
- (void)setImageWithURLString:(NSString *)urlString placeholderImageName:(NSString *)placeholderImageName completed:(SetImageCompletionBlock)complete;
- (void)setImageWithURLString:(NSString *)urlString placeholderImageName:(NSString *)placeholderImageName withFadeIn:(BOOL)withAnimate;

- (void)setImageWithURLString:(NSString *)urlString placeholderImage:(UIImage *)holderImage;
- (void)setImageWithURLString:(NSString *)urlString placeholderImage:(UIImage *)holderImage completed:(SetImageCompletionBlock)complete;
- (void)setImageWithURLString:(NSString *)urlString placeholderImage:(UIImage *)holderImage withFadeIn:(BOOL)withAnimate;
/**
 *  处理部分图形模糊
 */

@end


/**
 *  缩放Image
 */
@interface UIImage (Scale)

-(UIImage*)getSubImage:(CGRect)rect;
-(UIImage*)scaleToSize:(CGSize)size;

@end
