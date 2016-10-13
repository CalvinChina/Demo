//
//  YSCLogManager.h
//  YSCKit
//
//  Created by yangshengchao on 16/1/28.
//  Copyright © 2016年 Builder. All rights reserved.
//


/**
 *  日志记录类
 */

@interface YSCLogManager : NSObject
// 设置crash的hook(一般不用自己设置，因为通常都被第三方重置了，比如UMeng)
+ (void)SetUncaughtExceptionHandler;
// 保存NSError对象
+ (void)SaveLogError:(NSError *)error;
// 保存日志字符串
+ (void)SaveLog:(NSString *)logString;
+ (void)SaveLog:(NSString *)logString intoFileName:(NSString *)fileName;
+ (void)SaveLog:(NSString *)logString intoFilePath:(NSString *)logFilePath overWrite:(BOOL)overwrite;
// 保留最近N天日志文件
+ (void)DeleteLogFilesExceptLastDays:(NSInteger)days;
@end
