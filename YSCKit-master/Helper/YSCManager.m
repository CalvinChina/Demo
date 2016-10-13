//
//  YSCManager.m
//  YSCKit
//
//  Created by yangshengchao on 16/1/28.
//  Copyright © 2016年 Builder. All rights reserved.
//

#import "YSCManager.h"
#import <SystemConfiguration/CaptiveNetwork.h>

//--------------------------------------
//  常用操作
//--------------------------------------
@implementation YSCManager
// 检测新版本
+ (void)CheckNewVersion {
    CheckNewVersionType type = [kCheckNewVersionType integerValue];
    if (CheckNewVersionTypeServer == type) {
        [YSCRequestManager RequestFromUrl:kResPathAppCommonUrl
                                  withAPI:kResPathCheckNewVersion
                                   params:nil
                                dataModel:[NewVersionModel class]
                              requestType:RequestTypeGET
                         requestSuccessed:^(id responseObject) {
                             NewVersionModel *versionModel = (NewVersionModel *)responseObject;
                             if (isNotEmpty(versionModel.appVersion)) {
                                 [self _CheckNewVersionWithModel:versionModel isCheckOnAppStore:NO];
                             }
                             else {
                                 [self CheckNewVersionOnAppStore];
                             }
                         }
                           requestFailure:^(ErrorType errorType, NSError *error) {
                               [self CheckNewVersionOnAppStore];
                           }];
    }
    else if (CheckNewVersionTypeAppStore == type) {
        [self CheckNewVersionOnAppStore];
    }
}
+ (void)CheckNewVersionOnAppStore {
    NSURL *checkUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", kAppStoreId]];
    [[[NSURLSession sharedSession] dataTaskWithURL:checkUrl completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *dataString = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
        NSDictionary *resultsDict = (NSDictionary *)[NSString jsonObjectOfString:dataString];
        NSArray *results = resultsDict[@"results"];
        if ([results count] > 0) {
            NSDictionary *releaseItem = results[0];
            NSString *onlineVersion = releaseItem[@"version"];//最新版本号
            NSString *releaseNotes = releaseItem[@"releaseNotes"];//最新版本的修改内容
            if (NSOrderedAscending == [AppVersion compare:onlineVersion options:NSNumericSearch]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NewVersionModel *versionModel = [NewVersionModel new];
                    versionModel.appVersion = onlineVersion;
                    versionModel.appUpdateLog = releaseNotes;
                    versionModel.isForcedUpdate = NO;
                    [self _CheckNewVersionWithModel:versionModel isCheckOnAppStore:YES];
                });
            }
        }
    }] resume];
}
+ (void)_CheckNewVersionWithModel:(NewVersionModel *)versionModel isCheckOnAppStore:(BOOL)isCheckOnAppStore {
    //1. 取出模型中的参数
    NSString *appVersion = Trim(versionModel.appVersion);
    BOOL isSkipTheVersion = [YSCGetCacheObject(SkipVersion(appVersion)) boolValue];
    BOOL isForcedUpdate = versionModel.isForcedUpdate;
    NSString *appUpdateLog = Trim(versionModel.appUpdateLog);
    NSString *appDownloadUrl = Trim(versionModel.appDownloadUrl);
    if (NO == [appDownloadUrl isUrl]) {
        appDownloadUrl = AppUpdateUrl;
    }
    
    //2. 判断是否需要更新
    if (NO == isSkipTheVersion) {
        if (NSOrderedAscending == [AppVersion compare:appVersion options:NSNumericSearch]) {
            //0. 判断是否重复调用(APP第一次运行时如果有alertView需要处理，则applicationDidBecomeActive在处理完后会再次被调用，从而导致版本检测调用多次而出问题)
            static BOOL isAlertShow = NO;
            if (isAlertShow) {
                return;
            }
            isAlertShow = YES;
            
            //1. 显示新版本提示
            NSString *title = [NSString stringWithFormat:@"发现新版本 %@", appVersion];
            UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:title message:appUpdateLog];
            [alertView bk_setCancelButtonWithTitle:@"立即更新" handler:^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appDownloadUrl]];
                exit(0);
            }];
            if (NO == isForcedUpdate ) {   //非强制更新的话才显示更多选项
                [alertView bk_addButtonWithTitle:@"忽略此版本" handler:^{
                    YSCSaveCacheObject(@(YES), SkipVersion(appVersion));
                    isAlertShow = NO;
                }];
                [alertView bk_addButtonWithTitle:@"稍后再说" handler:^{
                    isAlertShow = NO;
                }];//下次启动再次检测
            }
            [alertView show];
        }
        else {
            if (NO == isCheckOnAppStore) {//如果接口未来得及更新升级信息，就自动检测AppStore上的新版本
                [self CheckNewVersionOnAppStore];
            }
        }
    }
    else {
        if (NO == isCheckOnAppStore) {//如果接口未来得及更新升级信息，就自动检测AppStore上的新版本
            [self CheckNewVersionOnAppStore];
        }
    }
}

