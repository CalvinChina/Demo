//
//  PSKConfigManager.m
//  PisenKit
//
//  Created by 杨胜超 on 16/6/29.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import "PSKConfigManager.h"

static NSString * const kSaveLocalConfigFileName = @"PSKConfigManager";

@interface PSKConfigManager ()
@property (nonatomic, strong) NSMutableDictionary *appParams;           //内存中的参数(high)
@property (nonatomic, strong) NSMutableDictionary *onlineParams;        //在线参数(normal)
@property (nonatomic, strong) NSMutableDictionary *localParams;         //本地参数(low)
@end

@implementation PSKConfigManager
+ (instancetype)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[PSKConfigManager alloc] init];
    });
    return _sharedObject;
}
- (id)init {
    self = [super init];
    if (self) {
        self.appParams = [NSMutableDictionary dictionary];
        self.onlineParams = [NSMutableDictionary dictionary];
        self.localParams = [NSMutableDictionary dictionary];
        [self _setupDefaultValue];
    }
    return self;
}
// 初始化默认值
- (void)_setupDefaultValue {
    self.isDownloadImageViaWWAN = YES;
    self.isDebugModelAvailable = YES;
    self.isDebugModel = NO;
    self.isAutoCancelTheLastSameRequesting = YES;
    
    self.screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.xibWidth = 750.0f;
    
    self.appStoreId = @"";
    self.appChannel = @"AppStore";
    self.appShortVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    self.appBundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    self.appVersion = [NSString stringWithFormat:@"%@ (%@)", self.appShortVersion, self.appBundleVersion];
    self.appBundleIdentifier = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    self.appConfigPlistName = @"PSKKit_AppConfig";
    self.appConfigDebugPlistName = @"PSKKit_AppConfigDebug";
    
    self.defaultColor = [UIColor colorWithRed:47 / 255.0f green:152 / 255.0f blue:233 / 255.0f alpha:1.0f];
    self.defaultViewColor = [UIColor colorWithRed:238 / 255.0f green:238 / 255.0f blue:238 / 255.0f alpha:1.0f];
    self.defaultBorderColor = [UIColor colorWithRed:220 / 255.0f green:220 / 255.0f blue:220 / 255.0f alpha:1.0f];
    self.defaultPlaceholderColor = [UIColor colorWithRed:200 / 255.0f green:200 / 255.0f blue:200 / 255.0f alpha:1.0f];
    self.defaultImageBackColor = [UIColor colorWithRed:240 / 255.0f green:240 / 255.0f blue:240 / 255.0f alpha:1.0f];
    
    self.defaultImageName = @"image_default";
    self.defaultEmptyImageName = @"icon_empty_default";
    self.defaultErrorImageName = @"icon_error_default";
    self.defaultTimeoutImageName = @"icon_timeout_default";
    self.defaultBackButtonImageName = @"arrow_left_default";
    self.defaultNaviBackgroundImageName = @"background_navigationbar_default";
    self.defaultNoMoreMessage = @"没有更多了";
    self.defaultEmptyMessage = @"暂无数据";
    self.defaultPageStartIndex = 1;
    self.defaultPageSize = 10;
    self.defaultRequestTimeOut = 15.0f;
    
    self.networkErrorDisconnected = @"网络未连接";
    self.networkErrorServerFailed = @"服务器连接失败";
    self.networkErrorTimeout = @"网络连接超时";
    self.networkErrorCancel = @"网络连接取消";
    self.networkErrorConnectionFailed = @"网络连接失败";
    self.networkErrorRequesFailed = @"创建网络连接失败";
    self.networkErrorURLInvalid = @"网络请求的URL不合法";
    self.networkErrorReturnEmptyData = @"返回数据为空";
    self.networkErrorDataMappingFailed = @"数据映射本地模型失败";
    self.networkErrorRequesting = @"数据获取中";
    
    self.regexPhone = @"^\\d{1,3}[-]+\\d{3,10}$";
    self.regexMobilePhone = @"^(01|1)\\d{10}$";
    self.regexEmail = @"^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$";
    self.regexWebUrl = @"((http|ftp|https)://)(([a-zA-Z0-9\\._-]+\\.[a-zA-Z]{2,6})|([0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}))(:[0-9]{1,4})*(/[a-zA-Z0-9\\&%_\\./-~-]*)?";
    
    [self _setupCustomValues];
}
// 在category中重写该方法可以修改默认值
- (void)_setupCustomValues {
    
}

