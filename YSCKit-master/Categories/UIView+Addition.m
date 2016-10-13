//
//  UIView+Addition.m
//  YSCKit
//
//  Created by  YangShengchao on 14-7-1.
//  Copyright (c) 2014年 yangshengchao. All rights reserved.
//

#import "UIView+Addition.h"


@implementation UIView (Addition)


- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}


- (void)removeAllGestureRecognizers {
    for (UIGestureRecognizer *gesture in self.gestureRecognizers) {
        [self removeGestureRecognizer:gesture];
    }    
}

- (void)removeAllSubviews {
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
}

- (void)removeAllConstraints {
    for (NSLayoutConstraint *constraint in self.constraints) {
#if __PureLayout_MinBaseSDK_iOS_8_0
        if ([self respondsToSelector:@selector(setActive:)]) {
            constraint.active = NO;
        }
#endif /* __PureLayout_MinBaseSDK_iOS_8_0 */
        
        if (constraint.firstItem) {
            [constraint.firstItem removeConstraint:constraint];
        }
        if (constraint.secondItem) {
            [constraint.secondItem removeConstraint:constraint];
        }
    }
    for (UIView *subView in self.subviews) {
        [subView removeAllConstraints];
    }
}

- (void)hideAllSubviews {
    for (UIView *subView in self.subviews) {
        subView.hidden = YES;
    }
}

#pragma mark - 图片选择器
//弹出actionSheet选择器
+ (UIActionSheet *)ShowImagePickerActionSheetonViewController:(UIViewController *)viewController
                                            numberOfSelection:(NSInteger)numberOfSelection {
    return [self ShowImagePickerActionSheetonViewController:viewController
                                          numberOfSelection:numberOfSelection
                                                cameraTitle:@"拍摄照片"
                                           imagePickerTitle:@"选取照片"];
}
+ (UIActionSheet *)ShowImagePickerActionSheetonViewController:(UIViewController *)viewController
                                            numberOfSelection:(NSInteger)numberOfSelection
                                                  cameraTitle:(NSString *)cameraTitle
                                             imagePickerTitle:(NSString *)imagePickerTitle {
    UIActionSheet *actionSheet = [UIActionSheet bk_actionSheetWithTitle:nil];
    [actionSheet bk_addButtonWithTitle:cameraTitle
                               handler:^{
                                   [self PresentCameraPickerOnViewController:viewController];
                               }];
    [actionSheet bk_addButtonWithTitle:imagePickerTitle
                               handler:^{
                                   [self PresentImagePickerOnViewController:viewController numberOfSelection:numberOfSelection];
                               }];
    [actionSheet bk_setCancelButtonWithTitle:@"取消" handler:nil];
    [actionSheet showInView:viewController.view];
    return actionSheet;
}

//弹出系统相机进行拍照
+ (void)PresentCameraPickerOnViewController:(UIViewController *)viewController {
    if (NO == [UIDevice isCanUseCamera]) {
        [UIView showResultThenHideOnWindow:@"请在设置->隐私->相机,打开本应用的权限"];
        return;
    }
    else {
        UIImagePickerController *imagePickerController = [self CreateImagePickerController:UIImagePickerControllerSourceTypeCamera allowsEditing:NO delegate:(id)viewController];
        [viewController presentViewController:imagePickerController animated:YES completion:nil];
    }
}

//弹出图片选择器
+ (void)PresentImagePickerOnViewController:(UIViewController *)viewController numberOfSelection:(NSInteger)numberOfSelection {
    if (NO == [UIDevice isPhotoLibraryAvailable]) {
        [UIView showResultThenHideOnWindow:@"请在设置->隐私->照片,打开本应用的权限"];
        return;
    }
    else {
        if (numberOfSelection > 1) {//多张图片
            ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
            picker.delegate = (id)viewController;
            picker.maximumNumberOfSelection = numberOfSelection;
            picker.assetsFilter = [ALAssetsFilter allPhotos];
            picker.showEmptyGroups = NO;
            picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
                    NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
                    return duration >= 5;
                } else {
                    return YES;
                }
            }];
            [UIResponder ConfigNavigationBar:picker.navigationBar];
            [viewController presentViewController:picker animated:YES completion:NULL];
        }
        else {//选择相册里单张图片
            UIImagePickerController *imagePickerController = [self CreateImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary allowsEditing:NO delegate:(id)viewController];
            [viewController presentViewController:imagePickerController animated:YES completion:nil];
        }
    }
}
//统一创建UIImagePickerController
+ (UIImagePickerController *)CreateImagePickerController:(UIImagePickerControllerSourceType)sourceType
                                           allowsEditing:(BOOL)allowsEditing
                                                delegate:(id)delegate {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = delegate;
    imagePickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagePickerController.allowsEditing = allowsEditing;
    imagePickerController.sourceType = sourceType;
    [UIResponder ConfigNavigationBar:imagePickerController.navigationBar];
    return imagePickerController;
}


