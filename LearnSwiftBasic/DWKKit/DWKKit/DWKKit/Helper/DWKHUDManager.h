//
//  DWKHUDManager.h
//  DWKKit
//
//  Created by pisen on 16/10/18.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * toast 提示
 */

@interface DWKHUDManager : NSObject
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
