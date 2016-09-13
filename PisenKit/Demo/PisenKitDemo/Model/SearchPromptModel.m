//
//  SearchPromptModel.m
//  PisenKitDemo
//
//  Created by 杨胜超 on 16/7/14.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import "SearchPromptModel.h"

@implementation SearchPromptModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"promptId" : @"Id",
             @"promptName" : @"Name",
             @"promptType" : @"Type"};
}
@end
