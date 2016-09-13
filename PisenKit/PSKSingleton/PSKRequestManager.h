//
//  PSKRequestManager.h
//  PisenKit
//
//  Created by 杨胜超 on 16/7/1.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import "PSKNetworkingAdapter.h"

#define PSKRequestManagerInstance       [PSKRequestManager sharedInstance]
#ifndef kPathAppBaseUrl
    #define kPathAppBaseUrl             @""//定义默认值，需要在具体项目中重新define
#endif

typedef void (^PSKRequestSuccess)(id responseObject);
typedef void (^PSKRequestFailed)(NSString *PSKErrorType, NSError *error);


/**
 *  网络访问类
 *  功能：json数据的获取、模型映射、取消请求、解析错误信息
 */
@interface PSKRequestManager : NSObject
@property (nonatomic, strong) NSMutableDictionary *requestQueue;

+ (instancetype)sharedInstance;
/** 取消单个网络请求 */
- (void)cancelRequestById:(NSString *)requestId;
/** 取消所有网络请求 */
- (void)cancelAllRequests;

/** 解析错误信息 */
- (NSString *)resolvePSKErrorType:(NSString *)errorType andError:(NSError *)error;

/** 常用网络请求方法 */
- (NSString *)requestWithApi:(NSString *)apiName
                      params:(NSDictionary *)params
                   dataModel:(Class)dataModel
                        type:(PSKRequestType)type
                     success:(PSKRequestSuccess)success
                      failed:(PSKRequestFailed)failed;
- (NSString *)requestFromUrl:(NSString *)url
                     withApi:(NSString *)apiName
                      params:(NSDictionary *)params
                   dataModel:(Class)dataModel
                        type:(PSKRequestType)type
                     success:(PSKRequestSuccess)success
                      failed:(PSKRequestFailed)failed;

/** 处理PSKModel和PSKDataBaseModel映射 */
- (NSString *)requestFromUrl:(NSString *)url
                     withApi:(NSString *)apiName
                      params:(NSDictionary *)params
                   dataModel:(Class)dataModel
                   imageData:(NSData *)imageData
                        type:(PSKRequestType)type
                     success:(PSKRequestSuccess)success
                      failed:(PSKRequestFailed)failed;

/** 处理自定义模型的映射，将映射好的自定义模型往上层抛 */
- (NSString *)requestFromUrl:(NSString *)url
                     withApi:(NSString *)apiName
                      params:(NSDictionary *)params
                 customModel:(Class)customModel
                   imageData:(NSData *)imageData
                        type:(PSKRequestType)type
                     success:(PSKRequestSuccess)success
                      failed:(PSKRequestFailed)failed;

/** 通用的GET、POST和上传（返回最原始的未经过任何映射的JSON字符串） */
- (NSString *)requestFromUrl:(NSString *)url
                     withApi:(NSString *)apiName
                      params:(NSDictionary *)params
            httpHeaderParams:(NSDictionary *)httpHeaderParams
                   imageData:(NSData *)imageData
                        type:(PSKRequestType)type
                     success:(PSKRequestSuccess)success
                      failed:(PSKRequestFailed)failed;


@end
