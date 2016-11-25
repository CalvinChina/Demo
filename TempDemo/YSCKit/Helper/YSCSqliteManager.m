//
//  YSCSqliteManager.m
//  KanPian
//
//  Created by 杨胜超 on 16/3/25.
//  Copyright © 2016年 SMIT. All rights reserved.
//

#import "YSCSqliteManager.h"
#import "FMDatabase.h"

@implementation YSCSqliteManager
+ (BOOL)sqliteUpdate:(NSString *)sql dbPath:(NSString *)dbPath {
    BOOL isSuccess = NO;
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]) {
        isSuccess = [db executeUpdate:sql];
    }
    [db close];
    return isSuccess;
}
+ (BOOL)sqliteCheckIfExists:(NSString *)sql dbPath:(NSString *)dbPath {
    BOOL isExists = NO;
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]) {
        FMResultSet *resultSet = [db executeQuery:sql];
        if (resultSet) {
            isExists = [resultSet next];
        }
        [resultSet close];
    }
    [db close];
    return isExists;
}
+ (int)sqliteGetRows:(NSString *)sql dbPath:(NSString *)dbPath {
    int num = 0;
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]) {
        FMResultSet *resultSet = [db executeQuery:sql];
        if ([resultSet next]) {
            num = [resultSet intForColumnIndex:0];
        }
        [resultSet close];
    }
    [db close];
    return num;
}
@end
