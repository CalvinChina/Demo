//
//  PSKDownloadModel.h
//  OperationDemo
//
//  Created by pisen on 16/12/27.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger ,PSKDownloadState) {
    PSKDownloadStateNone                = 0, // 未添加下载队列中
    PSKDownloadStateReady               = 20,// 准备下载
    PSKDownloadStateDownloading,// 下载中
    PSKDownloadStateDownloaded,// 已下载
    PSKDownloadStatePauseBySystem,// 非人为暂停
    PSKDownloadStatePauseByUser,// 人为暂停
    PSKDownloadStateCancelled,// 已取消下载
    PSKDownloadStateFailed, // 下载失败
};

@interface PSKDownloadModel : NSObject
@property (nonatomic ,copy) NSString * taskID;
@property (nonatomic ,copy) NSString * taskUrl;
@property (nonatomic ,assign) PSKDownloadState state;
// 下载产生的临时文件名
@property (nonatomic ,copy) NSString * tmpName;
@property (nonatomic ,assign) double createTime;
@property (nonatomic ,assign) double updateTime;
@property (nonatomic ,assign) long long downloadedFileSize;
@property (nonatomic ,assign) long long fileTotalSize;
- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
- (NSDictionary *)taskToDictionary;
@end
