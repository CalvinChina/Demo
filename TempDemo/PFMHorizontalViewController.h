//
//  PFMHorizontalViewController.h
//  PisenFM
//
//  Created by pisen on 16/10/27.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import "PSKBaseViewController.h"
#import "PFMTitleBarView.h"

@interface PFMHorizontalViewController : UIViewController<changePageDelegate>

// 当子视图控制器切换时调用
typedef void(^ChangeSubViewControllerBlock)(NSInteger selectIndex);
// 初始化方法，参数为子视图控制器
- (instancetype)initWithControllers:(NSArray *) controllers;

// 通知回调
@property (nonatomic, copy) ChangeSubViewControllerBlock ChangeSubViewControllerBlock;

@end
