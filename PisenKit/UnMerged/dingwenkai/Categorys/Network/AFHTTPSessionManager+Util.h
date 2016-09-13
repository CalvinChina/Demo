//
//  AFHTTPSessionManager+Util.h
//  CalvinUtils
//
//  Created by pisen on 16/2/4.
//  Copyright © 2016年 Calvin. All rights reserved.
//

#import "AFNetworking.h"

#import <UIKit/UIKit.h>

@interface AFHTTPSessionManager (Util)

+ (instancetype)Manager;

- (void)getWithURL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(id responseObject))success
           failure:(void (^)(NSError * error))failure;

- (void)postWithURL:(NSString *)url parameters:(NSDictionary *)parameters constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block success:(void (^)(id responseObject))success
            failure:(void (^)(NSError * error))failure;

@end
