//
//  NSDictionary+PisenKit.m
//  PisenKit
//
//  Created by 杨胜超 on 16/7/5.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import "NSDictionary+PisenKit.h"


//==============================================================================
//
//  常用方法
//
//==============================================================================
@implementation NSDictionary (PisenKit)

- (NSString *)psk_sortedKeyAndJoinedString {
    NSArray *keys = [[self allKeys] sortedArrayUsingSelector:@selector(compare:)];
    NSMutableArray *joinedArray = [NSMutableArray array];
    for (NSString *key in keys) {
        NSString *joinedString = [NSString stringWithFormat:@"%@=%@", key, self[key]];
        [joinedArray addObject:joinedString];
    }
    return [joinedArray componentsJoinedByString:@"&"];
}

+ (NSString *)psk_sortedKeyAndJoinedStringByDictionary:(NSDictionary *)dictionary {
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(dictionary);
    return [dictionary psk_sortedKeyAndJoinedString];
}

@end
