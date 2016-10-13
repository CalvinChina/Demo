//
//  BaseViewController.m
//  YSCKit
//
//  Created by  YangShengchao on 14-2-13.
//  Copyright (c) 2014年  YangShengchao. All rights reserved.
//

#import "YSCBaseViewController.h"

#define kHudIntervalShort 0.5f
#define kHudIntervalNormal 1.0f
#define kHudIntervalLong 2.0f

@interface YSCBaseViewController ()

@property (nonatomic, strong) UIStoryboard *storyBoard;
@property (nonatomic, strong) NSString *reachabilityManagerIdentifier;
@property (nonatomic, strong) NSString *isUserChangedIdentifier;

@end

@implementation YSCBaseViewController

#pragma mark - 重写基类方法

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	if ([self showCustomTitleBarView]) {
		if (self.navigationController) {
			[self.navigationController setNavigationBarHidden:YES animated:animated];
			[self.navigationController setToolbarHidden:YES animated:animated];
		}
		[self.view bringSubviewToFront:self.titleBarView];
	}
    else {
        [self.navigationController setNavigationBarHidden:[self.params[kParamIsHideNavBar] boolValue] animated:animated];
    }
    self.isAppeared = YES;
    YSCInstance.currentViewController = self;
}
- (void)viewDidAppear:(BOOL)animated {
    UMEventBeginLogPageView;
	[super viewDidAppear:animated];
    self.isClicked = NO;
}
- (void)viewDidDisappear:(BOOL)animated {
    UMEventEndLogPageView;
	self.isAppeared = NO;
    [super viewDidDisappear:animated];
}
- (void)dealloc {
	NSLog(@"[%@] dealloc......", NSStringFromClass(self.class));
    if (self.reachabilityManagerIdentifier) {
        [YSCInstance bk_removeObserversWithIdentifier:self.reachabilityManagerIdentifier];
    }
    if (self.isUserChangedIdentifier) {
        [APPDATA bk_removeObserversWithIdentifier:self.isUserChangedIdentifier];
    }
	[[NSNotificationCenter defaultCenter] removeObserver:self]; //等同于宏定义  removeAllObservers(self);
}

/**
 *  初始化
 */
- (void)viewDidLoad {
	[super viewDidLoad];
    WeakSelfType blockSelf = self;
    self.block = self.params[kParamBlock];
    
    //view基本参数设置
    if ([NSString isEmpty:self.navigationItem.title] && [NSString isNotEmpty:self.params[kParamTitle]]) {//已经有标题的就不再设置了
        self.navigationItem.title = self.params[kParamTitle];
    }
    self.view.clipsToBounds = YES;
	self.view.layer.masksToBounds = YES;//解决自定义导航条在移出时的延迟问题
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {//ios6不支持该属性
        [self setEdgesForExtendedLayout:UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight];
    }
    self.view.backgroundColor = kDefaultViewColor; //设置默认背景颜色
    
    //设置键盘显示和隐藏时，需要调整的内容
	if ([self willCareKeyboard]) {
        addNObserver(@selector(keyboardWillShow:), UIKeyboardWillShowNotification);
        addNObserver(@selector(keyboardWillHide:), UIKeyboardWillHideNotification);
	}
    
    //添加网络状态监控功能
    self.reachabilityManagerIdentifier = [YSCInstance bk_addObserverForKeyPath:@"isReachable" task:^(id target) {
        dispatch_async(dispatch_get_main_queue(), ^{//更新主线程的UI
		    [blockSelf networkReachablityChanged:YSCInstance.isReachable];
		});
    }];
    
    //设置导航栏
	if ([self showCustomTitleBarView]) {
		if (!self.titleBarView) {
			self.titleBarView = [YSCTitleBarView new];
			[self.view addSubview:self.titleBarView];
		}
		self.titleBarView.hidden = NO;
	}
	else {
		if (self.titleBarView) {
			self.titleBarView.hidden = YES;
		}
	}
 
    //设置返回按钮类型
    [self configBackButton];
    
    //相对布局——自动调整约束值和font大小
    if (AUTOLAYOUT_SCALE != 1) {
        [self.view resetFontSizeOfView];
        [self.view resetConstraintOfView];
    }
    
    //监控用户登录状态
    self.isUserChangedIdentifier = [APPDATA bk_addObserverForKeyPath:@"isUserChanged" task:^(id target) {
        [blockSelf userLoginStatusChanged];
    }];
    
    //监控APP运行状态(恢复运行、按下home键进入后台)
    addNObserver(@selector(didAppBecomeActive), UIApplicationDidBecomeActiveNotification);
    addNObserver(@selector(didAppEnterBackground), UIApplicationDidEnterBackgroundNotification);
}


