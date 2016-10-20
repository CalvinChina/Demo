//
//  commonFun_DB.m
//  KanPian
//
//  Created by zengbixing on 16/3/28.
//  Copyright © 2016年 SMIT. All rights reserved.
//

#import "commonFun_DB.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMResultSet.h"

@implementation commonFun_DB

+(BOOL)createTable:(NSString*)sqlCreateTable db:(FMDatabaseQueue*)dbQueue
{
    __block BOOL result = NO;
    
    NSLog(@"createTable is :%@\n",sqlCreateTable);
    
    [dbQueue inDatabase:^(FMDatabase* fdb){
        
        [fdb open];
        
        if (![fdb executeUpdate:sqlCreateTable])
        {
            NSLog(@"创建数据表失败\n");
            
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

+(BOOL)execSql:(NSString *)sql db:(FMDatabaseQueue*)dbQueue
{
    __block BOOL result = NO;
    [dbQueue inDatabase:^(FMDatabase* fdb){
        NSLog(@"excSql is :%@\n",sql);
        
        [fdb open];
        if (![fdb executeUpdate:sql])
        {
            NSLog(@"执行sql失败\n");
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

+(BOOL)InsertTable:(NSString*)sql db:(FMDatabaseQueue*)dbQueue
{
    __block BOOL result = NO;
    NSLog(@"[InsertTable]:%@\n",sql);
    
    [dbQueue inDatabase:^(FMDatabase* fdb){
        
        [fdb open];
        
        if (![fdb executeUpdate:sql])
        {
            NSLog(@"插入数据表失败\n");
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

+(BOOL)UpdataTable:(NSString*)sql db:(FMDatabaseQueue*)dbQueue{
    
    [dbQueue inDatabase:^(FMDatabase*fdb){
        [fdb open];
        
        if([fdb executeUpdate:sql])
        {
            //NSLog(@"\n更新表成功\n");
        }
        else
        {
            NSLog(@"\n更新表失败\n");
        }
        
        [fdb close];
    }];
    
    return YES;
    
}

+(NSArray*)querryTable:(NSString*)sqlQuerry db:(FMDatabaseQueue*)dbQueue
{
    __block NSMutableArray*    array = [[NSMutableArray alloc] init];
    
    [dbQueue inDatabase:^(FMDatabase* fdb){
        
        [fdb open];
        
        FMResultSet* dataSet = [fdb executeQuery:sqlQuerry];
        
        while ([dataSet next]) {
            
            NSDictionary* dataDict = [[NSDictionary alloc] initWithDictionary:[dataSet resultDictionary]];
            
            [array addObject:dataDict];
        }
        
        dataSet = nil;
        
        [fdb close];
    }];
    
    return array;
}

+(BOOL)transaction:(NSArray*)sqlArr db:(FMDatabaseQueue*)dbQueue
{
    __block BOOL resFlag = TRUE;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback)
     {
         [db open];
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
         [db close];
     }];
    
    return resFlag;
}

+ (BOOL)InsertDataDictionary:(NSDictionary *)dict toTable:(NSString *)table db:(FMDatabaseQueue*)dbQueue
{
    NSMutableString *sqlCmdM = [[NSMutableString alloc] init];
    
    NSMutableArray *args = [[NSMutableArray alloc] init];
    
    NSMutableArray *replacement = [[NSMutableArray alloc] init];
    
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        [args addObject:key];
        
        [replacement addObject:[NSString stringWithFormat:@":%@",key]];
    }];
    
    [sqlCmdM appendFormat:@"INSERT INTO %@(%@) VALUES(%@);",table,[args componentsJoinedByString:@","],[replacement componentsJoinedByString:@","]];
   
    
    NSLog(@"%s:%@",__func__,sqlCmdM);
    
    __block BOOL result = NO;
    
    [dbQueue inDatabase:^(FMDatabase* fdb){
        
        [fdb open];
        
        if (![fdb executeUpdate:sqlCmdM withParameterDictionary:dict]) {
            
            NSLog(@"写入失败 Command =  %@ dict = %@",sqlCmdM, dict);
            
            result = NO;
        }
        else {
            
            result = YES;
        }
        
        [fdb close];
    }];
    
    return result;
}

@end
