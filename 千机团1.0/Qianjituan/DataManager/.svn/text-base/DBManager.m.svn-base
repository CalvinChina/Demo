//
//  DBManager.m
//  Pisen cloud
//
//  Created by ios-mac on 14-8-19.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "DBManager.h"
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMResultSet.h"

#define kCURRENT_USER_DATABASE_PATH  @"kCurrentUserDatabasePath"

@implementation DBManager

static DBManager *instance = nil;

+ (DBManager *)sharedInstance
{
    if(!instance)
    {
        NSLog(@"创建数据库实例");
        instance = [[DBManager alloc] init];
    }
    return instance;
}

+ (void)refreshDBPath
{
    [instance release];
    instance = nil;
}

-(FMDatabaseQueue*)dbQueue;
{
    return dbQueue;
}

-(id)init
{
    self = [super init];
    if(self)
    {
//        NSString *databasePath = [NUSD objectForKey:kCURRENT_USER_DATABASE_PATH];
//        NSLog(@"databasePath:%@",databasePath);
        
        NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/Dbs"];
        
        if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:path] )
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:path
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:NULL];
        }
        
        NSString* dbtablepath = [NSString stringWithFormat:@"%@%@", [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Dbs"], @"fileTransfer.Db"];
        
        if(dbtablepath){
            dbQueue = [[FMDatabaseQueue databaseQueueWithPath:dbtablepath] retain];
        }
    }
    
    return self;
}

- (void)dealloc
{
    [dbQueue release];
    [super dealloc];
}

//创建表
-(BOOL)createTable:(NSString*)sqlCreateTable
{
    __block BOOL result = NO;
    NSLog(@"createTable is :%@\n",sqlCreateTable);
    [dbQueue inDatabase:^(FMDatabase* fdb){
        [fdb open];
        if (![fdb executeUpdate:sqlCreateTable])
        {
            NSLog(@"创建数据表失败\n");
            NSLog(@"Last error message: %@",self.dbQueue.database.lastErrorMessage);
            result = NO;
        }
        else
        {
            NSLog(@"创建数据表成功\n");
            result = YES;
        }
        [fdb close];
    }];
    return result;
}

/**
 *  执行数据库语句
 *
 *  @param sql sql语句
 *
 *  @return 成功YES 失败NO
 */
-(BOOL)execSql:(NSString *)sql
{
    __block BOOL result = NO;
    [dbQueue inDatabase:^(FMDatabase* fdb){
        NSLog(@"excSql is :%@\n",sql);
        
        [fdb open];
        
        if (![fdb executeUpdate:sql])
        {
            NSLog(@"执行sql失败\n");
            NSLog(@"Last error message: %@",self.dbQueue.database.lastErrorMessage);
            result = NO;
        }
        else
        {
            NSLog(@"执行sql成功\n");
            result = YES;
        }
        
        [fdb close];
    }];
    return result;
}

/**
 *  插入数据库表
 *
 *  @param sqlInsert 插入语句
 *
 *  @return 成功YES 失败NO
 */
-(BOOL)InsertTable:(NSString*)sqlInsert
{
    __block BOOL result = NO;
    NSLog(@"[InsertTable]:%@\n",sqlInsert);
    [dbQueue inDatabase:^(FMDatabase* fdb){
        [fdb open];
        if (![fdb executeUpdate:sqlInsert])
        {
            NSLog(@"插入数据表失败\n");
            NSLog(@"Last error message: %@",self.dbQueue.database.lastErrorMessage);
            result = NO;
        }
        else
        {
            NSLog(@"插入数据表成功\n");
            result = YES;
        }
        
        
        [fdb close];
    }];
    
    return result;
}


/**
 *  更新数据库表
 *
 *  @param sqlUpdata 更新语句
 *
 *  @return 成功YES 失败NO
 */
-(BOOL)UpdataTable:(NSString*)sqlUpdata{
    
    __block BOOL result = NO;
    NSLog(@"[UpdataTable]:%@\n",sqlUpdata);
    [dbQueue inDatabase:^(FMDatabase*fdb){
        [fdb open];
        
        if([fdb executeUpdate:sqlUpdata])
        {
            NSLog(@"\n更新表成功\n");
         
            result = YES;
        }
        else
        {
            NSLog(@"\n更新表失败\n");
            NSLog(@"Last error message: %@",self.dbQueue.database.lastErrorMessage);
            
            result = NO;
        }
        
        [fdb close];
    }];
    
    return result;
}

