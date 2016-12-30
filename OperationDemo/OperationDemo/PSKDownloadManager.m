//
//  PSKDownloadManager.m
//  OperationDemo
//
//  Created by pisen on 16/12/26.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

#import "PSKDownloadManager.h"
#import "PSKURLSessionOperation.h"
static NSInteger kMaxDownloaingNum  = 4;

@interface PSKDownloadManager()<NSURLSessionDelegate>
@property (nonatomic ,assign) NSUInteger contentLength;
@property (nonatomic ,copy) NSString * contentPath;
@property (nonatomic ,strong) NSMutableArray * downloadArray;

@property (nonatomic ,assign) NSMutableDictionary * resumeInfoDictionary;
@end

@implementation PSKDownloadManager

+ (instancetype)sharedInstance{
    static PSKDownloadManager * downloadManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        downloadManager = [[PSKDownloadManager alloc]init];
    });
    return downloadManager;
}

- (instancetype)init{
    if (self = [super init]){
        self.currentNetStatus = -1;
        self.isWWANDownload = YES;
        self.queue = [[NSOperationQueue alloc]init];
        self.queue.maxConcurrentOperationCount = kMaxDownloaingNum;
        NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
        self.downloadArray = [NSMutableArray array];
        self.operationDictionary = [NSMutableDictionary dictionary];
        [self _createResumeDict];
    }
    return self;
}
// 初始化断点下载配置信息
- (void)_createResumeDict{
    if (_resumeInfoDictionary == nil) {
        _resumeInfoDictionary = [NSMutableDictionary dictionary];
    }
    [_resumeInfoDictionary setObject:@"" forKey:@"NSURLSessionDownloadURL"];
    [_resumeInfoDictionary setObject:[NSNumber numberWithInteger:0] forKey:@"NSURLSessionResumeBytesReceived"];
    [_resumeInfoDictionary setObject:@"" forKey:@"NSURLSessionResumeInfoLocalPath"];
}

#pragma mark -- public method
- (void)addTaskByUrls:(NSArray *)urls completion:(PSKObjectBlock)completion{
    NSMutableArray * tasks = [NSMutableArray array];
    //
    for (int index = 0; index < urls.count;index ++) {
        NSMutableDictionary * modelDict = [NSMutableDictionary dictionary];
        NSString * tempUrl = urls[index];
        [modelDict setObject:tempUrl forKey:@"taskUrl"];
        NSString * urlMD5 = [tempUrl md5String];
        [modelDict setObject:urlMD5 forKey:@"taskID"];
        [modelDict setObject:@(PSKDownloadStateReady) forKey:@"state"];
        [modelDict setObject:@"" forKey:@"tmpName"];
        [modelDict setObject:@([NSDate date].timeIntervalSince1970) forKey:@"createTime"];
        [modelDict setObject:@([NSDate date].timeIntervalSince1970) forKey:@"createTime"];
        [modelDict setObject:@0 forKey:@"downloadedFileSize"];
        [modelDict setObject:@0 forKey:@"fileTotalSize"];
        PSKDownloadModel * model = [[PSKDownloadModel alloc]initWithDictionary:modelDict];
        [tasks addObject:model];
    }
    [self addTaskByTasks:tasks completion:completion];
}

- (void)addTaskByTasks:(NSArray *)tasks completion:(PSKObjectBlock)completion {
    NSMutableArray *unAddedTaskIds = [NSMutableArray array];
    for (PSKDownloadModel *task in tasks) {
        [unAddedTaskIds addObject:task.taskID];
    }
    NSArray * array = [[PSKCoreDataManager sharedInstance] queryFromData];
    NSMutableArray * removeIds = [NSMutableArray array];
    if (array){
        for (PSKDownloadModel * task in array){
            for (NSString * tempId in unAddedTaskIds){
                if ([task.taskID isEqualToString:tempId]){
                    [removeIds addObject:task.taskID];
                }
            }
        }
    }
    [unAddedTaskIds removeObjectsInArray:removeIds];
    
    // 过滤已经添加过的model
    NSMutableArray *unAddedTasks = [NSMutableArray array];
    for (PSKDownloadModel *task in tasks) {
        if ([unAddedTaskIds containsObject:task.taskID]) {
            [unAddedTasks addObject:task];
        }
    }
    // 判空
    if (unAddedTasks.count == 0) {
        if (completion) {
            completion(@"下载任务为空");
        }
        return;
    }
    // 插入下载任务
    NSInteger successCount = 0;
    for (PSKDownloadModel *task in unAddedTasks) {
        task.state = PSKDownloadStateReady;
        BOOL isSuccess =  [[PSKCoreDataManager sharedInstance] batchInsertDatasWithModels:@[task]];
        if (isSuccess) {
            successCount++ ;
        }
        else {
        }
    }
    if (successCount > 0) {
        // FIXME:执行下载
//        POST_NOTIFICATION(PSKAddDownloadTask);
//        [self _autoDownloading];// 启动下载任务
    }
    NSInteger failedCount = [unAddedTasks count] - successCount;
    NSMutableString *msg = [NSMutableString string];
    [msg appendFormat:@"成功添加%ld条下载任务", successCount];
    if (failedCount > 0) {
        [msg appendFormat:@"，失败%ld条", failedCount];
    }
    if (completion) {
        completion(msg);
    }
}



