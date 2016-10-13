//
//  NSArray+Addition.h
//  YSCKit
//
//  Created by yangshengchao on 15/2/13.
//  Copyright (c) 2015年 yangshengchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Addition)

+ (BOOL)isEquals:(NSArray *)array1 withArray:(NSArray *)array2;
+ (NSArray *)commonArrayBetween:(NSArray *)array1 withArray:(NSArray *)array2;

@end
