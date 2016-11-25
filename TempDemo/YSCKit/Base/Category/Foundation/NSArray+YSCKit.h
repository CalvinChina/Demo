//
//  NSArray+YSCKit.h
//  YSCKit
//
//  Created by yangshengchao on 15/2/13.
//  Copyright (c) 2015年 yangshengchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (YSCKit)

+ (BOOL)isEquals:(NSArray *)array1 with:(NSArray *)array2;
+ (NSArray *)commonArrayBetween:(NSArray *)array1 and:(NSArray *)array2;
+ (NSArray *)reverseArray:(NSArray *)array;

@end
