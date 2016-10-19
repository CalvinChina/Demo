//
//  DWKData.m
//  DWKKit
//
//  Created by pisen on 16/10/14.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

#import "DWKData.h"
#import "YYReachability.h"

#define CachedSyncInterval @"CachedSyncInterval" // 本地缓存的与服务器时间差

#define ConfigPlistPath             [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"]
#define ConfigDebugPlistPath        [[NSBundle mainBundle] pathForResource:@"AppConfigDebug" ofType:@"plist"]

@interface DWKData ()<AVAudioPlayerDelegate ,CLLocationManagerDelegate>
@property (nonatomic ,strong) YYReachability * reachability;
/**同步服务器时间是否成功*/
@property (nonatomic ,assign) BOOL isSyncSuccess;
/**时间差(毫秒)*/
@property (nonatomic ,assign) NSTimeInterval syncInterval;
/**音频播放器*/
@property (nonatomic ,strong) AVAudioPlayer * audioPlayer;
@end

@implementation DWKData
- (void)dealloc{
    //取消延迟执行
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)sharedInstance{
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc]init];
    })
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpReachability];
        // 监控APP运行状态
        ADD_OBSERVER(@selector(_didAppBecomeActive), UIApplicationDidBecomeActiveNotification);
        ADD_OBSERVER(@selector(_didAppEnterBackground), UIApplicationDidEnterBackgroundNotification);
        ADD_OBSERVER(@selector(_keyboardDidShow:), UIKeyboardDidShowNotification);
        ADD_OBSERVER(@selector(_keyboardDidHide:), UIKeyboardDidHideNotification);
        ADD_OBSERVER(@selector(_keyboardWillShow:), UIKeyboardWillShowNotification);
        ADD_OBSERVER(@selector(_keyboardWillHide:), UIKeyboardWillHideNotification);
    
        
    }
    return self;
}
#pragma mark - NSNotification Start
- (void)_didAppBecomeActive{
//    [self _refreshServerTime];//每次打开APP都会运行，防止本地修改了时间
//    [self _checkAppApproved];
}

- (void)_didAppEnterBackground{

}
- (void)_keyboardDidShow:(NSNotification *)noti{
    NSDictionary *info = [noti userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.currentKeyboardHeight = kbSize.height;
}
- (void)_keyboardDidHide:(NSNotification *)noti{
    self.currentKeyboardHeight = 0.0f;
}
- (void)_keyboardWillShow:(NSNotification *)noti{
    NSDictionary *info = [noti userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.currentKeyboardHeight = kbSize.height;
}
- (void)_keyboardWillHide:(NSNotification *)noti{
    self.currentKeyboardHeight = 0.0f;
}

#pragma mark -- NSNotification End

#pragma mark -- 获取服务器时间刷新当前时间 S
- (NSDate *)currentDate{
    return [NSDate dateWithTimeIntervalSinceNow:(self.syncInterval / 1000.0f)];
}
- (NSTimeInterval)currentTimeInterval{
    return [self.currentDate timeIntervalSince1970];
}

- (void)refreshServerTimeWithBlock:(DWKObjectBlock)block{
//    []
    
}

#pragma mark -- 获取服务器时间刷新当前时间 E

#pragma mark -- 开启网络监听
- (void)setUpReachability{
   @weakiy(self);
    self.reachability = [YYReachability reachability];
    self.isReachable = self.reachability.reachable;
    [self.reachability setTheNotifyBlock:^(YYReachability * _Nonnull reachability) {
        weak_self.isReachable = reachability.reachable;
    }];
}




@end
