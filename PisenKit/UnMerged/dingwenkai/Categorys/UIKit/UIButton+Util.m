//
//  UIButton+Util.m
//  CalvinUtils
//
//  Created by pisen on 16/2/4.
//  Copyright © 2016年 Calvin. All rights reserved.
//

#import "UIButton+Util.h"

@implementation UIButton (Util)

+ (instancetype)buttonWithFrame:(CGRect)frame image:(NSString *)imageName addTarget:(id)target action:(SEL)action forControlEvent:(UIControlEvents)controlEvent {
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn addTarget:target action:action forControlEvents:controlEvent];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    return btn;
}

+ (instancetype)buttonWithFrame:(CGRect)frame backgroundImage:(NSString *)backgroundImageName addTarget:(id)target action:(SEL)action forControlEvent:(UIControlEvents)controlEvent {
    UIButton * btn = [UIButton buttonWithFrame:frame image:nil addTarget:target action:action forControlEvent:controlEvent];
    [btn setBackgroundImage:[UIImage imageNamed:backgroundImageName] forState:UIControlStateNormal];
    
    return btn;
}

+ (instancetype)buttonWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor*)titleColor fontSize:(CGFloat)fontSize backgroundColor:(UIColor*)backgroundColor addTarget:(id)target action:(SEL)action forControlEvent:(UIControlEvents)controlEvent {
    UIButton *btn = [UIButton buttonWithFrame:frame image:nil addTarget:target action:action forControlEvent:controlEvent];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    btn.backgroundColor = backgroundColor;
    
    return btn;
}

+ (instancetype)buttonWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor*)titleColor fontSize:(CGFloat)fontSize backgroundColor:(UIColor*)backgroundColor backgroundImage:(NSString*)backgroundImageName image:(NSString*)imageName addTarget:(id)target action:(SEL)action forControlEvent:(UIControlEvents)controlEvent {
    UIButton * btn = [UIButton buttonWithFrame:frame title:title titleColor:titleColor fontSize:fontSize backgroundColor:backgroundColor addTarget:target action:action forControlEvent:controlEvent];
    [btn setBackgroundImage:[UIImage imageNamed:backgroundImageName] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    return btn;
}

@end
