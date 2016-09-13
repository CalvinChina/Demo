//
//  CALayer+TPAdditions.m
//
//  Created by pisen on 16/2/4.
//  Copyright © 2016年 Calvin. All rights reserved.
//

#import "CALayer+Additions.h"
#import <UIKit/UIKit.h>

@implementation CALayer (Additions)

- (void)setBorderColorFromUIColor:(UIColor *)color {
    self.borderColor = color.CGColor;
}

@end