#pragma mark - 私有方法

/**
 *  设置返回按钮（左上角）
 */
- (void)configBackButton {
    if ([NSObject isNotEmpty:self.params[kParamBackType]]) {
		self.backType = [self.params[kParamBackType] integerValue];
	}
	else {
		self.backType = BackTypeDefault;
	}
    
    if (BackTypeDefault == self.backType) { //设置返回按钮(默认)
		if ([self showCustomTitleBarView]) {//显示自定义TitleBarView
			if (!self.backButton) {
				self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(2, 22, 44, 40)];
				self.backButton.contentEdgeInsets = UIEdgeInsetsMake(4, 0, 4, 12);
				self.backButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
				self.backButton.backgroundColor = [UIColor clearColor];
				[self.backButton setTitle:nil forState:UIControlStateNormal];
				[self.backButton setImage:kDefaultNaviBarPopImage forState:UIControlStateNormal];
			}
			[self.backButton addTarget:self action:@selector(popButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
			[self.titleBarView addSubview:self.backButton];
		}
		else {//显示系统默认返回按钮(向左的箭头带)
            //------去掉返回按钮的文字------
            UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
            temporaryBarButtonItem.title = @"";
            self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
            //-------------END-----------
		}
	}
    else if (BackTypeImage == self.backType) {//自定义返回按钮的图片(包括push和present的)
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:kDefaultNaviBarPopImage
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(backButtonClicked:)];
    }
    else if (BackTypeSliding == self.backType) { //设置侧边栏按钮
        if ([self showCustomTitleBarView]) {
            if (!self.backButton) {
                self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, 50, 44)];
                self.backButton.contentEdgeInsets = UIEdgeInsetsMake(10, 13, 11, 14);
                self.backButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
                self.backButton.backgroundColor = [UIColor clearColor];
                [self.backButton setTitle:nil forState:UIControlStateNormal];
                [self.backButton setImage:[UIImage imageNamed:@"button_leftslide"] forState:UIControlStateNormal];
            }
            [self.backButton addTarget:self action:@selector(leftSlideButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.titleBarView addSubview:self.backButton];
        }
        else {
            UIButton *slideButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 40)];
            [slideButton addTarget:self action:@selector(leftSlideButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [slideButton setImageEdgeInsets:UIEdgeInsetsMake(4, -4, 4, 16)];
            [slideButton setImage:[UIImage imageNamed:@"button_leftslide"] forState:UIControlStateNormal];
            slideButton.tintColor = [UIColor blackColor];
            self.navigationItem.hidesBackButton = YES;
            self.navigationItem.leftBarButtonItems = [self customBarButtonOnNavigationBar:slideButton withFixedSpaceWidth:-10];
        }
    }
	else {
		NSAssert(YES, @"self.backType = [%lu] 不支持该类型！", self.backType);
	}
}
- (void)addTapToHideKeyboardGesture {
    UIGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapped:)];
	gestureRecognizer.cancelsTouchesInView = NO;
