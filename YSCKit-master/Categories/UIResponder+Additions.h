//
//  UIResponder+Additions.h
//  YSCKit
//
//  Created by  YangShengchao on 14-7-24.
//  Copyright (c) 2014年 YSHCH_TEAM. All rights reserved.
//  FORMATED!
//

#import <UIKit/UIKit.h>

@interface UIResponder (Additions)

+ (id)CurrentFirstResponder;
//统一创建UIViewController
+ (UIViewController *)CreateBaseViewController:(NSString *)className;
//统一创建UINavigationController
+ (UINavigationController *)CreateNavigationControllerWithRootViewController:(UIViewController *)viewController;
//这里统一设置controller的各种属性
+ (void)ConfigNavigationBar:(UINavigationBar *)navigationBar;

@end
