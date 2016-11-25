//
//  UIImageView+YSCKit.m
//  YSCKit
//
//  Created by  YangShengchao on 14-7-28.
//  Copyright (c) 2014年 YSHCH_TEAM. All rights reserved.
//

#import "UIImageView+YSCKit.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (YSCKit)

@end


/**
 *  网络图片缓存处理
 */
@implementation UIImageView (Cache)

- (void)ysc_setImageWithURLString:(NSString *)urlString {
    [self _setImageWithURLString:urlString placeholderImage:nil withFadeIn:YES completed:nil];
}
- (void)ysc_setImageWithURLString:(NSString *)urlString completed:(SetImageCompletionBlock)complete {
    [self _setImageWithURLString:urlString placeholderImage:nil withFadeIn:YES completed:complete];
}
- (void)ysc_setImageWithURLString:(NSString *)urlString withFadeIn:(BOOL)withAnimate {
    [self _setImageWithURLString:urlString placeholderImage:nil withFadeIn:withAnimate completed:nil];
}
- (void)ysc_setImageWithURLString:(NSString *)urlString withFadeIn:(BOOL)withAnimate completed:(SetImageCompletionBlock)complete {
    [self _setImageWithURLString:urlString placeholderImage:nil withFadeIn:withAnimate completed:complete];
}

- (void)ysc_setImageWithURLString:(NSString *)urlString placeholderImageName:(NSString *)placeholderImageName {
    [self _setImageWithURLString:urlString placeholderImage:[UIImage imageNamed:placeholderImageName] withFadeIn:YES completed:nil];
}
- (void)ysc_setImageWithURLString:(NSString *)urlString placeholderImageName:(NSString *)placeholderImageName completed:(SetImageCompletionBlock)complete {
    [self _setImageWithURLString:urlString placeholderImage:[UIImage imageNamed:placeholderImageName] withFadeIn:YES completed:complete];
}
- (void)ysc_setImageWithURLString:(NSString *)urlString placeholderImageName:(NSString *)placeholderImageName withFadeIn:(BOOL)withAnimate {
    [self _setImageWithURLString:urlString placeholderImage:[UIImage imageNamed:placeholderImageName] withFadeIn:withAnimate completed:nil];
}

- (void)ysc_setImageWithURLString:(NSString *)urlString placeholderImage:(UIImage *)holderImage {
    [self _setImageWithURLString:urlString placeholderImage:holderImage withFadeIn:YES completed:nil];
}
- (void)ysc_setImageWithURLString:(NSString *)urlString placeholderImage:(UIImage *)holderImage completed:(SetImageCompletionBlock)complete {
    [self _setImageWithURLString:urlString placeholderImage:holderImage withFadeIn:YES completed:complete];
}
- (void)ysc_setImageWithURLString:(NSString *)urlString placeholderImage:(UIImage *)holderImage withFadeIn:(BOOL)withAnimate {
    [self _setImageWithURLString:urlString placeholderImage:holderImage withFadeIn:withAnimate completed:nil];
}

/**
 *
 *
 *  @param urlString            网络图片完整url地址
 *  @param placeholderImage     用于默认替代的图片对象
 *  @param thumbnail            是否采用缩略图
 *  @param withAnimate          是否动画显示
 */
- (void)_setImageWithURLString:(NSString *)urlString
             placeholderImage:(UIImage *)placeholderImage
                   withFadeIn:(BOOL)withAnimate
                    completed:(SetImageCompletionBlock)complete {
    @weakiy(self);
    //设置基本参数
    self.clipsToBounds = YES;
    NSString *newUrlString = [NSString trimString:[urlString copy]];
    if ( ! placeholderImage) {
        placeholderImage = [UIImage imageNamed:YSCConfigDataInstance.defaultImageName];
        self.image = [UIImage imageNamed:YSCConfigDataInstance.defaultImageName];
        self.backgroundColor = YSCConfigDataInstance.defaultImageBackColor;
        
        //如果默认图片比imageView要小，则居中显示之
        if (self.image.size.width < self.width && self.image.size.height < self.height) {
            self.contentMode = UIViewContentModeCenter;
        }
        else {//等比例缩放，且全部显示出来
            self.contentMode = UIViewContentModeScaleAspectFit;
        }
    }
    else {
        [self _setCustomImage:placeholderImage];
    }
    
    //判断是否本地图片
    if(OBJECT_ISNOT_EMPTY(newUrlString)) {
        if ( ! [NSString isContains:@"/" inString:newUrlString]) {//简单判断是不是本地图片
            UIImage *localImage = [UIImage imageNamed:newUrlString];
            if(localImage) {
                [self _setCustomImage:localImage];
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
    if ([NSString isNotWebUrl:newUrlString]) {
        UIImage *cacheImage = [UIImage imageWithContentsOfFile:newUrlString];
        if (cacheImage) {
            [self _setCustomImage:cacheImage];
            if (complete) { complete(cacheImage,nil); }
            return;
        }
    }
    
    //处理相对路径
    if ([NSString isNotWebUrl:newUrlString]) {
        newUrlString = [[NSString replaceString:kPathAppResUrl byRegex:@"/+$" to:@""] stringByAppendingFormat:@"/%@",
                        [NSString replaceString:newUrlString byRegex:@"^/+" to:@""]];
    }
    //处理相对路径后仍然不是合法的url，则返回默认图片
    if ([NSString isNotWebUrl:newUrlString]) {
        if (complete) { complete(placeholderImage,nil); }
        return;
    }

    //采用SDWebImage的缓存方案(wifi环境下一定会从网络下载图片)
    if (YSCDataInstance.isReachableViaWiFi || YSCConfigDataInstance.isDownloadImageViaWWAN) {
        [self sd_setImageWithURL:[NSURL URLWithString:newUrlString]
                placeholderImage:placeholderImage
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)  {
                           if ( ! error) {
                               weak_self.backgroundColor = [UIColor clearColor];
                               weak_self.contentMode = UIViewContentModeScaleAspectFill;//等比例缩放，且全部填充(会切掉部分图片)
                               
                               if (withAnimate) {
                                   weak_self.alpha = 0;
                                   [UIView animateWithDuration:0.2f
                                                         delay:0
                                                       options:UIViewAnimationOptionCurveEaseIn
                                                    animations:^{
                                                        weak_self.alpha = 1.0f;
                                                    } completion:nil];
                               }
                           }
                           //设置回调
                           if (complete) {
                               complete(image, error);
                           }
                       }];
    }
    else {//读取缓存图片
        UIImage *image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:[[NSURL URLWithString:newUrlString] absoluteString]];//先从内存中查找
        if ( ! image) {
            image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[[NSURL URLWithString:newUrlString] absoluteString]];//再从硬盘中查找
        }
        [self _setCustomImage:image];
        //设置回调
        if (complete) {
            complete(image, nil);
        }
    }
}

- (void)_setCustomImage:(UIImage *)image {
    RETURN_WHEN_OBJECT_IS_EMPTY(image);
    self.image = image;
    self.backgroundColor = [UIColor clearColor];
    self.contentMode = UIViewContentModeScaleAspectFit;//等比例缩放，且全部显示出来
}

@end
