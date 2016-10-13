//
//  UIViewController+ScrollingNavbar.h
//  ScrollingNavbarDemo
//
//  Created by Andrea on 24/03/14.
//  Copyright (c) 2014 Andrea Mazzini. All rights reserved.
//

@interface UIViewController (ScrollingNavbar) <UIGestureRecognizerDelegate, UIScrollViewDelegate>

- (void)followScrollView:(UIView*)scrollableView;
- (void)followScrollView:(UIView*)scrollableView withDelay:(float)delay;

- (void)showNavbar;
- (void)showNavBarAnimated:(BOOL)animated;

- (void)stopFollowingScrollView;
- (void)setScrollingEnabled:(BOOL)enabled;

- (void)setShouldScrollWhenContentFits:(BOOL)enabled;

@end

