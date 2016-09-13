//
//  UIControl+PisenKit.m
//  PisenKit
//
//  Created by 杨胜超 on 16/6/30.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import "UIControl+PisenKit.h"
#import <objc/runtime.h>

@interface _PSKUIControlBlockTarget : NSObject
@property (nonatomic, copy) void (^block)(id sender);
@property (nonatomic, assign) UIControlEvents events;
- (id)initWithBlock:(void (^)(id sender))block events:(UIControlEvents)events;
- (void)invoke:(id)sender;
@end
@implementation _PSKUIControlBlockTarget
- (id)initWithBlock:(void (^)(id sender))block events:(UIControlEvents)events {
    self = [super init];
    if (self) {
        _block = block;
        _events = events;
    }
    return self;
}
- (void)invoke:(id)sender {
    if (self.block) {
        self.block(sender);
    }
}
@end


//==============================================================================
//
//  封装事件的添加
//
//==============================================================================
@implementation UIControl (PisenKit)
- (void)psk_addTouchUpInsideEventBlock:(void (^)(id sender))block {
    [self psk_addBlock:block forControlEvents:UIControlEventTouchUpInside];
}
- (void)psk_addBlock:(void (^)(id sender))block forControlEvents:(UIControlEvents)controlEvents {
    if (!controlEvents) return;
    _PSKUIControlBlockTarget *target = [[_PSKUIControlBlockTarget alloc]
                                        initWithBlock:block events:controlEvents];
    [self addTarget:target action:@selector(invoke:) forControlEvents:controlEvents];
    NSMutableArray *targets = [self _psk_allUIControlBlockTargets];
    [targets addObject:target];
}

- (void)psk_reAddTouchUpInsideEventBlock:(void (^)(id sender))block {
    [self psk_reAddBlock:block forControlEvents:UIControlEventTouchUpInside];
}
- (void)psk_reAddBlock:(void (^)(id sender))block forControlEvents:(UIControlEvents)controlEvents {
    [self psk_removeAllBlocksForControlEvents:controlEvents];
    [self psk_addBlock:block forControlEvents:controlEvents];
}

- (void)psk_removeAllBlocksForControlEvents:(UIControlEvents)controlEvents {
    if (!controlEvents) return;
    
    NSMutableArray *targets = [self _psk_allUIControlBlockTargets];
    NSMutableArray *removes = [NSMutableArray array];
    for (_PSKUIControlBlockTarget *target in targets) {
        if (target.events & controlEvents) {
            UIControlEvents newEvent = target.events & (~controlEvents);
            if (newEvent) {
                [self removeTarget:target action:@selector(invoke:) forControlEvents:target.events];
                target.events = newEvent;
                [self addTarget:target action:@selector(invoke:) forControlEvents:target.events];
            }
            else {
                [self removeTarget:target action:@selector(invoke:) forControlEvents:target.events];
                [removes addObject:target];
            }
        }
    }
    [targets removeObjectsInArray:removes];
}
- (NSMutableArray *)_psk_allUIControlBlockTargets {
    NSMutableArray *targets = objc_getAssociatedObject(self, _cmd);
    if (!targets) {
        targets = [NSMutableArray array];
        objc_setAssociatedObject(self, _cmd, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return targets;
}
@end