#pragma mark -- public method

#pragma mark -- private method
// 获取恢复下载Data
- (NSData *) _createResumeDatawithModel:(PSKDownloadModel*)model{
    if (model.tmpName.length == 0){
        NSLog(@"无临时路径");
        return nil;
    }
    if (!model.tmpName) {
        NSLog(@"无临时路径");
        return nil;
    }
    NSData * tempData = [NSData new];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:model.taskUrl]];
    NSString *fullPath = [NSTemporaryDirectory() stringByAppendingPathComponent:model.tmpName];
    long long fileSize = [self getFileSize:fullPath];
    [req addValue:[NSString stringWithFormat:@"bytes=%lld", fileSize] forHTTPHeaderField:@"Range"];
    NSData *a = [NSKeyedArchiver archivedDataWithRootObject:req];
    [_resumeInfoDictionary setObject:a forKey:@"NSURLSessionResumeCurrentRequest"];
    [_resumeInfoDictionary setObject:[NSNumber numberWithInteger:fileSize] forKey:@"NSURLSessionResumeBytesReceived"];
    [_resumeInfoDictionary setObject:TRIM_STRING(fullPath) forKey:@"NSURLSessionResumeInfoLocalPath"];
    [_resumeInfoDictionary setObject:TRIM_STRING(model.taskUrl) forKey:@"NSURLSessionDownloadURL"];
    tempData = [NSPropertyListSerialization dataWithPropertyList:_resumeInfoDictionary format:NSPropertyListXMLFormat_v1_0 options:0 error:nil];
    return tempData;
}
- (long long) getFileSize:(NSString*)path {
    NSFileManager *fm  = [NSFileManager defaultManager];
    NSError *error = nil;
    NSDictionary* dictFile = [fm attributesOfItemAtPath:path error:&error];
    if (error) {
        NSLog(@"getfilesize error: %@", error);
        return 0;
    }
    long fileSize = [dictFile fileSize];
    return fileSize;
}
/**根据ID在存储信息中找到对应的对象**/
- (PSKDownloadModel *)_getModelByTaskIdFromSaveInfo:(NSString *)taskId{
    PSKDownloadModel * model = nil;
    NSArray * array = [[PSKCoreDataManager sharedInstance] queryFromData];
    for (PSKDownloadModel * temp in array){
        if ([temp.taskID isEqualToString:taskId]){
            model = temp;
        }
    }
    return model;
}
// 获取临时文件的大小
- (long long)_getTempSizeOfDownloadingTask:(NSString * )taskId{
    long long fileSize =  0;
    PSKDownloadModel * task = [self _getModelByTaskIdFromSaveInfo:taskId];
    if (nil == task.tmpName || [task.tmpName length] == 0) {
        return 0;
    }
    NSString * fullPath = [NSTemporaryDirectory() stringByAppendingPathComponent:task.tmpName];
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:fullPath]){
        fileSize = [[manager attributesOfItemAtPath:fullPath error:nil] fileSize];
    }
    return fileSize;
}

/**批量更改任务状态**/
- (void)_updateTasksState:(PSKDownloadState)state tasks:(NSArray *)tasks{
    if (nil == tasks){
        return;
    }
    [[PSKCoreDataManager sharedInstance] batchUpdateTasks:tasks State:state];
}