#pragma mark - view边框调整
+ (void)makeCircleForView:(UIView *)view {
    ReturnWhenObjectIsEmpty(view);
    [view makeCircleView];
}
- (void)makeCircleView {
    [self makeRoundWithRadius:self.bounds.size.width / 2.0];
}

+ (void)makeRoundForView:(UIView *)view withRadius:(CGFloat)radius {
    ReturnWhenObjectIsEmpty(view);
    [view makeRoundWithRadius:radius];
}
- (void)makeRoundWithRadius:(CGFloat)radius {
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

+ (void)makeBorderForView:(UIView *)view {
    [self makeBorderForView:view withColor:kDefaultBorderColor borderWidth:1];
}
- (void)makeBorderLine {
    [self makeBorderWithColor:kDefaultBorderColor borderWidth:1];
}
+ (void)makeBorderForView:(UIView *)view withColor:(UIColor *)color borderWidth:(CGFloat)width {
    ReturnWhenObjectIsEmpty(view);
    [view makeBorderWithColor:color borderWidth:width];
}
- (void)makeBorderWithColor:(UIColor *)color borderWidth:(CGFloat)width {
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = AUTOLAYOUT_LENGTH(width);
}


#pragma mark - 添加手势
/**
 *	实现水平方向上左右滑动的动画效果
 *
 *	@param	view	需要做动画的view
 *	@param	subtype	方向 kCATransitionFromRight、kCATransitionFromLeft
 */
+ (void)animateHorizontalSwipe:(UIView *)view withSubType:(NSString *)subtype {
    ReturnWhenObjectIsEmpty(view);
    [view animateHorizontalSwipeWithSubType:subtype];
}
- (void)animateHorizontalSwipeWithSubType:(NSString *)subtype {
    CATransition *animation = [CATransition animation];
    animation.duration = 0.2;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.type = kCATransitionPush;
    animation.subtype = subtype;
    [self.layer addAnimation:animation forKey:@"animation"];
}
+ (void)add1fingerHorizontalSwipe:(UIView *)view
                     swipeToRight:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))toRightBlock
                      swipeToLeft:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))toLeftBlock {
    UISwipeGestureRecognizer *swipeRight = [UISwipeGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        NSLog(@"向右滑动，看前面一页");
        if (toRightBlock) {
            toRightBlock(sender, state, location);
        }
    }];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [view addGestureRecognizer:swipeRight];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        NSLog(@"向左滑动，看后面一页");
        if (toLeftBlock) {
            toLeftBlock(sender, state, location);
        }
    }];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [view addGestureRecognizer:swipeLeft];
}


