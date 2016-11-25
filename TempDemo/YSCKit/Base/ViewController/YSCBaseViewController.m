//
//  YSCBaseViewController.m
//  YSCKit
//
//  Created by  YangShengchao on 14-2-13.
//  Copyright (c) 2014年  YangShengchao. All rights reserved.
//

#import "YSCBaseViewController.h"
@interface YSCBaseViewController ()
@property (nonatomic, strong) NSMutableDictionary *requestIdDictionary;
@end
@implementation YSCBaseViewController
- (void)dealloc {
    NSLog(@"[%@] is deallocing...", NSStringFromClass(self.class));
    if (self.customTitleView) {
        [self.customTitleView removeFromSuperview];
        self.customTitleView = nil;
    }
    if (self.tipsView) {
        [self.tipsView removeFromSuperview];
        self.tipsView = nil;
    }
    
    // 取消未结束的网络请求
    NSArray *requestIds = [self.requestIdDictionary.allValues copy];
    for (NSString *requestId in requestIds) {
        [YSCRequestInstance cancelRequestById:requestId];
    }
    [self.requestIdDictionary removeAllObjects];
    self.requestIdDictionary = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self]; //等同于宏定义  removeAllObservers(self);
}
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    if (self.customTitleView) {
        [self.view bringSubviewToFront:self.customTitleView];
    }
    else {
        BOOL isBarHidden = [self.params[kParamIsHideNavBar] boolValue];
        if (isBarHidden != self.navigationController.navigationBar.hidden) {
            [self.navigationController setNavigationBarHidden:isBarHidden animated:animated];
        }
    }
    if (self.tipsView) {
        [self.view bringSubviewToFront:self.tipsView];
    }
    self.isAppeared = YES;
    YSCDataInstance.currentViewController = self;
    NSLog(@"%@ will appear", NSStringFromClass(self.class));
}
- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}
- (void)viewDidDisappear:(BOOL)animated {
	self.isAppeared = NO;
    [super viewDidDisappear:animated];
}
// 初始化
- (void)viewDidLoad {
	[super viewDidLoad];
    self.requestIdDictionary = [NSMutableDictionary dictionary];
    if ( ! self.params) {
        self.params = [NSMutableDictionary dictionary];
    }
    NSLog(@"self.params = %@", self.params);
    self.block = self.params[kParamBlock];
    //相对布局——自动调整约束值和font大小
    if (1 != YSCConfigDataInstance.autoLayoutScale &&
        ( ! [self respondsToSelector:@selector(setCloseResetFontAndConstraint:)])) {
        [self.view resetSize];
    }
    //设置title
    [self _configTitleView];
    self.view.backgroundColor = YSCConfigDataInstance.defaultViewColor; //设置默认背景颜色
    self.hidesBottomBarWhenPushed = YES;
    self.view.clipsToBounds = YES;
	self.view.layer.masksToBounds = YES;//解决自定义导航条在移出时的延迟问题
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {//ios6不支持该属性
        [self setEdgesForExtendedLayout:UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight];
    }
    //设置tipsview
    self.tipsView = [YSCTipsView createYSCTipsViewOnView:self.view];
    self.tipsView.backgroundColor = YSCConfigDataInstance.defaultViewColor;
    self.tipsView.hidden = YES;
    if (self.customTitleView) {
        [self.tipsView resetFrameWithEdgeInsets:UIEdgeInsetsMake(64, 0, 0, 0)];
    }
    else {
        if ( ! [self.params[kParamIsHideNavBar] boolValue]) {
            [self _configBackButton];//设置返回按钮类型
        }
    }
    
    //监控APP运行状态(恢复运行、按下home键进入后台)
    ADD_OBSERVER(@selector(didAppBecomeActive), UIApplicationDidBecomeActiveNotification);
    ADD_OBSERVER(@selector(didAppEnterBackground), UIApplicationDidEnterBackgroundNotification);
}

#pragma mark - Private Methods
- (void)_configTitleView {
    if (OBJECT_ISNOT_EMPTY(self.customTitleViewName)) {
        Class class = NSClassFromString(self.customTitleViewName);
        if ([class respondsToSelector:@selector(createTitleView)]) {
            self.customTitleView = [class performSelector:@selector(createTitleView) withObject:nil];
        }
        if (self.customTitleView) {
            //添加自定义title view
            [self.view addSubview:self.customTitleView];
            //强制隐藏系统navi bar
            self.params[kParamIsHideNavBar] = @YES;
            //设置返回事件
            if ([self.customTitleView respondsToSelector:@selector(setGoBackBlock:)]) {
                @weakiy(self);
                YSCBlock block = ^{
                    [weak_self backButtonClicked:nil];
                };
                [self.customTitleView performSelector:@selector(setGoBackBlock:)
                                           withObject:block];
            }
            
        }
    }
    [self resetTitle:self.params[kParamTitle]];
}
- (void)_configBackButton {
    if (self.params[kParamBackType]) {
        self.backArrowType = [self.params[kParamBackType] integerValue];
    }
    else {
        self.backArrowType = BackArrowTypeDefault;
    }
    
    if (BackArrowTypeDefault == self.backArrowType) {//自定义返回按钮的图片(包括push和present的)
        UIImage *backArrowImage = [UIImage imageNamed:YSCConfigDataInstance.defaultBackButtonImageName];
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:backArrowImage
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(backButtonClicked:)];
        self.navigationItem.leftBarButtonItem = barButtonItem;
        
    }
    else if (BackArrowTypeSystemWithoutText == self.backArrowType) {
        UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
        temporaryBarButtonItem.title = @"";//去掉返回按钮的文字
        self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    }
}

