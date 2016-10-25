//
//  BaseViewController.h
//  Qianjituan
//
//  Created by ios-mac on 15/9/16.
//  Copyright (c) 2015年 ios-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (void)initQianjituanNavBack;
- (void)initNavBack;
- (void)initLeftBarButton:(BOOL)bQianjituan;
- (void)setRightBtnTitle:(NSString *)title;
- (void)setLeftBtnTitle:(NSString *)title;
- (void)onRightClicked:(id)sender;
- (void)onLeftClicked:(id)sender;
- (void)hideRightNavBtn;
- (void)hideLeftNavBtn;
- (void)showRightNavBtn;
- (void)showLeftNavBtn;

@end
