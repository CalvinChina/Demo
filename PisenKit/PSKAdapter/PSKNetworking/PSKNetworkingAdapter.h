//
//  PSKNetworkingAdapter.h
//  PisenKit
//
//  Created by 杨胜超 on 16/7/5.
//  Copyright © 2016年 Pisen. All rights reserved.
//

// 定义网络请求方式
typedef NS_ENUM (NSInteger, PSKRequestType) {
    PSKRequestTypeGET = 0,          // default
    PSKRequestTypePOST,
    PSKRequestTypePostBodyData,
    PSKRequestTypeUploadFile,
    PSKRequestTypeCustomResponse    // 数据源不是PSKRequestManager
};

/**
 *  网络请求库必须实现的协议
 */
@protocol PSKNetworkingAdapterDelegate <NSObject>
@required
- (NSURLSessionDataTask *)dataTaskWithUrl:(NSString *)url
                                  apiName:(NSString *)apiName
                             normalParams:(NSDictionary *)params
                         httpHeaderParams:(NSDictionary *)httpHeaderParams
                                imageData:(NSData *)imageData
                              requestType:(PSKRequestType)requestType
                        completionHandler:(void (^)(NSURLResponse *response, id responseObject,  NSError * error))completionHandler;
@end


/**
 *  统一适配网络请求，屏蔽第三方细节
 */
@interface PSKNetworkingAdapter : NSObject

@property (strong, nonatomic) id<PSKNetworkingAdapterDelegate> delegate;
+ (instancetype)adapter;

@end
