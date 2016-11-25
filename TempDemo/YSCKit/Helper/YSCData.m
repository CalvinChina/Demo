//
//  YSCData.m
//  YSCKit
//
//  Created by yangshengchao on 16/1/28.
//  Copyright © 2016年 Builder. All rights reserved.
//

#import "YSCData.h"
#import "YYReachability.h"
#define CachedSyncInterval          @"CachedSyncInterval"       //本地缓存的与服务器时间差(毫秒)
#define ConfigPlistPath             [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"]
#define ConfigDebugPlistPath        [[NSBundle mainBundle] pathForResource:@"AppConfigDebug" ofType:@"plist"]

//--------------------------------------
//  定义全局变量
//--------------------------------------
@interface YSCData () <AVAudioPlayerDelegate, CLLocationManagerDelegate>
@property (nonatomic, strong) YYReachability *reachability;
// 同步服务器时间
@property (assign, nonatomic) BOOL isSyncSuccess;                       //服务器时间是否同步成功
@property (assign, nonatomic) NSTimeInterval syncInterval;              //服务器时间 - 本地时间 (服务器时间比本地时间快多少毫秒)
// 播放音频
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@end
@implementation YSCData
- (void)dealloc {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
+ (instancetype)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^ {
        return [[self alloc] init];
    })
}
- (id)init {
    self = [super init];
    if (self) {
        [self _initReachability];
        
        // 监控APP运行状态
        ADD_OBSERVER(@selector(_didAppBecomeActive), UIApplicationDidBecomeActiveNotification);
        ADD_OBSERVER(@selector(_didAppEnterBackground), UIApplicationDidEnterBackgroundNotification);
        ADD_OBSERVER(@selector(_keyboardDidShow:), UIKeyboardDidShowNotification);
        ADD_OBSERVER(@selector(_keyboardDidHide:), UIKeyboardDidHideNotification);
        ADD_OBSERVER(@selector(_keyboardWillShow:), UIKeyboardWillShowNotification);
        ADD_OBSERVER(@selector(_keyboardWillHide:), UIKeyboardWillHideNotification);
        
        // 初始化时间差
        if ( ! YSCGetObject(CachedSyncInterval)) {
            YSCSaveObject(@(-500), CachedSyncInterval);
            self.syncInterval = -500;
        }
        else {
            self.syncInterval =  [YSCGetObject(CachedSyncInterval) doubleValue];
        }
        
        // 这里必须延迟调用方法，防止self未初始化完成就在方法里调用，导致永远不能初始化！
        [self performSelector:@selector(_refreshServerTime) withObject:nil afterDelay:3];
    }
    return self;
}
//APP恢复运行
- (void)_didAppBecomeActive {
    [self _refreshServerTime];//每次打开APP都会运行，防止本地修改了时间
    [self _checkAppApproved];
}
//用户按下Home键,APP进入后台
- (void)_didAppEnterBackground {
    self.isSyncSuccess = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(_refreshServerTime)
                                               object:nil];
}
//键盘弹出
- (void)_keyboardWillShow:(NSNotification*)notification {
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.currentKeyboardHeight = kbSize.height;
}
- (void)_keyboardDidShow:(NSNotification*)notification {
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.currentKeyboardHeight = kbSize.height;
}
//键盘关闭
- (void)_keyboardWillHide:(NSNotification*)notification {
    self.currentKeyboardHeight = 0.0f;
}
- (void)_keyboardDidHide:(NSNotification*)notification {
    self.currentKeyboardHeight = 0.0f;
}
//缓存数据库路径
- (NSString *)cacheDBPath {
    NSString *dbName = [NSString stringWithFormat:@"ysckit_cache_%@.sqlite", USER_ID];
    return [[YSCFileManager directoryPathOfDocuments] stringByAppendingPathComponent:dbName];
}
//获取本地缓存的是否通过审核
- (BOOL)isAppApproved {
    return [YSCGetObject(@"YSCData_isAppApproved") boolValue];
}
//检测APP是否通过了官方的审核
- (void)_checkAppApproved {
    if ( ! self.isAppApproved) {
        [YSCManager checkOnAppStoreStatus:nil block:^(NSDictionary *releaseItem) {
            NSString *onlineVersion = releaseItem[@"version"];
            if (OBJECT_ISNOT_EMPTY(onlineVersion) &&
                NSOrderedDescending != COMPARE_CURRENT_VERSION(onlineVersion)) {
                YSCSaveObject(@(YES), @"YSCData_isAppApproved");// 一旦通过了审核就不再检测
            }
        }];
    }
}

#pragma mark - 网络状态
- (void)_initReachability {
    @weakiy(self);
    self.reachability = [YYReachability reachability];
    self.isReachable = self.reachability.reachable;
    [self.reachability setTheNotifyBlock:^(YYReachability * _Nonnull reachability) {
        weak_self.isReachable = reachability.reachable;
    }];
}
- (BOOL)isReachableViaWiFi {
    return YYReachabilityStatusWiFi == self.reachability.status;
}

