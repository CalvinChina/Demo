//
//  YSCRequestManager.m
//  YSCKit
//
//  Created by yangshengchao on 16/1/28.
//  Copyright © 2016年 Builder. All rights reserved.
//

#import "YSCRequestManager.h"
#import "AFNetworking.h"

//------------------------------------------------------------------------
//  请求业务数据
//------------------------------------------------------------------------
@implementation YSCRequestManager
// 常用方法
+ (void)RequestWithAPI:(NSString *)apiName
                params:(NSDictionary *)params
             dataModel:(Class)dataModel
           requestType:(RequestType)requestType
      requestSuccessed:(RequestSuccessed)requestSuccessed
        requestFailure:(RequestFailure)requestFailure {
    [self RequestFromUrl:kResPathAppBaseUrl withAPI:apiName params:params dataModel:dataModel requestType:requestType requestSuccessed:requestSuccessed requestFailure:requestFailure];
}
+ (void)RequestFromUrl:(NSString *)url
               withAPI:(NSString *)apiName
                params:(NSDictionary *)params
             dataModel:(Class)dataModel
           requestType:(RequestType)requestType
      requestSuccessed:(RequestSuccessed)requestSuccessed
        requestFailure:(RequestFailure)requestFailure {
    [self RequestFromUrl:url withAPI:apiName params:params dataModel:dataModel imageData:nil requestType:requestType requestSuccessed:requestSuccessed requestFailure:requestFailure];
}

// 处理YSCBaseModel和BaseDataModel映射、登陆过期(state=99)
+ (void)RequestFromUrl:(NSString *)url
             withAPI:(NSString *)apiName
              params:(NSDictionary *)params
           dataModel:(Class)dataModel
           imageData:(NSData *)imageData
         requestType:(RequestType)requestType
    requestSuccessed:(RequestSuccessed)requestSuccessed
      requestFailure:(RequestFailure)requestFailure {
    //0. url组装、参数格式化
    NSString *tempApiName = [@"/" stringByAppendingPathComponent:apiName];//组装完整的url地址
    url = [url stringByAppendingString:tempApiName];
    
    //1. 调用网络访问通用方法
    [self RequestFromUrl:url params:params customModel:[YSCBaseModel class] imageData:imageData requestType:requestType requestSuccessed:^(id responseObject) {
        YSCBaseModel *baseModel = responseObject;
        if (baseModel && [baseModel isKindOfClass:[YSCBaseModel class]]) {
            if ([baseModel isSuccess]) {//接口访问成功，开始解析data模型
                NSObject *dataObject = baseModel.data;
                if (dataObject && dataModel && [[dataModel class] respondsToSelector:@selector(ObjectWithKeyValues:)]) {
                    dataObject = [dataModel ObjectWithKeyValues:dataObject];
                    if (dataObject) {//将成功映射后的data模型往上层抛
                        if (requestSuccessed) {
                            requestSuccessed(dataObject);
                        }
                    }
                    else {
                        if (requestFailure) {
                            requestFailure(ErrorTypeDataMappingFailed, CreateNSError(@"数据映射出错"));
                        }
                    }
                }
                else {
                    if (requestSuccessed) {
                        requestSuccessed(dataObject);
                    }
                }
            }
            else {
                if ([baseModel isLoginExpired]) {//登录过期
                    NSDictionary *param = @{kParamUserId : USERID, kParamMessage : Trim(baseModel.message)};
                    postNWithInfo(kNotificationLoginExpired, param);
                }
                if (requestFailure) {
                    requestFailure(ErrorTypeInternalServer, CreateNSErrorCode(baseModel.state, baseModel.message));
                }
            }
        }
        else {
            if (requestFailure) {
                requestFailure(ErrorTypeDataMappingFailed, CreateNSError(@"数据映射出错"));
            }
        }
    } requestFailure:requestFailure];
}


// 处理自定义模型的映射，将映射好的自定义模型往上层抛
+ (void)RequestFromUrl:(NSString *)url
              params:(NSDictionary *)params
         customModel:(Class)customModel
           imageData:(NSData *)imageData
         requestType:(RequestType)requestType
    requestSuccessed:(RequestSuccessed)requestSuccessed
      requestFailure:(RequestFailure)requestFailure {
    [self RequestFromUrl:url params:params imageData:imageData requestType:requestType requestSuccessed:^(id responseObject) {
        NSObject *model = responseObject;
        if (customModel && [[customModel class] respondsToSelector:@selector(ObjectWithKeyValues:)]) {
            model = [customModel ObjectWithKeyValues:responseObject];
            if (model) {//将成功映射后的data模型往上层抛
                if (requestSuccessed) {
                    requestSuccessed(model);
                }
            }
            else {
                if (requestFailure) {
                    requestFailure(ErrorTypeDataMappingFailed, CreateNSError(@"数据映射出错"));
                }
            }
        }
        else {
            if (requestSuccessed) {
                requestSuccessed(model);
            }
        }
    } requestFailure:requestFailure];
}


