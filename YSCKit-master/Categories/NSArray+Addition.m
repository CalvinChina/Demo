//
//  NSArray+Addition.m
//  YSCKit
//
//  Created by yangshengchao on 15/2/13.
//  Copyright (c) 2015年 yangshengchao. All rights reserved.
//

#import "NSArray+Addition.h"

@implementation NSArray (Addition)

+ (BOOL)isEquals:(NSArray *)array1 withArray:(NSArray *)array2 {
    ReturnNOWhenObjectIsEmpty(array1);
    ReturnNOWhenObjectIsEmpty(array2);
    NSArray *tempArray1 = [array1 sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if (((NSNumber *)obj1).integerValue < ((NSNumber *)obj2).integerValue) {
            return NSOrderedAscending;
        }
        return NSOrderedDescending;
    }];
    NSArray *tempArray2 = [array2 sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if (((NSNumber *)obj1).integerValue < ((NSNumber *)obj2).integerValue) {
            return NSOrderedAscending;
        }
        return NSOrderedDescending;
    }];
    return [tempArray1 isEqualToArray:tempArray2];
}

+ (NSArray *)commonArrayBetween:(NSArray *)array1 withArray:(NSArray *)array2 {
    ReturnNilWhenObjectIsEmpty(array1);
    ReturnNilWhenObjectIsEmpty(array2);
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSObject *obj1 in array1) {
        if ([array2 containsObject:obj1] && ! [resultArray containsObject:obj1]) {
            [resultArray addObject:obj1];
        }
    }
    return resultArray;
}
@end
