//
//  PSKStorageUtil.h
//  PisenKit
//
//  Created by 杨胜超 on 16/7/4.
//  Copyright © 2016年 Pisen. All rights reserved.
//


#define PSKSaveObject(obj,key)                      [PSKStorageUtil saveObject:obj forKey:key fileName:nil subFolder:nil]
#define PSKSaveObjectByFile(obj,key,file)           [PSKStorageUtil saveObject:obj forKey:key fileName:file subFolder:nil]
#define PSKSaveCacheObject(obj,key)                 [PSKStorageUtil saveCacheObject:obj forKey:key fileName:nil subFolder:nil]
#define PSKSaveCacheObjectByFile(obj,key,file)      [PSKStorageUtil saveCacheObject:obj forKey:key fileName:file subFolder:nil]
#define PSKGetObject(key)                           [PSKStorageUtil getObjectForKey:key fileName:nil subFolder:nil]
#define PSKGetObjectByFile(key,file)                [PSKStorageUtil getObjectForKey:key fileName:file subFolder:nil]
#define PSKGetCacheObject(key)                      [PSKStorageUtil getCacheObjectForKey:key fileName:nil subFolder:nil]
#define PSKGetCacheObjectByFile(key,file)           [PSKStorageUtil getCacheObjectForKey:key fileName:file subFolder:nil]

//====================================
//
// 本地缓存常用目录
//
//====================================
@interface PSKStorageUtil : NSObject
/**
 *  设置用户ID
 */
+ (void)setUserId:(NSString *)userId;

/**
 *  /Documents/PisenKitStorage/
 */
+ (NSString *)directoryPathOfDocumentsStorage;
/**
 *  没有userId: /Documents/PisenKitStorage/
 *  存在userId: /Documents/PisenKitStorage/userId/
 */
+ (NSString *)directoryPathOfDocumentsUserStorage;

/**
 *  /Library/Caches/PisenKitStorage/
 */
+ (NSString *)directoryPathOfLibraryCachesStorage;
/**
 *  没有userId: /Library/Caches/PisenKitStorage/
 *  存在userId: /Library/Caches/PisenKitStorage/userId/
 */
+ (NSString *)directoryPathOfLibraryCachesUserStorage;

/**
 *  返回保存日志的目录
 */
+ (NSString *)directoryPathOfLog;
/**
 *  删除以下目录中的所有数据
 *  1. /Library/Caches/PisenKitStorage/
 *  2. /Library/Caches/BOUNLD_ID/
 */
+ (void)clearLibraryCaches;
@end



//====================================
//
// 采用对象的序列化进行本地缓存
//
//====================================
@interface PSKStorageUtil (Archive)
/**
 *  /Document/PisenKitStorage
 *  该目录下的数据与业务逻辑相关
 *  overwrite = NO
 */
+ (BOOL)saveObject:(NSObject *)object forKey:(NSString *)key fileName:(NSString *)fileName subFolder:(NSString *)subFoler;
+ (id)getObjectForKey:(NSString *)key fileName:(NSString *)fileName subFolder:(NSString *)subFoler;

/**
 *  /Library/Caches/PisenKitStorage
 *  该目录下的数据与业务逻辑无关，随时都可以清除
 *  overwrite = NO
 */
+ (BOOL)saveCacheObject:(NSObject *)object forKey:(NSString *)key fileName:(NSString *)fileName subFolder:(NSString *)subFoler;
+ (id)getCacheObjectForKey:(NSString *)key fileName:(NSString *)fileName subFolder:(NSString *)subFoler;

/**
 *  对象的序列化与反序列化
 */
+ (BOOL)archiveDictionary:(NSDictionary *)dicionary toFilePath:(NSString *)filePath;
+ (BOOL)archiveDictionary:(NSDictionary *)dicionary toFilePath:(NSString *)filePath overwrite:(BOOL)overwrite;
+ (NSDictionary *)unarchiveDictionaryFromFilePath:(NSString *)filePath;
@end



//====================================
//
// 管理keychain中的数据
//
//====================================
@interface PSKStorageUtil (KeyChain)
/** 新增&&更新 */
+ (BOOL)saveObject:(id)anObject inKeyChainForKey:(NSString *)key;
/** 获取 */
+ (id)objectInKeyChainForKey:(NSString *)key;
/** 移除 */
+ (BOOL)removeObjectInKeyChainForKey:(NSString *)key;
@end


