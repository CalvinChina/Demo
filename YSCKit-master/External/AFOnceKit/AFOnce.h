//
//  AFOnce.h
//  AFOnceKitDemo
//
//  Created by Jinjin on 15/5/30.
//  Copyright (c) 2015年 AnnyFun. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma Class AFOnceInfo
@interface AFOnceBlockInfo : NSObject
@property (nonatomic, retain) NSString *lastVersion;
@property (nonatomic, retain) NSDate *lastTime;
@end

typedef void (^AFOnceBlock) (AFOnceBlockInfo *blockInfo);

#pragma Class AFOnce
@interface AFOnce : NSObject
/**
 *  Singleton instance shared for the app session.
 *
 *  @return the initialized object.
 */
+ (instancetype)shared;

#pragma mark - Run with defaultGroup methods
/**
 *  执行一次Block
 *
 *  @param onceBlock 需要执行的Block
 *  @param blockKey  Block的唯一Key
 */
+ (void)runOnce:(AFOnceBlock)onceBlock forKey:(NSString *)blockKey;

/**
 *  执行一次Block，若执行过了就执行另外一个Block
 *
 *  @param onceBlock    需要执行一次的Block
 *  @param elseRunBlock 其他情况执行的Block
 *  @param blockKey     Block的唯一Key
 */
+ (void)runOnce:(AFOnceBlock)onceBlock elseRun:(AFOnceBlock)elseRunBlock forKey:(NSString *)blockKey;

/**
 *  当前版本只执行一次Block
 *
 *  @param onceBlock 当前版本中中执行的Block
 *  @param blockKey  Block的唯一Key
 */
+ (void)runOncePerVersion:(AFOnceBlock)onceBlock forKey:(NSString *)blockKey;

/**
 *  当前版本只执行一次Block，否则执行另一个Block
 *
 *  @param onceBlock    当前版本中中执行的Block
 *  @param elseRunBlock 其他情况执行的Block
 *  @param blockKey     Block的唯一Key
 */
+ (void)runOncePerVersion:(AFOnceBlock)onceBlock elseRun:(AFOnceBlock)elseRunBlock forKey:(NSString *)blockKey;

/**
 *  在一个时间间隔内只执行一次Block
 *
 *  @param onceBlock 需要执行一次的Block
 *  @param blockKey  Block的唯一Key
 *  @param interval  执行的最小时间间隔
 */
+ (void)runOnce:(AFOnceBlock)onceBlock forKey:(NSString *)blockKey withInterval:(NSTimeInterval)interval;

/**
 *  在一个时间间隔内只执行一次Block，否则执行另一个Block
 *
 *  @param onceBlock    需要执行一次的Block
 *  @param elseRunBlock 其他情况执行的Block
 *  @param blockKey     Block的唯一Key
 *  @param interval     执行的最小时间间隔
 */
+ (void)runOnce:(AFOnceBlock)onceBlock elseRun:(AFOnceBlock)elseRunBlock forKey:(NSString *)blockKey withInterval:(NSTimeInterval)interval;

#pragma mark - Run method
/**
 *  在满足条件的情况下，执行一次Block
 *
 *  @param onceBlock    执行一次的Block
 *  @param elseRunBlock 条件不满足的情况下执行的Block
 *  @param blockKey     Block唯一的key
 *  @param group        Block所在组的唯一Key
 *  @param checkVersion 是否检测Version，YES-当前版本内唯一执行一次
 *  @param interval     执行的最小间隔，在间隔内只执行一次
 */
+ (void)runOnce:(AFOnceBlock)onceBlock elseRun:(AFOnceBlock)elseRunBlock forKey:(NSString *)blockKey forGroup:(NSString *)group perVersion:(BOOL)checkVersion interval:(NSTimeInterval)interval;

#pragma mark - Check methods
/**
 *  在默认分组中判断Block是否执行过
 *
 *  @param blockKey Block的唯一Key
 *
 *  @return Yes-执行过了
 */
+ (BOOL)blockWasRun:(NSString *)blockKey;

/**
 *  判断Block是否已经执行过
 *
 *  @param blockKey     Block的唯一名称
 *  @param groupKey     Block所在组的唯一名称
 *  @param checkVersion 是否检测AppVersion  YES-检测当前版本内唯一；NO-忽略版本
 *  @param interval     执行间隔，一个间隔周期内只执行一次
 *
 *  @return YES-已经执行过
 */
+ (BOOL)blockAlreadyRunForKey:(NSString *)blockKey group:(NSString *)groupKey perVersion:(BOOL)checkVersion interval:(NSTimeInterval)interval;

#pragma mark - Reset methods
/**
 *  清空默认组的执行记录
 */
+ (void)reset;

/**
 *  清空所有分组的执行记录
 */
+ (void)resetAllGroup;

/**
 *  清除相应组的执行记录
 *
 *  @param group 组名,为空时清除全部组
 */
+ (void)resetForGroup:(NSString *)group;
@end
