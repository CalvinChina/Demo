//
//  UIImageView+Util.h
//  CalvinUtils
//
//  Created by pisen on 16/2/4.
//  Copyright © 2016年 Calvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Util)

+ (instancetype)imageViewWithFrame:(CGRect)frame imageName:(NSString*)imageName;

// 加载网络图片：SDWebImage
- (void)loadNetImageWithURLStr:(NSString *)url;

- (void)loadNetImageWithURLStr:(NSString *)url placeholderImage:(UIImage *)placeholderImage;

@end
