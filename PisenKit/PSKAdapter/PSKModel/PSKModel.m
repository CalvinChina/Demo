//
//  PSKModel.m
//  PisenKit
//
//  Created by 杨胜超 on 16/7/1.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import "PSKModel.h"
#import "MJExtension.h"

@implementation PSKModel
MJExtensionLogAllProperties
+ (instancetype)objectWithKeyValues:(id)keyValues {
    return [self mj_objectWithKeyValues:keyValues];
}
- (BOOL)checkRequestIsSuccess {
    return 1 == self.state;
}
@end
