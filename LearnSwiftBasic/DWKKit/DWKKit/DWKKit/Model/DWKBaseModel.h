//
//  DWKBaseModel.h
//  DWKKit
//
//  Created by pisen on 16/10/18.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DWKBaseModel : NSObject

@property (nonatomic ,assign) NSInteger state;
@property (nonatomic ,copy) NSString * message;
@property (nonatomic ,strong) NSObject * data;

+ (instancetype)objectWithKeyValues:(id)keyValues;
- (BOOL)checkRequestIsSuccess;
- (void)postNotificationWhenLoginExpired;

@end
