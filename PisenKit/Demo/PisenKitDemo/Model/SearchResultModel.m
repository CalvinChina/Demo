//
//  SearchResultModel.m
//  PisenKitDemo
//
//  Created by 杨胜超 on 16/7/14.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import "SearchResultModel.h"

@implementation SearchResultModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"programId" : @"ParentId",
             @"programType" : @"Type"};
}
@end
@implementation SearchResultListModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"movieList" : @"SearchResultModel"};
}
@end