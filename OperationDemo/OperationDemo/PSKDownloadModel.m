//
//  PSKDownloadModel.m
//  OperationDemo
//
//  Created by pisen on 16/12/27.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

#import "PSKDownloadModel.h"

@implementation PSKDownloadModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
}
- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    if (self = [super init]) {
        self.taskID = dictionary[@"taskID"];
        self.taskUrl = dictionary[@"taskUrl"];
        self.state = [dictionary [@"state"] integerValue];
        self.tmpName = dictionary [@"tmpName"];
        self.createTime = [dictionary[@"createTime"] doubleValue];
        self.updateTime = [dictionary[@"updateTime"] doubleValue];
        self.downloadedFileSize = [dictionary[@"downloadedFileSize"] longLongValue];
        self.fileTotalSize = [dictionary[@"fileTotalSize"] longLongValue];
    }
    return self;
}
- (NSDictionary *)taskToDictionary{
    NSMutableDictionary * modelDict = [NSMutableDictionary dictionary];
    [modelDict setObject:TRIM_STRING(_taskID) forKey:@"taskID"];
    [modelDict setObject:TRIM_STRING(_taskUrl) forKey:@"taskUrl"];
    [modelDict setObject:@(_state) forKey:@"state"];
    [modelDict setObject:TRIM_STRING(_tmpName) forKey:@"tmpName"];
    [modelDict setObject:@(_createTime) forKey:@"createTime"];
    [modelDict setObject:@(_updateTime) forKey:@"updateTime"];
    [modelDict setObject:@(_downloadedFileSize) forKey:@"downloadedFileSize"];
    [modelDict setObject:@(_fileTotalSize) forKey:@"fileTotalSize"];
    return modelDict;
}

@end