// 打电话
+ (void)MakeCall:(NSString *)phoneNumber {
    [self MakeCall:phoneNumber success:nil];
}
+ (void)MakeCall:(NSString *)phoneNumber success:(YSCBlock)block {
    if ([self isEmpty:phoneNumber]) {
        return;
    }
    if (NO == [UIDevice isCanMakeCall]) {
        [UIView showResultThenHideOnWindow:@"无法拨打电话"];
        return;
    }
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];//去掉-
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[NSString trimString:phoneNumber]]];
    NSString *message = [NSString stringWithFormat:@"确定要拨打电话：%@？", phoneNumber];
    UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:@"提示" message:message];
    [alertView bk_addButtonWithTitle:@"确定" handler:^{
        if (block) {
            block();
        }
        [[UIApplication sharedApplication] openURL:phoneURL];
    }];
    [alertView bk_setCancelButtonWithTitle:@"取消" handler:nil];
    [alertView show];
}

// NSURL获取参数
+ (NSDictionary *)GetParamsInNSURL:(NSURL *)url {
    ReturnNilWhenObjectIsEmpty(url)
    return [self GetParamsInQueryString:url.query];
}
+ (NSDictionary *)GetParamsInQueryString:(NSString *)queryString {
    ReturnNilWhenObjectIsEmpty(queryString)
    NSScanner *scanner = [NSScanner scannerWithString:queryString];
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"&?"]];
    if ([queryString isContains:@"?"]) {
        [scanner scanUpToString:@"?" intoString:nil];//skip to ?
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *tmpValue;
    while ([scanner scanUpToString:@"&" intoString:&tmpValue]) {
        NSArray *components = [tmpValue componentsSeparatedByString:@"="];
        if (components.count >= 2) {
            NSString *key = [components[0] stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
            NSString *value = [components[1] stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
            parameters[key] = value;
        }
    }
    return parameters;
}

// 获取wifi的mac地址
//1. 全部获取
//{
//    BSSID = "c8:3a:35:57:30:a0";
//    SSID = ZLDNRJB;
//    SSIDDATA = ;
//}
+ (id)FetchSSIDInfo {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    NSLog(@"Supported interfaces: %@", ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        NSLog(@"%@ => %@", ifnam, info);
        if (info && [info count]) { break; }
    }
    return info;
}
//2. 只获取BSSID
//{
//    c8:3a:35:57:30:a0
//}
+ (NSString *)CurrentWifiBSSID {
    if ([UIDevice isRunningOnSimulator]) {
        return @"";
    }
    NSString *bssid = nil;
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    for (NSString *ifnam in ifs) {
        NSDictionary *info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info[@"BSSID"]) {
            bssid = [NSString stringWithFormat:@"%@", info[@"BSSID"]];
            bssid = bssid.lowercaseString;
        }
    }
    return [self FormatMacAddress:bssid];
}

// 解析错误信息并格式化输出
+ (NSString *)ResolveErrorType:(ErrorType)errorType andError:(NSError *)error {
    NSMutableString *errMsg = [NSMutableString stringWithFormat:@"\r>>>>>>>>>>>>>>>>>>>>ErrorType[%ld]>>>>>>>>>>>>>>>>>>>>\r", (long)errorType];//错误标记开始
    NSString *messageTitle = @"提示";
    NSString *messageDetail = [self ResolveErrorType:errorType];
    if (isEmpty(messageDetail)) {
        messageDetail = GetNSErrorMsg(error);
    }
    if (isEmpty(messageDetail)) {
        messageDetail = @"未知错误";
    }
    
    //继续组织错误日志
    [errMsg appendFormat:@"  messageTitle:%@\r  messageDetail:%@\r", messageTitle, messageDetail];//显示解析后的错误提示
    if (error) {
        [errMsg appendFormat:@"  errorCode:%ld\r  errorMessage:%@\r", (long)error.code, error];//显示error的错误内容
    }
    [errMsg appendFormat:@"<<<<<<<<<<<<<<<<<<<<ErrorType[%ld]<<<<<<<<<<<<<<<<<<<<\r\n", (long)errorType];//错误标记结束
    NSLog(@"errMsg=%@", errMsg);
    return messageDetail;
}
+ (NSString *)ResolveErrorType:(ErrorType)errorType {
    if (ErrorTypeDisconnected == errorType) {
        return @"网络未连接";
    }
    else if (ErrorTypeConnectionFailed == errorType) {
        return @"网络连接失败";
    }
    else if (ErrorTypeServerFailed == errorType) {
        return @"服务器连接失败";
    }
    else if (ErrorTypeInternalServer == errorType) {
        return @"";//NOTE:需要进一步解析dataModel.state 和 message
    }
    else if (ErrorTypeCopyFileFailed == errorType) {
        return @"拷贝文件失败";
    }
    else if (ErrorTypeURLInvalid == errorType) {
        return @"网络请求的URL不合法";
    }
    else if (ErrorTypeDataEmpty == errorType) {
        return @"返回数据为空";
    }
    else if (ErrorTypeDataMappingFailed == errorType) {
        return @"数据映射本地模型失败";
    }
    else if (ErrorTypeLoginExpired == errorType) {
        return @"登录过期";
    }
    
    return @"";
}
+ (void)SaveNSError:(NSError *)error {
    NSMutableString *errMsg = [NSMutableString stringWithFormat:@"\r>>>>>>>>>>>>>>>>>>>>errorCode(%ld)>>>>>>>>>>>>>>>>>>>>\r", (long)error.code];
    [errMsg appendFormat:@"errorMessage:%@\r", error];
    [errMsg appendFormat:@"<<<<<<<<<<<<<<<<<<<<errorCode(%ld)<<<<<<<<<<<<<<<<<<<<\r\n", (long)error.code];
    NSLog(@"error=%@", errMsg);
}

// UIView(UILabel/UITextField/UITextView)上显示HTML
//只能显示HTML内容，但不能点击链接
+ (void)LayoutHtmlString:(NSString *)htmlString onView:(UIView *)view {
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding]
                                                                   options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}
                                                        documentAttributes:nil
                                                                     error:nil];
    if ([view respondsToSelector:@selector(setAttributedText:)]) {
        [view performSelector:@selector(setAttributedText:) withObject:attrStr];
    }
}
+ (void)FillMutableAttributedString:(NSMutableAttributedString *)attributedString byRegular:(NSRegularExpression *)regular attributes:(NSDictionary *)attributes {
    ReturnWhenObjectIsEmpty(attributedString);
    ReturnWhenObjectIsEmpty(regular);
    ReturnWhenObjectIsEmpty(attributedString.string);
    
    NSRange stringRange = NSMakeRange(0, [attributedString.string length]);
    [regular enumerateMatchesInString:attributedString.string
                              options:0
                                range:stringRange
                           usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                               //0. 获取到匹配的范围
                               NSRange matchRange = [result range];
                               //1. 设置通用的attribute
                               if (attributes) {
                                   [attributedString addAttributes:attributes range:matchRange];
                               }
                               //2. 分别设置匹配项目的attribute
                               if ([result resultType] == NSTextCheckingTypeLink) {
                                   NSURL *url = [result URL];
                                   [attributedString addAttribute:NSLinkAttributeName value:url range:matchRange];
                               }
                               else if ([result resultType] == NSTextCheckingTypePhoneNumber) {
                                   NSString *phoneNumber = [result phoneNumber];
                                   [attributedString addAttribute:NSLinkAttributeName value:phoneNumber range:matchRange];
                               }
                               else {
                                   //其它特殊内容
                               }
                           }];

}
@end