//	gestureRecognizer.delegate = self;
	[self.view addGestureRecognizer:gestureRecognizer];
}
- (void)singleTapped:(UIGestureRecognizer *)gestureRecognizer {
	[self performSelector:@selector(hideKeyboard) withObject:nil afterDelay:0.1f];
}
- (void)keyboardWillShow:(NSNotification *)notification {
	NSDictionary *userInfo = [notification userInfo];
	NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
	CGRect keyboardRect = [aValue CGRectValue];
	NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
	NSTimeInterval animationDuration;
	[animationDurationValue getValue:&animationDuration];

	[self willLayoutForKeyboardHeight:keyboardRect.size.height];
	WeakSelfType blockSelf = self;
	[UIView animateWithDuration:animationDuration
	                 animations: ^{
                         [blockSelf layoutForKeyboardHeight:keyboardRect.size.height];
                     }
	                 completion: ^(BOOL finished) {
                         [blockSelf didLayoutForKeyboardHeight:keyboardRect.size.height];
                     }];
}
- (void)keyboardWillHide:(NSNotification *)notification {
	NSDictionary *userInfo = [notification userInfo];
	NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
	NSTimeInterval animationDuration;
	[animationDurationValue getValue:&animationDuration];

	[self willLayoutForKeyboardHeight:0];
	WeakSelfType blockSelf = self;
	[UIView animateWithDuration:animationDuration
	                 animations: ^{
                         [blockSelf layoutForKeyboardHeight:0];
                     }
	                 completion: ^(BOOL finished) {
                         [blockSelf didLayoutForKeyboardHeight:0];
                     }];
}

#pragma mark - push & pop & dismiss view controller
- (UIViewController *)pushViewController:(NSString *)className {
	return [self pushViewController:className withParams:nil];
}
- (UIViewController *)pushViewController:(NSString *)className withParams:(NSDictionary *)paramDict {
    return [self pushViewController:className withParams:paramDict animated:YES];
}
- (UIViewController *)pushViewController:(NSString *)className withParams:(NSDictionary *)paramDict animated:(BOOL)animated {
    [self hideKeyboard];
    ReturnNilWhenObjectIsEmpty(className);
    UIViewController *pushedViewController = [UIResponder CreateBaseViewController:className];
    NSMutableDictionary *mutableParamDict = [NSMutableDictionary dictionaryWithDictionary:paramDict];
    if ( ! mutableParamDict[kParamBackType]) {
        [mutableParamDict setValue:@(BackTypeImage) forKey:kParamBackType];   //这里设置的返回按钮由即将push出来的viewController负责处理
    }
    if ([pushedViewController isKindOfClass:[YSCBaseViewController class]]) {
        [(YSCBaseViewController *)pushedViewController setParams:mutableParamDict];
    }
    
    //NOTE:这里设置backBarButtonItem没有用！
    [self.navigationController pushViewController:pushedViewController animated:animated];
    return pushedViewController;
}

#pragma mark - pop & dismiss
//返回上一层(最多到根)
//如果没有NavigationController就直接dismiss
- (UIViewController *)popViewController {
    [self hideKeyboard];
    UMEventKeyPopViewController;
	if (self.navigationController) {     //如果有navigationBar
		NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
		UIViewController *previousViewController = [self.navigationController.viewControllers objectAtIndex:MAX(index - 1, 0)];
		[self.navigationController popViewControllerAnimated:YES];
		return previousViewController;
	}
	else {
        [self dismissOnPresentingViewController];
        return self.presentingViewController;
	}
}
//返回上一层(会自动dismiss根)
//如果没有NavigationController就直接dismiss
- (UIViewController *)backViewController {
    [self hideKeyboard];
    UMEventKeyBackViewController;
	if (self.navigationController) {            //如果有navigationBar
		NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
		if (index > 0) {                        //不是root，就返回上一级
            return [self popToViewControllerWithStep:1];
		}
		else {
			[self dismissOnPresentingViewController];
            return self.presentingViewController;
		}
	}
	else {
		[self dismissOnPresentingViewController];
        return self.presentingViewController;
	}
}
//return 最顶层的viewController
- (UIViewController *)popToRootViewController {
    if (self.navigationController) {
        UIViewController *topViewController = [self.navigationController.viewControllers objectAtIndex:0];
        [self.navigationController popToRootViewControllerAnimated:YES];
        return topViewController;
    }
	else {
        return nil;
    }
}
//向后回退的步数
- (UIViewController *)popToViewControllerWithStep:(NSInteger)step {
    if (self.navigationController) {
        NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
        UIViewController *previousViewController = [self.navigationController.viewControllers objectAtIndex:MIN([self.navigationController.viewControllers count] - 1, MAX(index - step, 0))];
        [self.navigationController popToViewController:previousViewController animated:YES];
        return previousViewController;
    }
    else {
        return nil;
    }
}

