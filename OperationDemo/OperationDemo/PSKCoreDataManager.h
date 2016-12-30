//
//  PSKCoreDataManager.h
//  MicroVideo
//
//  Created by pisen on 16/12/22.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PSKDownloadModel.h"

@interface PSKCoreDataManager : NSObject

+ (PSKCoreDataManager *) sharedInstance;
/**
 插入

 @param models @[PSKDownloadModel]

 @return BOOL
 */
- (BOOL)batchInsertDatasWithModels:(NSArray*)models;
/**
 查询

 @return @[PSKDownloadModel]
 */
- (NSArray *)queryFromData;
/**
 批量删除

 @param tasks @[PSKDownloadModel]
 */
- (BOOL)batchDelete:(NSArray*)tasks;
/**
 更新下载状态存储信息


 @param tasks @[PSKDownloadModel]
 @param state 下载状态
 */
- (BOOL)batchUpdateTasks:(NSArray*)tasks State:(PSKDownloadState)state;


@end
