//
//  YSCStorageData.h
//  YSCKit
//
//  Created by yangshengchao on 16/1/28.
//  Copyright © 2016年 Builder. All rights reserved.
//


/**
 *  缓存单例类
 *  作用：封装缓存目录的管理业务
 */

#define YSCStorageInstance                          [YSCStorageData SharedInstance]

#define YSCSaveObject(obj,key)                      [YSCStorageInstance saveObject:obj forKey:key fileName:nil subFolder:nil]
#define YSCSaveObjectByFile(obj,key,file)           [YSCStorageInstance saveObject:obj forKey:key fileName:file subFolder:nil]
#define YSCSaveCacheObject(obj,key)                 [YSCStorageInstance saveCacheObject:obj forKey:key fileName:nil subFolder:nil]
#define YSCSaveCacheObjectByFile(obj,key,file)      [YSCStorageInstance saveCacheObject:obj forKey:key fileName:file subFolder:nil]
#define YSCGetObject(key)                           [YSCStorageInstance getObjectForKey:key fileName:nil subFolder:nil]
#define YSCGetObjectByFile(key,file)                [YSCStorageInstance getObjectForKey:key fileName:file subFolder:nil]
#define YSCGetCacheObject(key)                      [YSCStorageInstance getCacheObjectForKey:key fileName:nil subFolder:nil]
#define YSCGetCacheObjectByFile(key,file)           [YSCStorageInstance getCacheObjectForKey:key fileName:file subFolder:nil]


//--------------------------------------
//  定义各种文件的缓存路径
//--------------------------------------
@interface YSCStorageData : NSObject
@property (nonatomic, copy) NSString *directoryPathOfHome;
@property (nonatomic, copy) NSString *directoryPathOfDocuments;
@property (nonatomic, copy) NSString *directoryPathOfLibrary;
@property (nonatomic, copy) NSString *directoryPathOfLibraryCaches;
@property (nonatomic, copy) NSString *directoryPathOfLibraryPreferences;
@property (nonatomic, copy) NSString *directoryPathOfTmp;

+ (instancetype)SharedInstance;
- (void)setUserId:(NSString *)userId;               // config userId
- (NSString *)directoryPathOfDocumentsCommon;       // Documents/YSCKit_Storage/
- (NSString *)filePathOfCommonSettings;             // Documents/YSCKit_Storage/CommonSettings.archive
- (NSString *)directoryPathOfDocumentsByUserId;     // Documents/YSCKit_Storage/UserId/
- (NSString *)filePathOfUserSettings;               // Documents/YSCKit_Storage/UserId/UserSettings.archive
- (NSString *)directoryPathOfLibraryCachesCommon;   // Library/Caches/YSCKit_Storage/
- (NSString *)directoryPathOfLibraryCachesByUserId; // Library/Caches/YSCKit_Storage/UserId/
- (NSString *)directoryPathOfPicByUserId;           // Library/Caches/YSCKit_Storage/UserId/Pics/
- (NSString *)directoryPathOfAudioByUserId;         // Library/Caches/YSCKit_Storage/UserId/Audioes/
- (NSString *)directoryPathOfVideoByUserId;         // Library/Caches/YSCKit_Storage/UserId/Videoes/
- (NSString *)directoryPathOfLibraryCachesBundleIdentifier; // Library/Caches/com.xxx.yyy
- (NSString *)directoryPathOfDocumentsLog;          // Library/Caches/YSCKit_Storage/YSCLog/
@end


//--------------------------------------
//  管理缓存数据的序列化和反序列化
//--------------------------------------
@interface YSCStorageData (Archive)
// 公共配置文件存取
- (void)setConfigValue:(NSObject *)value forKey:(NSString *)key;
- (id)configValueForKey:(NSString *)key;

// 用户配置文件存取
- (void)setUserConfigValue:(NSObject *)value forKey:(NSString *)key;
- (id)userConfigValueForKey:(NSString *)key;

// 序列化
- (BOOL)archiveDictionary:(NSDictionary *)dicionary toFilePath:(NSString *)filePath;
- (BOOL)archiveDictionary:(NSDictionary *)dicionary toFilePath:(NSString *)filePath overwrite:(BOOL)overwrite;
- (NSDictionary *)unarchiveDictionaryFromFilePath:(NSString *)filePath;

// 删除Documents和Caches目录中的缓存数据，并确保所有缓存目录都存在
- (void)clearLibraryCaches;
@end


//--------------------------------------
//  处理缓存数据
//--------------------------------------
@interface YSCStorageData (Cache)
//------------------------------------
//Document/YSCKit_Storage
//该目录下的数据与业务逻辑相关，删除会影响逻辑
//overwrite = NO
//------------------------------------
- (BOOL)saveObject:(NSObject *)object forKey:(NSString *)key fileName:(NSString *)fileName subFolder:(NSString *)subFoler;
- (id)getObjectForKey:(NSString *)key fileName:(NSString *)fileName subFolder:(NSString *)subFoler;

//------------------------------------
//Library/Caches/YSCKit_Storage
//该目录下的数据随时都可以被清除，与业务逻辑无关
//overwrite = NO
//------------------------------------
- (BOOL)saveCacheObject:(NSObject *)object forKey:(NSString *)key fileName:(NSString *)fileName subFolder:(NSString *)subFoler;
- (id)getCacheObjectForKey:(NSString *)key fileName:(NSString *)fileName subFolder:(NSString *)subFoler;
@end

