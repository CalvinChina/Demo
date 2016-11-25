//
//  YSCConfigManager.h
//  KanPian
//
//  Created by 杨胜超 on 16/3/25.
//  Copyright © 2016年 SMIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef kDefaultNaviBarTintColor
    #define kDefaultNaviBarTintColor        RGB(47, 152, 233)       //导航栏默认文字、icon的颜色
#endif
#ifndef kDefaultNaviBarTitleColor
    #define kDefaultNaviBarTitleColor       RGB(10, 10, 10)         //导航栏标题颜色
#endif
#ifndef kDefaultNaviBarTitleFont
    #define kDefaultNaviBarTitleFont        [UIFont boldSystemFontOfSize:AUTOLAYOUT_LENGTH(34)]    //导航栏标题字体大小
#endif
#ifndef kDefaultNaviTintColor
    #define kDefaultNaviTintColor           RGBA(255, 255, 255, 1)  //系统导航栏背景颜色(包括了StatusBar)
#endif
#ifndef kDefaultNaviBarItemColor
    #define kDefaultNaviBarItemColor        kDefaultNaviBarTintColor//导航栏左右文字颜色
#endif
#ifndef kDefaultNaviBarItemFont
    #define kDefaultNaviBarItemFont         AUTOLAYOUT_FONT(28)     //导航栏左右文字大小
#endif

@interface YSCConfigManager : NSObject
+ (void)configNavigationBar:(UINavigationBar *)navigationBar;
+ (void)registerForRemoteNotification;
@end
