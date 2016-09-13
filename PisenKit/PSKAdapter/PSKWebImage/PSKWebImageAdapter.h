//
//  PSKWebImageAdapter.h
//  PisenKitDemo
//
//  Created by 杨胜超 on 16/7/14.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSKWebImageAdapter : NSObject

+ (UIImage *)cachedImageForKey:(NSString *)key;
+ (void)downloadWebImageWithURL:(NSURL *)url onImageView:(UIImageView *)imageView placeholderImage:(UIImage *)placeholderImage completed:(void(^)(UIImage *image, NSError *error))completed;

@end
