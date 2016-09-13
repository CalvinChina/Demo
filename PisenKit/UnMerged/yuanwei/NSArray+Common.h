//
//  NSArray+Common.h
//  KanPian
//
//  Created by Pisen on 16/4/8.
//  Copyright © 2016年 SMIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Common)

/**
 *  检查数组是否越界
 */
- (id)objectAtIndexWithCheck:(NSUInteger)index;

@end
