//
//  UIImageView+PisenKit.m
//  PisenKit
//
//  Created by 杨胜超 on 16/6/30.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import "UIImageView+PisenKit.h"
#import "NSString+PisenKit.h"
#import "PSKWebImageAdapter.h"

//==============================================================================
//
//  设置网络图片
//
//==============================================================================
@implementation UIImageView (PisenKit)
- (void)psk_setImageWithURLString:(NSString *)urlString {
    [self _psk_setImageWithURLString:urlString placeholderImage:nil animation:NO completed:nil];
}
- (void)psk_setImageWithURLString:(NSString *)urlString
                        completed:(void(^)(UIImage *image, NSError *error))complete {
    [self _psk_setImageWithURLString:urlString placeholderImage:nil animation:NO completed:complete];
}
- (void)psk_setImageWithURLString:(NSString *)urlString
                        animation:(BOOL)animation {
    [self _psk_setImageWithURLString:urlString placeholderImage:nil animation:animation completed:nil];
}
- (void)psk_setImageWithURLString:(NSString *)urlString
                        animation:(BOOL)animation
                        completed:(void(^)(UIImage *image, NSError *error))complete {
    [self _psk_setImageWithURLString:urlString placeholderImage:nil animation:animation completed:complete];
}

- (void)psk_setImageWithURLString:(NSString *)urlString
                 placeholderImage:(UIImage *)holderImage {
    [self _psk_setImageWithURLString:urlString placeholderImage:holderImage animation:NO completed:nil];
}
- (void)psk_setImageWithURLString:(NSString *)urlString
                 placeholderImage:(UIImage *)holderImage
                        completed:(void(^)(UIImage *image, NSError *error))complete {
    [self _psk_setImageWithURLString:urlString placeholderImage:holderImage animation:NO completed:complete];
}
- (void)psk_setImageWithURLString:(NSString *)urlString
                 placeholderImage:(UIImage *)holderImage
                        animation:(BOOL)animation {
    [self _psk_setImageWithURLString:urlString placeholderImage:holderImage animation:animation completed:nil];
}
- (void)psk_setImageWithURLString:(NSString *)urlString
                 placeholderImage:(UIImage *)holderImage
                        animation:(BOOL)animation
                        completed:(void(^)(UIImage *image, NSError *error))complete {
    [self _psk_setImageWithURLString:urlString placeholderImage:holderImage animation:animation completed:complete];
}

/**
 *
 *
 *  @param urlString            网络图片完整url地址
 *  @param placeholderImage     用于默认替代的图片对象
 *  @param thumbnail            是否采用缩略图
 *  @param withAnimate          是否动画显示
 */
- (void)_psk_setImageWithURLString:(NSString *)urlString
                  placeholderImage:(UIImage *)placeholderImage
                         animation:(BOOL)animation
                         completed:(void(^)(UIImage *image, NSError *error))complete {
    @weakiy(self);
    //设置基本参数
    self.clipsToBounds = YES;
    NSString *newUrlString = [NSString psk_trimString:[urlString copy]];
    
    if ( ! placeholderImage) {
        placeholderImage = [UIImage imageNamed:PSKConfigManagerInstance.defaultImageName];
        self.image = [UIImage imageNamed:PSKConfigManagerInstance.defaultImageName];
        self.backgroundColor = PSKConfigManagerInstance.defaultImageBackColor;

        //如果默认图片比imageView要小，则居中显示之
        if (self.image.size.width < self.frame.size.width && self.image.size.height < self.frame.size.height) {
            self.contentMode = UIViewContentModeCenter;
        }
        else {//等比例缩放，且全部显示出来
            self.contentMode = UIViewContentModeScaleAspectFit;
        }
    }
    else {
        [self _psk_setCustomImage:placeholderImage];
    }

    //判断是否本地图片
    if(OBJECT_ISNOT_EMPTY(newUrlString)) {
        if ( ! [NSString psk_isContains:@"/" inString:newUrlString]) {//简单判断是不是本地图片
            UIImage *localImage = [UIImage imageNamed:newUrlString];
            if(localImage) {
                [self _psk_setCustomImage:localImage];
                if (complete) { complete(localImage,nil); }
                return;
            }
        }
    }
    else {
        if (complete) { complete(placeholderImage,nil); }
        return;//url为空就直接返回默认图片
    }

    //是否本地缓存图片
    if ([NSString psk_isWebUrlByString:newUrlString]) {
        UIImage *cacheImage = [UIImage imageWithContentsOfFile:newUrlString];
        if (cacheImage) {
            [self _psk_setCustomImage:cacheImage];
            if (complete) { complete(cacheImage,nil); }
            return;
        }
    }

    //处理相对路径
    if ([NSString psk_isNotWebUrlByString:newUrlString]) {
        newUrlString = [[NSString psk_replaceString:kPathAppResUrl byRegex:@"/+$" to:@""] stringByAppendingFormat:@"/%@",
                        [NSString psk_replaceString:newUrlString byRegex:@"^/+" to:@""]];
    }
    //处理相对路径后仍然不是合法的url，则返回默认图片
    if ([NSString psk_isNotWebUrlByString:newUrlString]) {
        if (complete) { complete(placeholderImage,nil); }
        return;
    }

    //采用SDWebImage的缓存方案(wifi环境下一定会从网络下载图片)
    if (PSKManagerInstance.isReachableViaWiFi || PSKConfigManagerInstance.isDownloadImageViaWWAN) {
        [PSKWebImageAdapter downloadWebImageWithURL:[NSURL URLWithString:newUrlString]
                                        onImageView:self placeholderImage:placeholderImage
                                          completed:^(UIImage *image, NSError *error) {
                                              weak_self.backgroundColor = [UIColor clearColor];
                                              weak_self.contentMode = UIViewContentModeScaleAspectFill;//等比例缩放，且全部填充(会切掉部分图片)
                                              if (animation) {
                                                  weak_self.alpha = 0;
                                                  [UIView animateWithDuration:0.2f
                                                                        delay:0
                                                                      options:UIViewAnimationOptionCurveEaseIn
                                                                   animations:^{
                                                                       weak_self.alpha = 1.0f;
                                                                   } completion:nil];
                                              }
                                              //设置回调
                                              if (complete) {
                                                  complete(image, error);
                                              }
                                          }];
    }
    else {//读取缓存图片
        UIImage *image = [PSKWebImageAdapter cachedImageForKey:[[NSURL URLWithString:newUrlString] absoluteString]];
        [self _psk_setCustomImage:image];
        //设置回调
        if (complete) {
            complete(image, nil);
        }
    }
}

- (void)_psk_setCustomImage:(UIImage *)image {
    RETURN_WHEN_OBJECT_IS_EMPTY(image);
    self.image = image;
    self.backgroundColor = [UIColor clearColor];
    self.contentMode = UIViewContentModeScaleAspectFit;//等比例缩放，且全部显示出来
}
@end
