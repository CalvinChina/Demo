//
//  UIViewController+ScrollingNavbar.m
//  ScrollingNavbarDemo
//
//  Created by Andrea on 24/03/14.
//  Copyright (c) 2014 Andrea Mazzini. All rights reserved.
//

#import "UIViewController+ScrollingNavbar.h"
#import <objc/runtime.h>

#ifndef IOS7_OR_LATER
    #define IOS7_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#endif

@implementation UIViewController (ScrollingNavbar)

#pragma mark - private properties

- (void)setPanGesture:(UIPanGestureRecognizer *)panGesture {
	objc_setAssociatedObject(self, @selector(panGesture), panGesture, OBJC_ASSOCIATION_RETAIN);
}

- (UIPanGestureRecognizer *)panGesture {
	return objc_getAssociatedObject(self, @selector(panGesture));
}

- (void)setScrollableView:(UIView *)scrollableView {
	objc_setAssociatedObject(self, @selector(scrollableView), scrollableView, OBJC_ASSOCIATION_RETAIN);
}

- (UIView *)scrollableView {
	return objc_getAssociatedObject(self, @selector(scrollableView));
}

- (void)setOverlay:(UIView *)overlay {
	objc_setAssociatedObject(self, @selector(overlay), overlay, OBJC_ASSOCIATION_RETAIN);
}

- (UIView *)overlay {
	return objc_getAssociatedObject(self, @selector(overlay));
}

- (void)setIsNavBarHidden:(BOOL)isNavBarHidden {
	objc_setAssociatedObject(self, @selector(isNavBarHidden), [NSNumber numberWithBool:isNavBarHidden], OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)isNavBarHidden {
	return [objc_getAssociatedObject(self, @selector(isNavBarHidden)) boolValue];
}

- (void)setLastContentOffset:(float)lastContentOffset {
	objc_setAssociatedObject(self, @selector(lastContentOffset), [NSNumber numberWithFloat:lastContentOffset], OBJC_ASSOCIATION_RETAIN);
}

- (float)lastContentOffset {
	return [objc_getAssociatedObject(self, @selector(lastContentOffset)) floatValue];
}

- (void)setShouldScrollWhenContentFits:(BOOL)shouldScrollWhenContentFits {
	objc_setAssociatedObject(self, @selector(shouldScrollWhenContentFits), [NSNumber numberWithBool:shouldScrollWhenContentFits], OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)shouldScrollWhenContentFits {
	return [objc_getAssociatedObject(self, @selector(shouldScrollWhenContentFits)) boolValue];
}


#pragma mark - private params

- (UIScrollView *)scrollView {
	UIScrollView *scroll;
	if ([self.scrollableView isKindOfClass:[UIWebView class]]) {
		scroll = [(UIWebView *)self.scrollableView scrollView];
	}
	else if ([self.scrollableView isKindOfClass:[UIScrollView class]]) {
		scroll = (UIScrollView *)self.scrollableView;
	}
	return scroll;
}

- (CGPoint)contentoffset {
	return [[self scrollView] contentOffset];
}

- (CGSize)contentSize {
	return [[self scrollView] contentSize];
}

- (float)deltaLimit {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return ([[UIApplication sharedApplication] isStatusBarHidden]) ? 44 : 24;
	}
	else {
		if ([[UIApplication sharedApplication] isStatusBarHidden]) {
			return (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]) ? 44 : 32);
		}
		else {
			return (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]) ? 24 : 12);
		}
	}
}

- (float)statusBarHeight {
	return ([[UIApplication sharedApplication] isStatusBarHidden]) ? 0 : 20;
}

- (float)navbarHeight {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return ([[UIApplication sharedApplication] isStatusBarHidden]) ? 44 : 64;
	}
	else {
		if ([[UIApplication sharedApplication] isStatusBarHidden]) {
			return (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]) ? 44 : 32);
		}
		else {
			return (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]) ? 64 : 52);
		}
	}
}




#pragma mark - public methods

- (void)followScrollView:(UIView *)scrollableView {
	[self followScrollView:scrollableView withDelay:0];
}

