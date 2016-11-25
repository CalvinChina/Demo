//
//  YSCBaseNavigationViewController.m
//  KanPian
//
//  Created by 杨胜超 on 16/4/14.
//  Copyright © 2016年 SMIT. All rights reserved.
//

#import "YSCBaseNavigationViewController.h"

@interface YSCBaseNavigationViewController () <UIGestureRecognizerDelegate>

@end

// TODO: 如何设置中间拖动返回
@implementation YSCBaseNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /**
     * 滑动不够灵敏！
     */
//    self.interactivePopGestureRecognizer.delegate = self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.viewControllers.count <= 1 ) {
        return NO;
    }
    return YES;
}

@end
