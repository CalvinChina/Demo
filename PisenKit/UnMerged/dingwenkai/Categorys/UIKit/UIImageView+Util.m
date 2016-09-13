//
//  UIImageView+Util.m
//  CalvinUtils
//
//  Created by pisen on 16/2/4.
//  Copyright © 2016年 Calvin. All rights reserved.
//

#import "UIImageView+Util.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (Util)

+ (instancetype)imageViewWithFrame:(CGRect)frame imageName:(NSString*)imageName {
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:frame];
    imageView.image = [UIImage imageNamed:imageName];
    imageView.userInteractionEnabled = YES;
    
    return imageView;
}

- (void)loadNetImageWithURLStr:(NSString *)url {
    [self loadNetImageWithURLStr:url placeholderImage:nil];
}

- (void)loadNetImageWithURLStr:(NSString *)url placeholderImage:(UIImage *)placeholderImage {
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholderImage options:0];
}


@end
