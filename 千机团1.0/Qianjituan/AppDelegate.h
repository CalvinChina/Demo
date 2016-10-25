//
//  AppDelegate.h
//  Qianjituan
//
//  Created by ios-mac on 15/9/14.
//  Copyright (c) 2015年 ios-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>

#import <Accelerate/Accelerate.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (assign) BOOL isNoShowAdvert;

@property int mLoginFailCounter;

@property (nonatomic,copy)NSString* mLoginAttachedData;

@property (nonatomic,copy)NSString* mCurrentLoadingUrl;

- (void)enterMainController:(BOOL)bFade;

@end

