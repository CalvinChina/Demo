//
//  PSKGeneralUtil.h
//  PisenKit
//
//  Created by 杨胜超 on 16/7/5.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import <Foundation/Foundation.h>

//====================================
//
// 常用小方法
//
//====================================
@interface PSKGeneralUtil : NSObject
// 检测新版本
+ (void)checkNewVersionOnAppStore;
+ (void)checkOnAppStoreStatus:(NSString *)appStoreId block:(void (^)(NSDictionary *releaseItem))block;

// NSURL获取参数
+ (NSDictionary *)getParamsInNSURL:(NSURL *)url;
+ (NSDictionary *)getParamsInQueryString:(NSString *)queryString;

// 获取wifi的mac地址
//1. 全部获取
//{
//    BSSID = "c8:3a:35:57:30:a0";
//    SSID = ZLDNRJB;
//    SSIDDATA = ;
//}
+ (id)fetchSSIDInfo;
//2. 只获取BSSID
//{
//    c8:3a:35:57:30:a0
//}
+ (NSString *)currentWifiBSSID;

// 添加cell
+ (void)insertTableViewCell:(UITableView *)tableView oldCount:(NSInteger)oldCount addCount:(NSInteger)addCount;
+ (void)insertCollectionViewCell:(UICollectionView *)collectionView oldCount:(NSInteger)oldCount addCount:(NSInteger)addCount;

// 保存错误日志
+ (void)saveNSError:(NSError *)error;

// 检测是否用测试证书打包
+ (BOOL)isArchiveByDevelopment;
@end
