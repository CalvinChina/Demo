//
//  UIImage+common.m
//  KanPian
//
//  Created by Pisen on 16/6/27.
//  Copyright © 2016年 SMIT. All rights reserved.
//

#import "UIImage+common.h"

@implementation UIImage (common)

+ (UIImage*) createImageWithColor: (UIColor*) color Size:(CGSize)size
{
    CGRect rect=CGRectMake(0,0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
