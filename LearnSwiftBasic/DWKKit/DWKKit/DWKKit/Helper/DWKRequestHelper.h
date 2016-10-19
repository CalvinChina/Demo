//
//  DWKRequestHelper.h
//  DWKKit
//
//  Created by pisen on 16/10/14.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DWKRequestInstance             [DWKRequestHelper sharedInstance]

typedef NS_ENUM(NSInteger ,DWKRequestType) {
    DWKRequestTypeGET = 0,
    DWKRequestTypePOST,
    DWKRequestTypePostBodyData,
    DWKRequestTypeUploadFile,
    DWKRequestTypeDownloadFile,
    DWKRequestTypeCustomResponse
};

typedef void(^DWKRequestSuccess)(id responseObject);
typedef void(^DWKRequestFailure)(NSString *DWKErrorType,NSError *error);


/**
 *  网络访问类
 *  作用：控制业务json数据的获取、模型映射、取消请求、
 *       上一次相同的请求未完成之前不能重复请求
 *  TODO:上传文件、下载文件、网络访问需要解耦AFNetworking
 */
@interface DWKRequestHelper : NSObject
@property (nonatomic ,strong) NSMutableDictionary * requestQueue;
/**httpHeader的参数signatue(请求参数的签名)的MD5加密密钥*/
@property (nonatomic ,copy) NSString * signatureSecretKey;
/**httpHeader的参数httpToken的DES加密密钥(为空则不加密)*/
@property (nonatomic ,copy) NSString * httpTokenSecretKey;

+ (instancetype)sharedInstance;
/**
 * 取消网络请求
 */
- (void)cacelRequestById:(NSString *)requestId;
- (void)cancleAllRequest;
/**
 * 解析错误信息
 */
- (NSString *)resolveDWKErrorType:(NSString *)errorType andError:(NSError *)error;
/**
 * 常用请求参数
 */
- (NSString *)requestWithApiName:(NSString *)apiName
                          params:(NSDictionary *)params
                       dataModel:(Class)dataModel
                            type:(DWKRequestType)type
                         success:(DWKRequestSuccess)success
                         failure:(DWKRequestFailure)failure;
- (NSString *)requestFromUrl:(NSString *)url
                 WithApiName:(NSString *)apiName
                      params:(NSDictionary *)params
                   dataModel:(Class)dataModel
                        type:(DWKRequestType)type
                     success:(DWKRequestSuccess)success
                     failure:(DWKRequestFailure)failure;

/**
 *  处理DWKBaseModel和DWKDataModel映射、登陆过期
 */
- (NSString *)requestFromUrl:(NSString *)url
                 WithApiName:(NSString *)apiName
                      params:(NSDictionary *)params
                   dataModel:(Class)dataModel
                   imageData:(NSData *)imageData
                        type:(DWKRequestType)type
                     success:(DWKRequestSuccess)success
                     failure:(DWKRequestFailure)failure;
/** 
 *处理自定义模型的映射，将映射好的自定义模型往上层抛
 *
 */
- (NSString *)requestFromUrl:(NSString *)url
                 WithApiName:(NSString *)apiName
                      params:(NSDictionary *)params
                   customModel:(Class)customModel
                   imageData:(NSData *)imageData
                        type:(DWKRequestType)type
                     success:(DWKRequestSuccess)success
                     failure:(DWKRequestFailure)failure;

/**
 *通用的GET、POST和上传图片（返回最原始的未经过任何映射的JSON字符串）
 *
 */
- (NSString *)requestFromUrl:(NSString *)url
                 WithApiName:(NSString *)apiName
                      params:(NSDictionary *)params
            httpHeaderParams:(NSDictionary *)httpHeaderParams
                   imageData:(NSData *)imageData
                        type:(DWKRequestType)type
                     success:(DWKRequestSuccess)success
                     failure:(DWKRequestFailure)failure;


@end
