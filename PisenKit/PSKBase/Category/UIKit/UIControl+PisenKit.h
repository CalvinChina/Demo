//
//  UIControl+PisenKit.h
//  PisenKit
//
//  Created by 杨胜超 on 16/6/30.
//  Copyright © 2016年 Pisen. All rights reserved.
//


//==============================================================================
//
//  封装事件的添加
//
//==============================================================================
@interface UIControl (PisenKit)
// add event
- (void)psk_addTouchUpInsideEventBlock:(void (^)(id sender))block;
- (void)psk_addBlock:(void (^)(id sender))block forControlEvents:(UIControlEvents)controlEvents;
//  first remove then add
- (void)psk_reAddTouchUpInsideEventBlock:(void (^)(id sender))block;
- (void)psk_reAddBlock:(void (^)(id sender))block forControlEvents:(UIControlEvents)controlEvents;
// remove event
- (void)psk_removeAllBlocksForControlEvents:(UIControlEvents)controlEvents;
@end
