//
//  DWKBaseModel.m
//  DWKKit
//
//  Created by pisen on 16/10/18.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

#import "DWKBaseModel.h"
#import "MJExtension.h"

@implementation DWKBaseModel
MJExtensionLogAllProperties
+ (instancetype)objectWithKeyValues:(id)keyValues{
    return [self mj_objectWithKeyValues:keyValues];
}

- (BOOL)checkRequestIsSuccess{
    return self.state == 1;
}

- (void)postNotificationWhenLoginExpired{
    if (99 == self.state) {
        NSDictionary * param = @{kParamUserId:USER_ID,kParamMessage:TRIM_STRING(self.message)};
        POST_NOTIFICATION_WITH_INFO(kNotificationLoginExpired, param);
    }
}

@end
