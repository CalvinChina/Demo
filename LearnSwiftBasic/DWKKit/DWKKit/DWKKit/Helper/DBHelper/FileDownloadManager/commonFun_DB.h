//
//  commonFun_DB.h
//  KanPian
//
//  Created by zengbixing on 16/3/28.
//  Copyright © 2016年 SMIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabaseQueue.h"

@interface commonFun_DB : NSObject

+(BOOL)createTable:(NSString*)sqlCreateTable db:(FMDatabaseQueue*)dbQueue;

+(BOOL)execSql:(NSString *)sql db:(FMDatabaseQueue*)dbQueue;

+(BOOL)InsertTable:(NSString*)sql db:(FMDatabaseQueue*)dbQueue;

+(BOOL)UpdataTable:(NSString*)sql db:(FMDatabaseQueue*)dbQueue;

+(NSArray*)querryTable:(NSString*)sqlQuerry db:(FMDatabaseQueue*)dbQueue;

+(BOOL)transaction:(NSArray*)sqlArr db:(FMDatabaseQueue*)dbQueue;

+ (BOOL)InsertDataDictionary:(NSDictionary *)dict toTable:(NSString *)table db:(FMDatabaseQueue*)dbQueue;

@end