#pragma mark - 自定义titleView
- (NSString *)customTitleViewName {
    return @"";
}
- (void)resetTitle:(NSString *)title {
    if (self.customTitleView) {
        if ([self.customTitleView respondsToSelector:@selector(setTitle:)]) {
            [self.customTitleView performSelector:@selector(setTitle:)
                                       withObject:TRIM_STRING(title)];
        }
    }
    else {
        if ( ! [self.params[kParamIsHideNavBar] boolValue]) {
            self.navigationItem.title = TRIM_STRING(title);
        }
    }
}

#pragma mark - 显示/隐藏tipsview
- (void)showTipsWithMessage:(NSString *)message buttonAction:(YSCBlock)buttonAction {
    if (self.tipsView) {
        self.tipsView.hidden = NO;
        self.tipsView.messageLabel.text = message;
        if (OBJECT_IS_EMPTY(message)) {// 没有错误信息就显示空数据提示
            [self.tipsView resetImageName:YSCConfigDataInstance.defaultEmptyImageName];
            self.tipsView.actionButton.hidden = YES;
        }
        else {
            if ([YSCConfigDataInstance.networkErrorTimeout isEqualToString:message]) {
                [self.tipsView resetImageName:YSCConfigDataInstance.defaultTimeoutImageName];
            }
            else {
                [self.tipsView resetImageName:YSCConfigDataInstance.defaultErrorImageName];
            }
            [self.tipsView resetActionWithButtonTitle:@"重新加载" buttonAction:buttonAction];
        }
    }
    else {
        [YSCAlertManager showAlertViewWithMessage:message];
    }
}
- (void)hideTipsView:(BOOL)remove {
    RETURN_WHEN_OBJECT_IS_EMPTY(self.tipsView)
    self.tipsView.hidden = YES;
    if (remove) {
        [self.tipsView removeFromSuperview];
        self.tipsView = nil;
    }
}

#pragma mark - 显示/隐藏HUD，自动判断hud的背景是否透明，以及HUD的edgeInsets
- (void)showHUDOnSelfViewWithMessage:(NSString *)message {
    [YSCHUDManager showHUDOnView:self.view
                         message:message
                      edgeInsets:(self.customTitleView ? UIEdgeInsetsMake(64, 0, 0, 0) : UIEdgeInsetsZero)
                 backgroundColor:(self.tipsView ? YSCConfigDataInstance.defaultViewColor : nil)];
}
- (void)showHUDOnSelfView {
    [self showHUDOnSelfViewWithMessage:nil];
}
- (void)showHUDOnSelfViewThenHideWithMessage:(NSString *)message {
    [YSCHUDManager showHUDThenHideOnView:self.view message:message];
}
- (void)hideHUDOnSelfView {
    [YSCHUDManager hideHUDOnView:self.view];
}

#pragma mark - 监控APP恢复运行、按下home键
- (void)didAppBecomeActive {
}
- (void)didAppEnterBackground {
}

#pragma mark - 管理网络请求队列
- (void)addRequestId:(NSString *)requestId forKey:(NSString *)requestKey {
    RETURN_WHEN_OBJECT_IS_EMPTY(requestId);
    RETURN_WHEN_OBJECT_IS_EMPTY(requestKey);
    self.requestIdDictionary[requestKey] = requestId;
}
- (void)removeRequestIdByKey:(NSString *)requestKey {
    RETURN_WHEN_OBJECT_IS_EMPTY(requestKey);
    NSString *requestId = self.requestIdDictionary[requestKey];
    if (requestId && ! YSCRequestInstance.requestQueue[requestId]) {
        // 只有当网络请求队列里移除了requestId才移除对应的requestKey
        [self.requestIdDictionary removeObjectForKey:requestKey];
    }
}
- (void)cancelRequestIdByKey:(NSString *)requestKey {
    NSString *requestId = self.requestIdDictionary[requestKey];
    if (requestId) {
        [YSCRequestInstance cancelRequestById:requestId];
        [self.requestIdDictionary removeObjectForKey:requestKey];
    }
}

#pragma mark - 其它
- (IBAction)backButtonClicked:(id)sender {
    [self backViewController];
}

@end
