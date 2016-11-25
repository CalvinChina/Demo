//
//  YSCSqliteManager.h
//  KanPian
//
//  Created by 杨胜超 on 16/3/25.
//  Copyright © 2016年 SMIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSCSqliteManager : NSObject
+ (BOOL)sqliteUpdate:(NSString *)sql dbPath:(NSString *)dbPath;
+ (BOOL)sqliteCheckIfExists:(NSString *)sql dbPath:(NSString *)dbPath;
+ (int)sqliteGetRows:(NSString *)sql dbPath:(NSString *)dbPath;
@end
