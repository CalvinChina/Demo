//
//  UIControl+YSCKit.m
//  YSCKit
//
//  Created by 杨胜超 on 16/3/30.
//  Copyright © 2016年 SMIT. All rights reserved.
//

#import "UIControl+YSCKit.h"
#import <objc/runtime.h>

YYSYNTH_DUMMY_CLASS(UIControl_YSCKit)

static const int block_key;
@interface _YYUIControlBlockTarget : NSObject
@property (nonatomic, copy) void (^block)(id sender);
@property (nonatomic, assign) UIControlEvents events;
- (id)initWithBlock:(void (^)(id sender))block events:(UIControlEvents)events;
- (void)invoke:(id)sender;
@end

@implementation _YYUIControlBlockTarget
- (id)initWithBlock:(void (^)(id sender))block events:(UIControlEvents)events {
    self = [super init];
    if (self) {
        _block = [block copy];
        _events = events;
    }
    return self;
}
- (void)invoke:(id)sender {
    if (_block) _block(sender);
}
@end


@implementation UIControl (YSCKit)
- (void)addBlock:(void (^)(id sender))block forControlEvents:(UIControlEvents)controlEvents {
    if (!controlEvents) return;
    _YYUIControlBlockTarget *target = [[_YYUIControlBlockTarget alloc]
                                       initWithBlock:block events:controlEvents];
    [self addTarget:target action:@selector(invoke:) forControlEvents:controlEvents];
    NSMutableArray *targets = [self _allUIControlBlockTargets];
    [targets addObject:target];
}
- (void)addTouchUpInsideEventBlock:(void (^)(id sender))block {
    [self addBlock:block forControlEvents:UIControlEventTouchUpInside];
}

- (void)reAddBlock:(void (^)(id sender))block forControlEvents:(UIControlEvents)controlEvents {
    [self removeAllBlocksForControlEvents:controlEvents];
    [self addBlock:block forControlEvents:controlEvents];
}
- (void)reAddTouchUpInsideEventBlock:(void (^)(id sender))block {
    [self reAddBlock:block forControlEvents:UIControlEventTouchUpInside];
}

- (void)removeAllBlocksForControlEvents:(UIControlEvents)controlEvents {
    if (!controlEvents) return;
    
    NSMutableArray *targets = [self _allUIControlBlockTargets];
    NSMutableArray *removes = [NSMutableArray array];
    for (_YYUIControlBlockTarget *target in targets) {
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
- (NSMutableArray *)_allUIControlBlockTargets {
    NSMutableArray *targets = objc_getAssociatedObject(self, &block_key);
    if (!targets) {
        targets = [NSMutableArray array];
        objc_setAssociatedObject(self, &block_key, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return targets;
}
@end
