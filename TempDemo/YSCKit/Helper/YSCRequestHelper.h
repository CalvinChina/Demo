//
//  YSCRequestHelper.h
//  KanPian
//
//  Created by 杨胜超 on 16/3/26.
//  Copyright © 2016年 SMIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#define YSCRequestInstance              [YSCRequestHelper sharedInstance]


// 网络请求方式
typedef NS_ENUM (NSInteger, YSCRequestType) {
    YSCRequestTypeGET = 0,
    YSCRequestTypePOST,
    YSCRequestTypePostBodyData,
    YSCRequestTypeUploadFile,
    YSCRequestTypeDownloadFile,
    YSCRequestTypeCustomResponse       //数据来源不是YSCRequestHelper
};

typedef void (^YSCRequestSuccess)(id responseObject);
typedef void (^YSCRequestFailed)(NSString *YSCErrorType, NSError *error);


/**
 *  网络访问类
 *  作用：控制业务json数据的获取、模型映射、取消请求、
 *       上一次相同的请求未完成之前不能重复请求
 *  TODO:上传文件、下载文件、网络访问需要解耦AFNetworking
 */
@interface YSCRequestHelper : NSObject
@property (nonatomic, strong) NSMutableDictionary *requestQueue;
// httpHeader的参数signatue(请求参数的签名)的MD5加密密钥
@property (nonatomic, strong) NSString *signatureSecretKey;
// httpHeader的参数httpToken的DES加密密钥(为空则不加密)
@property (nonatomic, strong) NSString *httpTokenSecretKey;

+ (instancetype)sharedInstance;
// 取消网络请求
- (void)cancelRequestById:(NSString *)requestId;
- (void)cancelAllRequests;
// 解析错误信息
- (NSString *)resolveYSCErrorType:(NSString *)errorType andError:(NSError *)error;

// 常用网络请求方法
- (NSString *)requestWithApi:(NSString *)apiName
                      params:(NSDictionary *)params
                   dataModel:(Class)dataModel
                        type:(YSCRequestType)type
                     success:(YSCRequestSuccess)success
                      failed:(YSCRequestFailed)failed;
- (NSString *)requestFromUrl:(NSString *)url
                     withApi:(NSString *)apiName
                      params:(NSDictionary *)params
                   dataModel:(Class)dataModel
                        type:(YSCRequestType)type
                     success:(YSCRequestSuccess)success
                      failed:(YSCRequestFailed)failed;

// 处理YSCBaseModel和YSCDataModel映射、登陆过期
- (NSString *)requestFromUrl:(NSString *)url
                     withApi:(NSString *)apiName
                      params:(NSDictionary *)params
                   dataModel:(Class)dataModel
                   imageData:(NSData *)imageData
                        type:(YSCRequestType)type
                     success:(YSCRequestSuccess)success
                      failed:(YSCRequestFailed)failed;

// 处理自定义模型的映射，将映射好的自定义模型往上层抛
- (NSString *)requestFromUrl:(NSString *)url
                     withApi:(NSString *)apiName
                      params:(NSDictionary *)params
                 customModel:(Class)customModel
                   imageData:(NSData *)imageData
                        type:(YSCRequestType)type
                     success:(YSCRequestSuccess)success
                      failed:(YSCRequestFailed)failed;

// 通用的GET、POST和上传图片（返回最原始的未经过任何映射的JSON字符串）
- (NSString *)requestFromUrl:(NSString *)url
                     withApi:(NSString *)apiName
                      params:(NSDictionary *)params
            httpHeaderParams:(NSDictionary *)httpHeaderParams
                   imageData:(NSData *)imageData
                        type:(YSCRequestType)type
                     success:(YSCRequestSuccess)success
                      failed:(YSCRequestFailed)failed;

@end


