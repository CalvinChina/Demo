//
//  AppDelegate.m
//  Qianjituan
//
//  Created by ios-mac on 15/9/14.
//  Copyright (c) 2015年 ios-mac. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "APService.h"
#import "DBManager.h"
#import "WelocomeViewController.h"
#import "LoginViewController.h"
#import "QianjituanViewController.h"
#import <sys/xattr.h>

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

#import <sys/xattr.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"

#import "MobClick.h"
#import "MobClickSocialAnalytics.h"

#import <MeiQiaSDK/MQManager.h>

@interface AppDelegate ()

@end

BMKMapManager* _mapManager;

@implementation AppDelegate

- (void)startMobStat
{
    [MobClick startWithAppkey:@"5691ecc467e58eae0e00186d"
                 reportPolicy:BATCH
                    channelId:@""];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    _mapManager = [[BMKMapManager alloc]init];
    
    BOOL ret =
    [_mapManager start: @"YRkBc3EU3EEHH7UuVIlWmelR"
       generalDelegate: self];
    
    if(!ret)
    {
        NSLog(@"manager start failed!");
    }
    // 注册美洽
    [MQManager initWithAppkey:@"c88aabde6a2b5e06c7463369d7b5ba3c" completion:^(NSString *clientId, NSError *error) {
    }];
    
    [self initQianjituan];
    
    [self startMobStat];
    
    //防止用户删除默认目录
    [self createDirectory];
    
    [self pushInit:launchOptions];
    
    [self enterMainUI];
    
    [ShareSDK registerApp:@"f4cce8a1b620"
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType)
    {
        switch (platformType)
        {
            case SSDKPlatformTypeWechat:
                [ShareSDKConnector connectWeChat:[WXApi class]];
                break;
            case SSDKPlatformTypeQQ:
                [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                break;
            case SSDKPlatformTypeSinaWeibo:
                [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                break;
            default:
                break;
        }
    }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"2511955865"
                                           appSecret:@"bb31a59d1f6bc425528e68182c74c858"
                                         redirectUri:@"http://www.sharesdk.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
            case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1105132843" appKey:@"2KcbGAdUvCx7ycma" authType:SSDKAuthTypeBoth];
                 break;
            case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupQQByAppId:@"wx03fd1d0226ecd218" appKey:@"2bc2ffd4bdd216327eb686bb8e12b6d2" authType:SSDKAuthTypeBoth];
                 break;
            
             default:
                 break;
         }
     }];
    
    return YES;
}

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [MQManager closeMeiqiaService];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [MQManager openMeiqiaService];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - init Qianjituan

- (void)initQianjituan
{
    NSString* secretAgent = [[[UIWebView alloc] init] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@%@%@",secretAgent, QianjituanUANAME, @"1.0.1"], @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
}


#pragma mark -push Notification

- (void)networkDidSetup:(NSNotification *)notification {
    
    NSLog(@"已连接");
}

- (void)networkDidClose:(NSNotification *)notification {
    
    NSLog(@"未连接。。。");
}

- (void)networkDidRegister:(NSNotification *)notification {
    
    NSLog(@"已注册");
}

- (void)networkDidLogin:(NSNotification *)notification {
    
    NSLog(@"已登录");
    
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    
    NSDictionary * userInfo = [notification userInfo];
    NSString *title = [userInfo valueForKey:@"title"];
    NSString *content = [userInfo valueForKey:@"content"];
    NSInteger badge = [[userInfo valueForKey:@"badge"] integerValue]; //badge数量
    //  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    // [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    NSLog(@"received title:%@  and content:%@",title,content);
    
    // [self showAlert:title andContent:content andBadgeValue:badge];
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
    
}

- (void) pushInit:(NSDictionary *)launchOptions {
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    [defaultCenter addObserver:self selector:@selector(networkDidSetup:) name:kJPFNetworkDidSetupNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidClose:) name:kJPFNetworkDidCloseNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidRegister:) name:kJPFNetworkDidRegisterNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidLogin:) name:kJPFNetworkDidLoginNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    //推送相关 Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)                      categories:nil];
    }else{
        
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
    
    // Required
    [APService setupWithOption:launchOptions];
    
    [APService setTags:[NSSet setWithObjects:@"tag_cloud_formal_ios_2.0.20141212", nil] alias:nil callbackSelector:@selector(tagsAliasCallback:tags:alias:) target:self];
    
}

