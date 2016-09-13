//
//  NSArray+PisenKit.h
//  PisenKit
//
//  Created by 杨胜超 on 16/6/30.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import <Foundation/Foundation.h>


//==============================================================================
//
//  常用方法
//
//==============================================================================
@interface NSArray (PisenKit)
/**
 *  判断两个数组是否具有相同的元素
 *  只能针对基本类型的元素，Object类型的元素不支持比较！
 *
 *  @param array1
 *  @param array2
 *
 *  @return 相同-YES  不同-NO
 */
+ (BOOL)psk_isEquals:(NSArray *)array1 with:(NSArray *)array2;
/**
 *  过滤出两个数组相同的元素集合
 *
 *  @param array1
 *  @param array2
 *
 *  @return 两个数组元素相同的新数组
 */
+ (NSArray *)psk_intersectionArrayBetween:(NSArray *)array1 and:(NSArray *)array2;
/**
 *  反转数组顺序
 *
 *  @param array
 *
 *  @return 反转后的数组
 * ============================================
 *
 * 方法一: for (NSInteger i = [array count] - 1; i >= 0; i--)
 * 方法二: [array enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:
 * 方法三: NSArray *resultArray = [[array reverseObjectEnumerator] allObjects];
 *
 * 测试结果：50万条记录耗时
 *  0.071s 4%STDEV
 *  0.041s 8%STDEV
 *  0.025s 7%STDEV
 * 测试结果：500万条记录耗时
 *  0.568s 3%STDEV
 *  0.398s 4%STDEV
 *  0.260s 7%STDEV
 */
+ (NSArray *)psk_reverseArray:(NSArray *)array;
@end
