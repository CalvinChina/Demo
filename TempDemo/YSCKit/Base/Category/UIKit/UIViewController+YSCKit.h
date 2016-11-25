//
//  UIViewController+YSCKit.h
//  YSCKit
//
//  Created by yangshengchao on 15/4/23.
//  Copyright (c) 2015年 yangshengchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (YSCKit)
@property (nonatomic, strong) NSMutableDictionary *params;

- (void)hideKeyboard;

/** push view controller */
- (void)pushViewController:(NSString *)className;
- (void)pushViewController:(NSString *)className withParams:(NSDictionary *)params;
- (void)pushViewController:(NSString *)className withParams:(NSDictionary *)params animated:(BOOL)animated;

/** pop & dismiss view controller */
- (void)popViewController;          //返回上一级，最多到根
- (void)popViewControllerWithStep:(NSInteger)step;  //向后回退的步数
- (void)backViewController;         //返回上一级，直到dismiss

/** present viewcontroller
 *  [presentingViewController -> self -> presentedViewController] */
- (void)presentViewController:(NSString *)className;
- (void)presentViewController:(NSString *)className withParams:(NSDictionary *)params;
- (void)presentViewController:(NSString *)className withParams:(NSDictionary *)params animated:(BOOL)animated;

/** dismiss viewcontroller */
- (void)dismissOnPresentingViewController;  //在self上一级viewController调用dismiss（通常情况下使用该方法）
- (void)dismissOnPresentedViewController;   //在self下一级viewController调用dismiss

@end
