//
//  UIViewController+YSCKit.m
//  YSCKit
//
//  Created by yangshengchao on 15/4/23.
//  Copyright (c) 2015年 yangshengchao. All rights reserved.
//

#import "UIViewController+YSCKit.h"
#import <objc/runtime.h>

static NSInteger const kTagOfMaskView       = 234688;

@implementation UIViewController (YSCKit)

+ (void)load {
    [super load];
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        SWIZZLING_INSTANCE_METHOD(self.class, @selector(viewDidLoad), @selector(ysc_viewDidLoad))
    });
}

// 添加params属性
YYSYNTH_DYNAMIC_PROPERTY_OBJECT(params, setParams, RETAIN, NSMutableDictionary *)

- (void)hideKeyboard {
    [self.view endEditing:YES];
}

/** push view controller */
- (void)pushViewController:(NSString *)className {
    [self pushViewController:className withParams:nil];
}
- (void)pushViewController:(NSString *)className withParams:(NSDictionary *)params {
    [self pushViewController:className withParams:params animated:YES];
}
- (void)pushViewController:(NSString *)className withParams:(NSDictionary *)params animated:(BOOL)animated {
    [self hideKeyboard];
    [self _showMaskView];
    RETURN_WHEN_OBJECT_IS_EMPTY(className);
    UIViewController *viewController = [[NSClassFromString(className) alloc] init];
    //[[NSClassFromString(className) alloc] initWithNibName:className bundle:nil];//该方法对于没有xib的实例化会crash！
    if ([viewController isKindOfClass:[UIViewController class]]) {
        NSMutableDictionary *mutableParamDict = [NSMutableDictionary dictionaryWithDictionary:params];
        [viewController setParams:mutableParamDict];
        //NOTE:这里设置backBarButtonItem没有用！
        if ([self isKindOfClass:[UINavigationController class]]) {
            [(UINavigationController *)self pushViewController:viewController animated:animated];
        }else{
            [self.navigationController pushViewController:viewController animated:animated];
        }
    }
    else {
        NSLog(@"view controller [%@] instance failed!", className);
    }
}

/** pop & dismiss view controller */
- (void)popViewController {
    [self hideKeyboard];
    if (self.navigationController) {     //如果有navigationBar
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissOnPresentingViewController];
    }
}
- (void)popViewControllerWithStep:(NSInteger)step {
    [self hideKeyboard];
    if (self.navigationController) {
        NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
        UIViewController *previousViewController = [self.navigationController.viewControllers objectAtIndex:MIN([self.navigationController.viewControllers count] - 1, MAX(index - step, 0))];
        [self.navigationController popToViewController:previousViewController animated:YES];
    }
}
- (void)backViewController {
    [self hideKeyboard];
    if (self.navigationController) {            //如果有navigationBar
        NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
        if (index > 0) {                        //不是root，就返回上一级
            [self popViewControllerWithStep:1];
        }
        else {
            [self dismissOnPresentingViewController];
        }
    }
    else {
        [self dismissOnPresentingViewController];
    }
}

/** present viewcontroller 
 *  [presentingViewController -> self -> presentedViewController] */
- (void)presentViewController:(NSString *)className {
    [self presentViewController:className withParams:nil];
}
- (void)presentViewController:(NSString *)className withParams:(NSDictionary *)params {
    [self presentViewController:className withParams:params animated:YES];
}
- (void)presentViewController:(NSString *)className withParams:(NSDictionary *)params animated:(BOOL)animated {
    [self hideKeyboard];
    [self _showMaskView];
    RETURN_WHEN_OBJECT_IS_EMPTY(className);
    UIViewController *viewController =  [[NSClassFromString(className) alloc] initWithNibName:className bundle:nil];
    NSMutableDictionary *mutableParamDict = [NSMutableDictionary dictionaryWithDictionary:params];
    [viewController setParams:mutableParamDict];
    UINavigationController *navigationController = [[YSCBaseNavigationViewController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:animated completion:nil];
}

/** dismiss viewcontroller */
- (void)dismissOnPresentingViewController {
    if (self.presentingViewController) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)dismissOnPresentedViewController {
    if (self.presentedViewController) {
        [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)_showMaskView {
    UIView *maskView = [KEY_WINDOW viewWithTag:kTagOfMaskView];
    if ( ! maskView) {
        maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        maskView.tag = kTagOfMaskView;
        maskView.backgroundColor = [UIColor clearColor];
        [KEY_WINDOW addSubview:maskView];
    }
}
- (void)_hideMaskView {
    UIView *maskView = [KEY_WINDOW viewWithTag:kTagOfMaskView];
    if (maskView) {
        [maskView removeFromSuperview];
        maskView = nil;
    }
}

/** Swizzling Methods */
- (void)ysc_viewDidLoad {
    [self _hideMaskView];
    [self ysc_viewDidLoad];
}

@end
