//
//  PSKRequestManager.m
//  PisenKit
//
//  Created by 杨胜超 on 16/7/1.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import "PSKRequestManager.h"
#import "PSKFormatUtil.h"
#import "PSKModel.h"

@implementation PSKRequestManager

+ (instancetype)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[PSKRequestManager alloc] init];
    });
    return _sharedObject;
}
- (id)init {
    self = [super init];
    if (self) {
        self.requestQueue = [NSMutableDictionary dictionary];
    }
    return self;
}
- (void)cancelRequestById:(NSString *)requestId {
    NSURLSessionTask *task = self.requestQueue[requestId];
    if (NSURLSessionTaskStateRunning == task.state) {
        [task cancel];
    }
    [self.requestQueue removeObjectForKey:requestId];
}
- (void)cancelAllRequests {
    for (NSString *requestId in self.requestQueue) {
        NSURLSessionTask *task = self.requestQueue[requestId];
        if (NSURLSessionTaskStateRunning == task.state) {
            [task cancel];
        }
    }
    [self.requestQueue removeAllObjects];
}

// 解析错误信息
- (NSString *)resolvePSKErrorType:(NSString *)errorType andError:(NSError *)error {
    NSMutableString *errMsg = [NSMutableString stringWithString:@"\r>>>>>>>>>>>>>>>>>>>>ErrorType[0]>>>>>>>>>>>>>>>>>>>>\r"];//错误标记开始
    NSString *messageTitle = @"提示";
    NSString *messageDetail = errorType;
    if (OBJECT_IS_EMPTY(messageDetail)) {
        messageDetail = error.userInfo[NSLocalizedDescriptionKey];
    }
    if (OBJECT_IS_EMPTY(messageDetail)) {
        messageDetail = @"未知错误";
    }
    
    //继续组织错误日志
    [errMsg appendFormat:@"  messageTitle:%@\r  messageDetail:%@\r", messageTitle, messageDetail];//显示解析后的错误提示
    if (error) {
        [errMsg appendFormat:@"  errorCode:%ld\r  errorMessage:%@\r", (long)error.code, error];//显示error的错误内容
    }
    [errMsg appendString:@"<<<<<<<<<<<<<<<<<<<<ErrorType[0]<<<<<<<<<<<<<<<<<<<<\r\n"];//错误标记结束
    NSLog(@"error message=%@", errMsg);
    return messageDetail;
}

// 常用网络请求方法
- (NSString *)requestWithApi:(NSString *)apiName
                      params:(NSDictionary *)params
                   dataModel:(Class)dataModel
                        type:(PSKRequestType)type
                     success:(PSKRequestSuccess)success
                      failed:(PSKRequestFailed)failed {
    return [self requestFromUrl:kPathAppBaseUrl withApi:apiName params:params dataModel:dataModel type:type success:success failed:failed];
}
- (NSString *)requestFromUrl:(NSString *)url
                     withApi:(NSString *)apiName
                      params:(NSDictionary *)params
                   dataModel:(Class)dataModel
                        type:(PSKRequestType)type
                     success:(PSKRequestSuccess)success
                      failed:(PSKRequestFailed)failed {
    return [self requestFromUrl:url withApi:apiName params:params dataModel:dataModel imageData:nil type:type success:success failed:failed];
}

// 处理PSKModel和PSKDataBaseModel映射
- (NSString *)requestFromUrl:(NSString *)url
                     withApi:(NSString *)apiName
                      params:(NSDictionary *)params
                   dataModel:(Class)dataModel
                   imageData:(NSData *)imageData
                        type:(PSKRequestType)type
                     success:(PSKRequestSuccess)success
                      failed:(PSKRequestFailed)failed {
    return [self requestFromUrl:url withApi:apiName params:params customModel:[PSKModel class] imageData:imageData type:type success:^(id responseObject) {
        PSKModel *baseModel = responseObject;
        if (baseModel && [baseModel isKindOfClass:[PSKModel class]]) {
            if ([baseModel checkRequestIsSuccess]) {//接口访问成功，开始解析data模型
                NSObject *dataObject = baseModel.data;
                if (dataObject && dataModel && [[dataModel class] respondsToSelector:@selector(objectWithKeyValues:)]) {
                    dataObject = [dataModel objectWithKeyValues:dataObject];
                    if (dataObject) {//将成功映射后的data模型往上层抛
                        if (success) {
                            success(dataObject);
                        }
                    }
                    else {
                        if (failed) {
                            failed(PSKConfigManagerInstance.networkErrorDataMappingFailed, nil);
                        }
                    }
                }
                else {
                    if (success) {
                        success(dataObject);
                    }
                }
            }
            else {
                if (failed) {
                    NSInteger state = baseModel.state;
                    NSString *message = TRIM_STRING(baseModel.message);
                    failed(@"", CREATE_NSERROR_WITH_Code(state, message));// 服务器内部错误(需要进一步解析dataModel.state 和 message)
                }
            }
        }
        else {
            if (failed) {
                failed(PSKConfigManagerInstance.networkErrorDataMappingFailed, nil);
            }
        }
    } failed:failed];
}

