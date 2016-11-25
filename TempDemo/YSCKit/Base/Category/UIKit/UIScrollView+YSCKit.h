//
//  UIScrollView+YSCKit.h
//  YSCKit
//
//  Created by yangshengchao on 15/3/6.
//  Copyright (c) 2015年 yangshengchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (YSCKit)

- (BOOL)isAtTop;
- (BOOL)isAtBottom;
- (BOOL)isSwipingRight; //指的是手指往右滚，看右面的内容
- (BOOL)isSwipingLeft;
- (BOOL)isSwipingDown;  //指的是手指往下滚，看下面的内容
- (BOOL)isSwipingUp;

- (void)scrollToTop;
- (void)scrollToBottom;
- (void)scrollToLeft;
- (void)scrollToRight;
- (void)scrollToTopAnimated:(BOOL)animated;
- (void)scrollToBottomAnimated:(BOOL)animated;
- (void)scrollToLeftAnimated:(BOOL)animated;
- (void)scrollToRightAnimated:(BOOL)animated;
@end
