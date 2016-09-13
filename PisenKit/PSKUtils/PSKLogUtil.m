//
//  PSKLogUtil.m
//  PisenKit
//
//  Created by 杨胜超 on 16/7/4.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import "PSKLogUtil.h"
#import "PSKStorageUtil.h"

@interface PSKLogUtil ()
@property (nonatomic, strong) dispatch_queue_t saveLogQueue;
@end

@implementation PSKLogUtil
+ (instancetype)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[PSKLogUtil alloc] init];
    });
    return _sharedObject;
}
- (id)init {
    self = [super init];
    if (self) {
        self.saveLogQueue = dispatch_queue_create("com.PisenKit.saveLogQueue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

+ (void)saveLogError:(NSError *)error {
    NSString *errMsg = [NSString stringWithFormat:@"%@", error];
    [self saveLog:errMsg];
}
+ (void)saveLog:(NSString *)logString {
    NSString *fileName =  [CURRENT_DATE psk_stringWithFormat:@"yyyy-MM-dd"];
    NSString *filePath = [[PSKStorageUtil directoryPathOfLog] stringByAppendingPathComponent:fileName];
    NSString *logStringWithTime = [NSString stringWithFormat:@"%@ -> %@\r\n", [CURRENT_DATE psk_stringWithFormat:@"HH:mm:ss SSS"], logString];
    [self saveLog:logStringWithTime filePath:filePath overWrite:NO];
}
+ (void)saveLog:(NSString *)logString filePath:(NSString *)filePath overWrite:(BOOL)overwrite {
    RETURN_WHEN_OBJECT_IS_EMPTY(logString);
    if (overwrite) {
        [NSFileManager psk_deleteFileOrDirectory:filePath];
    }
    
    dispatch_async([PSKLogUtil sharedInstance].saveLogQueue , ^{
        NSFileHandle* fh = [NSFileHandle fileHandleForWritingAtPath:filePath];
        if ( ! fh ) {
            [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
            fh = [NSFileHandle fileHandleForWritingAtPath:filePath];
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
    });
}

+ (void)deleteLogFilesExceptLastDays:(NSInteger)days {
    NSArray *fileNames = [NSFileManager psk_allPathsInDirectoryPath:[PSKStorageUtil directoryPathOfLog]];
    NSArray *tempArray = [fileNames sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSDate *date1 = [NSDate psk_dateFromString:(NSString *)obj1 withFormat:kDateFormat3];
        NSDate *date2 = [NSDate psk_dateFromString:(NSString *)obj2 withFormat:kDateFormat3];
        return [date1 psk_isEarlierThanDate:date2];
    }];
    NSInteger index = 0;
    for (NSString *fileName in tempArray) {
        NSDate *tempDate = [NSDate psk_dateFromString:fileName withFormat:kDateFormat3];
        if (tempDate) {
            index++;
            if (index > days) {
                NSString *filePath = [[PSKStorageUtil directoryPathOfLog] stringByAppendingPathComponent:fileName];
                [NSFileManager psk_deleteFileOrDirectory:filePath];
            }
        }
    }
}
@end
