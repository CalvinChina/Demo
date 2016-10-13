//
//  YSCStorageData.m
//  YSCKit
//
//  Created by yangshengchao on 16/1/28.
//  Copyright © 2016年 Builder. All rights reserved.
//

#import "YSCStorageData.h"
#define kCommonDirectory            @"YSCKit_Storage/"
#define kCommonSettingFile          @"CommonSetting.archive"
#define kUserSettingFile            @"UserSetting.archive"


//----------------------------------------------------------------------------
//  定义各种文件的缓存路径
//----------------------------------------------------------------------------
@interface YSCStorageData ()
@property (nonatomic, copy) NSString *userId;
@end
@implementation YSCStorageData
+ (instancetype)SharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^ {
        return [[self alloc] init];
    })
}
- (id)init {
    self = [super init];
    if (self) {
        self.directoryPathOfHome = kPathOfSandBoxHome;
        self.directoryPathOfDocuments = [YSCFileManager DirectoryPathOfDocuments];
        self.directoryPathOfLibrary = [YSCFileManager DirectoryPathOfLibrary];
        self.directoryPathOfLibraryCaches = [YSCFileManager DirectoryPathOfLibraryCaches];
        self.directoryPathOfLibraryPreferences = [YSCFileManager DirectoryPathOfLibraryPreferences];
        self.directoryPathOfTmp = kPathOfSandBoxTemp;
        [self _ensureCommonDirectories];
    }
    return self;
}
- (void)setUserId:(NSString *)userId {
    if (isNotEmpty(userId)) {
        _userId = userId;
        [self _ensureUserDirectories];
    }
}

// Documents目录下的文件和目录路径
- (NSString *)directoryPathOfDocumentsCommon {
    return [self.directoryPathOfDocuments stringByAppendingPathComponent:kCommonDirectory];
}
- (NSString *)filePathOfCommonSettings {
    return [[self directoryPathOfDocumentsCommon] stringByAppendingPathComponent:kCommonSettingFile];
}
- (NSString *)directoryPathOfDocumentsByUserId {
    return [[self directoryPathOfDocumentsCommon] stringByAppendingPathComponent:self.userId];
}
- (NSString *)filePathOfUserSettings {
    return [[self directoryPathOfDocumentsByUserId] stringByAppendingPathComponent:kUserSettingFile];
}

// Library目录下的文件和目录路径
- (NSString *)directoryPathOfLibraryCachesCommon {
    return [self.directoryPathOfLibraryCaches stringByAppendingPathComponent:kCommonDirectory];
}
- (NSString *)directoryPathOfLibraryCachesByUserId {
    return [[self directoryPathOfLibraryCachesCommon] stringByAppendingPathComponent:self.userId];
}
- (NSString *)directoryPathOfPicByUserId {
    return [[self directoryPathOfLibraryCachesByUserId] stringByAppendingPathComponent:@"Pics/"];
}
- (NSString *)directoryPathOfAudioByUserId {
    return [[self directoryPathOfLibraryCachesByUserId] stringByAppendingPathComponent:@"Audioes/"];
}
- (NSString *)directoryPathOfVideoByUserId {
    return [[self directoryPathOfLibraryCachesByUserId] stringByAppendingPathComponent:@"Videoes/"];
}
- (NSString *)directoryPathOfLibraryCachesBundleIdentifier {
    return [self.directoryPathOfLibraryCaches stringByAppendingPathComponent:BundleIdentifier];
}
- (NSString *)directoryPathOfDocumentsLog {
    return [[self directoryPathOfLibraryCachesCommon] stringByAppendingPathComponent:@"YSCLog/"];
}

// 私有方法
- (void)_ensureCommonDirectories {
    [YSCFileManager EnsureDirectory:[self directoryPathOfDocumentsCommon]];
    [YSCFileManager EnsureDirectory:[self directoryPathOfDocumentsLog]];
    [YSCFileManager EnsureDirectory:[self directoryPathOfLibraryCachesCommon]];
}
- (void)_ensureUserDirectories {
    [YSCFileManager EnsureDirectory:[self directoryPathOfDocumentsByUserId]];
    [YSCFileManager EnsureDirectory:[self directoryPathOfLibraryCachesByUserId]];
    [YSCFileManager EnsureDirectory:[self directoryPathOfPicByUserId]];
    [YSCFileManager EnsureDirectory:[self directoryPathOfAudioByUserId]];
    [YSCFileManager EnsureDirectory:[self directoryPathOfVideoByUserId]];
}
@end


