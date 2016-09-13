//
//  UIView+PisenKit.h
//  PisenKit
//
//  Created by 杨胜超 on 16/6/30.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import <UIKit/UIKit.h>

//==============================================================================
//
//  常用方法
//
//==============================================================================
@interface UIView (PisenKit)
@property (nonatomic) CGFloat psk_left;
@property (nonatomic) CGFloat psk_top;
@property (nonatomic) CGFloat psk_width;
@property (nonatomic) CGFloat psk_height;
@property (nonatomic) CGFloat psk_centerX;
@property (nonatomic) CGFloat psk_centerY;
@property (nonatomic) CGPoint psk_origin;

- (void)psk_removeAllGestureRecognizers;
- (void)psk_removeAllSubviews;
- (void)psk_removeAllConstraints;       //移除view(包括subviews)上所有constraints
- (void)psk_hideAllSubviews;
- (UIViewController *)psk_viewController;

/** view边框 */
- (void)psk_addCornerWithRadius:(CGFloat)radius;
- (void)psk_makeBorderWithColor:(UIColor *)color borderWidth:(CGFloat)width;

/** view截图 */
- (UIImage *)psk_snapshotImage;
- (UIImage *)psk_snapshotImageAfterScreenUpdates:(BOOL)afterUpdates;
- (NSData *)psk_snapshotPDF;
- (void)psk_addLayerShadow:(UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius;
@end


//==============================================================================
//
//  手势处理
//
//==============================================================================
@interface UIView (PisenKit_HandleGesture)
- (void)psk_addSingleTapWithBlock:(void (^)(void))block;
- (void)psk_reAddSingleTapWithBlock:(void (^)(void))block;
- (void)psk_addDoubleTapWithBlock:(void (^)(void))block;
- (void)psk_reAddDoubleTapWithBlock:(void (^)(void))block;
- (void)psk_removeAllTapGestures;

/**
 *	实现水平方向上左右滑动的动画效果
 *
 *	@param	view	需要做动画的view
 *	@param	subtype	方向 kCATransitionFromRight、kCATransitionFromLeft
 */
- (void)psk_animateHorizontalSwipeWithSubType:(NSString *)subtype;
- (void)psk_flipWithTransition:(UIViewAnimationTransition)transition duration:(CGFloat)duration;
@end


//==============================================================================
//
//  自动布局动态计算
//
//==============================================================================
@interface UIView (PisenKit_AutoLayout)
/**
 *  如果存在自定义属性doNotResetFont，则该view不重置字体大小
 */
- (void)psk_resetFontSize;
- (void)psk_resetFontSizeByXibWidth:(CGFloat)xibWidth;
/**
 *  如果存在自定义属性doNotResetConstraint，则该view不重置约束
 */
- (void)psk_resetConstraint;
- (void)psk_resetConstraintByXibWidth:(CGFloat)xibWidth;
@end


//==============================================================================
//
//  从xib加载新的view
//
//==============================================================================
@interface UIView (PisenKit_LoadFromNib)
+ (instancetype)psk_loadFromNib;
+ (instancetype)psk_loadFromNibName:(NSString *)nibName;
+ (instancetype)psk_loadFromNibName:(NSString *)nibName index:(NSInteger)index;
@end


