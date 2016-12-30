//
//  PSKDownloadManager.h
//  OperationDemo
//
//  Created by pisen on 16/12/26.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^PSKObjectBlock)(NSObject *object);

@protocol PSKDownloadManagerDelegate <NSObject>
- (void)didReceiveDataWithSpeed:(NSString *)speed progress:(float) progress taskUrlString:(NSString *)taskUrlString;
- (void)didiFinishDownloadTaskWithOperation:(NSString *)taskUrlString;
- (void)downloadError:(NSString *)taskUrlString error:(NSError *)error;
@end

@interface PSKDownloadManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic ,strong) NSURLSession * session;
@property (nonatomic ,copy) NSString * urlString;
@property (nonatomic ,strong) NSMutableDictionary * operationDictionary;
@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic ,assign) NSUInteger currentNetStatus;
@property (nonatomic ,assign) BOOL isWWANDownload;
@property (nonatomic ,weak) id <PSKDownloadManagerDelegate> delegate;

@end
