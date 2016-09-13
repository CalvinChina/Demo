//
//  UIViewController+PisenKit.m
//  PisenKit
//
//  Created by 杨胜超 on 16/6/30.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import "UIViewController+PisenKit.h"
#import <objc/runtime.h>

//==============================================================================
//
//  基本切换功能
//
//==============================================================================
@implementation UIViewController (PisenKit)

// 添加params属性
PSK_DYNAMIC_PROPERTY_OBJECT(psk_params, setPsk_params, RETAIN_NONATOMIC, NSMutableDictionary *)

+ (void)load {
    [super load];
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        SWIZZLING_INSTANCE_METHODS(self.class, @selector(viewWillAppear:),
                                   @selector(psk_viewWillAppear:));
    });
}
/** 采用Method Swizzling的方式可以继续回到原来的执行流程，本质是AOP */
- (void)psk_viewWillAppear:(BOOL)animated {
    [self psk_viewWillAppear:animated];// 如果不加这行代码就和Override一样！
    NSLog(@"[%@] will appear", NSStringFromClass(self.class));
}

- (void)psk_hideKeyboard {
    [self.view endEditing:YES];
}

/** push view controller */
- (void)psk_pushViewController:(NSString *)className {
    [self psk_pushViewController:className withParams:nil];
}
- (void)psk_pushViewController:(NSString *)className withParams:(NSDictionary *)params {
    [self psk_pushViewController:className withParams:params animated:YES];
}
- (void)psk_pushViewController:(NSString *)className withParams:(NSDictionary *)params animated:(BOOL)animated {
    [self psk_hideKeyboard];
    RETURN_WHEN_OBJECT_IS_EMPTY(className);
    UIViewController *viewController = [[NSClassFromString(className) alloc] init];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        NSMutableDictionary *mutableParamDict = [NSMutableDictionary dictionaryWithDictionary:params];
        [viewController setPsk_params:mutableParamDict];
        [self.navigationController pushViewController:viewController animated:animated];
    }
    else {
        NSLog(@"view controller [%@] instance failed!", className);
    }
}

/** pop & dismiss view controller */
- (void)psk_popViewController {
    [self psk_hideKeyboard];
    if (self.navigationController) {     //如果有navigationBar
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self psk_dismissOnPresentingViewController];
    }
}
- (void)psk_popViewControllerWithStep:(NSInteger)step {
    [self psk_hideKeyboard];
    if (self.navigationController) {
        NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
        UIViewController *previousViewController = [self.navigationController.viewControllers objectAtIndex:MIN([self.navigationController.viewControllers count] - 1, MAX(index - step, 0))];
        [self.navigationController popToViewController:previousViewController animated:YES];
    }
}
- (void)psk_backViewController {
    [self psk_hideKeyboard];
    if (self.navigationController) {            //如果有navigationBar
        NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
        if (index > 0) {                        //不是root，就返回上一级
            [self psk_popViewControllerWithStep:1];
        }
        else {
            [self psk_dismissOnPresentingViewController];
        }
    }
    else {
        [self psk_dismissOnPresentingViewController];
    }
}

/** present viewcontroller
 *  [presentingViewController -> self -> presentedViewController] */
- (void)psk_presentViewController:(NSString *)className {
    [self psk_presentViewController:className withParams:nil];
}
- (void)psk_presentViewController:(NSString *)className withParams:(NSDictionary *)params {
    [self psk_presentViewController:className withParams:params animated:YES];
}
- (void)psk_presentViewController:(NSString *)className withParams:(NSDictionary *)params animated:(BOOL)animated {
    [self psk_hideKeyboard];
    RETURN_WHEN_OBJECT_IS_EMPTY(className);
    UIViewController *viewController = [[NSClassFromString(className) alloc] init];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        NSMutableDictionary *mutableParamDict = [NSMutableDictionary dictionaryWithDictionary:params];
        [viewController setPsk_params:mutableParamDict];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        [self presentViewController:navigationController animated:animated completion:nil];
    }
    else {
        NSLog(@"view controller [%@] instance failed!", className);
    }
}

/** dismiss viewcontroller */
- (void)psk_dismissOnPresentingViewController {
    if (self.presentingViewController) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)psk_dismissOnPresentedViewController {
    if (self.presentedViewController) {
        [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

@end



//==============================================================================
//
//  实例化viewController
//
//==============================================================================
@implementation UIViewController (PisenKit_CreateNew)
+ (instancetype)psk_createNew {
    return [self psk_createNewByName:NSStringFromClass(self.class)];
}
+ (instancetype)psk_createNewByName:(NSString *)name {
    if ( ! name) {
        return nil;
    }
    if (IS_NIB_EXISTS(name)) {
        return [[NSClassFromString(name) alloc] initWithNibName:name bundle:nil];
    }
    else {
        return [[NSClassFromString(name) alloc] init];
    }
}
+ (UINavigationController *)psk_createNewNavigationByRootName:(NSString *)rootName {
    UIViewController *rootViewController = [self psk_createNewByName:rootName];
    if (rootViewController) {
        return [[UINavigationController alloc] initWithRootViewController:rootViewController];
    }
    else {
        return nil;
    }
}
@end