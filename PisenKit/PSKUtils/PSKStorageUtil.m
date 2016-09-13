//
//  PSKStorageUtil.m
//  PisenKit
//
//  Created by 杨胜超 on 16/7/4.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import "PSKStorageUtil.h"

static NSString * const kRootDirectoryOfStorage     = @"PisenKitStorage";       //默认缓存根目录名称
static NSString * const kDefaultFileOfAppSettings   = @"AppSettings.archive";   //默认配置文件名称
static NSString * const kDefaultDirectoryOfLog      = @"PSKLog";                //日志目录默认名称

@interface PSKStorageUtil ()
@property (nonatomic, strong) NSString *userId;
@end

@implementation PSKStorageUtil
+ (instancetype)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[PSKStorageUtil alloc] init];
    });
    return _sharedObject;
}
- (id)init {
    self = [super init];
    if (self) {
        [PSKStorageUtil _ensureStorageDirectories];
    }
    return self;
}
+ (void)setUserId:(NSString *)userId {
    [PSKStorageUtil sharedInstance].userId = TRIM_STRING(userId);
    [PSKStorageUtil _ensureStorageDirectories];
}
+ (NSString *)directoryPathOfDocumentsStorage {
    return [[NSString psk_directoryPathOfDocuments] stringByAppendingString:kRootDirectoryOfStorage];
}
+ (NSString *)directoryPathOfDocumentsUserStorage {
    return [[self directoryPathOfDocumentsStorage] stringByAppendingString:TRIM_STRING([PSKStorageUtil sharedInstance].userId)];
}

+ (NSString *)directoryPathOfLibraryCachesStorage {
    return [[NSString psk_directoryPathOfLibraryCaches] stringByAppendingString:kRootDirectoryOfStorage];
}
+ (NSString *)directoryPathOfLibraryCachesUserStorage {
    return [[self directoryPathOfLibraryCachesStorage] stringByAppendingString:TRIM_STRING([PSKStorageUtil sharedInstance].userId)];
}

+ (NSString *)directoryPathOfLog {
    NSString *storageRoot = [[NSString psk_directoryPathOfLibraryCaches] stringByAppendingString:kRootDirectoryOfStorage];
    return [storageRoot stringByAppendingString:kDefaultDirectoryOfLog];
}
+ (void)_ensureStorageDirectories {
    [NSFileManager psk_ensureDirectory:[PSKStorageUtil directoryPathOfDocumentsStorage]];
    [NSFileManager psk_ensureDirectory:[PSKStorageUtil directoryPathOfLibraryCachesStorage]];
}
+ (void)clearLibraryCaches {
    [NSFileManager psk_clearDirectoryPath:[self directoryPathOfLibraryCachesStorage]];
    [NSFileManager psk_clearDirectoryPath:[NSString psk_directoryPathOfLibraryCachesBundleIdentifier]];
}
@end



//====================================
//
// 采用对象的序列化进行本地缓存
//
//====================================
@implementation PSKStorageUtil (Archive)
+ (BOOL)saveObject:(NSObject *)object forKey:(NSString *)key fileName:(NSString *)fileName subFolder:(NSString *)subFoler {
    return [self _saveObject:object forKey:key fileName:fileName folder:[self directoryPathOfDocumentsUserStorage] subFolder:subFoler];
}
+ (id)getObjectForKey:(NSString *)key fileName:(NSString *)fileName subFolder:(NSString *)subFoler {
    return [self _getObjectForKey:key fileName:fileName folder:[self directoryPathOfDocumentsUserStorage] subFolder:subFoler];
}
+ (BOOL)saveCacheObject:(NSObject *)object forKey:(NSString *)key fileName:(NSString *)fileName subFolder:(NSString *)subFoler {
    return [self _saveObject:object forKey:key fileName:fileName folder:[self directoryPathOfLibraryCachesUserStorage] subFolder:subFoler];
}
+ (id)getCacheObjectForKey:(NSString *)key fileName:(NSString *)fileName subFolder:(NSString *)subFoler {
    return [self _getObjectForKey:key fileName:fileName folder:[self directoryPathOfLibraryCachesUserStorage] subFolder:subFoler];
}

