//
//  PSKModel.h
//  PisenKit
//
//  Created by 杨胜超 on 16/7/1.
//  Copyright © 2016年 Pisen. All rights reserved.
//


//------------------------------------------------
//
//  最外层的JSON对象
//  功能：判断返回状态
//
//------------------------------------------------
@interface PSKModel : NSObject
@property (assign, nonatomic) NSInteger state;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSObject *data;

/** json -> model */
+ (instancetype)objectWithKeyValues:(id)keyValues;
/** 根据错误码判断返回的数据是否成功 */
- (BOOL)checkRequestIsSuccess;
@end
