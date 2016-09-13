//
//  MBProgressHUD+Util.h
//  CalvinUtils
//
//  Created by pisen on 16/2/4.
//  Copyright © 2016年 Calvin. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Util)

+ (void)showSuccess:(NSString *)success;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

+ (void)showError:(NSString *)error;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message;
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

+ (void)hideHUD;
+ (void)hideHUDForView:(UIView *)view;

@end