// 两个通用方法：存储数据、获取数据
+ (BOOL)_saveObject:(NSObject *)object forKey:(NSString *)key fileName:(NSString *)fileName folder:(NSString *)folderPath subFolder:(NSString *)subFolerName {
    RETURN_NO_WHEN_OBJECT_IS_EMPTY(key)
    RETURN_NO_WHEN_OBJECT_IS_EMPTY(folderPath)
    if ( ! object) {
        object = [NSNull null];
    }
    
    if (OBJECT_ISNOT_EMPTY(subFolerName)) {
        folderPath = [folderPath stringByAppendingPathComponent:subFolerName];
    }
    if (OBJECT_IS_EMPTY(fileName)) {
        fileName = kDefaultFileOfAppSettings;
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
+ (id)_getObjectForKey:(NSString *)key fileName:(NSString *)fileName folder:(NSString *)folderPath subFolder:(NSString *)subFolerName {
    RETURN_NIL_WHEN_OBJECT_IS_EMPTY(key)
    RETURN_NIL_WHEN_OBJECT_IS_EMPTY(folderPath)
    
    if (OBJECT_ISNOT_EMPTY(subFolerName)) {
        folderPath = [folderPath stringByAppendingPathComponent:subFolerName];
    }
    if (OBJECT_IS_EMPTY(fileName)) {
        fileName = kDefaultFileOfAppSettings;
    }
    NSString *filePath = [folderPath stringByAppendingPathComponent:fileName];
    NSDictionary *cacheInfo = [self unarchiveDictionaryFromFilePath:filePath];
    NSObject *value = cacheInfo[key];
    if (value && ( ! [value isKindOfClass:[NSNull class]])) {
        return value;
    }
    else {
        return nil;
    }
}

+ (BOOL)archiveDictionary:(NSDictionary *)dicionary toFilePath:(NSString *)filePath {
    return [self archiveDictionary:dicionary toFilePath:filePath overwrite:NO];
}
+ (BOOL)archiveDictionary:(NSDictionary *)dicionary toFilePath:(NSString *)filePath overwrite:(BOOL)overwrite {
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
+ (NSDictionary *)unarchiveDictionaryFromFilePath:(NSString *)filePath {
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
@end



//====================================
//
// 管理keychain中的数据
//
//====================================
@implementation PSKStorageUtil (KeyChain)
+ (BOOL)saveObject:(id)anObject inKeyChainForKey:(NSString*)key {
    if (!anObject || !key) return NO;
    NSMutableDictionary *secItem = @{
                                     (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
                                     (__bridge id)kSecAttrService : key,
                                     (__bridge id)kSecAttrAccount : key,
                                     }.mutableCopy;
    SecItemDelete((__bridge CFDictionaryRef)secItem);
    [secItem setObject:[NSKeyedArchiver archivedDataWithRootObject:anObject] forKey:(__bridge id)kSecValueData];
    CFTypeRef result = NULL;
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)secItem, &result);
    if (status == errSecSuccess){
        return YES;
    }
    return NO;
}
+ (id)objectInKeyChainForKey:(NSString *)key {
    if (!key) return nil;
    id object = nil;
    NSDictionary *query = @{
                            (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecAttrService : key,
                            (__bridge id)kSecAttrAccount : key,
                            (__bridge id)kSecReturnData : (__bridge id)kCFBooleanTrue,
                            (__bridge id)kSecMatchLimit : (__bridge id)kSecMatchLimitOne
                            };
    
    CFDataRef keyData = NULL;
    OSStatus results = SecItemCopyMatching((__bridge CFDictionaryRef)query,(CFTypeRef *)&keyData);
    if (results == errSecSuccess) {
        object =  [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
    }
    if (keyData) CFRelease(keyData);
    return object;
}
+ (BOOL)removeObjectInKeyChainForKey:(NSString *)key {
    if (!key) return NO;
    NSDictionary *query = @{
                            (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecAttrService : key,
                            (__bridge id)kSecAttrAccount : key
                            };
    OSStatus foundExisting = SecItemCopyMatching((__bridge CFDictionaryRef)query, NULL);
    if (foundExisting == errSecSuccess){
        OSStatus deleted = SecItemDelete((__bridge CFDictionaryRef)query);
        if (deleted == errSecSuccess){
            return YES;
        }
        return NO;
    }
    return NO;
}
@end


