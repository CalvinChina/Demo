//
//  FileDownloadModel.h
//
//  Created by pisen on 16/1/22.
//  Copyright © 2016年 zbx. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FileDownloadModel;

@protocol FileDownloadDelegate<NSObject>

- (void)handleDownloadProgress:(FileDownloadModel*)model;

- (void)handleDownloadFinish:(FileDownloadModel*)model;

- (void)handleDownloadFail:(FileDownloadModel*)model;

@end

@interface FileDownloadModel : NSObject

/**下载开始时间*/
@property (nonatomic ,copy) NSString * downloadStartDate;
/**文件名*/
@property (nonatomic ,copy) NSString * fileName;
/**资源路径*/
@property (nonatomic ,copy) NSString * url;
/**原始大小*/
@property (nonatomic ,copy) NSString * orignalCount;
/**下载进度*/
@property (nonatomic ,copy) NSString * downloadProgress;
/**下载状态*/ //0等待 1下载中 2已完成 3,用户暂停 4下载失败
@property (nonatomic ,copy) NSString * downloadState;
/**下载ID*/
@property (nonatomic ,copy) NSString * downloadID;
/**存储路径*/
@property (nonatomic ,copy) NSString * savePath;
/**缓存路径*/
@property (nonatomic ,copy) NSString * cachePath;
/**终止时间*/
@property (nonatomic ,copy) NSString * downloadEndDate;
//文件类型微片0，电视剧1
@property (nonatomic, copy) NSString *fileType;
//原始被解析网页地址
@property (nonatomic, copy) NSString *fromUrl;
//上次下载的分辨率
@property (nonatomic, copy) NSString *qualityName;

//影视剧分段大小
@property (nonatomic, copy) NSString *curFileSize;

//影视剧封面
@property (nonatomic, copy) NSString *coverUrl;

//影视初始分段数
@property (nonatomic, copy) NSString *urlCount;

//当前下载分段
@property (nonatomic, copy) NSString *curSegmental;

//当前的文件后缀
@property (nonatomic, copy) NSString *fileSuffix;

@property (nonatomic, copy) NSString *programId;

@property (nonatomic, copy) NSString *programType;

@property (nonatomic, copy) NSString *episode;

//影片来源 qq,优酷等
@property (nonatomic, copy) NSString *website;

//扩展字段
@property (nonatomic, copy) NSString *jsonStr;

@property (nonatomic, strong) NSProgress *progress;

//0默认显示 1在缓存列表中不显示，我的缓存中显示
@property (nonatomic, strong) NSString *hiddenType;

//码率 数值越大，越清晰
@property (nonatomic, strong) NSString *br;

@property (nonatomic, weak) id<FileDownloadDelegate> delegate;

- (void)progressChange:(NSProgress*)pro;

- (void)progressChange_ASI:(CGFloat)pro;

- (void)progressFinish;

- (void)progressFail;

@end