#pragma mark - 推送相关

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
}
#endif

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSLog(@"aps token: %@", deviceToken);
    // Required
    [APService registerDeviceToken:deviceToken];
}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
}
//app前台或者后台运行时调用
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required
    [APService handleRemoteNotification:userInfo];
    
    [APService resetBadge];
    
    // 取得 APNs 标准信息内容
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
    
    
    // 取得自定义字段内容
    NSString *customizeField1 = [userInfo valueForKey:@"customizeField1"]; //自定义参数，key是自己定义的
    NSLog(@"content =[%@], badge=[%ld], sound=[%@], customize field =[%@]",content,(long)badge,sound,customizeField1);
    
    
}

//avoid compile error for sdk under 7.0
//iOS 7 的 Remote Notification 特性处理函数
//当注册了Backgroud Modes -> Remote notifications 后，notification 处理函数一律切换到下面函数，后台推送代码也在此函数中调用
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // Required
    [APService handleRemoteNotification:userInfo];
    [APService resetBadge];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

-(void)showAlert:(NSString*)title andContent:(NSString*)content andBadgeValue:(NSInteger)badge;
{
    //如果消息类型是20，则显示链接按钮
    if (badge == 20) {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:content delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"显示", nil];
        
        alert.tag = 98;
        
        [alert show];
    }
    else {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:content delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
        alert.tag = 98;
        
        [alert show];
    }
}
- (void) createDirectory{
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentPath=[paths lastObject];
    
    NSLog(@"%@",documentPath);
    
    //防止备份
    
    [self addSkipBackupAttributeToFileAtPath:documentPath];
    
    //每次启动先删除缓存的temp_text
    NSString *textDir = [documentPath stringByAppendingPathComponent:@"temp_text"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    [fileManager removeItemAtPath:textDir error:nil];
    
    NSString *mainPath=[documentPath stringByAppendingPathComponent:USERDIR];
    
    BOOL isDir;
    
    BOOL bFail = NO;
    
    if (![fileManager fileExistsAtPath:mainPath isDirectory:&isDir]) {
        
        [fileManager createDirectoryAtPath:mainPath withIntermediateDirectories:YES attributes:Nil error:Nil];
    }
}

//防止备份，否则无法上架
- (BOOL)addSkipBackupAttributeToFileAtPath:(NSString *)aFilePath
{
    assert([[NSFileManager defaultManager] fileExistsAtPath:aFilePath]);
    
    NSError *error = nil;
    BOOL success = NO;
    
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    if ([systemVersion floatValue] >= 5.1f)
    {
        success = [[NSURL fileURLWithPath:aFilePath] setResourceValue:[NSNumber numberWithBool:YES]
                                                               forKey:NSURLIsExcludedFromBackupKey
                                                                error:&error];
    }
    else if ([systemVersion isEqualToString:@"5.0.1"])
    {
        const char* filePath = [aFilePath fileSystemRepresentation];
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
        
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        success = (result == 0);
    }
    else
    {
        NSLog(@"Can not add 'do no back up' attribute at systems before 5.0.1");
    }
    
    if(!success)
    {
        NSLog(@"Error excluding %@ from backup %@", [aFilePath lastPathComponent], error);
    }
    
    return success;
}

//进入主ui界面
- (void)enterMainUI
{
    NSString *str = [NUSD objectForKey:@"first_enter"];
    
    if([str isEqualToString:@"1"])
    {
        [self enterMainController: YES];
    }
    else
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"YYYY/MM/dd HH:mm:ss"];
        NSDate *nowDate = [NSDate date];
        NSString *time = [df stringFromDate:nowDate];
        
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"first_enter"];
        
        [NUSD setObject:[NSNumber numberWithBool:YES] forKey:@"checkUpdate"];
        
        [NUSD setObject:[NSNumber numberWithBool:YES] forKey:@"update"];
        
        [NUSD setObject:time forKey:@"installTime"];
        
        [NUSD synchronize];
        
        self.window.rootViewController = [[WelocomeViewController alloc] initWithNibName:@"WelocomeViewController" bundle:nil];
    }
}

- (void)enterMainController:(BOOL)bFade {
    
    if (bFade) {
        
        CATransition *animation = [CATransition animation];
        animation.duration = 1.0;
        
        animation.type = kCATransitionFade;
        
        animation.subtype = kCATransitionFromTop;
        
        animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
        
        [self.window.layer addAnimation:animation forKey:@"animation"];
    }
    
    QianjituanViewController *yzVC = [[QianjituanViewController alloc] init];
    
    UINavigationController *naviC = [[UINavigationController alloc] initWithRootViewController: yzVC];
    
    self.window.rootViewController = naviC;
}

@end
