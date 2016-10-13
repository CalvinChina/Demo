
//  BaseModel.m
//  YSCKit
//
//  Created by  YangHangbin on 14-3-3.
//  Copyright (c) 2014年 yangshengchao. All rights reserved.
//

#import "YSCBaseModel.h"
#import <MJExtension/MJExtension.h>//TODO:模型映射工具需要解耦

@implementation YSCBaseModel

+ (instancetype)ObjectWithKeyValues:(id)keyValues {
    return [self mj_objectWithKeyValues:keyValues];
}
- (BOOL)isSuccess {
    return 1 == self.state;
}
- (BOOL)isLoginExpired {
    return 99 == self.state;
}

@end