// getter
- (BOOL)isDownloadImageViaWWAN {
    NSString *name = @"kIsDownloadImageViaWWAN";
    NSObject *tempObject = [self getLocalConfigValueByName:name];
    if (tempObject) {
        NSString *tempValue = [NSString stringWithFormat:@"%@", tempObject];
        return [tempValue boolValue];
    }
    else {
        self.appParams[name] = @(_isDownloadImageViaWWAN);
        return _isDownloadImageViaWWAN;
    }
}
- (BOOL)isDebugModelAvailable {
    if (PSKManagerInstance.isAppApproved) {
        return NO;// 只要通过审核就永远关闭debugModel
    }
    NSString *name = @"kIsDebugModelAvailable";
    NSObject *tempObject = [self getLocalConfigValueByName:name];
    if (tempObject) {
        NSString *tempValue = [NSString stringWithFormat:@"%@", tempObject];
        return [tempValue boolValue];
    }
    else {
        self.appParams[name] = @(_isDebugModelAvailable);
        return _isDebugModelAvailable;
    }
}
- (BOOL)isDebugModel {
    NSString *name = @"PSKConfigManager_isDebugModel";
    NSObject *tempObject = nil;
    if (self.appParams[name]) {
        tempObject = self.appParams[name];
    }
    else {
        tempObject = PSKGetObjectByFile(name, kSaveLocalConfigFileName);
        if ( ! tempObject) {
            tempObject = @(_isDebugModel);
        }
        self.appParams[name] = tempObject;
    }
    NSString *tempValue = [NSString stringWithFormat:@"%@", tempObject];
    return [tempValue boolValue];
}

// setter
- (void)setXibWidth:(CGFloat)xibWidth {
    _xibWidth = xibWidth;
    self.autoLayoutScale = self.screenWidth / xibWidth;
}

// 缓存属性至运行时配置文件
- (void)saveIsDownloadImageViaWWAN:(BOOL)isDownloadImageViaWWAN {
    NSString *name = @"kIsDownloadImageViaWWAN";
    [self saveValue:@(isDownloadImageViaWWAN) toLocalConfigByName:name];
}
- (void)saveIsDebugModel:(BOOL)isDebugModel {
    NSString *name = @"PSKConfigManager_isDebugModel";
    [self saveValue:@(isDebugModel) toLocalConfigByName:name];
}

// 存取运行时配置文件的通用方法
- (void)saveValue:(NSObject *)value toLocalConfigByName:(NSString *)name {
    self.appParams[name] = value;
    PSKSaveObjectByFile(value, name, kSaveLocalConfigFileName);
}
- (NSObject *)getLocalConfigValueByName:(NSString *)name {
    return [self _objectOfLocalConfigFileByName:name];
}


// 管理配置文件里的参数
- (void)resetConfigParams {
    [self.onlineParams removeAllObjects];
    [self.appParams removeAllObjects];
}
- (void)saveObject:(NSObject *)object toMemoryByName:(NSString *)name {
    RETURN_WHEN_OBJECT_IS_EMPTY(name);
    if (object) {
        self.appParams[name] = object;
    }
}

