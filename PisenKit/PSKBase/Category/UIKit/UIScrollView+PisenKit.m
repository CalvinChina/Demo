//
//  UIScrollView+PisenKit.m
//  PisenKit
//
//  Created by 杨胜超 on 16/6/30.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import "UIScrollView+PisenKit.h"

//==============================================================================
//
//  常用方法
//
//==============================================================================
@implementation UIScrollView (PisenKit)
- (CGFloat)_psk_verticalOffsetForTop {
    CGFloat topInset = self.contentInset.top;
    return -topInset;
}
- (CGFloat)_psk_verticalOffsetForBottom {
    CGFloat scrollViewHeight = self.bounds.size.height;
    CGFloat scrollContentSizeHeight = self.contentSize.height;
    CGFloat bottomInset = self.contentInset.bottom;
    CGFloat scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight;
    return scrollViewBottomOffset;
}

- (BOOL)psk_isAtTop {
    return (self.contentOffset.y <= [self _psk_verticalOffsetForTop]);
}
- (BOOL)psk_isAtBottom {
    return (self.contentOffset.y >= [self _psk_verticalOffsetForBottom]);
}
- (BOOL)psk_isSwipingRight {
    CGPoint translation = [self.panGestureRecognizer translationInView:self.superview];
    return translation.x > 0;
}
- (BOOL)psk_isSwipingLeft {
    return ! [self psk_isSwipingRight];
}
- (BOOL)psk_isSwipingDown {
    CGPoint translation = [self.panGestureRecognizer translationInView:self.superview];
    return translation.y > 0;
}
- (BOOL)psk_isSwipingUp {
    return ! [self psk_isSwipingDown];
}

- (void)psk_scrollToTop {
    [self psk_scrollToTopAnimated:YES];
}
- (void)psk_scrollToBottom {
    [self psk_scrollToBottomAnimated:YES];
}
- (void)psk_scrollToLeft {
    [self psk_scrollToLeftAnimated:YES];
}
- (void)psk_scrollToRight {
    [self psk_scrollToRightAnimated:YES];
}
- (void)psk_scrollToTopAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.y = 0 - self.contentInset.top;
    [self setContentOffset:off animated:animated];
}
- (void)psk_scrollToBottomAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.y = self.contentSize.height - self.bounds.size.height + self.contentInset.bottom;
    [self setContentOffset:off animated:animated];
}
- (void)psk_scrollToLeftAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.x = 0 - self.contentInset.left;
    [self setContentOffset:off animated:animated];
}
- (void)psk_scrollToRightAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.x = self.contentSize.width - self.bounds.size.width + self.contentInset.right;
    [self setContentOffset:off animated:animated];
}
@end
