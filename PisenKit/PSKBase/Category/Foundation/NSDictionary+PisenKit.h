//
//  NSDictionary+PisenKit.h
//  PisenKit
//
//  Created by 杨胜超 on 16/7/5.
//  Copyright © 2016年 Pisen. All rights reserved.
//


//==============================================================================
//
//  常用方法
//
//==============================================================================
@interface NSDictionary (PisenKit)

/**
 *  返回格式：key1=value1&key2=value2...
 */
- (NSString *)psk_sortedKeyAndJoinedString;
+ (NSString *)psk_sortedKeyAndJoinedStringByDictionary:(NSDictionary *)dictionary;

@end
