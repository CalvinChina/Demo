//
//  PSKGeneralUtil.m
//  PisenKit
//
//  Created by 杨胜超 on 16/7/5.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import "PSKGeneralUtil.h"
#import <SystemConfiguration/CaptiveNetwork.h>

//新版本描述模型
@interface NewVersionModel : PSKDataBaseModel
@property (nonatomic, strong) NSString *appVersion;         //1.4.17
@property (nonatomic, strong) NSString *appUpdateLog;       //新版本描述
@property (nonatomic, assign) BOOL isForcedUpdate;          //是否强制升级
@property (nonatomic, strong) NSString *appDownloadUrl;     //plist文件的url地址 or appstore's url
@end
@implementation NewVersionModel @end


//====================================
//
// 常用小方法
//
//====================================
@implementation PSKGeneralUtil

+ (void)checkNewVersionOnAppStore {
    [self checkOnAppStoreStatus:nil block:^(NSDictionary *releaseItem) {
        NSString *onlineVersion = releaseItem[@"version"];//最新版本号
        NSString *releaseNotes = releaseItem[@"releaseNotes"];//最新版本的修改内容
        if (NSOrderedAscending == COMPARE_CURRENT_VERSION(onlineVersion)) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NewVersionModel *versionModel = [NewVersionModel new];
                versionModel.appVersion = onlineVersion;
                versionModel.appUpdateLog = releaseNotes;
                versionModel.isForcedUpdate = NO;
                [self _checkNewVersionWithModel:versionModel isCheckOnAppStore:YES];
            });
        }
    }];
}
+ (void)checkOnAppStoreStatus:(NSString *)appStoreId block:(void (^)(NSDictionary *releaseItem))block {
    if (OBJECT_IS_EMPTY(appStoreId)) {
        appStoreId = PSKConfigManagerInstance.appStoreId;
    }
    NSURL *checkUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/cn/lookup?id=%@", appStoreId]];
    [[[NSURLSession sharedSession] dataTaskWithURL:checkUrl completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *dataString = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
        NSDictionary *resultsDict = (NSDictionary *)[NSString psk_jsonObjectOfString:dataString];
        NSArray *results = resultsDict[@"results"];
        NSDictionary *releaseItem = nil;
        if ([results count] > 0) {
            releaseItem = results[0];
        }
        if (block) {
            block(releaseItem);
        }
    }] resume];
}
+ (void)_checkNewVersionWithModel:(NewVersionModel *)versionModel isCheckOnAppStore:(BOOL)isCheckOnAppStore {
    //1. 取出模型中的参数
    NSString *appVersion = TRIM_STRING(versionModel.appVersion);
    BOOL isSkipTheVersion = [PSKGetCacheObject(APP_SKIP_VERSION(appVersion)) boolValue];
    BOOL isForcedUpdate = versionModel.isForcedUpdate;
    NSString *appUpdateLog = TRIM_STRING(versionModel.appUpdateLog);
    NSString *appDownloadUrl = TRIM_STRING(versionModel.appDownloadUrl);
    if ( ! [NSString psk_isMatchRegex:PSKConfigManagerInstance.regexWebUrl withString:appDownloadUrl]) {
        appDownloadUrl = [@"https://itunes.apple.com/cn/app/id" stringByAppendingString:PSKConfigManagerInstance.appStoreId];
    }
    
    //2. 判断是否需要更新
    if ( ! isSkipTheVersion) {
        if (NSOrderedAscending == COMPARE_CURRENT_VERSION(appVersion)) {
            //0. 判断是否重复调用(APP第一次运行时如果有alertView需要处理，则applicationDidBecomeActive在处理完后会再次被调用，从而导致版本检测调用多次而出问题)
            static BOOL isAlertShow = NO;
            if (isAlertShow) {
                return;
            }
            isAlertShow = YES;
            
            //TODO:
            //1. 显示新版本提示
//            NSString *title = [NSString stringWithFormat:@"发现新版本 %@", appVersion];
//            UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:title message:appUpdateLog];
//            [alertView bk_setCancelButtonWithTitle:@"立即更新" handler:^{
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appDownloadUrl]];
//                exit(0);
//            }];
//            if ( ! isForcedUpdate ) {   //非强制更新的话才显示更多选项
//                [alertView bk_addButtonWithTitle:@"忽略此版本" handler:^{
//                    YSCSaveCacheObject(@(YES), APP_SKIP_VERSION(appVersion));
//                    isAlertShow = NO;
//                }];
//                [alertView bk_addButtonWithTitle:@"稍后再说" handler:^{
//                    isAlertShow = NO;
//                }];//下次启动再次检测
//            }
//            [alertView show];
        }
        else {
            if ( ! isCheckOnAppStore) {//如果接口未来得及更新升级信息，就自动检测AppStore上的新版本
                [self checkNewVersionOnAppStore];
            }
        }
    }
    else {
        if ( ! isCheckOnAppStore) {//如果接口未来得及更新升级信息，就自动检测AppStore上的新版本
            [self checkNewVersionOnAppStore];
        }
    }
}

