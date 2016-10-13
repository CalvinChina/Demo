//
//  NSArray+DWKKit.m
//  DWKKit
//
//  Created by pisen on 16/10/12.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

#import "NSArray+DWKKit.h"


@implementation NSArray (DWKKit)

+ (BOOL) isEquals:(NSArray *)array1 with:(NSArray *)array2{
    RETURN_NO_WHEN_OBJECT_IS_EMPTY(array1);
    RETURN_NO_WHEN_OBJECT_IS_EMPTY(array2);
    
    NSArray * tempArray1 = [array1 sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if (((NSNumber * )obj1).integerValue < ((NSNumber *)obj2).integerValue){
            return  NSOrderedAscending;
        }
        return NSOrderedDescending;
    }];
    
    NSArray * tempArray2 = [array2 sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if (((NSNumber * )obj1).integerValue < ((NSNumber *)obj2).integerValue){
            return  NSOrderedAscending;
        }
        return NSOrderedDescending;
    }];
    
    return  [tempArray1 isEqualToArray:tempArray2];
}

+ (NSArray *)commonArrayBetween:(NSArray *)array1 and:(NSArray *)array2{
    RETURN_NIL_WHEN_OBJECT_IS_EMPTY(array1);
    RETURN_NIL_WHEN_OBJECT_IS_EMPTY(array2);
    NSMutableArray * resultArray = [NSMutableArray array];
    for (NSObject * obj1 in array1) {
        if ([array2 containsObject:obj1] && ![resultArray containsObject:obj1]) {
            [resultArray addObject:obj1];
        }
    }
    return resultArray;
}

//NSMutableArray *array = [[NSMutableArray alloc]initWithObjects:@"item0",@"item1",@"item2",@"item3",nil];
////逆向遍历
//NSEnumerator *enumerator = [array reverseObjectEnumerator];
//array = (NSMutableArray*)[enumerator allObjects];

/**
 * 测试结果：526条记录
 * 方法一: for (id element in [array reverseObjectEnumerator])                 0.6ms 左右
 * 方法二: [array enumerateObjectsWithOptions:NSEnumerationReverse usingBlock: 0.6ms 左右
 * 方法三: NSArray *tempArray = [[array reverseObjectEnumerator] allObjects];  0.5-2.8ms
 */

+ (NSArray *)reverseArray:(NSArray *)array{
    RETURN_NIL_WHEN_OBJECT_IS_EMPTY(array);
    NSMutableArray * retArray = [NSMutableArray array];
    [array enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [retArray addObject:obj];
    }];
    
    

    return retArray;
}


@end
