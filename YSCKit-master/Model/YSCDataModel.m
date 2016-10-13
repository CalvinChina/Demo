//
//  YSCDataModel.m
//  YSCKit
//
//  Created by yangshengchao on 16/1/26.
//  Copyright © 2016年 Builder. All rights reserved.
//

#import "YSCDataModel.h"
#import <MJExtension/MJExtension.h>

@implementation BaseDataModel
MJExtensionCodingImplementation
MJExtensionLogAllProperties
-(instancetype)copyWithZone:(NSZone *)zone {
    return [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self]];
}
+ (id)ObjectWithKeyValues:(id)keyValues {
    if ([keyValues isKindOfClass:[NSArray class]]) {
        return [self mj_objectArrayWithKeyValuesArray:keyValues];
    }
    else {
        return [self mj_objectWithKeyValues:keyValues];
    }
}
+ (void)GetByMethod:(NSString *)method params:(NSDictionary *)params block:(YSCResponseErrorMessageBlock)block {
    [self _RequestByMethod:method params:params requestType:RequestTypeGET block:block];
}
+ (void)PostByMethod:(NSString *)method params:(NSDictionary *)params block:(YSCResponseErrorMessageBlock)block {
    [self _RequestByMethod:method params:params requestType:RequestTypePOST block:block];
}
+ (void)RequestByMethod:(NSString *)method params:(NSDictionary *)params block:(YSCResponseErrorMessageBlock)block {
    [self _RequestByMethod:method params:params requestType:RequestTypePostBodyData block:block];
}
+ (void)_RequestByMethod:(NSString *)method params:(NSDictionary *)params requestType:(RequestType)requestType block:(YSCResponseErrorMessageBlock)block {
    [YSCRequestManager RequestWithAPI:method params:params dataModel:[self class] requestType:requestType requestSuccessed:^(id responseObject) {
        if (block) {
            block(responseObject, nil);
        }
    } requestFailure:^(ErrorType errorType, NSError *error) {
        NSString *errMsg = [YSCManager ResolveErrorType:errorType andError:error];
        if (block) {
            block(nil, errMsg);
        }
    }];
}
- (NSString *)toJSONString {
    return [self mj_JSONString];
}
@end


@implementation YSCPhotoBrowseCellModel
+ (instancetype)CreateModelByImageUrl:(NSString *)imageUrl image:(UIImage *)image {
    YSCPhotoBrowseCellModel *model = [YSCPhotoBrowseCellModel new];
    model.imageUrl = imageUrl;
    model.image = image;
    return model;
}
@end
