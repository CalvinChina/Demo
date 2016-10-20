//
//  FileDbManager.m
//  KanPian
//
//  Created by zengbixing on 16/3/28.
//  Copyright © 2016年 SMIT. All rights reserved.
//

#import "FileDbManager.h"
#import "FMDatabaseQueue.h"
#import "commonFun_DB.h"

@implementation FileDbManager {
    
    FMDatabaseQueue *dbQueue;
    
    NSString *db_table_name;
}

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        [self createFileDb];
    }
    
    return self;
}

- (void)createFileDb {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentPath = [paths lastObject];
    
    NSString * fileDir = [documentPath stringByAppendingPathComponent:@"Dbs"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:fileDir] )
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:fileDir
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
    }
    
    NSString *dbtablepath = [fileDir stringByAppendingPathComponent:@"download.Db"];
    
    dbQueue = [[FMDatabaseQueue databaseQueueWithPath:dbtablepath] retain];
    
    db_table_name = @"download_table";
    
    NSString *sql = [NSString stringWithFormat:@"create table %@ (downloadStartDate text,\
                     downloadState text,\
                     fileName text,\
                     savePath text,\
                     cachePath text,\
                     downloadEndDate text,\
                     url text,\
                     orignalCount text,\
                     downloadProgress text,\
                     downloadID text,\
                     fileType text,\
                     fromUrl text,\
                     qualityName text,\
                     curFileSize text,\
                     urlCount text,\
                     coverUrl text,\
                     jsonStr text,\
                     curSegmental text,\
                     fileSuffix text,\
                     programId text,\
                     programType text,\
                     episode text,\
                     website text,\
                     hiddenType text)", db_table_name];
    
    [commonFun_DB createTable:sql db:dbQueue];
}

- (NSArray*)readDataFromDB {
    
    NSString * sql = [NSString stringWithFormat:@"select * from %@",db_table_name];

    NSArray *tempItems = [commonFun_DB querryTable:sql db:dbQueue];
    
    return tempItems;
}

- (BOOL)InsertInfoToTable:(FileDownloadModel*)model {
    
    NSDictionary *tableDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                               model.downloadStartDate, @"downloadStartDate",
                               model.fileName, @"fileName",
                               model.savePath, @"savePath",
                               model.cachePath, @"cachePath",
                               model.downloadEndDate, @"downloadEndDate",
                               model.url, @"url",
                               model.downloadProgress, @"downloadProgress",
                               model.orignalCount, @"orignalCount",
                               model.downloadID, @"downloadID",
                               model.downloadState, @"downloadState",
                               model.fileType, @"fileType",
                               model.fromUrl, @"fromUrl",
                               model.qualityName, @"qualityName",
                               model.curFileSize, @"curFileSize",
                               model.urlCount, @"urlCount",
                               model.coverUrl, @"coverUrl",
                               model.jsonStr, @"jsonStr",
                               model.curSegmental, @"curSegmental",
                               model.fileSuffix, @"fileSuffix",
                               model.programId, @"programId",
                               model.programType, @"programType",
                               model.episode, @"episode",
                               model.website, @"website",
                               model.hiddenType, @"hiddenType",
                               nil];
    
    return [commonFun_DB InsertDataDictionary:tableDict toTable:db_table_name db:dbQueue];

}

- (BOOL)UpdataDownloadStateToTable:(FileDownloadModel*)model {
    
    NSString *sql = [NSString stringWithFormat:@"update %@ set downloadState = '%@' where downloadID = '%@' ",
                     db_table_name,
                     model.downloadState,
                     model.downloadID];
    
    return [commonFun_DB UpdataTable:sql db:dbQueue];
}

- (BOOL)UpdataInfoCachePathToTable:(FileDownloadModel*)model {
    
    NSString *sql = [NSString stringWithFormat:@"update %@ set cachePath = '%@' where downloadID = '%@' ",
           db_table_name,
           model.cachePath,
           model.downloadID];
    
    return [commonFun_DB UpdataTable:sql db:dbQueue];
}

- (BOOL)UpdataInfoDownloadProgressToTable:(FileDownloadModel*)model {
    
    NSString *sql = [NSString stringWithFormat:@"update %@ set downloadProgress = '%@' where downloadID = '%@' ",
                     db_table_name,
                     model.downloadProgress,
                     model.downloadID];
    
    return [commonFun_DB UpdataTable:sql db:dbQueue];
}


- (BOOL)UpdataUrlsToTable:(FileDownloadModel*)model {
    
    NSString *sql = [NSString stringWithFormat:@"update %@ set url = '%@' where downloadID = '%@' ",
                     db_table_name,
                     model.url,
                     model.downloadID];
    
    return [commonFun_DB UpdataTable:sql db:dbQueue];
}

- (BOOL)UpdataCurFileSizeToTable:(FileDownloadModel*)model {
    
    NSString *sql = [NSString stringWithFormat:@"update %@ set curFileSize = '%@' where downloadID = '%@' ",
                     db_table_name,
                     model.curFileSize,
                     model.downloadID];
    
    return [commonFun_DB UpdataTable:sql db:dbQueue];
}

- (BOOL)UpdataUrlCountToTable:(FileDownloadModel*)model {
    
    NSString *sql = [NSString stringWithFormat:@"update %@ set urlCount = '%@' where downloadID = '%@' ",
                     db_table_name,
                     model.urlCount,
                     model.downloadID];
    
    return [commonFun_DB UpdataTable:sql db:dbQueue];
}

- (BOOL)UpdataHiddenTypeToTable:(FileDownloadModel*)model {
    
    NSString *sql = [NSString stringWithFormat:@"update %@ set hiddenType = '%@' where downloadID = '%@' ",
                     db_table_name,
                     model.hiddenType,
                     model.downloadID];
    
    return [commonFun_DB UpdataTable:sql db:dbQueue];
}

- (BOOL)UpdataCacheInfoToTable:(FileDownloadModel*)model {
    
    NSString *sql = [NSString stringWithFormat:@"update %@ set urlCount = '%@', qualityName = '%@', orignalCount = '%@', url = '%@', curSegmental ='%@', fileSuffix = '%@' where downloadID = '%@' ",
                     db_table_name,
                     model.urlCount,
                     model.qualityName,
                     model.orignalCount,
                     model.url,
                     model.curSegmental,
                     model.fileSuffix,
                     model.downloadID];
    
    return [commonFun_DB UpdataTable:sql db:dbQueue];
}

- (BOOL)DeleteItemToTable:(FileDownloadModel*)model {
    
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where downloadID = '%@'", db_table_name, model.downloadID];
    
    return [commonFun_DB UpdataTable:sql db:dbQueue];
}


- (BOOL)DeleteAllItemToTable:(NSString *)fileType{
    
     // download_table
    NSString * sql = [NSString stringWithFormat:@"delete from %@ where fileType = '%@'",db_table_name,fileType];
    
    return [commonFun_DB UpdataTable:sql db:dbQueue];
}

- (void) dealloc{
    
    [dbQueue close];
    
    [dbQueue release];
    
    [super dealloc];
}


@end
