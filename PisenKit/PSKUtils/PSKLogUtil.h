//
//  PSKLogUtil.h
//  PisenKit
//
//  Created by 杨胜超 on 16/7/4.
//  Copyright © 2016年 Pisen. All rights reserved.
//


//====================================
//
// 日志处理
//
//====================================
@interface PSKLogUtil : NSObject
/** 保存NSError对象 */
+ (void)saveLogError:(NSError *)error;
/** 保存日志字符串 */
+ (void)saveLog:(NSString *)logString;
+ (void)saveLog:(NSString *)logString filePath:(NSString *)filePath overWrite:(BOOL)overwrite;
/** 保留最近N天日志文件 */
+ (void)deleteLogFilesExceptLastDays:(NSInteger)days;
@end
