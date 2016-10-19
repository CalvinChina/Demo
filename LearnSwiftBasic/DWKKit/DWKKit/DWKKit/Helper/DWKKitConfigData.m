//
//  DWKKitConfigData.m
//  DWKKit
//
//  Created by pisen on 16/10/17.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

#import "DWKKitConfigData.h"

static NSString * const kSaveLocalConfigFileName = @"DWKKitConfigData";

@interface DWKKitConfigData ()
@property (nonatomic ,strong) NSMutableDictionary * memoryParams;
@property (nonatomic ,strong) NSMutableDictionary * cachedParams;
@property (nonatomic ,strong) NSMutableDictionary * localParms;
@end

@implementation DWKKitConfigData

+ (instancetype)sharedInstance{
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return  [[self alloc]init];
    })
}

- (instancetype)init{
    if (self = [super init]) {
        self.memoryParams = [NSMutableDictionary dictionary];
        self.cachedParams = [NSMutableDictionary dictionary];
        self.localParms = [NSMutableDictionary dictionary];
        [self setUpDefaultValue];
    }
    return self;
}


- (void)setUpDefaultValue{
    self.isDownloadImageViaWWAN = YES;
    self.isDebugModeAvailable = YES;
    self.isDebugMode = NO;
    self.isOutoutLog = NO;
    self.isUseHeaderSignature = YES;
    self.isUseHttpHeaderToken = YES;
    self.isAutoCancelTheSameRequesting = YES;
    
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
    self.defaultNaviBackroundImageName = @"background_navigationbar_default";
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
    
    [self setUpCustomValue];
}

// 在category中重写该方法可以修改默认值
- (void)setUpCustomValue{
}

- (BOOL)isDownloadImageViaWWAN{
    NSString * name = @"kIsDownloadImageViaWWAN";
    NSObject * tempObj = [self getLocalConfigValueByName:name];
    if (tempObj) {
        NSString * tempValue = [NSString stringWithFormat:@"%@",tempObj];
        return [tempValue boolValue];
    }else{
        self.memoryParams[name] = @(_isDownloadImageViaWWAN);
        return _isDownloadImageViaWWAN;
    }
}

- (BOOL)isDebugModeAvailable{
    if (DWKDataInstance.isAppApproved) {
        // 通过审核就关闭debugMode
        return NO;
    }
    NSString * name = @"kIsDebugModeAvailable";
    NSObject *tempObject = [self getLocalConfigValueByName:name];
    if (tempObject) {
        NSString *tempValue = [NSString stringWithFormat:@"%@", tempObject];
        return [tempValue boolValue];
    }
    else {
        self.memoryParams[name] = @(_isDebugModeAvailable);
        return _isDebugModeAvailable;
    }
}

- (BOOL)isDebugMode{
    NSString * name = @"DWKKitConfigData_isDebugMode";
    NSObject * tempObj = nil;
    if (self.memoryParams[name]) {
        tempObj = self.memoryParams[name];
    }else{
        tempObj = DWKGetObjectByFile(name, kSaveLocalConfigFileName);
        if ( ! tempObj) {
            tempObj = @(_isDebugMode);
        }
        self.memoryParams[name] = tempObj;
    }
    NSString *tempValue = [NSString stringWithFormat:@"%@", tempObj];
    return [tempValue boolValue];
}


- (BOOL)isOutputLog {
    NSString *name = @"YSCConfigData_isOutputLog";
    NSObject *tempObject = nil;
    if (self.memoryParams[name]) {
        tempObject = self.memoryParams[name];
    }
    else {
        tempObject = DWKGetObjectByFile(name, kSaveLocalConfigFileName);
        if ( ! tempObject) {
            tempObject = @(_isOutputLog);
        }
        self.memoryParams[name] = tempObject;
    }
    NSString *tempValue = [NSString stringWithFormat:@"%@", tempObject];
    return [tempValue boolValue];
}


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
    self.memoryParams[name] = value;
    DWKSaveObjectByFile(value, name, kSaveLocalConfigFileName);
}
- (NSObject *)getLocalConfigValueByName:(NSString *)name {
    return [self _objectOfLocalConfigFileByName:name];
}


//=========================================================================
// 管理配置文件里的参数
//=========================================================================
- (void)resetConfigParams {
    [self.cachedParams removeAllObjects];
    [self.memoryParams removeAllObjects];
}
- (void)saveObject:(NSObject *)object toMemoryByName:(NSString *)name {
    RETURN_WHEN_OBJECT_IS_EMPTY(name);
    if (object) {
        self.memoryParams[name] = object;
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
            self.memoryParams[name] = tempValue;
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
        NSObject *localObject = DWKGetObjectByFile(name, kSaveLocalConfigFileName);
        if (localObject) {
            self.memoryParams[name] = localObject;
            return localObject;
        }
    }
    return nil;
}
- (NSObject *)_objectOfConfigByName:(NSString *)name {
    RETURN_NIL_WHEN_OBJECT_IS_EMPTY(name);
    if (self.memoryParams[name]) {
        return self.memoryParams[name];
    }
    
    NSString *tempValue = [self _valueOfCachedConfig:name];
    if (tempValue) {
        self.memoryParams[name] = tempValue;
        return tempValue;
    }
    return nil;
}
- (NSString *)_valueOfCachedConfig:(NSString *)name {
    if (self.cachedParams[name]) {
        return TRIM_STRING(self.cachedParams[name]);
    }
    [self.cachedParams removeAllObjects];
    self.cachedParams = DWKGetObjectByFile(@"AppParams", @"CachedParams");
    if (self.cachedParams[name]) {
        return TRIM_STRING(self.cachedParams[name]);
    }
    return nil;
}
// 获取本地配置文件参数值(只有第一次访问是读取硬盘的文件，以后就直接从内存中读取参数值)
- (NSString *)_valueOfLocalConfig:(NSString *)name {
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(name);
    //1. 检测缓存
    if (self.localParms[name]) {
        return TRIM_STRING(self.localParms[name]);
    }
    //2. 加载到缓存
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:self.appConfigPlistName ofType:@"plist"];
    if (self.isDebugMode) {
        plistPath = [[NSBundle mainBundle] pathForResource:self.appConfigDebugPlistName ofType:@"plist"];
    }
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    [self.localParms removeAllObjects];
    [self.localParms addEntriesFromDictionary:dict];
    if (self.localParms[name]) {
        return TRIM_STRING(self.localParms[name]);
    }
    return nil;
}




@end
