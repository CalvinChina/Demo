//
//  YSCConfigManager.m
//  KanPian
//
//  Created by 杨胜超 on 16/3/25.
//  Copyright © 2016年 SMIT. All rights reserved.
//

#import "YSCConfigManager.h"

@implementation YSCConfigManager
// 这里统一设置controller的各种属性
// 之所以把这些设置放在单独的controller中进行，是因为在ios7环境下，
// MFMessageComposeViewController.navibar的相关设置
// 只会取[UINavigationBar appearance]中设置的，是个bug？
+ (void)configNavigationBar:(UINavigationBar *)navigationBar {
    //0. 统一设置导航栏是否透明，这会影响self.view的高度(如果透明则view.height=screen.height，否则view.height=screen.height-64)
    if ([navigationBar respondsToSelector:@selector(setTranslucent:)]) {
        [navigationBar setTranslucent:YES];
    }
    //1. 设置背景颜色/图片
    UIImage *backImage = [UIImage imageNamed:YSCConfigDataInstance.defaultNaviBackgroundImageName];
    if (backImage) {
        [navigationBar setBackgroundImage:backImage forBarMetrics:UIBarMetricsDefault];
    }
    else {
        [navigationBar setBarTintColor:kDefaultNaviTintColor];
    }
    //2. 默认样式，带下横线的
    [navigationBar setBarStyle:UIBarStyleDefault];
    //3. 影响范围：icon颜色、left、right文字颜色
    [navigationBar setTintColor:kDefaultNaviBarTintColor];
    //4. 设置Title字体大小和颜色(如果不设置将按默认显示whiteColor)
    [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kDefaultNaviBarTitleColor,
                                            NSFontAttributeName : kDefaultNaviBarTitleFont}];
    
    //5. 设置BarButtonItem字体大小和颜色(如果不设置将按默认的tintColor显示)
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : kDefaultNaviBarItemColor,
                                                           NSFontAttributeName : kDefaultNaviBarItemFont}
                                                forState:UIControlStateNormal];
}
+ (void)registerForRemoteNotification {
    UIApplication *application = [UIApplication sharedApplication];
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert |
                                                UIUserNotificationTypeBadge |
                                                UIUserNotificationTypeSound
                                                                                 categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    } else {
        [application registerForRemoteNotificationTypes:
         UIRemoteNotificationTypeBadge |
         UIRemoteNotificationTypeAlert |
         UIRemoteNotificationTypeSound];
    }
}
@end
