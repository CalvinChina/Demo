//
//  PSKURLSessionOperation.h
//  OperationDemo
//
//  Created by pisen on 16/12/26.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface PSKURLSessionOperation : NSOperation

- (instancetype)initWithSession:(NSURLSession *)session URLString:(NSString *)urlString;
- (instancetype)initWithSession:(NSURLSession *)session URLString:(NSString *)urlString ResumeData:(NSData *)resumeData;
@property (nonatomic, strong) NSURLSessionDownloadTask *task;
@property (nonatomic, strong) NSData *resumeData;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSDate *startOperationDate;
@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, assign) BOOL isResume;
@property (nonatomic, assign) BOOL isSuspend;
@property (nonatomic, assign) BOOL alReadyStart;
@property (nonatomic, assign, getter=isOperationStarted) BOOL operationStarted;
- (void)completeOperation;

@end