// 处理自定义模型的映射，将映射好的自定义模型往上层抛
- (NSString *)requestFromUrl:(NSString *)url
                     withApi:(NSString *)apiName
                      params:(NSDictionary *)params
                 customModel:(Class)customModel
                   imageData:(NSData *)imageData
                        type:(PSKRequestType)type
                     success:(PSKRequestSuccess)success
                      failed:(PSKRequestFailed)failed {
    return [self requestFromUrl:url withApi:apiName params:params httpHeaderParams:nil imageData:imageData type:type success:^(id responseObject) {
        NSObject *model = responseObject;
        if (customModel && [[customModel class] respondsToSelector:@selector(objectWithKeyValues:)]) {
            model = [customModel objectWithKeyValues:responseObject];
            if (model) {//将成功映射后的data模型往上层抛
                if (success) {
                    success(model);
                }
            }
            else {
                if (failed) {
                    failed(PSKConfigManagerInstance.networkErrorDataMappingFailed, nil);
                }
            }
        }
        else {
            if (success) {
                success(model);
            }
        }
    } failed:failed];
}

// 通用的GET、POST和上传（返回最原始的未经过任何映射的JSON字符串）
- (NSString *)requestFromUrl:(NSString *)url
                     withApi:(NSString *)apiName
                      params:(NSDictionary *)params
            httpHeaderParams:(NSDictionary *)httpHeaderParams
                   imageData:(NSData *)imageData
                        type:(PSKRequestType)requestType
                     success:(PSKRequestSuccess)success
                      failed:(PSKRequestFailed)failed {
    //0. 判断网络状态、url合法性
    if ( ! PSKManagerInstance.isReachable) {
        if (failed) {
            failed(PSKConfigManagerInstance.networkErrorDisconnected, nil);
        }
        return @"";
    }
    if ( ! [NSString psk_isMatchRegex:PSKConfigManagerInstance.regexWebUrl withString:url]) {
        if (failed) {
            failed(PSKConfigManagerInstance.networkErrorURLInvalid, nil);
        }
        return @"";
    }
    //1. 自动处理重复请求
    NSString *joinedString1 = [NSDictionary psk_sortedKeyAndJoinedStringByDictionary:params];
    NSString *joinedString2 = [NSDictionary psk_sortedKeyAndJoinedStringByDictionary:httpHeaderParams];
    NSString *requestIdSource = [NSString stringWithFormat:@"%@_%@_%@_%@_%ld",
                                 url, apiName, joinedString1, joinedString2, requestType];
    NSString *requestId = [requestIdSource psk_MD5EncryptString];
    if (self.requestQueue[requestId]) {
        if (PSKConfigManagerInstance.isAutoCancelTheLastSameRequesting) {
            [self cancelRequestById:requestId];
        }
        else {
            NSLog(@"The same requstId[%@] is still running!\rurl:%@\rapi:%@\rparams:%@\rtype:%ld",
                  requestId, url, apiName, params, requestType);
            if (failed) {
                failed(PSKConfigManagerInstance.networkErrorRequesting, nil);
            }
            return @"";
        }
    }
    //2. 实例化Adapter
    PSKNetworkingAdapter *adapter = [PSKNetworkingAdapter adapter];
    if ( ! adapter) {
        if (failed) {
            failed(PSKConfigManagerInstance.networkErrorRequesFailed, nil);
        }
        return @"";
    }
    //3. 发起网络请求
    @weakiy(self)
    NSURLSessionDataTask *dataTask = [adapter.delegate dataTaskWithUrl:url apiName:apiName normalParams:params httpHeaderParams:httpHeaderParams imageData:imageData requestType:requestType completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        [weak_self.requestQueue removeObjectForKey:requestId];//移除网络请求
        if (error) {
            NSInteger statusCode = error.code;
            if (200 == statusCode) {// 服务器无法连接
                if (failed) {
                    failed(PSKConfigManagerInstance.networkErrorServerFailed, error);
                }
            }
            else if (-1001 == statusCode) {// 网络连接超时
                if (failed) {
                    failed(PSKConfigManagerInstance.networkErrorTimeout, error);
                }
            }
            else if (-1009 == statusCode || -1004 == statusCode) {// 网络处于断开状态
                if (failed) {
                    failed(PSKConfigManagerInstance.networkErrorDisconnected, error);
                }
            }
            else if (-999 == statusCode) {// 网络连接取消
                if (failed) {
                    failed(PSKConfigManagerInstance.networkErrorCancel, error);
                }
            }
            else {// 其它网络错误
                if (failed) {
                    failed(PSKConfigManagerInstance.networkErrorConnectionFailed, error);
                }
            }
        }
        else {
            NSString *resolvedString = @"";
            if ([responseObject isKindOfClass:[NSData class]]) {
                resolvedString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            }
            else if ([responseObject isKindOfClass:[NSDictionary class]] ||
                     [responseObject isKindOfClass:[NSArray class]]) {
                resolvedString = [NSString psk_jsonStringWithObject:responseObject];
            }
            NSString *formatedJsonString = [PSKFormatUtil formatPrintJsonStringOnConsole:resolvedString];
            resolvedString = OBJECT_IS_EMPTY(formatedJsonString) ? resolvedString : formatedJsonString;
            NSLog(@"resolvedString=\r%@", resolvedString);
            if ([resolvedString length] > 0) {
                if (success) {
                    success(resolvedString);
                }
            }
            else {
                if (failed) {
                    failed(PSKConfigManagerInstance.networkErrorReturnEmptyData, nil);
                }
            }
        }
    }];
    //4. 加入任务队列
    if (dataTask) {
        [dataTask resume];
        self.requestQueue[requestId] = dataTask;//加入网络请求队列
        return requestId;
    }
    else {
        if (failed) {
            failed(PSKConfigManagerInstance.networkErrorRequesFailed, nil);
        }
        return @"";
    }
}
@end
