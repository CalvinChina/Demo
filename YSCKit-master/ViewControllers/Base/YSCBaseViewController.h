//
//  BaseViewController.h
//  YSCKit
//
//  Created by  YangShengchao on 14-2-13.
//  Copyright (c) 2014年  YangShengchao. All rights reserved.
//  FORMATED!
//

#import <UIKit/UIKit.h>

#define CheckWeakSelfIsClicked      if(weakSelf.isClicked){ return; }weakSelf.isClicked = YES;
#define CheckSelfIsClicked          if(self.isClicked){ return; }self.isClicked = YES;

@interface YSCBaseViewController : UIViewController

#pragma mark - 视图切换
@property (nonatomic, strong) NSDictionary *params; //显示该视图控制器的时候传入的参数
@property (nonatomic, strong) YSCKTipsView *tipsView;   //提示信息，默认隐藏
@property (nonatomic, assign) BOOL isTipsViewHidden;        //设置没有数据的提示view是否隐藏
@property (nonatomic, strong) YSCTitleBarView *titleBarView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, assign) BackType backType;    //返回类型（是上一级还是侧边栏）默认是pop上一级
@property (nonatomic, assign) BOOL isAppeared;      //当前viewcontroller是否显示
@property (nonatomic, assign) BOOL isClicked;       //判断重复点击某一操作
@property (nonatomic, copy) YSCResultBlock block;

#pragma mark - push view controller
- (UIViewController *)pushViewController:(NSString *)className;
- (UIViewController *)pushViewController:(NSString *)className withParams:(NSDictionary *)paramDict;
- (UIViewController *)pushViewController:(NSString *)className withParams:(NSDictionary *)paramDict animated:(BOOL)animated;

#pragma mark - pop & dismiss
//返回上一级，最多到根
- (UIViewController *)popViewController;
//返回上一级，直到dismiss
- (UIViewController *)backViewController;
//返回到根
- (UIViewController *)popToRootViewController;
//向后回退的步数
- (UIViewController *)popToViewControllerWithStep:(NSInteger)step;


#pragma mark - present & dismiss viewcontroller [presentingViewController -> self -> presentedViewController]
- (UINavigationController *)presentViewController:(NSString *)className;
- (UINavigationController *)presentViewController:(NSString *)className withParams:(NSDictionary *)paramDict;
- (UINavigationController *)presentViewController:(NSString *)className withParams:(NSDictionary *)paramDict animated:(BOOL)animated;
- (UINavigationController *)presentNormalViewController:(UIViewController *)viewController;
//在self上一级viewController调用dismiss（通常情况下使用该方法）
- (void)dismissOnPresentingViewController;
//在self下一级viewController调用dismiss
- (void)dismissOnPresentedViewController;



#pragma mark -  show & hide HUD
- (MBProgressHUD *)showHUDLoading:(NSString *)hintString;
- (MBProgressHUD *)showHUDLoadingOnWindow:(NSString *)hintString;
- (MBProgressHUD *)showHUDLoading:(NSString *)hintString onView:(UIView *)view;

- (void)hideHUDLoading;
- (void)hideHUDLoadingOnWindow;
- (void)hideHUDLoadingOnView:(UIView *)view;

- (void)showResultThenHide:(NSString *)resultString;
- (void)showResultThenHideOnWindow:(NSString *)resultString;
- (void)showResultThenPop:(NSString *)resultString;
- (void)showResultThenPopOnWindow:(NSString *)resultString;
- (void)showResultThenBack:(NSString *)resultString;
- (void)showResultThenBackOnWindow:(NSString *)resultString;
- (void)showResultThenDismiss:(NSString *)resultString;
- (void)showResultThenDismissOnWindow:(NSString *)resultString;
- (void)showResultThenHide:(NSString *)resultString afterDelay:(NSTimeInterval)delay onView:(UIView *)view;


#pragma mark - alert view
- (UIAlertView *)showAlertVieWithMessage:(NSString *)message;
- (UIAlertView *)showAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message;
- (UIAlertView *)showAlertVieWithMessage:(NSString *)message block:(YSCResultBlock)block;
- (UIAlertView *)showAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message block:(YSCResultBlock)block;

#pragma mark - Overridden methods 缓存相关
- (id)cachedObjectForKey:(NSString *)cachedKey;
- (id)cachedObjectForKey:(NSString *)cachedKey withSuffix:(NSString *)suffix;
- (void)saveObject:(id)object forKey:(NSString *)cachedKey;
- (void)saveObject:(id)object forKey:(NSString *)cachedKey withSuffix:(NSString *)suffix;
- (NSMutableArray *)commonLoadCaches:(NSString *)cacheKey;


#pragma mark - Overridden methods 业务相关
- (void)userLoginStatusChanged;//用户登录状态改变了
- (void)didAppBecomeActive;//APP恢复运行
- (void)didAppEnterBackground;//用户按下Home键APP进入后台
- (NSArray *)customBarButtonOnNavigationBar:(UIView *)customButton withFixedSpaceWidth:(NSInteger)width;
- (IBAction)backButtonClicked:(id)sender;
- (IBAction)popButtonClicked:(id)sender;
- (IBAction)leftSlideButtonClicked:(id)sender;
- (BOOL)showCustomTitleBarView;
- (void)hideKeyboard;
- (BOOL)willCareKeyboard;
- (void)willLayoutForKeyboardHeight:(CGFloat)keyboardHeight;
- (void)layoutForKeyboardHeight:(CGFloat)keyboardHeight;
- (void)didLayoutForKeyboardHeight:(CGFloat)keyboardHeight;
- (void)networkReachablityChanged:(BOOL)reachable;
//专门针对tableview的seperator左右间隔进行设置
- (UIEdgeInsets)edgeInsetsOfCellSeperator;
- (void)callBlock;

@end