- (void)followScrollView:(UIView *)scrollableView withDelay:(float)delay {
	self.scrollableView = scrollableView;
    
	self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
	[self.panGesture setMaximumNumberOfTouches:1];
    
	[self.panGesture setDelegate:self];
	[self.scrollableView addGestureRecognizer:self.panGesture];
    
	/* The navbar fadeout is achieved using an overlay view with the same barTintColor.
     this might be improved by adjusting the alpha component of every navbar child */
	CGRect frame = self.navigationController.navigationBar.frame;
	frame.origin = CGPointZero;
	self.overlay = [[UIView alloc] initWithFrame:frame];
    
	// Use tintColor instead of barTintColor on iOS < 7
	if (IOS7_OR_LATER) {
		if (self.navigationController.navigationBar.barTintColor) {
			[self.overlay setBackgroundColor:self.navigationController.navigationBar.barTintColor];
		}
		else if ([UINavigationBar appearance].barTintColor) {
			[self.overlay setBackgroundColor:[UINavigationBar appearance].barTintColor];
		}
	}
	else {
		[self.overlay setBackgroundColor:self.navigationController.navigationBar.tintColor];
	}
    
	[self.overlay setUserInteractionEnabled:NO];
	[self.overlay setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
	[self.navigationController.navigationBar addSubview:self.overlay];
	[self.overlay setAlpha:0];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
	                                         selector:@selector(didBecomeActive:)
	                                             name:UIApplicationDidBecomeActiveNotification
	                                           object:nil];
	self.shouldScrollWhenContentFits = NO;
}

- (void)showNavbar {
	[self showNavBarAnimated:YES];
}

- (void)showNavBarAnimated:(BOOL)animated {
    self.lastContentOffset = 0;
	NSTimeInterval interval = animated ? 0.2 : 0;
	if (self.scrollableView != nil) {
		if (self.isNavBarHidden) {
			[UIView animateWithDuration:interval animations: ^{
			    [self scrollWithDelta:-[self navbarHeight]];
			    [self updateNavbarAlpha:-[self navbarHeight]];
			}];
		}
		else {
			[self updateNavbarAlpha:[self navbarHeight]];
		}
	}
}

- (void)stopFollowingScrollView {
	[self showNavBarAnimated:NO];
	[self.scrollableView removeGestureRecognizer:self.panGesture];
	[self.overlay removeFromSuperview];
	self.overlay = nil;
	self.scrollableView = nil;
	self.panGesture = nil;
}

- (void)setScrollingEnabled:(BOOL)enabled {
	self.panGesture.enabled = enabled;
}

#pragma mark - private methods

- (void)didBecomeActive:(id)sender {
	[self showNavbar];
}

- (void)updateNavbar {
	if (self.isNavBarHidden == NO) {
        
	}
	else {
        
	}
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	CGRect frame = self.overlay.frame;
	frame.size.height = self.navigationController.navigationBar.frame.size.height;
	self.overlay.frame = frame;
    
	[self updateSizingWithDelta:0];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
	return YES;
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
	if (!self.shouldScrollWhenContentFits) {
		if (self.scrollableView.frame.size.height >= [self contentSize].height) {
			return;
		}
	}
    
	CGPoint translation = [gesture translationInView:[self.scrollableView superview]];
    
	float delta = self.lastContentOffset - translation.y;
	self.lastContentOffset = translation.y;
    
	if ([self checkRubberbanding:delta]) {
		[self scrollWithDelta:delta];
	}
    
	if ([gesture state] == UIGestureRecognizerStateEnded) {
		// Reset the nav bar if the scroll is partial
		[self checkForPartialScroll];
		self.lastContentOffset = 0;
	}
}

- (void)checkForPartialScroll {
	CGFloat pos = self.navigationController.navigationBar.frame.origin.y;
	__block CGRect frame = self.navigationController.navigationBar.frame;
    
	// Get back down
	if (pos >= ([self statusBarHeight] - frame.size.height / 2)) {
        self.isNavBarHidden = NO;
		CGFloat delta = frame.origin.y - [self statusBarHeight];
		NSTimeInterval duration = ABS((delta / (frame.size.height / 2)) * 0.2);
		[UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations: ^{
		    frame.origin.y = [self statusBarHeight];
		    self.navigationController.navigationBar.frame = frame;
		    [self updateSizingWithDelta:delta];
		} completion:nil];
	}
	else {// And back up
        self.isNavBarHidden = YES;
		CGFloat delta = frame.origin.y + [self deltaLimit];
		NSTimeInterval duration = ABS((delta / (frame.size.height / 2)) * 0.2);
		[UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations: ^{
		    frame.origin.y = -[self deltaLimit];
		    self.navigationController.navigationBar.frame = frame;
		    [self updateSizingWithDelta:delta];
		} completion:nil];
	}
}

/**
 *  Prevents the navbar from moving during the 'rubberband' scroll
 *
 *  @param delta
 *
 *  @return YES / NO
 */
- (BOOL)checkRubberbanding:(CGFloat)delta {
	if (delta < 0) {//scroll to bottom to seen the top
		if ([self contentoffset].y + self.scrollableView.frame.size.height > [self contentSize].height) {
			if (self.scrollableView.frame.size.height < [self contentSize].height) { // Only if the content is big enough
				return NO;
			}
		}
	}
	else {
		if ([self contentoffset].y < 0) {
			return NO;
		}
	}
	return YES;
}