//select
-(NSArray*)querryTable:(NSString*)sqlQuerry
{
    NSLog(@"[querryTable]:%@\n",sqlQuerry);
    __block NSMutableArray*    array = [[NSMutableArray alloc] init];
    
    [dbQueue inDatabase:^(FMDatabase* fdb){
        
        [fdb open];
        FMResultSet* dataSet = [fdb executeQuery:sqlQuerry];
        while ([dataSet next]) {
            NSDictionary* dataDict = [[NSDictionary alloc] initWithDictionary:[dataSet resultDictionary]];
            [array addObject:dataDict];
            [dataDict release];
        }
        
        dataSet = nil;
        [fdb close];
    }];
    
    return [array autorelease];
}

/**
 *  database 事务处理
 *
 *  @param sqlArr 输入的事务，以nsarray格式
 *
 *  @return 成功yes 失败no
 */
-(BOOL)transaction:(NSArray*)sqlArr
{
    NSLog(@"[%s]:%@",__func__,sqlArr);
    
    __block BOOL resFlag = TRUE;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback)
     {
         
         for (int i=0; i<[sqlArr count]; i++)
         {
             if([[sqlArr objectAtIndex:i] isKindOfClass:[NSString class]])
             {
                 if(![db executeUpdate:((NSString*)[sqlArr objectAtIndex:i])])
                 {
                     *rollback = YES;
                     resFlag = FALSE;
                     return;
                 }
             }
         }
         
     }];
    
    return resFlag;
}

/**
 *  插入数据库操作，插入表项由字典封装
 *
 *  @param dict  字典封装的插入表项
 *  @param table 需要插入的表名
 *
 *  @return 成功YES 失败NO
 */
- (BOOL)insertDataDictionary:(NSDictionary *)dict toTable:(NSString *)table
{
    return [self insertDataDictionary:dict toTable:table returnId:nil];
}

/**
 *  插入数据库操作，插入表项由字典封装
 *
 *  @param dict  字典封装的插入表项
 *  @param table 需要插入的表名
 *  @param retId id项
 *
 *  @return 成功YES 失败NO
 */
- (BOOL)insertDataDictionary:(NSDictionary *)dict toTable:(NSString *)table returnId:(NSInteger *)retId
{
    NSMutableString *sqlCmdM = [[NSMutableString alloc] init];
    NSMutableArray *args = [[NSMutableArray alloc] init];
    NSMutableArray *replacement = [[NSMutableArray alloc] init];
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [args addObject:key];
        [replacement addObject:[NSString stringWithFormat:@":%@",key]];
    }];
    [sqlCmdM appendFormat:@"INSERT INTO %@(%@) VALUES(%@);",table,[args componentsJoinedByString:@","],[replacement componentsJoinedByString:@","]];
    [args release];
    [replacement release];
    
    NSLog(@"%s:%@",__func__,sqlCmdM);
    __block BOOL result = NO;
    [dbQueue inDatabase:^(FMDatabase* fdb){
        [fdb open];
        if (![fdb executeUpdate:sqlCmdM withParameterDictionary:dict])
        {
            NSLog(@"写入失败 Command =  %@ dict = %@",sqlCmdM, dict);
            NSLog(@"Last error message: %@",self.dbQueue.database.lastErrorMessage);
            result = NO;
        }
        else
        {
            result = YES;
            if(retId != nil)
            {
                NSString *queryStr = [NSString stringWithFormat:@"SELECT id FROM %@ ORDER BY id DESC LIMIT 1",table];
                NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
                FMResultSet *dataSet = [fdb executeQuery:queryStr];
                while ([dataSet next]) {
                    NSDictionary* dataDict = [[NSDictionary alloc] initWithDictionary:[dataSet resultDictionary]];
                    [array addObject:dataDict];
                    [dataDict release];
                }
                dataSet = nil;
                
                if([array count] > 0)
                {
                    *retId = [[[array objectAtIndex:0] objectForKey:@"id"] integerValue];
                }
            }
        }
        [fdb close];
    }];
    [sqlCmdM release];
    return result;
}

- (long long)dbLastRowId
{
    __block long long rowId;
    
    [dbQueue inDatabase:^(FMDatabase* fdb){
        
        [fdb open];
        
        rowId = [self.dbQueue.database lastInsertRowId];
        
        [fdb close];
    }];
    return rowId;
}

@end