+ (NSDictionary *)getParamsInNSURL:(NSURL *)url {
    RETURN_NIL_WHEN_OBJECT_IS_EMPTY(url)
    return [self getParamsInQueryString:url.query];
}
+ (NSDictionary *)getParamsInQueryString:(NSString *)queryString {
    RETURN_NIL_WHEN_OBJECT_IS_EMPTY(queryString)
    NSScanner *scanner = [NSScanner scannerWithString:queryString];
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"&?"]];
    if ([queryString psk_isContains:@"?"]) {
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

+ (id)fetchSSIDInfo {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    NSLog(@"Supported interfaces: %@", ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        NSLog(@"%@ => %@", ifnam, info);
        if (OBJECT_ISNOT_EMPTY(info) ) { break; }
    }
    return info;
}
+ (NSString *)currentWifiBSSID {
    if ([UIDevice psk_isRunningOnSimulator]) {
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
    return [PSKFormatUtil formatMacAddress:bssid];
}


+ (void)insertTableViewCell:(UITableView *)tableView oldCount:(NSInteger)oldCount addCount:(NSInteger)addCount {
    NSMutableArray *insertedIndexPaths = [NSMutableArray array];
    for (int i = 0; i < addCount; i++) {
        [insertedIndexPaths addObject:[NSIndexPath indexPathForRow:oldCount + i inSection:0]];
    }
    [tableView beginUpdates];
    [tableView insertRowsAtIndexPaths:insertedIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView endUpdates];
}
+ (void)insertCollectionViewCell:(UICollectionView *)collectionView oldCount:(NSInteger)oldCount addCount:(NSInteger)addCount {
    [UIView setAnimationsEnabled:NO];//默认的动画效果有点乱，这里先把所有动画关掉
    [collectionView performBatchUpdates:^{
        NSMutableArray *insertedIndexPaths = [NSMutableArray array];
        for (int i = 0; i < addCount; i++) {
            [insertedIndexPaths addObject:[NSIndexPath indexPathForRow:oldCount + i inSection:0]];
        }
        [collectionView insertItemsAtIndexPaths:insertedIndexPaths];
    }
                             completion:nil];
    [UIView setAnimationsEnabled:YES];
}

+ (void)saveNSError:(NSError *)error {
    NSMutableString *errMsg = [NSMutableString stringWithFormat:@"\r>>>>>>>>>>>>>>>>>>>>errorCode(%ld)>>>>>>>>>>>>>>>>>>>>\r", (long)error.code];
    [errMsg appendFormat:@"errorMessage:%@\r", error];
    [errMsg appendFormat:@"<<<<<<<<<<<<<<<<<<<<errorCode(%ld)<<<<<<<<<<<<<<<<<<<<\r\n", (long)error.code];
    NSLog(@"error=%@", errMsg);
}
+ (BOOL)isArchiveByDevelopment {
    // Special case of simulator
    if ([UIDevice psk_isRunningOnSimulator]) {
        return YES;
    }
    
    // There is no provisioning profile in AppStore Apps
    NSString *profilePath = [[NSBundle mainBundle] pathForResource:@"embedded" ofType:@"mobileprovision"];
    
    // Check provisioning profile existence
    if (profilePath) {
        // Get hex representation
        NSData *profileData = [NSData dataWithContentsOfFile:profilePath];
        NSString *profileString = [NSString stringWithFormat:@"%@", profileData];
        
        // Remove brackets at beginning and end
        profileString = [profileString stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
        profileString = [profileString stringByReplacingCharactersInRange:NSMakeRange(profileString.length - 1, 1) withString:@""];
        
        // Remove spaces
        profileString = [profileString stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        // Convert hex values to readable characters
        NSMutableString *profileText = [NSMutableString new];
        for (int i = 0; i < profileString.length; i += 2) {
            NSString *hexChar = [profileString substringWithRange:NSMakeRange(i, 2)];
            int value = 0;
            sscanf([hexChar cStringUsingEncoding:NSASCIIStringEncoding], "%x", &value);
            [profileText appendFormat:@"%c", (char)value];
        }
        
        // Remove whitespaces and new lines characters
        NSArray *profileWords = [profileText componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *profileClearText = [profileWords componentsJoinedByString:@""];
        
        // Look for debug value
        NSRange debugRange = [profileClearText rangeOfString:@"<key>get-task-allow</key><true/>"];
        if (debugRange.location != NSNotFound) {
            return YES;
        }
    }
    
    // Return NO by default to avoid security leaks
    return NO;
}

@end