// 通用的GET、POST和上传图片（返回最原始的未经过任何映射的JSON字符串）
+ (void)RequestFromUrl:(NSString *)url
              params:(NSDictionary *)params
           imageData:(NSData *)imageData
         requestType:(RequestType)requestType
    requestSuccessed:(RequestSuccessed)requestSuccessed
      requestFailure:(RequestFailure)requestFailure {
    //0. 判断网络状态、判断url合法性
    if (NO == YSCInstance.isReachable) {
        if (requestFailure) {
            requestFailure(ErrorTypeDisconnected, CreateNSError(@"网络未连接"));
        }
        return;
    }
    if (NO == [NSString isUrl:url]) {
        if (requestFailure) {
            requestFailure(ErrorTypeURLInvalid, CreateNSError(@"url不合法"));
        }
        return;
    }
    NSDictionary *formatedParams = [YSCManager FormatRequestParams:params];//格式化所有请求的参数
    
    //1. 定义返回成功的block
    void (^success)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *resolvedString = [YSCManager ResolveResponseObject:responseObject];
        if ([resolvedString length] > 0) {
            if (requestSuccessed) {
                requestSuccessed(resolvedString);
            }
        }
        else {
            if (requestFailure) {
                requestFailure(ErrorTypeDataEmpty, CreateNSError(@"返回数据为空"));
            }
        }
    };
    
    //2. 定义返回失败的block
    void (^failed)(AFHTTPRequestOperation *operation, NSError *error) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        if (200 != operation.response.statusCode) {
            if (401 == operation.response.statusCode) {
                NSDictionary *param = @{kParamUserId : USERID, kParamMessage : @"登录过期"};
                postNWithInfo(kNotificationLoginExpired, param);
                if (requestFailure) {
                    requestFailure(ErrorTypeLoginExpired, error);
                }
            }
            else {
                if (requestFailure) {
                    requestFailure(ErrorTypeServerFailed, error);
                }
            }
        }
        else {
            if (requestFailure) {
                requestFailure(ErrorTypeConnectionFailed, error);
            }
        }
    };
    
    //3. 发起网络请求
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    manager.requestSerializer.timeoutInterval = kDefaultRequestTimeOut;//设置POST和GET的超时时间
    //解决返回的Content-Type始终是application/xml问题！
    [manager.requestSerializer setValue:@"application/xml" forHTTPHeaderField:@"Accept"];
    //    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];//TODO:压缩上传内容
    [manager.requestSerializer setValue:AppVersion forHTTPHeaderField:kParamVersion];
    [manager.requestSerializer setValue:kParamFromValue forHTTPHeaderField:kParamFrom];
    [manager.requestSerializer setValue:[YSCManager SignatureWithParams:formatedParams] forHTTPHeaderField:kParamSignature];
    [manager.requestSerializer setValue:[YSCManager EncryptHttpHeaderToken] forHTTPHeaderField:kAppHTTPTokenName];
    if (RequestTypeGET == requestType) {
        NSLog(@"getting data from url[%@]", url);
        [manager   GET:url
            parameters:formatedParams
               success:success
               failure:failed];
    }
    else if (RequestTypePOST == requestType) {
        NSLog(@"posting data to url[%@]", url);
        [manager  POST:url
            parameters:formatedParams
               success:success
               failure:failed];
    }
    else if (RequestTypeUploadFile == requestType) {
        NSLog(@"uploading data to url[%@]", url);
        [manager       POST:url
                 parameters:formatedParams
  constructingBodyWithBlock: ^(id < AFMultipartFormData > formData) {
      if (imageData) {
          [formData appendPartWithFileData:imageData name:@"file" fileName:@"avatar.png" mimeType:@"application/octet-stream"];
      }
  }
                    success:success
                    failure:failed];
    }
    else if (RequestTypePostBodyData == requestType) {
        NSLog(@"posting bodydata to url[%@]", url);
        NSString *bodyParam = [NSString jsonStringWithObject:formatedParams];
        bodyParam = [YSCManager EncryptPostBodyParam:bodyParam];
        NSMutableURLRequest *mutableRequest = [manager.requestSerializer requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
        mutableRequest.HTTPBody = [bodyParam dataUsingEncoding:manager.requestSerializer.stringEncoding];
        [mutableRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:mutableRequest success:success failure:failed];
        [manager.operationQueue addOperation:operation];
    }
}

@end



//------------------------------------------------------------------------
//  上传大文件
//------------------------------------------------------------------------
@implementation YSCRequestManager (Upload)

@end


//------------------------------------------------------------------------
//  下载大文件
//------------------------------------------------------------------------
@implementation YSCRequestManager (Download)

@end