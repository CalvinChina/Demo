//
//  UIImageView+Additions.m
//  YSCKit
//
//  Created by  YangShengchao on 14-7-28.
//  Copyright (c) 2014年 YSHCH_TEAM. All rights reserved.
//

#import "UIImageView+Additions.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation UIImageView (Additions)

@end


/**
 *  网络图片缓存处理
 */
@implementation UIImageView (Cache)

- (void)setImageWithURLString:(NSString *)urlString {
    [self setImageWithURLString:urlString completed:nil];
}
- (void)setImageWithURLString:(NSString *)urlString completed:(SetImageCompletionBlock)complete {
    [self setImageWithURLString:urlString placeholderImage:nil withFadeIn:YES completed:complete];
}
- (void)setImageWithURLString:(NSString *)urlString withFadeIn:(BOOL)withAnimate {
    [self setImageWithURLString:urlString placeholderImage:nil withFadeIn:withAnimate completed:nil];
}

- (void)setImageWithURLString:(NSString *)urlString placeholderImageName:(NSString *)placeholderImageName {
    [self setImageWithURLString:urlString placeholderImageName:placeholderImageName completed:nil];
}
- (void)setImageWithURLString:(NSString *)urlString placeholderImageName:(NSString *)placeholderImageName completed:(SetImageCompletionBlock)complete {
    [self setImageWithURLString:urlString placeholderImage:[UIImage imageNamed:placeholderImageName] withFadeIn:YES completed:complete];
}
- (void)setImageWithURLString:(NSString *)urlString placeholderImageName:(NSString *)placeholderImageName withFadeIn:(BOOL)withAnimate {
    [self setImageWithURLString:urlString placeholderImage:[UIImage imageNamed:placeholderImageName] withFadeIn:withAnimate completed:nil];
}

- (void)setImageWithURLString:(NSString *)urlString placeholderImage:(UIImage *)holderImage {
    [self setImageWithURLString:urlString placeholderImage:holderImage completed:nil];
}
- (void)setImageWithURLString:(NSString *)urlString placeholderImage:(UIImage *)holderImage completed:(SetImageCompletionBlock)complete {
    [self setImageWithURLString:urlString placeholderImage:holderImage withFadeIn:YES completed:complete];
}
- (void)setImageWithURLString:(NSString *)urlString placeholderImage:(UIImage *)holderImage withFadeIn:(BOOL)withAnimate {
    [self setImageWithURLString:urlString placeholderImage:holderImage withFadeIn:withAnimate completed:nil];
}

/**
 *
 *
 *  @param urlString            网络图片完整url地址
 *  @param placeholderImage     用于默认替代的图片对象
 *  @param thumbnail            是否采用缩略图
 *  @param withAnimate          是否动画显示
 */
- (void)setImageWithURLString:(NSString *)urlString
             placeholderImage:(UIImage *)placeholderImage
                   withFadeIn:(BOOL)withAnimate
                    completed:(SetImageCompletionBlock)complete {
    WeakSelfType blockSelf = self;
    //设置基本参数
    self.clipsToBounds = YES;
    NSString *newUrlString = [NSString trimString:[urlString copy]];
    if (nil == placeholderImage) {
        placeholderImage = kDefaultImage;
        self.image = kDefaultImage;
        self.backgroundColor = kDefaultImageBackColor;
        
        //如果默认图片比imageView要小，则居中显示之
        if (self.image.size.width < self.width && self.image.size.height < self.height) {
            self.contentMode = UIViewContentModeCenter;
        }
        else {//等比例缩放，且全部显示出来
            self.contentMode = UIViewContentModeScaleAspectFit;
        }
    }
    else {
        [self setCustomImage:placeholderImage];
    }
    
    //判断是否本地图片
    if([NSString isNotEmpty:newUrlString]) {
        if (NO == [NSString isContains:@"/" inString:newUrlString]) {//简单判断是不是本地图片
            UIImage *localImage = [UIImage imageNamed:newUrlString];
            if(localImage) {
                [self setCustomImage:localImage];
                return;
            }
        }
    }
    else {
        return;//url为空就直接返回默认图片
    }
    
    //是否本地缓存图片
    if ([NSString isNotUrl:newUrlString]) {
        UIImage *cacheImage = [UIImage imageWithContentsOfFile:newUrlString];
        if (cacheImage) {
            [self setCustomImage:cacheImage];
            return;
        }
    }
    
    //处理相对路径
    if ([NSString isNotUrl:newUrlString]) {
        newUrlString = [[NSString replaceString:kResPathAppResUrl byRegex:@"/+$" to:@""] stringByAppendingFormat:@"/%@",
                        [NSString replaceString:newUrlString byRegex:@"^/+" to:@""]];
    }
    //处理相对路径后仍然不是合法的url，则返回默认图片
    if ([NSString isNotUrl:newUrlString]) {
        return;
    }
    newUrlString = newUrlString.URLEncodeString;

    //采用SDWebImage的缓存方案
    if (YSCInstance.isReachableViaWiFi ||
        [YSCGetObject(kParamEnableDownloadImage) boolValue]) {//wifi环境下一定会从网络下载图片
        [self sd_setImageWithURL:[NSURL URLWithString:newUrlString]
                placeholderImage:placeholderImage
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)  {
                           if ( ! error) {
                               blockSelf.backgroundColor = [UIColor clearColor];
                               blockSelf.contentMode = UIViewContentModeScaleAspectFill;//等比例缩放，且全部填充(会切掉部分图片)
                               
                               if (withAnimate) {
                                   blockSelf.alpha = 0;
                                   [UIView animateWithDuration:0.2f
                                                         delay:0
                                                       options:UIViewAnimationOptionCurveEaseIn
                                                    animations:^{
                                                        blockSelf.alpha = 1.0f;
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
        if (nil == image) {
            image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[[NSURL URLWithString:newUrlString] absoluteString]];//再从硬盘中查找
        }
        [self setCustomImage:image];
    }
}

- (void)setCustomImage:(UIImage *)image {
    ReturnWhenObjectIsEmpty(image);
    self.image = image;
    self.backgroundColor = [UIColor clearColor];
    self.contentMode = UIViewContentModeScaleAspectFill;//等比例缩放，且全部显示出来
}

@end



@implementation UIImage (Scale)

//截取部分图像
-(UIImage*)getSubImage:(CGRect)rect {
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return smallImage;
}

//等比例缩放 //注意：此方法会导致UIImageView的contentMode不起作用
-(UIImage*)scaleToSize:(CGSize)size {
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
    float verticalRadio = size.height*1.0/height;
    float horizontalRadio = size.width*1.0/width;
    
    float radio = 1;
    if(verticalRadio>1 && horizontalRadio>1) {
        radio = MIN(verticalRadio, horizontalRadio);
    }
    else {
        radio = MAX(verticalRadio, horizontalRadio);
    }
    
    width = width*radio;
    height = height*radio;
    
    int xPos = (size.width - width)/2;
    int yPos = (size.height-height)/2;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(xPos, yPos, width, height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

@end
