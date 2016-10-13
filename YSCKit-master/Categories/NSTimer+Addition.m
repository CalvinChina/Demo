//
//  NSTimer+Addition.m
//  PagedScrollView
//
//  Created by 陈政 on 14-1-24.
//  Copyright (c) 2014年 Apple Inc. All rights reserved.
//

#import "NSTimer+Addition.h"

@implementation NSTimer (Addition)

- (void)pauseTimer {
	if (![self isValid]) {
		return;
	}
	[self setFireDate:[NSDate distantFuture]];
}

- (void)resumeTimerAfterInterval:(NSTimeInterval)interval {
	if (![self isValid]) {
		return;
	}
	[self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}

@end