//----------------------------------------------------------------------------
//  管理缓存数据的序列化和反序列化
//----------------------------------------------------------------------------
@implementation YSCStorageData (Archive)
// 公共配置文件存取
- (void)setConfigValue:(NSObject *)value forKey:(NSString *)key {
    [self _setConfigWithValuesAndKeys:value, key, nil];
}
- (id)configValueForKey:(NSString *)key {
    if (isEmpty(key)) {
        return nil;
    }
    
    NSDictionary *config = [self unarchiveDictionaryFromFilePath:[self filePathOfCommonSettings]];
    return config[key];
}
- (void)_setConfigWithValuesAndKeys:(id)firstObject, ... NS_REQUIRES_NIL_TERMINATION {
    NSMutableArray *keys = [NSMutableArray array];
    NSMutableArray *values = [NSMutableArray array];
    
    va_list args;
    va_start(args, firstObject);
    for (id value = firstObject; value != nil; value = va_arg(args, id)) {
        id key = va_arg(args, id);
        [values addObject:value];
        [keys addObject:key];
    }
    va_end(args);
    
    NSUInteger valueCount = [values count];
    if (valueCount != [keys count]) {
        NSLog(@"set config error : objects and keys don’t have the same number of elements.");
    }
    else {
        NSMutableDictionary *configDictionary = [NSMutableDictionary dictionary];
        for(int index = 0; index < valueCount; index ++) {
            [configDictionary setObject:[values objectAtIndex:index] forKey:[keys objectAtIndex:index]];
        }
        [self archiveDictionary:configDictionary toFilePath:[self filePathOfCommonSettings] overwrite:NO];
    }
    
}

// 用户配置文件存取
- (void)setUserConfigValue:(NSObject *)value forKey:(NSString *)key {
    [self _setUserConfigWithValuesAndKeys:value, key, nil];
}
- (id)userConfigValueForKey:(NSString *)key {
    if (isEmpty(key)) {
        return nil;
    }
    
    NSDictionary *userConfig = [self unarchiveDictionaryFromFilePath:[self filePathOfUserSettings]];
    return userConfig[key];
}
- (void)_setUserConfigWithValuesAndKeys:(id)firstObject, ... NS_REQUIRES_NIL_TERMINATION {
    NSMutableArray *keys = [NSMutableArray array];
    NSMutableArray *values = [NSMutableArray array];
    
    va_list args;
    va_start(args, firstObject);
    for (id value = firstObject; value != nil; value = va_arg(args, id)) {
        id key = va_arg(args, id);
        [values addObject:value];
        [keys addObject:key];
    }
    va_end(args);
    
    NSUInteger valueCount = [values count];
    if (valueCount != [keys count]) {
        NSLog(@"set config error : objects and keys don’t have the same number of elements.");
    }
    else {
        NSMutableDictionary *configDictionary = [NSMutableDictionary dictionary];
        for(int index = 0; index < valueCount; index ++) {
            [configDictionary setObject:[values objectAtIndex:index] forKey:[keys objectAtIndex:index]];
        }
        [self archiveDictionary:configDictionary toFilePath:[self filePathOfUserSettings] overwrite:NO];
    }
}

// 序列化 & 反序列化
- (BOOL)archiveDictionary:(NSDictionary *)dicionary toFilePath:(NSString *)filePath {
    return [self archiveDictionary:dicionary toFilePath:filePath overwrite:NO];
}
- (BOOL)archiveDictionary:(NSDictionary *)dicionary toFilePath:(NSString *)filePath overwrite:(BOOL)overwrite {
    if (overwrite) {
        return [NSKeyedArchiver archiveRootObject:dicionary toFile:filePath];
    }
    else {
        NSMutableDictionary *allDictionary = [NSMutableDictionary dictionaryWithCapacity:[dicionary count]];
        [allDictionary addEntriesFromDictionary:[self unarchiveDictionaryFromFilePath:filePath]];
        [allDictionary addEntriesFromDictionary:dicionary];
        return [NSKeyedArchiver archiveRootObject:allDictionary toFile:filePath];
    }
}
- (NSDictionary *)unarchiveDictionaryFromFilePath:(NSString *)filePath {
    NSDictionary *dictionary;
    @try {
        dictionary = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    }
    @catch(NSException *exception) {
        NSLog(@"unarchive error:%@", [exception debugDescription]);
    }
    @finally {
        
    }
    return dictionary;
}

