//
//  DWKSqilteManager.h
//  DWKKit
//
//  Created by pisen on 16/10/20.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabaseQueue.h"


@interface DWKSqilteManager : NSObject

// FMDatabase
+ (BOOL)sqliteUpdate:(NSString *)sql dbPath:(NSString *)dbPath;
+ (BOOL)sqliteCheckIfExists:(NSString *)sql dbPath:(NSString *)dbPath;
+ (int)sqliteGetRows:(NSString *)sql dbPath:(NSString *)dbPath;


// FMDatabaseQueue 多线程数据库擦做

+(BOOL)createTable:(NSString*)sqlCreateTable db:(FMDatabaseQueue*)dbQueue;

+(BOOL)execSql:(NSString *)sql db:(FMDatabaseQueue*)dbQueue;

+(BOOL)InsertTable:(NSString*)sql db:(FMDatabaseQueue*)dbQueue;

+(BOOL)UpdataTable:(NSString*)sql db:(FMDatabaseQueue*)dbQueue;

+(NSArray*)querryTable:(NSString*)sqlQuerry db:(FMDatabaseQueue*)dbQueue;

+(BOOL)transaction:(NSArray*)sqlArr db:(FMDatabaseQueue*)dbQueue;

+ (BOOL)InsertDataDictionary:(NSDictionary *)dict toTable:(NSString *)table db:(FMDatabaseQueue*)dbQueue;

@end
