//
//  UIView+YSCKit.h
//  YSCKit
//
//  Created by  YangShengchao on 14-7-1.
//  Copyright (c) 2014年 yangshengchao. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 常用方法封装 */
@interface UIView (YSCKit)
@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;
@property (nonatomic) CGPoint origin;

- (void)removeAllGestureRecognizers;
- (void)removeAllSubviews;
- (void)removeAllConstraints;       //移除view(包括subviews)上所有constraints
- (void)hideAllSubviews;
- (UIViewController *)viewController;

/** view边框 */
- (void)addCornerWithRadius:(CGFloat)radius;
- (void)addCorner:(UIRectCorner)corner withRaidus:(CGFloat)radius;
- (void)makeBorderLine;
- (void)makeBorderWithColor:(UIColor *)color borderWidth:(CGFloat)width;

- (void)makeImageViewRadius:(CGFloat)radius size:(CGSize)sizeToFit YSCDeprecated("不能兼容 image.size != imageView.size 的情况！！！");
- (void)makeViewRadius:(CGFloat)radius size:(CGSize)sizeToFit YSCDeprecated("不能兼容view中有背景图片的情况！！！");


/** view截图 */
- (UIImage *)snapshotImage;
- (UIImage *)snapshotImageAfterScreenUpdates:(BOOL)afterUpdates;
- (NSData *)snapshotPDF;
- (void)addLayerShadow:(UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius;


/** 递归遍历所有子view */
- (void)resetSize;
- (void)resetFontSize;
- (void)resetFontSizeByXibWidth:(CGFloat)xibWidth;
- (void)resetConstraint;
- (void)resetConstraintByXibWidth:(CGFloat)xibWidth;
@end



/** 手势处理 */
@interface UIView (Gesture)
// tap gesture
- (void)addSingleTapWithBlock:(void (^)(void))block;
- (void)reAddSingleTapWithBlock:(void (^)(void))block;
- (void)addDoubleTapWithBlock:(void (^)(void))block;
- (void)reAddDoubleTapWithBlock:(void (^)(void))block;
- (void)removeAllTapGestures;

/**
 *	实现水平方向上左右滑动的动画效果
 *
 *	@param	view	需要做动画的view
 *	@param	subtype	方向 kCATransitionFromRight、kCATransitionFromLeft
 */
- (void)animateHorizontalSwipeWithSubType:(NSString *)subtype;
- (void)flipWithTransition:(UIViewAnimationTransition)transition duration:(CGFloat)duration;
@end




/** 坐标转换 reference: UIView+YYAdd */
@interface UIView (ConvertPoint)
/**
 Converts a point from the receiver's coordinate system to that of the specified view or window.
 
 @param point A point specified in the local coordinate system (bounds) of the receiver.
 @param view  The view or window into whose coordinate system point is to be converted.
 If view is nil, this method instead converts to window base coordinates.
 @return The point converted to the coordinate system of view.
 */
- (CGPoint)convertPoint:(CGPoint)point toViewOrWindow:(UIView *)view;

/**
 Converts a point from the coordinate system of a given view or window to that of the receiver.
 
 @param point A point specified in the local coordinate system (bounds) of view.
 @param view  The view or window with point in its coordinate system.
 If view is nil, this method instead converts from window base coordinates.
 @return The point converted to the local coordinate system (bounds) of the receiver.
 */
- (CGPoint)convertPoint:(CGPoint)point fromViewOrWindow:(UIView *)view;

/**
 Converts a rectangle from the receiver's coordinate system to that of another view or window.
 
 @param rect A rectangle specified in the local coordinate system (bounds) of the receiver.
 @param view The view or window that is the target of the conversion operation. If view is nil, this method instead converts to window base coordinates.
 @return The converted rectangle.
 */
- (CGRect)convertRect:(CGRect)rect toViewOrWindow:(UIView *)view;

/**
 Converts a rectangle from the coordinate system of another view or window to that of the receiver.
 
 @param rect A rectangle specified in the local coordinate system (bounds) of view.
 @param view The view or window with rect in its coordinate system.
 If view is nil, this method instead converts from window base coordinates.
 @return The converted rectangle.
 */
- (CGRect)convertRect:(CGRect)rect fromViewOrWindow:(UIView *)view;
@end