//--------------------------------------
//  设置全局参数
//--------------------------------------
@implementation YSCManager (Config)
+ (void)ConfigNavigationBar {
    //设置BarButtonItem字体大小和颜色(如果不设置将按默认的tintColor显示)
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : kDefaultNaviBarItemColor,
                                                           NSFontAttributeName : kDefaultNaviBarItemFont}
                                                forState:UIControlStateNormal];
    //其它大部分的设置都放在创建navigationController([UIResponder createNavi])中了
}
+ (void)ConfigPullToBack {
//    [MLBlackTransition validatePanPackWithMLBlackTransitionGestureRecognizerType:MLBlackTransitionGestureRecognizerTypeScreenEdgePan];
    //TODO:测试自带的拖动返回功能
}
+ (void)RegisterForRemoteNotification {
    UIApplication *application = [UIApplication sharedApplication];
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert |
                                                UIUserNotificationTypeBadge |
                                                UIUserNotificationTypeSound
                                                                                 categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    } else {
        [application registerForRemoteNotificationTypes:
         UIRemoteNotificationTypeBadge |
         UIRemoteNotificationTypeAlert |
         UIRemoteNotificationTypeSound];
    }
}
@end


//--------------------------------------
//  格式化数据
//--------------------------------------
@implementation YSCManager (Format)
+ (NSString *)FormatPrice:(NSNumber *)price {
    return [self FormatPrice:price showMoneyTag:YES showDecimalPoint:YES useUnit:NO];
}
+ (NSString *)FormatPriceWithUnit:(NSNumber *)price {
    return [self FormatPrice:price showMoneyTag:YES showDecimalPoint:YES useUnit:YES];
}
+ (NSString *)FormatPrice:(NSNumber *)price showMoneyTag:(BOOL)isTagUsed showDecimalPoint:(BOOL) isDecimal useUnit:(BOOL)isUnitUsed {
    NSString *formatedPrice = @"";
    //是否保留2位小数
    if (isDecimal) {
        formatedPrice = [NSString stringWithFormat:@"%0.2f", [price doubleValue]];
    }
    else {
        formatedPrice = [NSString stringWithFormat:@"%ld", (long)[price integerValue]];
    }
    
    //是否添加前缀 ￥
    if (isTagUsed) {
        formatedPrice = [NSString stringWithFormat:@"￥%@", formatedPrice];
    }
    
    //是否添加后缀 元
    if(isUnitUsed) {
        formatedPrice = [NSString stringWithFormat:@"%@元", formatedPrice];
    }
    
    return formatedPrice;
}
+ (NSString *)FormatNumberValue:(NSNumber *)value {
    return [self FormatFloatValue:value.floatValue];
}
+ (NSString *)FormatFloatValue:(CGFloat)value {
    if (value == floorf(value)) {
        return [NSString stringWithFormat:@"%.0f", value];
    }
    else {
        return [NSString stringWithFormat:@"%.2f", value];
    }
}
+ (NSString *)FormatMacAddress:(NSString *)macAddress {
    NSMutableString *newMacAddress = [NSMutableString string];
    NSArray *array = [NSString splitString:macAddress byRegex:@":"];
    for (NSString *str in array) {
        NSScanner *scanner = [NSScanner scannerWithString:str];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [newMacAddress appendFormat:@"%02x:", intValue];
    }
    if ([newMacAddress length] > 0) {
        return [newMacAddress removeLastChar];
    }
    else {
        return macAddress;
    }
}
+ (NSString *)FormatPrintJsonStringOnConsole:(NSString *)jsonString {
    if (isNotEmpty(jsonString)) {
        NSError *error = nil;
        id data = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                                  options:0
                                                    error:&error];
        if (nil == error) {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                               options:(NSJSONWritingOptions)NSJSONWritingPrettyPrinted
                                                                 error:&error];
            if (nil == error) {
                return (jsonData) ? [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] : @"";
            }
            else {
                return @"";
            }
        }
        else {
            return @"";
        }
    }
    else {
        return @"";
    }
}
@end