#pragma mark - 截图
//返回UIView全屏截图
+ (UIImage *)screenshotOfView:(UIView *) view {
    ReturnNilWhenObjectIsEmpty(view);
    return [view screenshotOfView];
}
- (UIImage *)screenshotOfView {
    UIGraphicsBeginImageContext(self.frame.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    __autoreleasing UIImage *fullImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return fullImage;
}


#pragma mark - 递归遍历所有子view

//重新调整UILabel和UIButton的font
+ (void)resetFontSizeOfView:(UIView *)view {
    ReturnWhenObjectIsEmpty(view);
    [view resetFontSizeOfView];
}
- (void)resetFontSizeOfView {
    for (UIView *subview in self.subviews) {
        if ([subview respondsToSelector:@selector(setCloseResetFontAndConstraint:)]) {
            continue;
        }
        if ([subview isMemberOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)subview;
            label.font = AUTOLAYOUT_FONT(label.font.pointSize);
        }
        else if ([subview isMemberOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            button.titleLabel.font = AUTOLAYOUT_FONT(button.titleLabel.font.pointSize);
        }
        else if ([subview isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)subview;
            textField.font = AUTOLAYOUT_FONT(textField.font.pointSize);
        }
        else if ([subview isKindOfClass:[UITextView class]]) {
            UITextView *textView = (UITextView *)subview;
            textView.font = AUTOLAYOUT_FONT(textView.font.pointSize);
        }
        [subview resetFontSizeOfView];
    }
}

+ (void)resetConstraintOfView:(UIView *)view {
    ReturnWhenObjectIsEmpty(view);
    [view resetConstraintOfView];
}
- (void)resetConstraintOfView {
    for (NSLayoutConstraint *constraint in self.constraints) {
        if (constraint.constant > 0) {
            constraint.constant = AUTOLAYOUT_LENGTH(constraint.constant);
        }
    }
    if ([self respondsToSelector:@selector(setCloseResetFontAndConstraint:)]) {
        return;
    }
    
    if ([self.subviews count] > 0) {
        for (UIView *subView in self.subviews) {
            [subView resetConstraintOfView];
        }
    }
}

#pragma mark - 计算自动布局的size
- (void)autoLayoutSize {
    CGSize size = AUTOLAYOUT_SIZE(self.frame.size);
    self.width = size.width;
    self.height = size.height;
}


#pragma mark -  show & hide HUD
- (MBProgressHUD *)showHUDLoading:(NSString *)hintString {
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self];
    if (hud) {
        [hud show:YES];
    }
    else {
        hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    }
    hud.labelText = hintString;
    hud.mode = MBProgressHUDModeIndeterminate;
    return hud;
}
+ (MBProgressHUD *)showHUDLoadingOnWindow:(NSString *)hintString {
    UIView *view = [UIApplication sharedApplication].keyWindow;
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

- (void)hideHUDLoading {
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self];
    [hud hide:YES];
}
+ (void)hideHUDLoadingOnWindow {
    UIView *view = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
	[hud hide:YES];
}

- (void)showResultThenHide:(NSString *)resultString {
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self];
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    }
    hud.labelText = resultString;
    hud.mode = MBProgressHUDModeText;
    [hud show:YES];
    [hud hide:YES afterDelay:1];
}
+ (void)showResultThenHideOnWindow:(NSString *)resultString {
    [self showResultThenHideOnWindow:resultString afterDelay:1];
}
+ (void)showResultThenHideOnWindow:(NSString *)resultString afterDelay:(NSTimeInterval)delay {
    UIView *view = [UIApplication sharedApplication].keyWindow;
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
+ (UIAlertView *)showAlertVieWithMessage:(NSString *)message {
    return [self showAlertViewWithMessage:message block:nil];
}
+ (UIAlertView *)showAlertViewWithMessage:(NSString *)message block:(YSCResultBlock)block {
    return [self showAlertViewWithTitle:@"提示" andMessage:message block:block];
}
+ (UIAlertView *)showAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message {
    return [self showAlertViewWithTitle:title andMessage:message block:nil];
}
+ (UIAlertView *)showAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message block:(YSCResultBlock)block {
    UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:title message:message];
    [alertView bk_setCancelButtonWithTitle:@"确定" handler:^{
        if (block) {
            block(nil);
        }
    }];
    [alertView show];
    return alertView;
}

#pragma mark - current view controller
- (UIViewController *)currentViewController {
    return nil;
}
+ (UIViewController *)currentViewController {
    UIViewController *viewController = KeyWindow.rootViewController;//NOTE:只有当第一个viewController的viewDidLoad中无法获取
    return [UIView getVisibleViewControllerFrom:viewController];
}
+ (UIViewController *)getVisibleViewControllerFrom:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        return [UIView getVisibleViewControllerFrom:[((UINavigationController *) viewController) visibleViewController]];
    }
    else if ([viewController isKindOfClass:[UITabBarController class]]) {
        return [UIView getVisibleViewControllerFrom:[((UITabBarController *) viewController) selectedViewController]];
    }
    else {
        if (viewController.presentedViewController) {
            return [UIView getVisibleViewControllerFrom:viewController.presentedViewController];
        } else {
            return viewController;
        }
    }
}

#pragma mark - UITableView insert cell
+ (void)insertTableViewCell:(UITableView *)tableView oldCount:(NSInteger)oldCount addCount:(NSInteger)addCount {
    NSMutableArray *insertedIndexPaths = [NSMutableArray array];
    for (int i = 0; i < addCount; i++) {
        [insertedIndexPaths addObject:[NSIndexPath indexPathForRow:oldCount + i inSection:0]];
    }
    [tableView beginUpdates];
    [tableView insertRowsAtIndexPaths:insertedIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView endUpdates];
}

#pragma mark - UICollectionView insert cell
+ (void)insertCollectionViewCell:(UICollectionView *)collectionView oldCount:(NSInteger)oldCount addCount:(NSInteger)addCount {
    [UIView setAnimationsEnabled:NO];//默认的动画效果有点乱，这里先把所有动画关掉
    [collectionView performBatchUpdates:^{
        NSMutableArray *insertedIndexPaths = [NSMutableArray array];
        for (int i = 0; i < addCount; i++) {
            [insertedIndexPaths addObject:[NSIndexPath indexPathForRow:oldCount + i inSection:0]];
        }
        [collectionView insertItemsAtIndexPaths:insertedIndexPaths];
    }
                                              completion:nil];
    [UIView setAnimationsEnabled:YES];
}


@end

@implementation UIView (Animation)

+ (void)flipView:(UIView *)view withTransition:(UIViewAnimationTransition)transition duration:(CGFloat)duration {
    [UIView beginAnimations:@"animationID" context:nil];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationTransition:transition forView:view cache:YES];
    [UIView commitAnimations];
}

@end