#pragma mark - present & dismiss viewcontroller [presentingViewController -> self -> presentedViewController]
- (UINavigationController *)presentViewController:(NSString *)className {
	return [self presentViewController:className withParams:nil];
}
- (UINavigationController *)presentViewController:(NSString *)className withParams:(NSDictionary *)paramDict {
    return [self presentViewController:className withParams:paramDict animated:YES];
}
- (UINavigationController *)presentViewController:(NSString *)className withParams:(NSDictionary *)paramDict animated:(BOOL)animated {
    ReturnNilWhenObjectIsEmpty(className);
    UIViewController *viewController = [UIResponder CreateBaseViewController:className];
    NSMutableDictionary *mutableParamDict = [NSMutableDictionary dictionaryWithDictionary:paramDict];
    if ( ! mutableParamDict[kParamBackType]) {
        [mutableParamDict setValue:@(BackTypeImage) forKey:kParamBackType];   //这里设置的返回按钮由即将push出来的viewController负责处理
    }
    if ([viewController isKindOfClass:[YSCBaseViewController class]]) {
        [(YSCBaseViewController *)viewController setParams:mutableParamDict];
    }
    
    return [self presentNormalViewController:viewController];
}
- (UINavigationController *)presentNormalViewController:(UIViewController *)viewController {
    [self hideKeyboard];
    [self presentViewController:[UIResponder CreateNavigationControllerWithRootViewController:viewController]
                       animated:YES completion:nil];
    return nil;
}
//在self上一级viewController调用dismiss（通常情况下使用该方法）
- (void)dismissOnPresentingViewController {
	if (self.presentingViewController) {
		[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
	}
}
//在self下一级viewController调用dismiss
- (void)dismissOnPresentedViewController {
	if (self.presentedViewController) {
		[self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
	}
}

#pragma mark -  show & hide HUD
//在self.view上显示hud
- (MBProgressHUD *)showHUDLoading:(NSString *)hintString {
	return [self showHUDLoading:hintString onView:self.view];
}
//在window上显示hud
- (MBProgressHUD *)showHUDLoadingOnWindow:(NSString *)hintString {
	return [self showHUDLoading:hintString onView:KeyWindow];
}
//显示hud的通用方法
- (MBProgressHUD *)showHUDLoading:(NSString *)hintString onView:(UIView *)view {
	MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
	if (hud) {
		[hud show:YES];
	}
	else {
		hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
	}
	hud.labelText = hintString;
	hud.mode = MBProgressHUDModeIndeterminate;
	return hud;
}
//隐藏self.view上的hud
- (void)hideHUDLoading {
	[self hideHUDLoadingOnView:self.view];
}
//隐藏window上的hud
- (void)hideHUDLoadingOnWindow {
	[self hideHUDLoadingOnView:KeyWindow];
}
//隐藏hud的通用方法
- (void)hideHUDLoadingOnView:(UIView *)view {
	MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
	[hud hide:YES];
}
//直接隐藏self.view上的hud
- (void)showResultThenHide:(NSString *)resultString {
	[self showResultThenHide:resultString afterDelay:kHudIntervalNormal onView:self.view];
}
//直接隐藏window上的hud
- (void)showResultThenHideOnWindow:(NSString *)resultString {
	[self showResultThenHide:resultString afterDelay:kHudIntervalNormal onView:KeyWindow];
}
//延迟隐藏self.view上的hud,返回上一级
- (void)showResultThenPop:(NSString *)resultString {
	[self showResultThenHide:resultString afterDelay:kHudIntervalNormal onView:self.view];
	[self performSelector:@selector(popViewController) withObject:nil afterDelay:kHudIntervalNormal];
}
//延迟隐藏window上的hud后，返回上一级
- (void)showResultThenPopOnWindow:(NSString *)resultString {
	[self showResultThenHide:resultString afterDelay:kHudIntervalNormal onView:KeyWindow];
	[self performSelector:@selector(popViewController) withObject:nil afterDelay:kHudIntervalNormal];
}
//延迟隐藏self.view上的hud后，并返回上一级或dismiss
- (void)showResultThenBack:(NSString *)resultString {
	[self showResultThenHide:resultString afterDelay:kHudIntervalNormal onView:self.view];
	[self performSelector:@selector(backViewController) withObject:nil afterDelay:kHudIntervalNormal];
}
//延迟隐藏window上的hud后，并返回上一级或dismiss
- (void)showResultThenBackOnWindow:(NSString *)resultString {
	[self showResultThenHide:resultString afterDelay:kHudIntervalNormal onView:KeyWindow];
	[self performSelector:@selector(backViewController) withObject:nil afterDelay:kHudIntervalNormal];
}
//延迟隐藏self.view上的hud后，并dismiss
- (void)showResultThenDismiss:(NSString *)resultString {
    [self showResultThenHide:resultString afterDelay:kHudIntervalNormal onView:self.view];
	
    if (self.presentingViewController) {
        [self performSelector:@selector(dismissOnPresentingViewController) withObject:nil afterDelay:kHudIntervalNormal];
	}
    else {
        [self performSelector:@selector(dismissOnPresentedViewController) withObject:nil afterDelay:kHudIntervalNormal];
    }
}
//延迟隐藏window上的hud后，并dismiss
- (void)showResultThenDismissOnWindow:(NSString *)resultString {
    [self showResultThenHide:resultString afterDelay:kHudIntervalNormal onView:KeyWindow];
    
    if (self.presentingViewController) {
        [self performSelector:@selector(dismissOnPresentingViewController) withObject:nil afterDelay:kHudIntervalNormal];
	}
    else {
        [self performSelector:@selector(dismissOnPresentedViewController) withObject:nil afterDelay:kHudIntervalNormal];
    }
}
//延迟隐藏view上hud的通用方法
- (void)showResultThenHide:(NSString *)resultString afterDelay:(NSTimeInterval)delay onView:(UIView *)view {
	MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
	if (!hud) {
		hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
	}
	hud.labelText = resultString;
	hud.mode = MBProgressHUDModeText;
	[hud show:YES];
	[hud hide:YES afterDelay:delay];
}

#pragma mark - alert view

- (UIAlertView *)showAlertVieWithMessage:(NSString *)message {
    return [self showAlertViewWithTitle:@"提示" andMessage:message block:nil];
}
- (UIAlertView *)showAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message {
	return [self showAlertViewWithTitle:title andMessage:message block:nil];
}
- (UIAlertView *)showAlertVieWithMessage:(NSString *)message block:(YSCResultBlock)block {
    return [self showAlertViewWithTitle:@"提示" andMessage:message block:block];
}
- (UIAlertView *)showAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message block:(YSCResultBlock)block {
    UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:title message:message];
    [alertView bk_setCancelButtonWithTitle:@"确定" handler:^{
        if (block) {
            block(nil);
        }
    }];
    [alertView show];
    return alertView;
}

#pragma mark - Overridden methods 缓存相关
- (id)cachedObjectForKey:(NSString *)cachedKey {
	return [self cachedObjectForKey:cachedKey withSuffix:nil];
}
- (id)cachedObjectForKey:(NSString *)cachedKey withSuffix:(NSString *)suffix {
    NSString *fileName = [NSString stringWithFormat:@"%@%@.dat",
                          NSStringFromClass(self.class),
                          [NSString isEmpty:suffix] ? @"" :[NSString stringWithFormat:@"_%@",suffix]]; //缓存文件名称
    return YSCGetCacheObjectByFile(cachedKey, fileName);
}
- (void)saveObject:(id)object forKey:(NSString *)cachedKey {
	[self saveObject:object forKey:cachedKey withSuffix:nil];
}
- (void)saveObject:(id)object forKey:(NSString *)cachedKey withSuffix:(NSString *)suffix {
    NSString *fileName = [NSString stringWithFormat:@"%@%@.dat",
                          NSStringFromClass(self.class),
                          [NSString isEmpty:suffix] ? @"" :[NSString stringWithFormat:@"_%@",suffix]]; //缓存文件名称
    
    YSCSaveCacheObjectByFile(object, cachedKey, fileName);
}

/**
 *  加载本地缓存数据
 *  同时初始化为NSMutableArray
 */
- (NSMutableArray *)commonLoadCaches:(NSString *)cacheKey {
    NSMutableArray *cacheArray = [NSMutableArray array];
    NSArray *tempArray = [self cachedObjectForKey:cacheKey];
    if ([tempArray isKindOfClass:[NSArray class]] && [NSArray isNotEmpty:tempArray]) {
        [cacheArray addObjectsFromArray:tempArray];
    }
    return cacheArray;
}

#pragma mark - Overridden methods 业务相关
//用户登录状态改变了
- (void)userLoginStatusChanged {
}
//APP恢复运行
- (void)didAppBecomeActive {
}
//用户按下Home键APP进入后台
- (void)didAppEnterBackground {
}

/**
 *  返回自定义的在navigationBar上的按钮
 *
 *  @param customButton
 *  @param width        -10
 *
 *  @return
 */
- (NSArray *)customBarButtonOnNavigationBar:(UIView *)customButton withFixedSpaceWidth:(NSInteger)width {
	UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customButton];
	UIBarButtonItem *flexSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                target:self
                                                                                action:nil];
	flexSpacer.width = width;
	return [NSArray arrayWithObjects:flexSpacer, leftButtonItem, nil];
}

