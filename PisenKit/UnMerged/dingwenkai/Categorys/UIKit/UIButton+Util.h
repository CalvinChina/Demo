//
//  UIButton+Util.h
//  CalvinUtils
//
//  Created by pisen on 16/2/4.
//  Copyright © 2016年 Calvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Util)

+ (instancetype)buttonWithFrame:(CGRect)frame image:(NSString *)imageName addTarget:(id)target action:(SEL)action forControlEvent:(UIControlEvents)controlEvent;

+ (instancetype)buttonWithFrame:(CGRect)frame backgroundImage:(NSString *)backgroundImageName addTarget:(id)target action:(SEL)action forControlEvent:(UIControlEvents)controlEvent;

+ (instancetype)buttonWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor*)titleColor fontSize:(CGFloat)fontSize backgroundColor:(UIColor*)backgroundColor addTarget:(id)target action:(SEL)action forControlEvent:(UIControlEvents)controlEvent;

+ (instancetype)buttonWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor*)titleColor fontSize:(CGFloat)fontSize backgroundColor:(UIColor*)backgroundColor backgroundImage:(NSString*)backgroundImageName image:(NSString*)imageName addTarget:(id)target action:(SEL)action forControlEvent:(UIControlEvents)controlEvent;

@end