- (BOOL)boolFromConfigByName:(NSString *)name {
    RETURN_NO_WHEN_OBJECT_IS_EMPTY(name);
    NSString *value = [self stringFromConfigByName:name];
    return [value boolValue];
}
- (float)floatFromConfigByName:(NSString *)name {
    RETURN_ZERO_WHEN_OBJECT_IS_EMPTY(name);
    NSString *value = [self stringFromConfigByName:name];
    return [value floatValue];
}
- (NSInteger)intFromConfigByName:(NSString *)name {
    RETURN_ZERO_WHEN_OBJECT_IS_EMPTY(name);
    NSString *value = [self stringFromConfigByName:name];
    return [value integerValue];
}
- (UIColor *)colorFromConfigByName:(NSString *)name {
    RETURN_NIL_WHEN_OBJECT_IS_EMPTY(name);
    NSString *value = [self stringFromConfigByName:name];
    return [UIColor psk_colorWithRGBString:value];
}
- (UIImage *)imageFromConfigByName:(NSString *)name {
    RETURN_NIL_WHEN_OBJECT_IS_EMPTY(name);
    NSString *value = [self stringFromConfigByName:name];
    return [UIImage imageNamed:value];
}
- (NSString *)stringFromConfigByName:(NSString *)name {
    NSObject *tempObject = [self _objectOfConfigByName:name];
    if (tempObject) {
        return [NSString stringWithFormat:@"%@", tempObject];
    }
    else {//3. 检测本地打包目录配置文件
        NSString *tempValue = [self _valueOfLocalConfig:name];
        if (tempValue) {
            self.appParams[name] = tempValue;
            return tempValue;
        }
    }
    return @"";
}


#pragma mark - Private Methods
// 检测内存缓存、在线配置参数、本地运行时配置文件
- (NSObject *)_objectOfLocalConfigFileByName:(NSString *)name {
    NSObject *tempObject = [self _objectOfConfigByName:name];
    if (tempObject) {
        return tempObject;
    }
    else {//3. 检测本地运行时配置文件
        NSObject *localObject = PSKGetObjectByFile(name, kSaveLocalConfigFileName);
        if (localObject) {
            self.appParams[name] = localObject;
            return localObject;
        }
    }
    return nil;
}
// 检测内存缓存和在线配置参数
- (NSObject *)_objectOfConfigByName:(NSString *)name {
    RETURN_NIL_WHEN_OBJECT_IS_EMPTY(name);
    //1. 判断内存中的缓存值
    if (self.appParams[name]) {
        return self.appParams[name];
    }
    
    NSString *tempValue = [self _valueOfOnlineConfig:name];
    //2. 获取在线配置的参数
    if (tempValue) {
        self.appParams[name] = tempValue;
        return tempValue;
    }
    return nil;
}
// 获取本地缓存的在线参数值
- (NSString *)_valueOfOnlineConfig:(NSString *)name {
    if (self.onlineParams[name]) {
        return TRIM_STRING(self.onlineParams[name]);
    }
    [self.onlineParams removeAllObjects];
    self.onlineParams = PSKGetObjectByFile(@"AppParams", @"OnLineParams");
    if (self.onlineParams[name]) {
        return TRIM_STRING(self.onlineParams[name]);
    }
    return nil;
}
// 获取本地配置文件参数值(只有第一次访问是读取硬盘的文件，以后就直接从内存中读取参数值)
- (NSString *)_valueOfLocalConfig:(NSString *)name {
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(name);
    //1. 检测缓存
    if (self.localParams[name]) {
        return TRIM_STRING(self.localParams[name]);
    }
    //2. 加载到缓存
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:self.appConfigPlistName ofType:@"plist"];
    if (self.isDebugModel) {
        plistPath = [[NSBundle mainBundle] pathForResource:self.appConfigDebugPlistName ofType:@"plist"];
    }
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    [self.localParams removeAllObjects];
    [self.localParams addEntriesFromDictionary:dict];
    if (self.localParams[name]) {
        return TRIM_STRING(self.localParams[name]);
    }
    return nil;
}
@end