//--------------------------------------
//  Sqlite操作
//--------------------------------------
@implementation YSCManager (Sqlite)
+ (BOOL)SqliteUpdate:(NSString *)sql {
    return [self SqliteUpdate:sql dbPath:kDBRealPath];
}
+ (BOOL)SqliteUpdate:(NSString *)sql dbPath:(NSString *)dbPath {
    BOOL isSuccess = NO;
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]) {
        isSuccess = [db executeUpdate:sql];
    }
    [db close];
    return isSuccess;
}
+ (BOOL)SqliteCheckIfExists:(NSString *)sql {
    return [self SqliteCheckIfExists:sql dbPath:kDBRealPath];
}
+ (BOOL)SqliteCheckIfExists:(NSString *)sql dbPath:(NSString *)dbPath {
    BOOL isExists = NO;
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]) {
        FMResultSet *resultSet = [db executeQuery:sql];
        if (resultSet) {
            isExists = [resultSet next];
        }
        [resultSet close];
    }
    [db close];
    return isExists;
}
+ (int)SqliteGetRows:(NSString *)sql {
    return [self SqliteGetRows:sql dbPath:kDBRealPath];
}
+ (int)SqliteGetRows:(NSString *)sql dbPath:(NSString *)dbPath {
    int num = 0;
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]) {
        FMResultSet *resultSet = [db executeQuery:sql];
        if ([resultSet next]) {
            num = [resultSet intForColumnIndex:0];
        }
        [resultSet close];
    }
    [db close];
    return num;
}
@end


