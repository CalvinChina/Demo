//
//  YSCDataModel.m
//  YSCKit
//
//  Created by yangshengchao on 16/1/26.
//  Copyright © 2016年 Builder. All rights reserved.
//

#import "YSCDataModel.h"
#import "MJExtension.h"

@implementation YSCDataModel
MJExtensionCodingImplementation
MJExtensionLogAllProperties
- (instancetype)copyWithZone:(NSZone *)zone {
    return [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self]];
}

// 处理与json对象之间的转换
+ (id)objectWithKeyValues:(id)keyValues {
    if ([keyValues isKindOfClass:[NSArray class]]) {
        return [self mj_objectArrayWithKeyValuesArray:keyValues];
    }
    else {
        return [self mj_objectWithKeyValues:keyValues];
    }
}
- (NSString *)toJSONString {
    return [self mj_JSONString];
}

// 接口访问方法
+ (NSString *)getByApi:(NSString *)apiName params:(NSDictionary *)params block:(YSCObjectErrorMessageBlock)block {
    return [self _requestByApi:apiName params:params requestType:YSCRequestTypeGET block:block];
}
+ (NSString *)postByApi:(NSString *)apiName params:(NSDictionary *)params block:(YSCObjectErrorMessageBlock)block {
    return [self _requestByApi:apiName params:params requestType:YSCRequestTypePOST block:block];
}
// 统一规范参数的提交方式：加密的json字符串写入httpBody
+ (NSString *)requestByApi:(NSString *)apiName params:(NSDictionary *)params block:(YSCObjectErrorMessageBlock)block {
    return [self _requestByApi:apiName params:params requestType:YSCRequestTypePostBodyData block:block];
}

+ (NSString *)_requestByApi:(NSString *)apiName
                     params:(NSDictionary *)params
                requestType:(YSCRequestType)requestType
                      block:(YSCObjectErrorMessageBlock)block {
    return [YSCRequestInstance requestWithApi:apiName params:params dataModel:[self class] type:requestType success:^(id responseObject) {
        if (block) {
            block(responseObject, nil);
        }
    } failed:^(NSString *YSCErrorType, NSError *error) {
        NSString *errMsg = [YSCRequestInstance resolveYSCErrorType:YSCErrorType andError:error];
        if (block) {
            block(nil, errMsg);
        }
    }];
}
@end
