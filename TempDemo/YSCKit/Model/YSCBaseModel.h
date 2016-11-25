//
//  BaseModel.h
//  YSCKit
//
//  Created by  YangHangbin on 14-3-3.
//  Copyright (c) 2014年 yangshengchao. All rights reserved.
//  FORMATED!
//

@interface YSCBaseModel : NSObject
@property (assign, nonatomic) NSInteger state;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSObject *data;

+ (instancetype)objectWithKeyValues:(id)keyValues;
- (BOOL)checkRequestIsSuccess;
- (void)postNotificationWhenLoginExpired;
@end