/**批量删除信息*/
- (void)_deleteTasksInSaveInfByTaskIds:(NSArray*)taskIds{
    if (taskIds.count == 0){
        return;
    }
    NSArray * array = [[PSKCoreDataManager sharedInstance] queryFromData];
    NSMutableArray * deleteTasks = [NSMutableArray array];
    for (PSKDownloadModel * task in array){
        if ([taskIds containsObject:task.taskID]){
            [deleteTasks addObject:task];
        }
    }
    [[PSKCoreDataManager sharedInstance] batchDelete:deleteTasks];
}
#pragma mark -- private method


#pragma mark --  NSURLSession Delegates
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL*)location{
    NSString * fileNameByMD5 = [downloadTask.taskDescription md5String];
    NSString * destinationPath = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([paths count] > 0) {
        destinationPath = [[NSString stringWithFormat:@"%@", paths[0]] stringByAppendingPathComponent:fileNameByMD5];
    }
    NSURL * fileUrl = [NSURL fileURLWithPath:destinationPath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:destinationPath]){
        NSError * error =  nil;
        [[NSFileManager defaultManager] moveItemAtURL:location toURL:fileUrl error:&error];
        if (error){
            [MZUtility showAlertViewWithTitle:@"" msg:error.localizedDescription];
        }
    }
    PSKURLSessionOperation * operation = [self.operationDictionary objectForKey:downloadTask.taskDescription];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didiFinishDownloadTaskWithOperation:)]){
        [self.delegate didiFinishDownloadTaskWithOperation:downloadTask.taskDescription];
    }
    [operation cancel];
    [operation completeOperation];
    [self.operationDictionary removeObjectForKey:downloadTask.taskDescription];
}
// 下载结果
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error){
        if (error.code != NSURLErrorCancelled){
            PSKURLSessionOperation * operation = [[PSKDownloadManager sharedInstance].operationDictionary objectForKey:task.taskDescription];
            
//            operation.resumeData =
        }
    
    }
//    if(error)
//    {
//        if(error.code != NSURLErrorCancelled)
//        {
//            DLURLSessionOperation *operation = [[DLDownloadMagager sharedManager].operationDictionary objectForKey:task.taskDescription];
//            operation.resumeData = (NSData *)[error.userInfo objectForKey:@"NSURLSessionDownloadTaskResumeData"];
//            if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishDownloadTaskWithOperation:)]) {
//                [self.delegate downloadError:task.taskDescription error:error];
//            }
//        }
//    }
}
// 进度
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten // 每次写入的data字节数
 totalBytesWritten:(int64_t)totalBytesWritten // 当前一共写入的data字节数
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite // 期望收到的所有data字节数
{
    // 计算当前下载进度并更新视图
    NSLog(@"%@",downloadTask.taskDescription);
    float progress = (float)downloadTask.countOfBytesReceived /  (float)downloadTask.countOfBytesExpectedToReceive;
    PSKURLSessionOperation * operation = [self.operationDictionary objectForKey:downloadTask.taskDescription];
    NSTimeInterval downloadTime = -1 * [operation.startOperationDate timeIntervalSinceNow];
    
    NSString * speed = [NSString stringWithFormat:@"%.2f %@",[MZUtility calculateFileSizeInUnit:(unsigned long long)(bytesWritten / downloadTime)],[MZUtility calculateUnit:(unsigned long long)(bytesWritten /  downloadTime)]];
    operation.startOperationDate = [NSDate date];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didReceiveDataWithSpeed:progress:taskUrlString:)]){
        [self.delegate didReceiveDataWithSpeed:speed progress:progress taskUrlString:downloadTask.taskDescription];
    }
    
    // 临时文件路径
    NSString * localPath = [[[downloadTask valueForKey:@"downloadFile"] valueForKey:@"path"] lastPathComponent];
    [_resumeInfoDictionary setObject:TRIM_STRING(localPath) forKey:@"NSURLSessionResumeInfoLocalPath"];
    NSString * tempID =  [downloadTask.taskDescription md5String];
    PSKDownloadModel * model = [self _getModelByTaskIdFromSaveInfo:tempID];
    model.tmpName = localPath;
    model.fileTotalSize = totalBytesExpectedToWrite;
    model.downloadedFileSize = [self _getTempSizeOfDownloadingTask:tempID];
    [[PSKCoreDataManager sharedInstance]batchUpdateTasks:@[model] State:PSKDownloadStateDownloading];
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session{
    if ([PSKDownloadManager sharedInstance].queue.operationCount > 0) {
        [[PSKDownloadManager sharedInstance].queue cancelAllOperations];
    };
}


@end
