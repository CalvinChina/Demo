//
//  DWKData.h
//  DWKKit
//
//  Created by pisen on 16/10/14.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  单例类
 *  作用：存储整个项目运行过程中用到的变量
 *       常用的单例变量管理
 */
#define DWKDataInstance  [DWKData sharedInstance]

@interface DWKData : NSObject
@property (nonatomic ,weak) UIViewController * currentViewController;
@property (nonatomic ,strong) CLLocationManager * locationManager;
@property (nonatomic ,assign) CLLocationDegrees currentLontitude; // 当前经度
@property (nonatomic ,assign) CLLocationDegrees currentLatitude;
/**缓存数据库路径*/
@property (nonatomic ,copy) NSString *cacheDBPath;
/**用户登录状态改变*/
@property (nonatomic ,assign) BOOL isUserLoginChangde;
/**APP是否通过了苹果审核*/
@property (nonatomic ,assign) BOOL isAppApproved;
/**当前键盘高度*/
@property (nonatomic ,assign)CGFloat currentKeyboardHeight;

/**是否处于联网状态*/
@property (nonatomic ,assign) BOOL isReachable;
/*是否通过wifi联网*/
@property (nonatomic ,assign) BOOL isReachableViaWiFi;

/**设备唯一标示(Umeng)*/
@property (nonatomic ,copy) NSString * udid;
/**推送通知的token(clientID)*/
@property (nonatomic ,copy) NSString * deviceToken;
@property (nonatomic ,assign) BOOL isCachedParamsChanged;
/**服务器当前时间*/
@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, assign) NSTimeInterval currentTimeInterval;//服务器当前时间戳(秒)从1970-01-01 00:00:00开始

+ (instancetype)sharedInstance;

#pragma mark - 定位当前位置
- (void)startLocationService;
- (void)stopLocationService;
//解析当前GPS坐标成文字信息
- (void)resolveUserLocationWithBlock:(DWKObjectBlock)block;
- (void)resolveLocationByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude block:(DWKObjectBlock)block;

#pragma mark - 获取服务器当前时间
- (void)refreshServerTimeWithBlock:(DWKObjectBlock)block;   //如果具体项目的网络请求不同就重新该方法


#pragma mark - 播放音频
- (void)playAudioWithFilePath:(NSString *)filePath;
- (void)playAudioWithFilePath:(NSString *)filePath repeatCount:(NSInteger)count;


@end
