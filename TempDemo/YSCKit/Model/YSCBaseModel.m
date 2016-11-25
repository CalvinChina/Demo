//
//  BaseModel.m
//  YSCKit
//
//  Created by  YangHangbin on 14-3-3.
//  Copyright (c) 2014年 yangshengchao. All rights reserved.
//

#import "YSCBaseModel.h"
#import "MJExtension.h"//TODO:模型映射工具需要解耦

@implementation YSCBaseModel
MJExtensionLogAllProperties
+ (instancetype)objectWithKeyValues:(id)keyValues {
    return [self mj_objectWithKeyValues:keyValues];
}
- (BOOL)checkRequestIsSuccess {
    return 1 == self.state;
}
- (void)postNotificationWhenLoginExpired {
    if (99 == self.state) {
        NSDictionary *param = @{kParamUserId : USER_ID, kParamMessage : TRIM_STRING(self.message)};
        POST_NOTIFICATION_WITH_INFO(kNotificationLoginExpired, param);
    }
}
@end