#pragma mark - 定位当前位置
- (void)startLocationService {
    if ([UIDevice isLocationAvaible]) {
        if ( ! self.locationManager) {
            self.locationManager = [CLLocationManager new];
            self.locationManager.delegate = self;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            self.locationManager.distanceFilter = kCLDistanceFilterNone;//will be informed of any movement
        }
//        [self.locationManager requestAlwaysAuthorization];
//        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager startUpdatingLocation];
    }
    else {
        NSLog(@"location service is not avaible!!!");
    }
}
- (void)stopLocationService {
    [self.locationManager stopUpdatingLocation];
}
//解析当前GPS坐标成文字信息
- (void)resolveUserLocationWithBlock:(YSCObjectBlock)block {
    [self resolveLocationByLatitude:self.currentLatitude longitude:self.currentLongitude block:block];
}
- (void)resolveLocationByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude block:(YSCObjectBlock)block {
    //TODO:解析地理位置信息
}
#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"----------didUpdateLocations--------");
    for (CLLocation *location in locations) {
        CLLocationCoordinate2D locationCoordinate = location.coordinate;
        CLLocationAccuracy accuracy = location.horizontalAccuracy;
    }
    NSLog(@"-----------------------------------");
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"----didUpdateToLocation----");
}
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    NSLog(@"----didUpdateHeading----");
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"----didFailWithError----");
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"status=%d", status);
}


#pragma mark - 获取服务器当前时间
- (NSDate *)currentDate {
    return [NSDate dateWithTimeIntervalSinceNow:(self.syncInterval / 1000.0f)];
}
- (NSTimeInterval)currentTimeInterval {
    return [self.currentDate timeIntervalSince1970];
}
- (void)refreshServerTimeWithBlock:(YSCObjectBlock)block {
    [YSCRequestInstance requestFromUrl:kPathAppCommonUrl
                               withApi:kPathGetServerTime
                                params:nil
                             dataModel:nil
                                  type:YSCRequestTypeGET
                               success:^(id responseObject) {
                                   NSString *tempStr = [NSString stringWithFormat:@"%@", responseObject];
                                   if (block) {
                                       block(tempStr);
                                   }
                               }
                                failed:^(NSString *YSCErrorType, NSError *error) {
                                    if (block) {
                                        block(nil);
                                    }
                                }];
}
//刷新服务器时间
- (void)_refreshServerTime {
    static BOOL isRunning = NO;
    if (isRunning) {
        return;
    }
    isRunning = YES;
    
    NSDate *startDate = [NSDate date];
    [self refreshServerTimeWithBlock:^(NSObject *object) {
        isRunning = NO;
        if (OBJECT_ISNOT_EMPTY(object)) {
            NSDate *endDate = [NSDate date];
            NSTimeInterval httpWaste = [endDate timeIntervalSinceDate:startDate];
            NSLog(@"waste:%lf", httpWaste);
            if (httpWaste >= 2) {//如果接口执行时间大于2秒就得重新请求
                [self _refreshFaild];
            }
            else {
                [NSObject cancelPreviousPerformRequestsWithTarget:self
                                                         selector:@selector(_refreshServerTime)
                                                           object:nil];
                self.isSyncSuccess = YES;
                NSString *tempStr = (NSString *)object;
                NSTimeInterval oldServerTime = [tempStr doubleValue];
                if (oldServerTime < 1000000000.0f * 1000.0f) {//如果单位是秒就需要转换成毫秒
                    oldServerTime *= 1000.0f;
                }
                NSTimeInterval serverTime = oldServerTime + httpWaste * 1000.0f / 2.0f;
                NSTimeInterval localTime = [endDate timeIntervalSince1970] * 1000.0f;
                self.syncInterval = serverTime - localTime;
                YSCSaveObject(@(self.syncInterval), CachedSyncInterval);
            }
        }
        else {
            [self _refreshFaild];
        }
    }];
}
- (void)_refreshFaild {
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(_refreshServerTime)
                                               object:nil];
    if ( ! self.isSyncSuccess) {
        [self performSelector:@selector(_refreshServerTime) withObject:nil afterDelay:30];
    }
}

#pragma mark - getter
- (NSString *)udid {
    if ( ! _udid) {
        NSString *tempUdid = YSCGetObject(@"OpenUDID");
        if (OBJECT_IS_EMPTY(tempUdid)) {
            tempUdid = [UIDevice openUdid];//保证只获取一次udid就保存在内存中！
            if (OBJECT_ISNOT_EMPTY(tempUdid)) {
                YSCSaveObject(tempUdid, @"OpenUDID");
            }
        }
        _udid = tempUdid;
    }
    return _udid == nil ? @"" : _udid;
}
- (NSString *)deviceToken {
    if (OBJECT_IS_EMPTY(_deviceToken)) {
        _deviceToken = YSCGetObject(@"DeviceToken");
    }
    return _deviceToken == nil ? @"" : _deviceToken;
}

#pragma mark - 播放音频
- (void)playAudioWithFilePath:(NSString *)filePath {
    [self playAudioWithFilePath:filePath repeatCount:0];
}
- (void)playAudioWithFilePath:(NSString *)filePath repeatCount:(NSInteger)count {
    [self stopPlaying];
    if ([YSCFileManager fileExistsAtPath:filePath]) {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryAmbient withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
        [audioSession setActive:YES error:nil];
        NSURL *soundURL = [[NSURL alloc] initFileURLWithPath:filePath];
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:nil];
        self.audioPlayer.delegate = self;
        [self.audioPlayer prepareToPlay];
        [self.audioPlayer setNumberOfLoops:count];
        [self.audioPlayer play];
    }
}
- (void)stopPlaying {
    if (self.audioPlayer) {
        [self.audioPlayer stop];
        self.audioPlayer = nil;
    }
}
#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    player = nil;
}
@end
