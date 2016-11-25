//
//  YSCConfigData.m
//  KanPian
//
//  Created by 杨胜超 on 16/4/8.
//  Copyright © 2016年 SMIT. All rights reserved.
//

#import "YSCConfigData.h"

static NSString * const kSaveLocalConfigFileName = @"YSCConfigData";

@interface YSCConfigData ()
@property (nonatomic, strong) NSMutableDictionary *memeryParams;
@property (nonatomic, strong) NSMutableDictionary *cachedParams;
@property (nonatomic, strong) NSMutableDictionary *localParams;
@end

@implementation YSCConfigData
+ (instancetype)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^ {
        return [[self alloc] init];
    })
}
- (id)init {
    self = [super init];
    if (self) {
        self.memeryParams = [NSMutableDictionary dictionary];
        self.cachedParams = [NSMutableDictionary dictionary];
        self.localParams = [NSMutableDictionary dictionary];
        [self _setupDefaultValue];
    }
    return self;
}
// 初始化默认值
- (void)_setupDefaultValue {
    self.isDownloadImageViaWWAN = YES;
    self.isDebugModeAvailable = YES;
    self.isDebugMode = NO;
    self.isOutputLog = NO;
    self.isUseHttpHeaderSignature = YES;
    self.isUseHttpHeaderToken = YES;
    self.isAutoCancelTheLastSameRequesting = YES;
    
    self.screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.xibWidth = 750.0f;
    self.appStoreId = @"";
    self.appChannel = @"AppStore";
    self.appShortVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    self.appBundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    self.appVersion = [NSString stringWithFormat:@"%@ (%@)", self.appShortVersion, self.appBundleVersion];
    self.appBundleIdentifier = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    self.appConfigPlistName = @"YSCKit_AppConfig";
    self.appConfigDebugPlistName = @"YSCKit_AppConfigDebug";
    
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
    
    [self _setupCustomValue];
}
// 在category中重写该方法可以修改默认值
- (void)_setupCustomValue {
    
}

//=========================================================================
// getter (不会影响属性设置值！)
//=========================================================================
- (BOOL)isDownloadImageViaWWAN {
    NSString *name = @"kIsDownloadImageViaWWAN";
    NSObject *tempObject = [self getLocalConfigValueByName:name];
    if (tempObject) {
        NSString *tempValue = [NSString stringWithFormat:@"%@", tempObject];
        return [tempValue boolValue];
    }
    else {
        self.memeryParams[name] = @(_isDownloadImageViaWWAN);
        return _isDownloadImageViaWWAN;
    }
}
- (BOOL)isDebugModeAvailable {
    if (YSCDataInstance.isAppApproved) {
        return NO;// 只要通过审核就永远关闭debugMode
    }
    NSString *name = @"kIsDebugModeAvailable";
    NSObject *tempObject = [self getLocalConfigValueByName:name];
    if (tempObject) {
        NSString *tempValue = [NSString stringWithFormat:@"%@", tempObject];
        return [tempValue boolValue];
    }
    else {
        self.memeryParams[name] = @(_isDebugModeAvailable);
        return _isDebugModeAvailable;
    }
}
- (BOOL)isDebugMode {
    NSString *name = @"YSCConfigData_isDebugMode";
    NSObject *tempObject = nil;
    if (self.memeryParams[name]) {
        tempObject = self.memeryParams[name];
    }
    else {
        tempObject = YSCGetObjectByFile(name, kSaveLocalConfigFileName);
        if ( ! tempObject) {
            tempObject = @(_isDebugMode);
        }
        self.memeryParams[name] = tempObject;
    }
    NSString *tempValue = [NSString stringWithFormat:@"%@", tempObject];
    return [tempValue boolValue];
}
- (BOOL)isOutputLog {
    NSString *name = @"YSCConfigData_isOutputLog";
    NSObject *tempObject = nil;
    if (self.memeryParams[name]) {
        tempObject = self.memeryParams[name];
    }
    else {
        tempObject = YSCGetObjectByFile(name, kSaveLocalConfigFileName);
        if ( ! tempObject) {
            tempObject = @(_isOutputLog);
        }
        self.memeryParams[name] = tempObject;
    }
    NSString *tempValue = [NSString stringWithFormat:@"%@", tempObject];
    return [tempValue boolValue];
}



//=========================================================================
// setter
//=========================================================================
- (void)setXibWidth:(CGFloat)xibWidth {
    _xibWidth = xibWidth;
    self.autoLayoutScale = self.screenWidth / xibWidth;
}



//=========================================================================
// 缓存属性至运行时配置文件
//=========================================================================
- (void)saveIsDownloadImageViaWWAN:(BOOL)isDownloadImageViaWWAN {
    NSString *name = @"kIsDownloadImageViaWWAN";
    [self saveValue:@(isDownloadImageViaWWAN) toLocalConfigByName:name];
}
- (void)saveIsDebugMode:(BOOL)isDebugMode {
    NSString *name = @"YSCConfigData_isDebugMode";
    [self saveValue:@(isDebugMode) toLocalConfigByName:name];
}
- (void)saveIsOutputLog:(BOOL)isOutputLog {
    NSString *name = @"YSCConfigData_isOutputLog";
    [self saveValue:@(isOutputLog) toLocalConfigByName:name];
}

// 存取运行时配置文件的通用方法
- (void)saveValue:(NSObject *)value toLocalConfigByName:(NSString *)name {
    self.memeryParams[name] = value;
    YSCSaveObjectByFile(value, name, kSaveLocalConfigFileName);
}
- (NSObject *)getLocalConfigValueByName:(NSString *)name {
    return [self _objectOfLocalConfigFileByName:name];
}


//=========================================================================
// 管理配置文件里的参数
//=========================================================================
- (void)resetConfigParams {
    [self.cachedParams removeAllObjects];
    [self.memeryParams removeAllObjects];
}
- (void)saveObject:(NSObject *)object toMemoryByName:(NSString *)name {
    RETURN_WHEN_OBJECT_IS_EMPTY(name);
    if (object) {
        self.memeryParams[name] = object;
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
    return [UIColor colorWithRGBString:value];
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
            self.memeryParams[name] = tempValue;
            return tempValue;
        }
    }
    return @"";
}


#pragma mark - Private Methods
- (NSObject *)_objectOfLocalConfigFileByName:(NSString *)name {
    NSObject *tempObject = [self _objectOfConfigByName:name];
    if (tempObject) {
        return tempObject;
    }
    else {//3. 检测本地运行时配置文件
        NSObject *localObject = YSCGetObjectByFile(name, kSaveLocalConfigFileName);
        if (localObject) {
            self.memeryParams[name] = localObject;
            return localObject;
        }
    }
    return nil;
}
- (NSObject *)_objectOfConfigByName:(NSString *)name {
    RETURN_NIL_WHEN_OBJECT_IS_EMPTY(name);
    if (self.memeryParams[name]) {
        return self.memeryParams[name];
    }
    
    NSString *tempValue = [self _valueOfCachedConfig:name];
    if (tempValue) {
        self.memeryParams[name] = tempValue;
        return tempValue;
    }
    return nil;
}
- (NSString *)_valueOfCachedConfig:(NSString *)name {
    if (self.cachedParams[name]) {
        return TRIM_STRING(self.cachedParams[name]);
    }
    [self.cachedParams removeAllObjects];
    self.cachedParams = YSCGetObjectByFile(@"AppParams", @"CachedParams");
    if (self.cachedParams[name]) {
        return TRIM_STRING(self.cachedParams[name]);
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
    if (self.isDebugMode) {
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