/**
 *  在自定义navigationBar上的返回按钮点击事件，
 *  返回上一级（如果有导航条最多只返回到根，如果没有导航条就dismiss）
 *
 *  @param sender
 */
- (IBAction)backButtonClicked:(id)sender {
	[self backViewController];
}

/**
 *  返回上一级按钮
 *  如果是rootViewController了，就dismiss
 *
 *  @param sender
 */
- (IBAction)popButtonClicked:(id)sender {
	[self popViewController];
}

/**
 *  点击侧边栏
 *
 *  @param sender
 */
- (IBAction)leftSlideButtonClicked:(id)sender {
	[self hideKeyboard];
	//    if (self.drawerController) {
	//        [self.drawerController toggleDrawerSide:XHDrawerSideLeft
	//        animated:YES completion:nil];
	//    }
}

/**
 *  设置是否显示自定义titleBar
 *  默认不显示
 */
- (BOOL)showCustomTitleBarView {
	return NO;
}
- (void)hideKeyboard {
	[self.view endEditing:YES];
}
- (BOOL)willCareKeyboard {
	return NO;
}
- (void)willLayoutForKeyboardHeight:(CGFloat)keyboardHeight {
}
- (void)layoutForKeyboardHeight:(CGFloat)keyboardHeight {
}
- (void)didLayoutForKeyboardHeight:(CGFloat)keyboardHeight {
}
- (void)networkReachablityChanged:(BOOL)reachable {
	if (!reachable) {
		[self showResultThenHideOnWindow:@"网络断开了"];
	}
}
//专门针对tableview的seperator左右间隔进行设置
- (UIEdgeInsets)edgeInsetsOfCellSeperator {
    return UIEdgeInsetsZero;
}
- (void)callBlock {
    WEAKSELF
    [self bk_performBlock:^(id obj) {
        if (weakSelf.block) {
            weakSelf.block(nil);
        }
    } afterDelay:1];
}

#pragma mark - Observe KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

}

#pragma mark - InterfaceOrientation
- (BOOL)shouldAutorotate {
    return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
//使用这个方法是有前提的，就是当前ViewController是通过全屏的Presentation方式展现出来的。
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//    return UIInterfaceOrientationPortraitUpsideDown | UIInterfaceOrientationPortrait | UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight;
//}

@end

