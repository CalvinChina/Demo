//
//  DWKManager.h
//  DWKKit
//
//  Created by pisen on 16/10/18.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 * 1. if (NSOrderedAscending != COMPARE_VERSION(v1,v2))  { //v1 >= v2 }
 * 2. if (NSOrderedDescending == COMPARE_VERSION(v1,v2)) { //v1 > v2 }
 * 3. if (NSOrderedAscending == COMPARE_VERSION(v1,v2))  { //v1 < v2 }
 */
#define COMPARE_VERSION(v1,v2)          [v1 compare:v2 options:NSNumericSearch]
#define COMPARE_CURRENT_VERSION(v)      COMPARE_VERSION([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], (v))
#define APP_SKIP_VERSION(v)             [NSString stringWithFormat:@"APP_SKIP_VERSION_%@", v]
#define APP_LAUNCH_VERSION(v)           [NSString stringWithFormat:@"APP_LAUNCH_VERSION_%@", v]


/**
 *  公共方法类
 *  作用：管理各种小方法(convenient methods)
 */

@interface DWKManager : NSObject

// 检测新版本
+ (void)checkNewVersion;
+ (void)checkNewVersionOnAppStore;
+ (void)checkOnAppStoreStatus:(NSString *)appStoreId block:(void (^)(NSDictionary *releaseItem))block;

// 打电话
+ (void)makeCall:(NSString *)phoneNumber;
+ (void)makeCall:(NSString *)phoneNumber success:(void(^)(void))block;

// NSURL获取参数
+ (NSDictionary *)getParamsInNSURL:(NSURL *)url;
+ (NSDictionary *)getParamsInQueryString:(NSString *)queryString;

// 获取wifi的mac地址
+ (id)fetchSSIDInfo;
+ (NSString *)currentWifiBSSID;

// 添加cell
+ (void)insertTableViewCell:(UITableView *)tableView oldCount:(NSInteger)oldCount addCount:(NSInteger)addCount;
+ (void)insertCollectionViewCell:(UICollectionView *)collectionView oldCount:(NSInteger)oldCount addCount:(NSInteger)addCount;

// 保存错误日志
+ (void)saveNSError:(NSError *)error;

//检测是否用测试证书打包
+ (BOOL)isArchiveByDevelopment;

@end
