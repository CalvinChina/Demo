//
//  UIScrollView+PisenKit.h
//  PisenKit
//
//  Created by 杨胜超 on 16/6/30.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import <UIKit/UIKit.h>

//==============================================================================
//
//  常用方法
//
//==============================================================================
@interface UIScrollView (PisenKit)
- (BOOL)psk_isAtTop;
- (BOOL)psk_isAtBottom;
- (BOOL)psk_isSwipingRight;
- (BOOL)psk_isSwipingLeft;
- (BOOL)psk_isSwipingDown;
- (BOOL)psk_isSwipingUp;

- (void)psk_scrollToTop;
- (void)psk_scrollToBottom;
- (void)psk_scrollToLeft;
- (void)psk_scrollToRight;
- (void)psk_scrollToTopAnimated:(BOOL)animated;
- (void)psk_scrollToBottomAnimated:(BOOL)animated;
- (void)psk_scrollToLeftAnimated:(BOOL)animated;
- (void)psk_scrollToRightAnimated:(BOOL)animated;
@end