/**
 *  change while scrolling
 *
 *  @param delta
 */
- (void)scrollWithDelta:(CGFloat)delta {
	CGRect frame = self.navigationController.navigationBar.frame;
    
	if (delta > 0) {
		if (self.isNavBarHidden) {
			return;
		}
        //TODO:cant understand
        //		if (frame.origin.y - delta < -[self deltaLimit]) {
        //			delta = frame.origin.y + [self deltaLimit];
        //		}
        
		frame.origin.y = MAX(-[self deltaLimit], frame.origin.y - delta);
		self.navigationController.navigationBar.frame = frame;
        
		if (frame.origin.y == -[self deltaLimit]) {
			self.isNavBarHidden = YES;
		}
        
		[self updateSizingWithDelta:delta];
	}
    
	if (delta < 0) {
		if (!self.isNavBarHidden) {
			return;
		}
        //TODO:cant understand
        //		if (frame.origin.y - delta > self.statusBar) {
        //			delta = frame.origin.y - self.statusBar;
        //		}
        
		frame.origin.y = MIN(20, frame.origin.y - delta);
		self.navigationController.navigationBar.frame = frame;
        
		if (frame.origin.y == [self statusBarHeight]) {
			self.isNavBarHidden = NO;
		}
        
		[self updateSizingWithDelta:delta];
	}
}

- (void)updateSizingWithDelta:(CGFloat)delta {
    [self updateScrollViewContentoffset:delta];
	[self updateNavbarAlpha:delta];
    
	// At this point the navigation bar is already been placed in the right position, it'll be the reference point for the other views'sizing
	CGRect frameNav = self.navigationController.navigationBar.frame;
    
	// Move and expand (or shrink) the superview of the given scrollview
	CGRect frame = self.scrollableView.superview.frame;
	if (IOS7_OR_LATER) {
		frame.origin.y = frameNav.origin.y + frameNav.size.height;
	}
	else {
		frame.origin.y = frameNav.origin.y - [self statusBarHeight];
	}
	if (IOS7_OR_LATER) {
		frame.size.height = [UIScreen mainScreen].bounds.size.height - frame.origin.y;
	}
	else {
		frame.size.height = [UIScreen mainScreen].bounds.size.height - [self statusBarHeight];
	}
	self.scrollableView.superview.frame = frame;
	self.scrollableView.frame = self.scrollableView.superview.bounds;
	[self.view setNeedsLayout];
}

/**
 *  Hold the scroll steady until the navbar appears/disappears
 *
 *  @param delta
 */
- (void)updateScrollViewContentoffset:(float)delta {
	CGPoint offset = [[self scrollView] contentOffset];
    
	if ([self scrollView].translatesAutoresizingMaskIntoConstraints) {
		[[self scrollView] setContentOffset:(CGPoint) {offset.x, offset.y - delta }];
	}
	else {
		if (delta > 0) {
			[[self scrollView] setContentOffset:(CGPoint) {offset.x, offset.y - delta - 1 }];
		}
		else {
			[[self scrollView] setContentOffset:(CGPoint) {offset.x, offset.y - delta + 1 }];
		}
	}
}

- (void)updateNavbarAlpha:(CGFloat)delta {
	CGRect frame = self.navigationController.navigationBar.frame;
    
	if (self.scrollableView != nil) {
		[self.navigationController.navigationBar bringSubviewToFront:self.overlay];
	}
    
	// Change the alpha channel of every item on the navbr. The overlay will appear, while the other objects will disappear, and vice versa
	float alpha = (frame.origin.y + [self deltaLimit]) / frame.size.height;
	[self.overlay setAlpha:1 - alpha];
    
	[self.navigationItem.leftBarButtonItems enumerateObjectsUsingBlock: ^(UIBarButtonItem *obj, NSUInteger idx, BOOL *stop) {
	    obj.customView.alpha = alpha;
	}];
	self.navigationItem.leftBarButtonItem.customView.alpha = alpha;
	[self.navigationItem.rightBarButtonItems enumerateObjectsUsingBlock: ^(UIBarButtonItem *obj, NSUInteger idx, BOOL *stop) {
	    obj.customView.alpha = alpha;
	}];
	self.navigationItem.rightBarButtonItem.customView.alpha = alpha;
    
	self.navigationItem.titleView.alpha = alpha;
	self.navigationController.navigationBar.tintColor = [self.navigationController.navigationBar.tintColor colorWithAlphaComponent:alpha];
}

#pragma mark - UIScrollViewDelegate

/**
 *  This enables the user to scroll down the navbar by tapping the status bar.
 *
 */
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
	[self showNavbar];
	return YES;
}

@end
