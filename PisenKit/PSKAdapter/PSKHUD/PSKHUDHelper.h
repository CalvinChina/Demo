//
//  PSKHUDHelper.h
//  PisenKit
//
//  Created by 杨胜超 on 16/7/1.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSKHUDHelper : NSObject
// 显示HUD
+ (void)showHUDOnView:(UIView *)view
              message:(NSString *)message
           edgeInsets:(UIEdgeInsets)edgeInsets
      backgroundColor:(UIColor *)backgroundColor;

+ (void)showHUDOnView:(UIView *)view message:(NSString *)message;
+ (void)showHUDOnView:(UIView *)view;

+ (void)showHUDOnView:(UIView *)view message:(NSString *)message edgeInsets:(UIEdgeInsets)edgeInsets;
+ (void)showHUDOnView:(UIView *)view edgeInsets:(UIEdgeInsets)edgeInsets;

+ (void)showHUDOnKeyWindowWithMesage:(NSString *)message;
+ (void)showHUDOnKeyWindow;

// 关闭HUD
+ (void)hideHUDOnView:(UIView *)view;
+ (void)hideHUDOnKeyWindow;

// 显示N秒后自动关闭HUD
+ (void)showHUDThenHideOnView:(UIView *)view message:(NSString *)message afterDelay:(NSTimeInterval)delay;
+ (void)showHUDThenHideOnView:(UIView *)view message:(NSString *)message;
+ (void)showHUDThenHideOnKeyWindowWithMessage:(NSString *)message;
@end