//--------------------------------------
//  打开设置里面的某个功能页面
//--------------------------------------
@implementation YSCManager (Setting)
+ (void)OpenPrivacyOfSetting {
    
}
@end



//--------------------------------------
//  Request
//--------------------------------------
@implementation YSCManager (Request)
+ (NSDictionary *)FormatRequestParams:(NSDictionary *)params {
    NSMutableDictionary *newDictParam = [NSMutableDictionary dictionaryWithDictionary:params];
    for (NSString *key in newDictParam.allKeys) {
        NSObject *value = params[key];
        //去掉key和value的前后空格字符
        NSString *newKey = Trim(key);
        NSString *newValue = [NSString stringWithFormat:@"%@", [NSString isEmpty:value] ? @"" : value];
        newValue = Trim(newValue);
        
        [newDictParam removeObjectForKey:key];//移除修改前的key
        newDictParam[newKey] = newValue;
    }
    //NOTE:添加通用参数
    
    NSLog(@"request params:\r%@", newDictParam);
    return newDictParam;
}
+ (NSString *)SignatureWithParams:(NSDictionary *)params {
    NSArray *keys = [[params allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    //1. 按照字典顺序拼接url字符串
    NSMutableString *joinedString = [NSMutableString string];
    for (NSString *key in keys) {
        if ([kParamSignature isEqualToString:key]) {//不对signature进行加密(如果有的话)
            continue;
        }
        [joinedString appendFormat:@"%@%@", Trim(key), Trim(params[key])];
    }
    
    //2. 对参数进行md5加密
    NSString *newString = [NSString stringWithFormat:@"%@%@", joinedString, kParamSecretKey];
    NSString *signature = [[NSString MD5Encrypt:newString] lowercaseString];
    return signature;
}
+ (NSString *)EncryptHttpHeaderToken {
    NSString *currentLongitude = [NSString stringWithFormat:@"%f", YSCInstance.currentLongitude];
    NSString *currentLatitude = [NSString stringWithFormat:@"%f", YSCInstance.currentLatitude];
    NSDictionary *param = @{kParamAppId : kAppId,
                            kParamVersion : AppVersion,
                            kParamUdid : YSCInstance.udid,
                            kParamFrom : kParamFromValue,
                            kParamLongitude : currentLongitude,
                            kParamLatitude : currentLatitude,
                            kParamToken : TOKEN,
                            kParamChannel : kAppChannel,
                            kParamDeviceToken : YSCInstance.deviceToken
                            };
    NSLog(@"ezgoaltoken:\r%@", param);
    NSString *encryptEzgoalToken = [NSString AESEncrypt:[NSString jsonStringWithObject:param] byKey:kParamAESSecretKey];
    NSLog(@"ezgoalToken=\r%@", encryptEzgoalToken);
    return encryptEzgoalToken;
}
+ (NSString *)EncryptPostBodyParam:(NSString *)bodyParam {
    NSLog(@"post body params:\r%@", bodyParam);
    if ([kIsRequestEncrypted boolValue]) {
        return [NSString AESEncrypt:bodyParam byKey:kParamAESSecretKey];
    }
    else {
        return bodyParam;
    }
}
+ (NSString *)ResolveResponseObject:(id)responseObject {
    NSString *resolvedString = @"";
    if ([responseObject isKindOfClass:[NSData class]]) {
        resolvedString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    }
    if ([responseObject isKindOfClass:[NSString class]]) {
        resolvedString = [NSString replaceString:responseObject byRegex:@"[\r\n\t]" to:@""];
    }
    if (isNotEmpty(resolvedString) && NO == [resolvedString isContains:@"{"]) {//这里兼容了返回内容没有加密的情况
        resolvedString = [NSString AESDecrypt:resolvedString byKey:kParamAESSecretKey];
    }
    NSString *formatedJsonString = [YSCManager FormatPrintJsonStringOnConsole:resolvedString];
    formatedJsonString = isEmpty(formatedJsonString) ? resolvedString : formatedJsonString;
    NSLog(@"request success! resolvedString:\r%@", formatedJsonString);
    return resolvedString;
}
@end
