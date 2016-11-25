//
//  YSCData.h
//  YSCKit
//
//  Created by yangshengchao on 16/1/28.
//  Copyright © 2016年 Builder. All rights reserved.
//

/**
 *  单例类
 *  作用：存储整个项目运行过程中用到的变量
 *       常用的单例变量管理
 */

#define YSCDataInstance             [YSCData sharedInstance]

//--------------------------------------
//  定义全局变量
//--------------------------------------
@interface YSCData : NSObject
@property (nonatomic, weak) UIViewController *currentViewController;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) CLLocationDegrees currentLongitude;   //当前的经度104.7
@property (nonatomic, assign) CLLocationDegrees currentLatitude;    //当前的纬度30.2
@property (nonatomic, strong) NSString *cacheDBPath;        //缓存数据库路径
@property (nonatomic, assign) BOOL isUserLoginChanged;      //用户登录状态改变
@property (nonatomic, assign) BOOL isAppApproved;           //APP是否通过了苹果审核
@property (nonatomic, assign) CGFloat currentKeyboardHeight;//当前键盘高度
//network status
@property (nonatomic, assign) BOOL isReachable;             //是否处于联网状态
@property (nonatomic, assign) BOOL isReachableViaWiFi;      //是否通过wifi联网
//app config
@property (nonatomic, strong) NSString *udid;               //设备唯一编号(UMeng)
@property (nonatomic, strong) NSString *deviceToken;        //推送通知的token
@property (nonatomic, assign) BOOL isCachedParamsChanged;
//current date
@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, assign) NSTimeInterval currentTimeInterval;//服务器当前时间戳(秒)从1970-01-01 00:00:00开始

+ (instancetype)sharedInstance;

#pragma mark - 定位当前位置
- (void)startLocationService;
- (void)stopLocationService;
//解析当前GPS坐标成文字信息
- (void)resolveUserLocationWithBlock:(YSCObjectBlock)block;
- (void)resolveLocationByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude block:(YSCObjectBlock)block;

#pragma mark - 获取服务器当前时间
- (void)refreshServerTimeWithBlock:(YSCObjectBlock)block;   //如果具体项目的网络请求不同就重新该方法


#pragma mark - 播放音频
- (void)playAudioWithFilePath:(NSString *)filePath;
- (void)playAudioWithFilePath:(NSString *)filePath repeatCount:(NSInteger)count;
@end
