//
//  DWKDataModel.m
//  DWKKit
//
//  Created by pisen on 16/10/18.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

#import "DWKDataModel.h"
#import "MJExtension.h"

@implementation DWKDataModel
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
+ (NSString *)getByApi:(NSString *)apiName params:(NSDictionary *)params block:(DWKObjectErrorMessageBlock)block {
    return [self _requestByApi:apiName params:params requestType:DWKRequestTypeGET block:block];
}
+ (NSString *)postByApi:(NSString *)apiName params:(NSDictionary *)params block:(DWKObjectErrorMessageBlock)block {
    return [self _requestByApi:apiName params:params requestType:DWKRequestTypePOST block:block];
}
// 统一规范参数的提交方式：加密的json字符串写入httpBody
+ (NSString *)requestByApi:(NSString *)apiName params:(NSDictionary *)params block:(DWKObjectErrorMessageBlock)block {
    return [self _requestByApi:apiName params:params requestType:DWKRequestTypePostBodyData block:block];
}

+ (NSString *)_requestByApi:(NSString *)apiName
                     params:(NSDictionary *)params
                requestType:(DWKRequestType)requestType
                      block:(DWKObjectErrorMessageBlock)block {
    
    
    return [DWKRequestInstance requestWithApiName:apiName params:params dataModel:[self class] type:requestType success:^(id responseObject) {
        if (block) {
            block(responseObject, nil);
        }
    } failure:^(NSString *DWKErrorType, NSError *error) {
        
        NSString *errMsg = [DWKRequestInstance resolveDWKErrorType:DWKErrorType andError:error];
        if (block) {
            block(nil, errMsg);
        }
    }];
}


@end
