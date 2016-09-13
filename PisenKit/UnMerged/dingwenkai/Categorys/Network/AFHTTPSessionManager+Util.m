//
//  AFHTTPSessionManager+Util.m
//  CalvinUtils
//
//  Created by pisen on 16/2/4.
//  Copyright © 2016年 Calvin. All rights reserved.
//

#import "AFHTTPSessionManager+Util.h"

@implementation AFHTTPSessionManager (Util)

+ (instancetype)Manager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:@[@"text/html", @"text/plain", @"text/xml", @"application/json"]];
    return manager;
}

- (void)getWithURL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(id responseObject))success
           failure:(void (^)(NSError * error))failure {
    [self GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {success(responseObject);}
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {failure(error);}
    }];
}

- (void)postWithURL:(NSString *)url parameters:(NSDictionary *)parameters constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block success:(void (^)(id responseObject))success
            failure:(void (^)(NSError * error))failure {
    [self POST:url parameters:parameters constructingBodyWithBlock:block progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {success(responseObject);}
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {failure(error);}
    }];
}

@end
