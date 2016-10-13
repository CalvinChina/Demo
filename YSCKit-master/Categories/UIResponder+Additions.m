//
//  UIResponder+Additions.m
//  YSCKit
//
//  Created by  YangShengchao on 14-7-24.
//  Copyright (c) 2014年 YSHCH_TEAM. All rights reserved.
//

#import "UIResponder+Additions.h" 

static __weak id currentFirstResponder;

@implementation UIResponder (Additions)

+(id)CurrentFirstResponder {
    currentFirstResponder = nil;
    [[UIApplication sharedApplication] sendAction:@selector(findFirstResponder:) to:nil from:nil forEvent:nil];
    return currentFirstResponder;
}

-(void)findFirstResponder:(id)sender {
    currentFirstResponder = self;
}
//统一创建UIViewController
+ (UIViewController *)CreateBaseViewController:(NSString *)className {
    UIViewController *pushedViewController = [[NSClassFromString(className) alloc] initWithNibName:className bundle:nil];
    NSAssert(pushedViewController, @"class[%@] is not exists in this project!", className);
    pushedViewController.hidesBottomBarWhenPushed = YES;
    NSLog(@"进入页面:%@", className);
    return pushedViewController;
}
//统一创建UINavigationController
+ (UINavigationController *)CreateNavigationControllerWithRootViewController:(UIViewController *)viewController {
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self ConfigNavigationBar:navigationController.navigationBar];
    return navigationController;
}
//这里统一设置controller的各种属性
//之所以把这些设置放在单独的controller中进行，是因为在ios7环境下，MFMessageComposeViewController.navibar的相关设置
//只会取[UINavigationBar appearance]中设置的，是个bug？
+ (void)ConfigNavigationBar:(UINavigationBar *)navigationBar {
    //统一设置导航栏是否透明，这会影响self.view的高度(如果透明则view.height=screen.height，否则view.height=screen.height-64)
    if ([navigationBar respondsToSelector:@selector(setTranslucent:)]) {
        [navigationBar setTranslucent:YES];
    }
    //设置背景颜色/图片
    if (kDefaultNaviBarBackImage) {
        [navigationBar setBackgroundImage:kDefaultNaviBarBackImage forBarMetrics:UIBarMetricsDefault];
    }
    else {
        [navigationBar setBarTintColor:kDefaultNaviTintColor];
    }
    //默认样式，带下横线的
    [navigationBar setBarStyle:UIBarStyleDefault];
    //影响范围：icon颜色、left、right文字颜色
    [navigationBar setTintColor:kDefaultNaviBarTintColor];
    //设置Title字体大小和颜色(如果不设置将按默认显示whiteColor)
    [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kDefaultNaviBarTitleColor,
                                            NSFontAttributeName : kDefaultNaviBarTitleFont}];
}
@end
