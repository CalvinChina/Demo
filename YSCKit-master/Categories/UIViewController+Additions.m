//
//  UIViewController+Additions.m
//  YSCKit
//
//  Created by yangshengchao on 15/4/23.
//  Copyright (c) 2015年 yangshengchao. All rights reserved.
//

#import "UIViewController+Additions.h"
#import <objc/runtime.h>

const char *DelegateUIviewControllerKey;

@implementation UIViewController (Additions)

- (void)setCustomTransitioningDelegate:(ADTransitioningDelegate *)transitioningDelegate {
    self.transitioningDelegate = transitioningDelegate;
    objc_setAssociatedObject(self, DelegateUIviewControllerKey, transitioningDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (ADTransitioningDelegate *)customTransitioningDelegate {
    return objc_getAssociatedObject(self, DelegateUIviewControllerKey);
}

@end
