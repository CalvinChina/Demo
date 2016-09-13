//
//  UIColor+Util.h
//  CalvinUtils
//
//  Created by pisen on 16/2/4.
//  Copyright © 2016年 Calvin. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIColor (Util)

+ (UIColor *)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;
+ (UIColor *)colorWithHex:(NSInteger)hexValue;
+ (NSString *)hexFromUIColor:(UIColor*) color;

#pragma mark - theme colors
//+ (UIColor *)colorOfTheme;
//
//+ (UIColor *)colorOfBackground;
//
//+ (UIColor *)colorOfLine;
//
//+ (UIColor *)colorOfBorder;
//
//+ (UIColor *)colorOfTitle;
//
//+ (UIColor *)colorOfSelectedTitle;




@end
