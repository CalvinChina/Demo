//
//  UIScrollView+YSCKit.m
//  YSCKit
//
//  Created by yangshengchao on 15/3/6.
//  Copyright (c) 2015年 yangshengchao. All rights reserved.
//

#import "UIScrollView+YSCKit.h"

@implementation UIScrollView (YSCKit)

- (CGFloat)_verticalOffsetForTop {
    CGFloat topInset = self.contentInset.top;
    return -topInset;
}
- (CGFloat)_verticalOffsetForBottom {
    CGFloat scrollViewHeight = self.bounds.size.height;
    CGFloat scrollContentSizeHeight = self.contentSize.height;
    CGFloat bottomInset = self.contentInset.bottom;
    CGFloat scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight;
    return scrollViewBottomOffset;
}

- (BOOL)isAtTop {
    return (self.contentOffset.y <= [self _verticalOffsetForTop]);
}
- (BOOL)isAtBottom {
    return (self.contentOffset.y >= [self _verticalOffsetForBottom]);
}
- (BOOL)isSwipingRight {
    CGPoint translation = [self.panGestureRecognizer translationInView:self.superview];
//    translation = [self.panGestureRecognizer velocityInView:self.superview];
    return translation.x > 0;
}
- (BOOL)isSwipingLeft {
    return ! [self isSwipingRight];
}
- (BOOL)isSwipingDown {
    CGPoint translation = [self.panGestureRecognizer translationInView:self.superview];
//    translation = [self.panGestureRecognizer velocityInView:self.superview];
    return translation.y > 0;
}
- (BOOL)isSwipingUp {
    return ! [self isSwipingDown];
}

- (void)scrollToTop {
    [self scrollToTopAnimated:YES];
}
- (void)scrollToBottom {
    [self scrollToBottomAnimated:YES];
}
- (void)scrollToLeft {
    [self scrollToLeftAnimated:YES];
}
- (void)scrollToRight {
    [self scrollToRightAnimated:YES];
}
- (void)scrollToTopAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.y = 0 - self.contentInset.top;
    [self setContentOffset:off animated:animated];
}
- (void)scrollToBottomAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.y = self.contentSize.height - self.bounds.size.height + self.contentInset.bottom;
    [self setContentOffset:off animated:animated];
}
- (void)scrollToLeftAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.x = 0 - self.contentInset.left;
    [self setContentOffset:off animated:animated];
}
- (void)scrollToRightAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.x = self.contentSize.width - self.bounds.size.width + self.contentInset.right;
    [self setContentOffset:off animated:animated];
}
@end
