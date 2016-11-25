//
//  YSCBaseViewController.h
//  YSCKit
//
//  Created by  YangShengchao on 14-2-13.
//  Copyright (c) 2014年  YangShengchao. All rights reserved.
//

#import "YSCTipsView.h"

// 定义返回按钮的箭头样式
typedef NS_ENUM(NSInteger, BackArrowType) {
    BackArrowTypeDefault = 0,       //默认用箭头图片代替返回按钮
    BackArrowTypeSystemWithoutText,  //用系统自带的返回箭头(去掉文字)
};

/**
 *  作用：
 *      1. 统一设置返回按钮的箭头图片
 *      2. 等比例调整约束值
 *      3. 监控APP恢复运行、用户按下home键
 *      4. 自定义titleview
 */
@interface YSCBaseViewController : UIViewController
@property (nonatomic, strong) YSCTipsView *tipsView;
@property (nonatomic, strong) UIView *customTitleView;
@property (nonatomic, assign) BackArrowType backArrowType;
@property (nonatomic, assign) BOOL isAppeared;      //当前viewcontroller是否已经显示
@property (nonatomic, copy) YSCObjectBlock block;   //回调上一级的block

/** 
 *  如果需要自定义titleview，只需要实现该方法且class满足如下条件即可：
 *  1. 有实例方法 - (void)setGoBackBlock:(YSCBlock)block:
 *  2. 有实例方法 - (void)setTitle:(NSString *)title;
 *  3. 有静态方法 + (instancetype)createTitleView;
 */
- (NSString *)customTitleViewName;
- (void)resetTitle:(NSString *)title;

/**
 *  显示/隐藏tipsview
 */
- (void)showTipsWithMessage:(NSString *)message buttonAction:(YSCBlock)buttonAction;
- (void)hideTipsView:(BOOL)remove;

/**
 *  显示/隐藏HUD，自动判断hud的背景是否透明，以及HUD的edgeInsets
 */
- (void)showHUDOnSelfViewWithMessage:(NSString *)message;
- (void)showHUDOnSelfView;
- (void)showHUDOnSelfViewThenHideWithMessage:(NSString *)message;
- (void)hideHUDOnSelfView;

/**
 *  监控APP恢复运行、按下home键
 */
- (void)didAppBecomeActive;
- (void)didAppEnterBackground;

/**
 *  管理网络请求队列
 */
- (void)addRequestId:(NSString *)requestId forKey:(NSString *)requestKey;
- (void)removeRequestIdByKey:(NSString *)requestKey;
- (void)cancelRequestIdByKey:(NSString *)requestKey;

/**
 *  其它
 */
- (IBAction)backButtonClicked:(id)sender;

@end

