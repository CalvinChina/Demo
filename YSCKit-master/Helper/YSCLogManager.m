//
//  YSCLogManager.m
//  YSCKit
//
//  Created by yangshengchao on 16/1/28.
//  Copyright © 2016年 Builder. All rights reserved.
//

#import "YSCLogManager.h"

//记录APP的crash日志
void _uncaughtExceptionHandler(NSException *exception) {
    NSArray *stackArray = [exception callStackSymbols];// 异常的堆栈信息
    NSString *reason = [exception reason];// 出现异常的原因
    NSString *name = [exception name];// 异常名称
    NSString *exceptionInfo = [NSString stringWithFormat:@"Exception reason：%@\rException name：%@\rException stack：%@",name, reason, stackArray];
    
    NSMutableString *errMsg = [NSMutableString stringWithString:@"\r>>>>>>>>>>>>>>>>>>>>CrashLog>>>>>>>>>>>>>>>>>>>>\r"];//错误标记开始
    [errMsg appendFormat:@"%@\r", exceptionInfo];
    [errMsg appendString:@"<<<<<<<<<<<<<<<<<<<<CrashLog<<<<<<<<<<<<<<<<<<<<\r\n"];//错误标记结束
    [YSCLogManager SaveLog:errMsg];
}
@implementation YSCLogManager

+ (void)SetUncaughtExceptionHandler {
    NSSetUncaughtExceptionHandler(&_uncaughtExceptionHandler);
}
+ (void)SaveLogError:(NSError *)error {
    NSString *errMsg = [NSString stringWithFormat:@"%@", error];
    [self SaveLog:errMsg];
}

+ (void)SaveLog:(NSString *)logString {
    NSString *logDirectory = [YSCStorageInstance directoryPathOfDocumentsLog];
    NSString *fileName =  [CURRENTDATE stringWithFormat:@"yyyy-MM-dd"];
    NSString *logFilePath = [logDirectory stringByAppendingPathComponent:fileName];
    NSString *logStringWithTime = [NSString stringWithFormat:@"%@ -> %@\r\n", [CURRENTDATE stringWithFormat:@"HH:mm:ss SSS"], logString];
    [self SaveLog:logStringWithTime intoFilePath:logFilePath overWrite:NO];
}
+ (void)SaveLog:(NSString *)logString intoFileName:(NSString *)fileName {
    NSString *logDirectory = [YSCStorageInstance directoryPathOfDocumentsLog];
    NSString *logFilePath = [logDirectory stringByAppendingPathComponent:fileName];
    [self SaveLog:logString intoFilePath:logFilePath overWrite:YES];
}
+ (void)SaveLog:(NSString *)logString intoFilePath:(NSString *)logFilePath overWrite:(BOOL)overwrite {
    ReturnWhenObjectIsEmpty(logString);
    if (overwrite && [YSCFileManager FileExistsAtPath:logFilePath]) {
        [YSCFileManager DeleteFileOrDirectory:logFilePath];
    }
    NSFileHandle* fh = [NSFileHandle fileHandleForWritingAtPath:logFilePath];
    if ( ! fh ) {
        [[NSFileManager defaultManager] createFileAtPath:logFilePath contents:nil attributes:nil];
        fh = [NSFileHandle fileHandleForWritingAtPath:logFilePath];
    }
    @try {
        [fh seekToEndOfFile];
        [fh writeData:[logString dataUsingEncoding:NSUTF8StringEncoding]];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    [fh closeFile];
}

+ (void)DeleteLogFilesExceptLastDays:(NSInteger)days {
    NSArray *fileNames = [YSCFileManager AllPathsInDirectoryPath:[YSCStorageInstance directoryPathOfDocumentsLog]];
    NSArray *tempArray = [fileNames sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSDate *date1 = [NSDate dateFromString:(NSString *)obj1 withFormat:kDateFormat3];
        NSDate *date2 = [NSDate dateFromString:(NSString *)obj2 withFormat:kDateFormat3];
        return [date1 isEarlierThanDate:date2];
    }];
    NSInteger index = 0;
    for (NSString *fileName in tempArray) {
        NSDate *tempDate = [NSDate dateFromString:fileName withFormat:kDateFormat3];
        if (tempDate) {
            index++;
            if (index > days) {
                NSString *filePath = [[YSCStorageInstance directoryPathOfDocumentsLog] stringByAppendingPathComponent:fileName];
                [YSCFileManager DeleteFileOrDirectory:filePath];
            }
        }
    }
}
@end
