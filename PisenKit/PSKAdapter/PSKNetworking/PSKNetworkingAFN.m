//
//  PSKNetworkingAFN.m
//  PisenKit
//
//  Created by 杨胜超 on 16/7/5.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import "PSKNetworkingAFN.h"
#import "AFNetworking.h"

@implementation PSKNetworkingAFN
- (NSURLSessionDataTask *)dataTaskWithUrl:(NSString *)url
                                  apiName:(NSString *)apiName
                             normalParams:(NSDictionary *)params
                         httpHeaderParams:(NSDictionary *)httpHeaderParams
                                imageData:(NSData *)imageData
                              requestType:(PSKRequestType)requestType
                        completionHandler:(void (^)(NSURLResponse *response, id responseObject,  NSError * error))completionHandler {
    //0. 格式化url和params
    url = [self _formatRequestUrl:url withApi:apiName];
    NSDictionary *formatedParams = [self _formatRequestParams:params withApi:apiName andUrl:url];
    
    //1. 组装manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain", @"audio/wav", nil];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    manager.requestSerializer.timeoutInterval = PSKConfigManagerInstance.defaultRequestTimeOut;
    [manager.requestSerializer setValue:[self _signatureParams:formatedParams] forHTTPHeaderField:@"signature"];
    [manager.requestSerializer setValue:[self _httpToken] forHTTPHeaderField:@"httpToken"];
    if (OBJECT_ISNOT_EMPTY(httpHeaderParams)) {
        for (NSString *key in [httpHeaderParams allKeys]) {
            NSString *value = httpHeaderParams[key];
            [manager.requestSerializer setValue:value forHTTPHeaderField:key];
        }
    }
    
    //2. 配置网络请求参数
    NSError *serializationError = nil;
    NSMutableURLRequest *mutableRequest = nil;
    if (PSKRequestTypeGET == requestType) {
        NSLog(@"getting data from url:\r%@?%@", url, [self _queryRequestParams:formatedParams]);
        mutableRequest = [manager.requestSerializer requestWithMethod:@"GET"
                                                            URLString:url
                                                           parameters:formatedParams
                                                                error:&serializationError];
    }
    else if (PSKRequestTypePOST == requestType) {
        NSLog(@"posting data to url:\r%@", url);
        mutableRequest = [manager.requestSerializer requestWithMethod:@"POST"
                                                            URLString:url
                                                           parameters:formatedParams
                                                                error:&serializationError];
    }
    else if (PSKRequestTypeUploadFile == requestType) {
        NSLog(@"uploading data to url:\r%@", url);
        mutableRequest = [manager.requestSerializer multipartFormRequestWithMethod:@"POST"
                                                                         URLString:url
                                                                        parameters:formatedParams
                                                         constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                             [formData appendPartWithFileData:imageData name:@"file" fileName:@"fileName" mimeType:@"application/octet-stream"];
                                                         }
                                                                             error:&serializationError];
    }
    else if (PSKRequestTypePostBodyData == requestType) {
        NSLog(@"posting bodydata to url:\r%@", url);
        NSString *bodyParam = [NSString psk_jsonStringWithObject:formatedParams];
        bodyParam = [self _encryptPostBodyParam:bodyParam];
        mutableRequest = [manager.requestSerializer requestWithMethod:@"POST"
                                                            URLString:url
                                                           parameters:nil
                                                                error:&serializationError];
        mutableRequest.HTTPBody = [bodyParam dataUsingEncoding:manager.requestSerializer.stringEncoding];
    }
    
    //3. 创建网络请求出错
    if ( ! serializationError && mutableRequest) {
        return [manager dataTaskWithRequest:mutableRequest completionHandler:completionHandler];
    }
    return nil;
}

#pragma mark - Private Methods
// 格式化请求的url地址
- (NSString *)_formatRequestUrl:(NSString *)url withApi:(NSString *)apiName {
    NSString *tempApiName = [@"/" stringByAppendingPathComponent:apiName];//组装完整的url地址
    return [url stringByAppendingString:tempApiName];
}
// 格式化请求参数
- (NSDictionary *)_formatRequestParams:(NSDictionary *)params
                               withApi:(NSString *)apiName
                                andUrl:(NSString *)url {
    NSMutableDictionary *newDictParam = [NSMutableDictionary dictionary];
    for (NSString *key in params.allKeys) {
        NSObject *value = params[key];
        NSString *newKey = TRIM_STRING(key);
        NSString *newValue = [NSString stringWithFormat:@"%@", OBJECT_IS_EMPTY(value) ? @"" : value];
        newDictParam[newKey] = TRIM_STRING(newValue);
    }
    NSLog(@"request params:\r%@", newDictParam);
    return newDictParam;
}
// 计算请求参数的签名
- (NSString *)_signatureParams:(NSDictionary *)params {
    return @"";
}
// 将请求参数拼接成url字符串
- (NSString *)_queryRequestParams:(NSDictionary *)params {
    return AFQueryStringFromParameters(params);
}
// 计算httpToken参数值
- (NSString *)_httpToken {
    return @"";
}
// 计算post body的参数值
- (NSString *)_encryptPostBodyParam:(NSString *)bodyParam {
    return bodyParam;
}
@end