// 删除Documents和Caches目录中的缓存数据，并确保所有缓存目录都存在
- (void)clearLibraryCaches {
    //Documents
    [YSCFileManager ClearDirectoryPath:self.directoryPathOfDocumentsLog];
    
    //Library/Caches
    [YSCFileManager ClearDirectoryPath:self.directoryPathOfLibraryCachesCommon];
    [YSCFileManager ClearDirectoryPath:self.directoryPathOfLibraryCachesBundleIdentifier];
    
    [self _ensureCommonDirectories];
    [self _ensureUserDirectories];
}
@end



//----------------------------------------------------------------------------
//  处理缓存数据
//----------------------------------------------------------------------------
@implementation YSCStorageData (Cache)
- (BOOL)saveObject:(NSObject *)object forKey:(NSString *)key fileName:(NSString *)fileName subFolder:(NSString *)subFoler {
    return [self _saveObject:object forKey:key fileName:fileName folder:self.directoryPathOfDocumentsCommon subFolder:subFoler];
}
- (id)getObjectForKey:(NSString *)key fileName:(NSString *)fileName subFolder:(NSString *)subFoler {
    return [self _getObjectForKey:key fileName:fileName folder:self.directoryPathOfDocumentsCommon subFolder:subFoler];
}
- (BOOL)saveCacheObject:(NSObject *)object forKey:(NSString *)key fileName:(NSString *)fileName subFolder:(NSString *)subFoler {
    return [self _saveObject:object forKey:key fileName:fileName folder:self.directoryPathOfLibraryCachesCommon subFolder:subFoler];
}
- (id)getCacheObjectForKey:(NSString *)key fileName:(NSString *)fileName subFolder:(NSString *)subFoler {
    return [self _getObjectForKey:key fileName:fileName folder:self.directoryPathOfLibraryCachesCommon subFolder:subFoler];
}

// 两个通用方法：存储数据、获取数据
- (BOOL)_saveObject:(NSObject *)object forKey:(NSString *)key fileName:(NSString *)fileName folder:(NSString *)folderPath subFolder:(NSString *)subFolerName {
    ReturnNOWhenObjectIsEmpty(key)
    ReturnNOWhenObjectIsEmpty(folderPath)
    if (nil == object) {
        object = [NSNull null];
    }
    
    if (isNotEmpty(subFolerName)) {
        folderPath = [folderPath stringByAppendingPathComponent:subFolerName];
    }
    if (isEmpty(fileName)) {
        fileName = kCommonSettingFile;
    }
    NSString *filePath = [folderPath stringByAppendingPathComponent:fileName];
    BOOL isSuccess = NO;
    @try {
        isSuccess = [self archiveDictionary:@{ key : object }
                                           toFilePath:filePath
                                            overwrite:NO];
    }
    @catch (NSException *exception){
        NSLog(@"序列化object出错：%@", exception); //可能是没有在对象里做序列号和反序列化！
        isSuccess = NO;
    }
    return isSuccess;
}
- (id)_getObjectForKey:(NSString *)key fileName:(NSString *)fileName folder:(NSString *)folderPath subFolder:(NSString *)subFolerName {
    ReturnNilWhenObjectIsEmpty(key)
    ReturnNilWhenObjectIsEmpty(folderPath)
    
    if (isNotEmpty(subFolerName)) {
        folderPath = [folderPath stringByAppendingPathComponent:subFolerName];
    }
    if (isEmpty(fileName)) {
        fileName = kCommonSettingFile;
    }
    NSString *filePath = [folderPath stringByAppendingPathComponent:fileName];
    NSDictionary *cacheInfo = [self unarchiveDictionaryFromFilePath:filePath];
    NSObject *value = cacheInfo[key];
    if (nil != value && NO == [value isKindOfClass:[NSNull class]]) {
        return value;
    }
    else {
        return nil;
    }
}

@end