//
//  PSKDataBaseModel.m
//  PisenKit
//
//  Created by 杨胜超 on 16/7/1.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import "PSKDataBaseModel.h"
#import "MJExtension.h"

@implementation PSKDataBaseModel
MJExtensionCodingImplementation
MJExtensionLogAllProperties
- (instancetype)copyWithZone:(NSZone *)zone {
    return [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self]];
}
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
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{};
}
+ (NSDictionary *)mj_objectClassInArray {
    return @{};
}

+ (NSString *)getByApi:(NSString *)apiName params:(NSDictionary *)params block:(PSKObjectErrorMessageBlock)block {
    return [self _requestByApi:apiName params:params requestType:PSKRequestTypeGET block:block];
}
+ (NSString *)postByApi:(NSString *)apiName params:(NSDictionary *)params block:(PSKObjectErrorMessageBlock)block {
    return [self _requestByApi:apiName params:params requestType:PSKRequestTypePOST block:block];
}
+ (NSString *)requestByApi:(NSString *)apiName params:(NSDictionary *)params block:(PSKObjectErrorMessageBlock)block {
    return [self _requestByApi:apiName params:params requestType:PSKRequestTypePostBodyData block:block];
}
+ (NSString *)_requestByApi:(NSString *)apiName
                     params:(NSDictionary *)params
                requestType:(PSKRequestType)requestType
                      block:(PSKObjectErrorMessageBlock)block {
    return [PSKRequestManagerInstance requestWithApi:apiName params:params dataModel:[self class] type:requestType success:^(id responseObject) {
        if (block) {
            block(responseObject, nil);
        }
    } failed:^(NSString *PSKErrorType, NSError *error) {
        NSString *errMsg = [PSKRequestManagerInstance resolvePSKErrorType:PSKErrorType andError:error];
        if (block) {
            block(nil, errMsg);
        }
    }];
}
@end

