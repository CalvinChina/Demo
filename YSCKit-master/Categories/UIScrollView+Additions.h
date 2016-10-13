//
//  UIScrollView+Additions.h
//  YSCKit
//
//  Created by yangshengchao on 15/3/6.
//  Copyright (c) 2015年 yangshengchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Additions)

- (BOOL)isAtTop;
- (BOOL)isAtBottom;
- (BOOL)isSwipingRight;
- (BOOL)isSwipingLeft;
- (BOOL)isSwipingDown;
- (BOOL)isSwipingUp;

@end
