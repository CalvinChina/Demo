//
//  UIControl+YSCKit.h
//  YSCKit
//
//  Created by 杨胜超 on 16/3/30.
//  Copyright © 2016年 SMIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIControl (YSCKit)
// event
- (void)addBlock:(void (^)(id sender))block forControlEvents:(UIControlEvents)controlEvents;
- (void)addTouchUpInsideEventBlock:(void (^)(id sender))block;
//  remove first then add
- (void)reAddBlock:(void (^)(id sender))block forControlEvents:(UIControlEvents)controlEvents;
- (void)reAddTouchUpInsideEventBlock:(void (^)(id sender))block;
// remove
- (void)removeAllBlocksForControlEvents:(UIControlEvents)controlEvents;
@end
