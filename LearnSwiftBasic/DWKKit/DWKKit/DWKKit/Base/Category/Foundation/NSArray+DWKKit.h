//
//  NSArray+DWKKit.h
//  DWKKit
//
//  Created by pisen on 16/10/12.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (DWKKit)
/**
 * 判断数组是否相同
 */
+ (BOOL)isEquals:(NSArray *) array1 with:(NSArray *)array2;
/**
 *  交集
 *@return 数组相同元素数组
 */
+ (NSArray *)commonArrayBetween:(NSArray *)array1 and:(NSArray *)array2;
/**
 * 数组倒序
 */
+ (NSArray *)reverseArray:(NSArray *)array;

@end
