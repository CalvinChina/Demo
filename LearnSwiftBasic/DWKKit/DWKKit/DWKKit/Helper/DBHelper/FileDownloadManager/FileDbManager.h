//
//  FileDbManager.h
//  KanPian
//
//  Created by zengbixing on 16/3/28.
//  Copyright © 2016年 SMIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileDownloadModel.h"

@interface FileDbManager : NSObject

- (NSArray*)readDataFromDB;

- (BOOL)InsertInfoToTable:(FileDownloadModel*)model;

- (BOOL)UpdataInfoCachePathToTable:(FileDownloadModel*)model;

- (BOOL)UpdataInfoDownloadProgressToTable:(FileDownloadModel*)model;

- (BOOL)UpdataDownloadStateToTable:(FileDownloadModel*)model;

- (BOOL)UpdataCurFileSizeToTable:(FileDownloadModel*)model;

//更新下载地址，针对影视缓存
- (BOOL)UpdataUrlsToTable:(FileDownloadModel*)model;

- (BOOL)UpdataUrlCountToTable:(FileDownloadModel*)model;

- (BOOL)UpdataCacheInfoToTable:(FileDownloadModel*)model;

- (BOOL)UpdataHiddenTypeToTable:(FileDownloadModel*)model;

- (BOOL)DeleteItemToTable:(FileDownloadModel*)model;
/*
 * @brief 删除所有数据
 **/
- (BOOL)DeleteAllItemToTable:(NSString *)fileType;

@end
