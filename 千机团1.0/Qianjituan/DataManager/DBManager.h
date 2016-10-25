//
//  DBManager.h
//  Pisen cloud
//
//  Created by ios-mac on 14-8-19.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabaseQueue;
@interface DBManager : NSObject
{
    FMDatabaseQueue *dbQueue;
}

+ (DBManager *)sharedInstance;
+ (void)refreshDBPath;

-(FMDatabaseQueue*)dbQueue;

-(BOOL)createTable:(NSString*)sqlCreateTable;

//执行sql语句
-(BOOL)execSql:(NSString*)sql;
//-(BOOL)execWithSqlArr:(NSArray*)sqlArr;

//插入数据库表数据
-(BOOL)InsertTable:(NSString*)sqlInsert;

//更新数据
-(BOOL)UpdataTable:(NSString*)sqlUpdata;

//查询数据，以NSArray元素为NSMutableDictionary结构,NSArray元素个数即为记录数
-(NSArray*)querryTable:(NSString*)sqlQuerry;

-(BOOL)transaction:(NSArray*)sqlArr;

- (BOOL)insertDataDictionary:(NSDictionary *)dict toTable:(NSString *)table returnId:(NSInteger *)retId;
- (BOOL)insertDataDictionary:(NSDictionary *)dict toTable:(NSString *)table;

- (long long)dbLastRowId;

@end
