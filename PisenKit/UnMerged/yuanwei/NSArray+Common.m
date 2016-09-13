//
//  NSArray+Common.m
//  KanPian
//
//  Created by Pisen on 16/4/8.
//  Copyright © 2016年 SMIT. All rights reserved.
//

#import "NSArray+Common.h"

@implementation NSArray (Common)

- (id)objectAtIndexWithCheck:(NSUInteger)index
{
    if (index < self.count) {
        id obj = [self objectAtIndex:index];
        if (obj != [NSNull null]) {
            return obj;
        }
    }
    return nil;
}

@end
