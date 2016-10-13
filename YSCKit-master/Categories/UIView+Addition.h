//
//  UIView+Addition.h
//  YSCKit
//
//  Created by  YangShengchao on 14-7-1.
//  Copyright (c) 2014年 yangshengchao. All rights reserved.
//  FORMATED!
//

#import <UIKit/UIKit.h>
#import "ZYQAssetPickerController.h"

@interface UIView (Addition)

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;

@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;

@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize  size;

/**
 *  移除view上所有的手势操作
 */
- (void)removeAllGestureRecognizers;
/**
 *  移除view上所有的子view
 */
- (void)removeAllSubviews;
/**
 *  移除view(包括subviews)上所有constraints
 */
- (void)removeAllConstraints;
/**
 *  隐藏所有子view
 */
- (void)hideAllSubviews;

#pragma mark - 图片选择器
//弹出选择器
+ (UIActionSheet *)ShowImagePickerActionSheetonViewController:(UIViewController *)viewController
                                            numberOfSelection:(NSInteger)numberOfSelection;
+ (UIActionSheet *)ShowImagePickerActionSheetonViewController:(UIViewController *)viewController
                                            numberOfSelection:(NSInteger)numberOfSelection
                                                  cameraTitle:(NSString *)cameraTitle
                                             imagePickerTitle:(NSString *)imagePickerTitle;
//弹出系统相机进行拍照
+ (void)PresentCameraPickerOnViewController:(UIViewController *)viewController;
//弹出图片选择器
+ (void)PresentImagePickerOnViewController:(UIViewController *)viewController numberOfSelection:(NSInteger)numberOfSelection;
//统一创建UIImagePickerController
+ (UIImagePickerController *)CreateImagePickerController:(UIImagePickerControllerSourceType)sourceType
                                           allowsEditing:(BOOL)allowsEditing
                                                delegate:(id)delegate;

#pragma mark - view边框调整
+ (void)makeCircleForView:(UIView *)view;
- (void)makeCircleView;
+ (void)makeRoundForView:(UIView *)view withRadius:(CGFloat)radius;
- (void)makeRoundWithRadius:(CGFloat)radius;

+ (void)makeBorderForView:(UIView *)view;
- (void)makeBorderLine;
+ (void)makeBorderForView:(UIView *)view withColor:(UIColor *)color borderWidth:(CGFloat)width;
- (void)makeBorderWithColor:(UIColor *)color borderWidth:(CGFloat)width;

#pragma mark - 添加手势
/**
 *	实现水平方向上左右滑动的动画效果
 *
 *	@param	view	需要做动画的view
 *	@param	subtype	方向 kCATransitionFromRight、kCATransitionFromLeft
 */
+ (void)animateHorizontalSwipe:(UIView *)view withSubType:(NSString *)subtype;
- (void)animateHorizontalSwipeWithSubType:(NSString *)subtype;
+ (void)add1fingerHorizontalSwipe:(UIView *)view
                     swipeToRight:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))toRightBlock
                      swipeToLeft:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))toLeftBlock;


#pragma mark - 截图
+ (UIImage *)screenshotOfView:(UIView *) view;
- (UIImage *)screenshotOfView;


#pragma mark - 递归遍历所有子view

+ (void)resetFontSizeOfView:(UIView *)view;
- (void)resetFontSizeOfView;

+ (void)resetConstraintOfView:(UIView *)view;
- (void)resetConstraintOfView;

#pragma mark - 计算自动布局的size
- (void)autoLayoutSize;

/**
 *  这里的HUD和AlertView主要用于非BaseViewController的情况下调用
 *
 */
#pragma mark -  show & hide HUD
- (MBProgressHUD *)showHUDLoading:(NSString *)hintString;
+ (MBProgressHUD *)showHUDLoadingOnWindow:(NSString *)hintString;
- (void)hideHUDLoading;
+ (void)hideHUDLoadingOnWindow;
- (void)showResultThenHide:(NSString *)resultString;
+ (void)showResultThenHideOnWindow:(NSString *)resultString;
+ (void)showResultThenHideOnWindow:(NSString *)resultString afterDelay:(NSTimeInterval)delay;

#pragma mark - alert view
+ (UIAlertView *)showAlertVieWithMessage:(NSString *)message;
+ (UIAlertView *)showAlertViewWithMessage:(NSString *)message block:(YSCResultBlock)block;
+ (UIAlertView *)showAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message;
+ (UIAlertView *)showAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message block:(YSCResultBlock)block;

#pragma mark - current view controller
- (UIViewController *)currentViewController;
+ (UIViewController *)currentViewController;
+ (UIViewController *)getVisibleViewControllerFrom:(UIViewController *)viewController;

#pragma mark - UITableView insert cell
+ (void)insertTableViewCell:(UITableView *)tableView oldCount:(NSInteger)oldCount addCount:(NSInteger)addCount;

#pragma mark - UICollectionView insert cell
+ (void)insertCollectionViewCell:(UICollectionView *)collectionView oldCount:(NSInteger)oldCount addCount:(NSInteger)addCount;

@end


@interface UIView (Animation)

+ (void)flipView:(UIView *)view withTransition:(UIViewAnimationTransition)transition duration:(CGFloat)duration;

@end
