//
//  PSKWebImageAdapter.m
//  PisenKitDemo
//
//  Created by 杨胜超 on 16/7/14.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import "PSKWebImageAdapter.h"
#import "UIImageView+WebCache.h"

@implementation PSKWebImageAdapter
+ (UIImage *)cachedImageForKey:(NSString *)key {
    UIImage *image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:key];//先从内存中查找
    if ( ! image) {
        image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];//再从硬盘中查找
    }
    return image;
}
+ (void)downloadWebImageWithURL:(NSURL *)url onImageView:(UIImageView *)imageView placeholderImage:(UIImage *)placeholderImage completed:(void(^)(UIImage *image, NSError *error))completed {
    [imageView sd_setImageWithURL:url placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (completed) {
            completed(image, error);
        }
    }];
}
@end
