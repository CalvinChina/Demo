//
//  NSObject+common.m
//  KanPian
//
//  Created by Pisen on 16/6/22.
//  Copyright © 2016年 SMIT. All rights reserved.
//

#import "NSObject+common.h"

@implementation NSObject (common)

- (BOOL)isKindOfClassFromName:(NSString *)name {
    Class class = NSClassFromString(name);
    if (class && [self isKindOfClass:class]) {
        return YES;
    }
    return NO;
}

@end
