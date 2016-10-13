//
//  YSCRequestManager.h
//  YSCKit
//
//  Created by yangshengchao on 16/1/28.
//  Copyright © 2016年 Builder. All rights reserved.
//

/**
 *  网络访问类
 *  作用：控制所有网络请求相关的业务
 *       包括业务数据的获取
 *  TODO:上传文件、下载文件、网络访问需要解耦AFNetworking
 */


typedef void (^RequestSuccessed)(id responseObject);
typedef void (^RequestFailure)(ErrorType errorType, NSError *error);


//--------------------------------------
//  请求业务数据
//--------------------------------------
@interface YSCRequestManager : NSObject
// 常用方法
+ (void)RequestWithAPI:(NSString *)apiName
                params:(NSDictionary *)params
             dataModel:(Class)dataModel
           requestType:(RequestType)requestType
      requestSuccessed:(RequestSuccessed)requestSuccessed
        requestFailure:(RequestFailure)requestFailure;
+ (void)RequestFromUrl:(NSString *)url
               withAPI:(NSString *)apiName
                params:(NSDictionary *)params
             dataModel:(Class)dataModel
           requestType:(RequestType)requestType
      requestSuccessed:(RequestSuccessed)requestSuccessed
        requestFailure:(RequestFailure)requestFailure;

// 处理YSCBaseModel和BaseDataModel映射、登陆过期(state=99)
+ (void)RequestFromUrl:(NSString *)url
             withAPI:(NSString *)apiName
              params:(NSDictionary *)params
           dataModel:(Class)dataModel
           imageData:(NSData *)imageData
         requestType:(RequestType)requestType
    requestSuccessed:(RequestSuccessed)requestSuccessed
      requestFailure:(RequestFailure)requestFailure;

// 处理自定义模型的映射，将映射好的自定义模型往上层抛
+ (void)RequestFromUrl:(NSString *)url
              params:(NSDictionary *)params
         customModel:(Class)customModel
           imageData:(NSData *)imageData
         requestType:(RequestType)requestType
    requestSuccessed:(RequestSuccessed)requestSuccessed
      requestFailure:(RequestFailure)requestFailure;

// 通用的GET、POST和上传图片（返回最原始的未经过任何映射的JSON字符串）
+ (void)RequestFromUrl:(NSString *)url
              params:(NSDictionary *)params
           imageData:(NSData *)imageData
         requestType:(RequestType)requestType
    requestSuccessed:(RequestSuccessed)requestSuccessed
      requestFailure:(RequestFailure)requestFailure;
@end



//--------------------------------------
//  上传大文件
//--------------------------------------
@interface YSCRequestManager (Upload)
//TODO:
@end


//--------------------------------------
//  下载大文件
//--------------------------------------
@interface YSCRequestManager (Download)
//TODO:
@end