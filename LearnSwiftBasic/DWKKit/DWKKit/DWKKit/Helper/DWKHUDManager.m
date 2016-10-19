//
//  DWKHUDManager.m
//  DWKKit
//
//  Created by pisen on 16/10/18.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

#import "DWKHUDManager.h"
#import "MBProgressHUD.h"

@implementation DWKHUDManager

#pragma mark - 显示HUD
+ (void)showHUDOnView:(UIView *)view
              message:(NSString *)message
           edgeInsets:(UIEdgeInsets)edgeInsets
      backgroundColor:(UIColor *)backgroundColor {
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if ( ! hud) {
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    hud.backgroundColor = (backgroundColor ? backgroundColor : [UIColor clearColor]);
    hud.label.text = message;
    hud.mode = MBProgressHUDModeIndeterminate;
    [hud showAnimated:YES];
    // 调整hud位置
    CGRect frame = view.bounds;
    frame.origin.x = edgeInsets.left;
    frame.origin.y = edgeInsets.top;
    frame.size.width = CGRectGetWidth(view.bounds) - (edgeInsets.left + edgeInsets.right);
    frame.size.height = CGRectGetHeight(view.bounds) - (edgeInsets.top + edgeInsets.bottom);
    hud.frame = frame;
}

+ (void)showHUDOnView:(UIView *)view message:(NSString *)message {
    [self showHUDOnView:view
                message:message
             edgeInsets:UIEdgeInsetsZero
        backgroundColor:nil];
}
+ (void)showHUDOnView:(UIView *)view {
    [self showHUDOnView:view
                message:nil
             edgeInsets:UIEdgeInsetsZero
        backgroundColor:nil];
}

+ (void)showHUDOnView:(UIView *)view message:(NSString *)message edgeInsets:(UIEdgeInsets)edgeInsets {
    [self showHUDOnView:view
                message:message
             edgeInsets:edgeInsets
        backgroundColor:nil];
}
+ (void)showHUDOnView:(UIView *)view edgeInsets:(UIEdgeInsets)edgeInsets {
    [self showHUDOnView:view
                message:nil
             edgeInsets:edgeInsets
        backgroundColor:nil];
}

+ (void)showHUDOnKeyWindowWithMesage:(NSString *)message {
    [self showHUDOnView:KEY_WINDOW
                message:message
             edgeInsets:UIEdgeInsetsZero
        backgroundColor:nil];
}
+ (void)showHUDOnKeyWindow {
    [self showHUDOnView:KEY_WINDOW
                message:nil
             edgeInsets:UIEdgeInsetsZero
        backgroundColor:nil];
}

#pragma mark - 关闭HUD
+ (void)hideHUDOnView:(UIView *)view {
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    [hud hideAnimated:YES];
}
+ (void)hideHUDOnKeyWindow {
    [self hideHUDOnView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark - 显示N秒后自动关闭HUD
+ (void)showHUDThenHideOnView:(UIView *)view message:(NSString *)message afterDelay:(NSTimeInterval)delay {
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if ( ! hud) {
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    hud.frame = view.bounds;
    hud.backgroundColor = [UIColor clearColor];
    hud.mode = MBProgressHUDModeText;
    hud.margin = 20;
    hud.label.numberOfLines = 2;
    hud.label.text = message;
    hud.label.textColor = [UIColor whiteColor];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.8];
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:delay];
}
+ (void)showHUDThenHideOnView:(UIView *)view message:(NSString *)message {
    [self showHUDThenHideOnView:view message:message afterDelay:1];
}
+ (void)showHUDThenHideOnKeyWindowWithMessage:(NSString *)message {
    [self showHUDThenHideOnView:[UIApplication sharedApplication].keyWindow message:message];
}

@end
