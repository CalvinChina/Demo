//
//  DWKStorageData.h
//  DWKKit
//
//  Created by pisen on 16/10/17.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  缓存单例类
 *  作用：封装缓存目录的管理业务
 */

#define DWKStorageInstance                          [DWKStorageData sharedInstance]

#define DWKSaveObject(obj,key)                      [DWKStorageInstance saveObject:obj forKey:key fileName:nil subFolder:nil]
#define DWKSaveObjectByFile(obj,key,file)           [DWKStorageInstance saveObject:obj forKey:key fileName:file subFolder:nil]
#define DWKSaveCacheObject(obj,key)                 [DWKStorageInstance saveCacheObject:obj forKey:key fileName:nil subFolder:nil]
#define DWKSaveCacheObjectByFile(obj,key,file)      [DWKStorageInstance saveCacheObject:obj forKey:key fileName:file subFolder:nil]
#define DWKGetObject(key)                           [DWKStorageInstance getObjectForKey:key fileName:nil subFolder:nil]
#define DWKGetObjectByFile(key,file)                [DWKStorageInstance getObjectForKey:key fileName:file subFolder:nil]
#define DWKGetCacheObject(key)                      [DWKStorageInstance getCacheObjectForKey:key fileName:nil subFolder:nil]
#define DWKGetCacheObjectByFile(key,file)           [DWKStorageInstance getCacheObjectForKey:key fileName:file subFolder:nil]


//--------------------------------------
//  定义各种文件的缓存路径
//--------------------------------------
@interface DWKStorageData : NSObject

@property (nonatomic, copy) NSString *directoryPathOfHome;
@property (nonatomic, copy) NSString *directoryPathOfDocuments;
@property (nonatomic, copy) NSString *directoryPathOfLibrary;
@property (nonatomic, copy) NSString *directoryPathOfLibraryCaches;
@property (nonatomic, copy) NSString *directoryPathOfLibraryPreferences;
@property (nonatomic, copy) NSString *directoryPathOfTmp;

+ (instancetype)sharedInstance;

// config userId
- (void)setUserId:(NSString *)userId;
// Documents/DWKKit_Storage/
- (NSString *)directoryPathOfDocumentsCommon;
// Documents/DWKKit_Storage/CommonSettings.archive
- (NSString *)filePathOfCommonSettings;

// Documents/DWKKit_Storage/UserId/
- (NSString *)directoryPathOfDocumentsByUserId;
// Documents/DWKKit_Storage/UserId/UserSettings.archive
- (NSString *)filePathOfUserSettings;

// Library/Caches/DWKKit_Storage/
- (NSString *)directoryPathOfLibraryCachesCommon;
// Library/Caches/DWKKit_Storage/UserId/
- (NSString *)directoryPathOfLibraryCachesByUserId;
// Library/Caches/DWKKit_Storage/UserId/Pics/
- (NSString *)directoryPathOfPicByUserId;
// Library/Caches/DWKKit_Storage/UserId/Audioes/
- (NSString *)directoryPathOfAudioByUserId;
// Library/Caches/DWKKit_Storage/UserId/Videoes/
- (NSString *)directoryPathOfVideoByUserId;
// Library/Caches/com.xxx.yyy
- (NSString *)directoryPathOfLibraryCachesBundleIdentifier;
// Library/Caches/DWKKit_Storage/DWKLog/
- (NSString *)directoryPathOfDocumentsLog;

@end

//--------------------------------------
//  管理缓存数据的序列化和反序列化
//--------------------------------------
@interface DWKStorageData (Archive)
// 公共配置文件存取
- (void)setConfigValue:(NSObject *)value forKey:(NSString *)key;
- (id)configValueForKey:(NSString *)key;
// 用户配置文件存取
- (void)setUserConfigValue:(NSObject *)value forKey:(NSString *) key;
- (void)userConfiValueForKey:(NSString *)value;
// 序列化
- (BOOL)archiveDictionary:(NSDictionary * )dictionary toFilePath:(NSString *)filePath;
- (BOOL)archiveDictionary:(NSDictionary *)dicionary toFilePath:(NSString *)filePath overwrite:(BOOL)overwrite;
- (NSDictionary *)unarchiveDictionaryFromFilePath:(NSString *)filePath;

// 删除Documents和Caches目录中的缓存数据，并确保所有缓存目录都存在
- (void)clearLibraryCaches;
@end


//--------------------------------------
//  处理缓存数据
//--------------------------------------
@interface DWKStorageData (Cache)
//------------------------------------
//Document/DWKKit_Storage
//该目录下的数据与业务逻辑相关，删除会影响逻辑
//overwrite = NO
//------------------------------------
- (BOOL)saveObject:(NSObject *)object forKey:(NSString *)key fileName:(NSString *)fileName subFolder:(NSString *)subFoler;
- (id)getObjectForKey:(NSString *)key fileName:(NSString *)fileName subFolder:(NSString *)subFoler;

//------------------------------------
//Library/Caches/DWKKit_Storage
//该目录下的数据随时都可以被清除，与业务逻辑无关
//overwrite = NO
//------------------------------------
- (BOOL)saveCacheObject:(NSObject *)object forKey:(NSString *)key fileName:(NSString *)fileName subFolder:(NSString *)subFoler;
- (id)getCacheObjectForKey:(NSString *)key fileName:(NSString *)fileName subFolder:(NSString *)subFoler;
@end


