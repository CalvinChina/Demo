//
//  AFOnce.m
//  AFOnceKitDemo
//
//  Created by Jinjin on 15/5/30.
//  Copyright (c) 2015年 AnnyFun. All rights reserved.
//

#import "AFOnce.h"

#pragma Class AFOnceInfo
@implementation AFOnceBlockInfo
- (id)initWithCoder:(NSCoder *)coder{
    if ((self = [super init])){
        _lastVersion = [coder decodeObjectForKey:@"lastVersion"];
        _lastTime    = [coder decodeObjectForKey:@"lastTime"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeObject:self.lastVersion forKey:@"lastVersion"];
    [coder encodeObject:self.lastTime forKey:@"lastTime"];
}
@end

/// WARNING: AFOnceSharedGroup请别修改！！否则会导致默认执行记录丢失
#define AFOnceSharedGroup   @"SharedGroup"
#define AFOnceAppVersion    ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"])
#define AFSharedOnce        ([AFOnce shared])

@interface AFOnce()
@property (nonatomic,strong) NSMutableDictionary *dataDict;
@end

@implementation AFOnce

#pragma mark - sharedInstance
+ (instancetype)shared{
    static AFOnce *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AFOnce alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Public methods - Reset
/**
 *  清空默认组的执行记录
 */
+ (void)reset{
    [self resetForGroup:AFOnceSharedGroup];
}

/**
 *  清空所有分组的执行记录
 */
+ (void)resetAllGroup{
    [self resetForGroup:nil];
}

/**
 *  清除相应组的执行记录
 *
 *  @param group 组名,为空时清除全部组
 */
+ (void)resetForGroup:(NSString *)group{
    @synchronized(AFSharedOnce){
        if (group) {
            [AFSharedOnce.dataDict removeObjectForKey:group];
        }else{
            [AFSharedOnce.dataDict removeAllObjects];
        }
        [AFSharedOnce saveDataToUserDefaults];
    }
}

#pragma mark - Public methods - Run
+ (void)runOnce:(AFOnceBlock)onceBlock forKey:(NSString *)blockKey{
    
    [self runOnce:onceBlock elseRun:NULL forKey:blockKey forGroup:AFOnceSharedGroup perVersion:NO interval:0];
}

+ (void)runOnce:(AFOnceBlock)onceBlock elseRun:(AFOnceBlock)elseRunBlock forKey:(NSString *)blockKey{
    
    [self runOnce:onceBlock elseRun:elseRunBlock forKey:blockKey forGroup:AFOnceSharedGroup perVersion:NO interval:0];
}

+ (void)runOncePerVersion:(AFOnceBlock)onceBlock forKey:(NSString *)blockKey{
    
    [self runOnce:onceBlock elseRun:NULL forKey:blockKey forGroup:AFOnceSharedGroup perVersion:YES interval:0];
}

+ (void)runOncePerVersion:(AFOnceBlock)onceBlock elseRun:(AFOnceBlock)elseRunBlock forKey:(NSString *)blockKey{
    
    [self runOnce:onceBlock elseRun:elseRunBlock forKey:blockKey forGroup:AFOnceSharedGroup perVersion:YES interval:0];
}

+ (void)runOnce:(AFOnceBlock)onceBlock forKey:(NSString *)blockKey withInterval:(NSTimeInterval)interval{
    
    [self runOnce:onceBlock elseRun:NULL forKey:blockKey forGroup:AFOnceSharedGroup perVersion:NO interval:interval];
}

+ (void)runOnce:(AFOnceBlock)onceBlock elseRun:(AFOnceBlock)elseRunBlock forKey:(NSString *)blockKey withInterval:(NSTimeInterval)interval{
    
    [self runOnce:onceBlock elseRun:elseRunBlock forKey:blockKey forGroup:AFOnceSharedGroup perVersion:NO interval:interval];
}

+ (void)runOnce:(AFOnceBlock)onceBlock elseRun:(AFOnceBlock)elseRunBlock forKey:(NSString *)blockKey forGroup:(NSString *)group perVersion:(BOOL)checkVersion interval:(NSTimeInterval)interval{

    if (onceBlock && blockKey && group) {
        AFOnceBlockInfo *blockInfo = [AFSharedOnce getBlockInfo:blockKey forGroup:group];
        if ([self blockAlreadyRunForKey:blockKey group:group perVersion:checkVersion interval:interval]){
            if (elseRunBlock) {
                elseRunBlock(blockInfo);
            }
        }else{
            [AFSharedOnce saveRunInformationForKey:blockKey forGroup:group];
            if (onceBlock) {
                onceBlock(blockInfo);
            }
        }
    }
}

#pragma mark - Public methods - Check

+ (BOOL)blockWasRun:(NSString *)blockKey{
    
    return [self blockAlreadyRunForKey:blockKey group:AFOnceSharedGroup perVersion:NO interval:0];
}

+ (BOOL)blockAlreadyRunForKey:(NSString *)blockKey group:(NSString *)groupKey perVersion:(BOOL)checkVersion interval:(NSTimeInterval)interval{
    
    @synchronized(AFSharedOnce){
        BOOL executed = NO;
        
        /// Get the key dictionary.
        AFOnceBlockInfo *blockInfo = [AFSharedOnce getBlockInfo:blockKey forGroup:groupKey];
        if (blockInfo) {
            executed = YES;
        }
        
        /// Version.
        if (checkVersion && blockInfo) {
            NSString *currentVersion = AFOnceAppVersion;
            executed = executed && [currentVersion isEqualToString:blockInfo.lastVersion];
        }
        
        /// interval.
        if (interval && blockInfo) {
            NSTimeInterval currentInterval = [[NSDate date] timeIntervalSinceDate:blockInfo.lastTime];
            executed = executed && (currentInterval <= interval);
        }
        
        return executed;
    }
}


#pragma mark - Private methods

/**
 *  在组中添加一个执行记录
 *
 *  @param blockKey 执行记录的唯一Key
 *  @param groupKey 执行记录所在组
 */
- (void)saveRunInformationForKey:(NSString *)blockKey
                        forGroup:(NSString *)groupKey{
    
    AFOnceBlockInfo *blockInfo = [self getBlockInfo:blockKey forGroup:groupKey];
    if (!blockInfo) {
        blockInfo = [AFOnceBlockInfo new];
    }
    blockInfo.lastVersion = AFOnceAppVersion;
    blockInfo.lastTime = [NSDate date];
    [self setBlockInfo:blockInfo forKey:blockKey forGroup:groupKey];
}

/**
 *  将一个执行记录保存到组
 *
 *  @param blockInfo 执行记录
 *  @param blockKey  执行记录名称
 *  @param groupKey  执行记录所在组名称
 */
- (void)setBlockInfo:(AFOnceBlockInfo *)blockInfo forKey:(NSString *)blockKey forGroup:(NSString *)groupKey{
    
    @synchronized(self){
        NSMutableDictionary *groupDictionary = [self getGroupDict:groupKey];
        if (!groupDictionary) {
            groupDictionary = [@{} mutableCopy];
        }
        
        [groupDictionary setObject:blockInfo forKey:blockKey];
        
        [self.dataDict setObject:groupDictionary forKey:groupKey];
        
        [self saveDataToUserDefaults];
    }
}

/**
 *  获取一个组执行记录
 *
 *  @param groupKey 需要读取的组名
 *
 *  @return dict
 */
- (NSMutableDictionary *)getGroupDict:(NSString *)groupKey{
    
    NSMutableDictionary *dict = nil;
    if (groupKey) dict = [self.dataDict objectForKey:groupKey];
    return dict;
}

/**
 *  获取一个执行记录
 *
 *  @param blockKey 执行记录名称
 *  @param groupKey 执行记录所在分组
 *
 *  @return AFOnceBlockInfo
 */
- (AFOnceBlockInfo *)getBlockInfo:(NSString *)blockKey forGroup:(NSString *)groupKey{
    
    return [[self getGroupDict:groupKey] objectForKey:blockKey];
}

#pragma mark - Getter
- (NSMutableDictionary *)dataDict{
    
    if (nil==_dataDict) {
        _dataDict = [self loadDataFromUserDefaults];
    }
    return _dataDict;
}

#pragma mark - Hepler methods
/**
 *  从UserDefaults中读取执行记录
 *
 *  @return 分组的所有执行记录
 */
- (NSMutableDictionary *)loadDataFromUserDefaults{
    
    NSData *encodedDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:NSStringFromClass([self class])];
    if (encodedDictionary) {
        NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:encodedDictionary];
        return [dict isKindOfClass:[NSDictionary class]]?[dict mutableCopy]:[NSMutableDictionary dictionary];
    } else {
        return [NSMutableDictionary dictionary];
    }
}

/**
 *  存储所有执行记录
 */
- (void)saveDataToUserDefaults{
    
    NSData *decodedDictionary = [NSKeyedArchiver archivedDataWithRootObject:self.dataDict];
    [[NSUserDefaults standardUserDefaults] setObject:decodedDictionary forKey:NSStringFromClass([self class])];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end



