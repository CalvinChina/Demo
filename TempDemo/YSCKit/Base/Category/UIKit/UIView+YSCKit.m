//
//  UIView+YSCKit.m
//  YSCKit
//
//  Created by  YangShengchao on 14-7-1.
//  Copyright (c) 2014年 yangshengchao. All rights reserved.
//

#import "UIView+YSCKit.h"
#import <objc/runtime.h>

@implementation UIView (YSCKit)
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
- (CGPoint)origin {
    return self.frame.origin;
}
- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
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
- (UIViewController *)viewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

#pragma mark - view边框调整
/**
 *  优点：兼容所有情况！
 *  缺点：导致离屏渲染问题
 */
- (void)addCornerWithRadius:(CGFloat)radius {
    // 方法一：
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
    
    // 方法二：
//    [self addCorner:UIRectCornerAllCorners withRaidus:radius];
}
- (void)addCorner:(UIRectCorner)corner withRaidus:(CGFloat)radius {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                               byRoundingCorners:corner
                                                     cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = self.bounds;
    layer.path = path.CGPath;
    self.layer.mask = layer;
}
- (void)makeBorderLine {
    [self makeBorderWithColor:YSCConfigDataInstance.defaultBorderColor borderWidth:1];
}
- (void)makeBorderWithColor:(UIColor *)color borderWidth:(CGFloat)width {
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
}

/**
 *  专门针对UIImageView和UIView作圆角
 *  方法的本质：画一个圆角背景图片来代替原来的。
 *  优点：高效不会导致离屏渲染、可以控制圆角的方位
 *  确定：无法兼容所有情况！
 */
- (void)makeImageViewRadius:(CGFloat)radius size:(CGSize)sizeToFit {
    UIImageView *imageView = (UIImageView *)self;
    if (imageView.image) {
        [imageView setImage:[self _makeImageViewRadiusImage:radius size:AUTOLAYOUT_SIZE(imageView.image.size)]];
        self.backgroundColor = [UIColor clearColor];
        return;
    }
}
- (void)makeViewRadius:(CGFloat)radius size:(CGSize)sizeToFit {
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:[self _makeViewRadiusImage:radius size:sizeToFit]];
    self.backgroundColor = [UIColor clearColor];
    [self insertSubview:backImageView atIndex:0];
}
- (UIImage *)_makeImageViewRadiusImage:(CGFloat)radius size:(CGSize)sizeToFit {
    CGRect rect = CGRectMake(0, 0, sizeToFit.width, sizeToFit.height);
    
    UIGraphicsBeginImageContextWithOptions(sizeToFit, false, [UIScreen mainScreen].scale);
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                     byRoundingCorners:UIRectCornerAllCorners //TODO:这里可以控制
                                                           cornerRadii:CGSizeMake(radius, radius)];
    CGContextAddPath(UIGraphicsGetCurrentContext(), bezierPath.CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    
    [self drawRect:rect];
    CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathFillStroke);
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return output;
}
- (UIImage *)_makeViewRadiusImage:(CGFloat)radius size:(CGSize)sizeToFit {
    UIColor *borderColor = [UIColor clearColor];
    UIColor *backgroundColor = self.backgroundColor;
    
    UIGraphicsBeginImageContextWithOptions(sizeToFit, false, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 0);
    CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
    
    CGFloat width = sizeToFit.width, height = sizeToFit.height;
    CGContextMoveToPoint(context, width, radius);  // 坐标右边开始
    CGContextAddArcToPoint(context, width, height, width - radius, height, radius);  // 右下角角度
    
    //    CGContextAddLineToPoint(context, 0, height);
    //    CGContextAddLineToPoint(context, 0, 0);
    //    CGContextAddLineToPoint(context, width, 0);
    //    CGContextAddLineToPoint(context, width, radius);
    
    CGContextAddArcToPoint(context, 0, height, 0, height - radius, radius); // 左下角角度
    CGContextAddArcToPoint(context, 0, 0, width, 0, radius); // 左上角
    CGContextAddArcToPoint(context, width, 0, width, radius, radius); // 右上角
    
    CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathFillStroke);
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return output;
}


#pragma mark - 截图
- (UIImage *)snapshotImage {
    UIGraphicsBeginImageContext(self.frame.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    __autoreleasing UIImage *fullImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return fullImage;
}
- (UIImage *)snapshotImageAfterScreenUpdates:(BOOL)afterUpdates {
    if (![self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        return [self snapshotImage];
    }
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:afterUpdates];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}
- (NSData *)snapshotPDF {
    CGRect bounds = self.bounds;
    NSMutableData *data = [NSMutableData data];
    CGDataConsumerRef consumer = CGDataConsumerCreateWithCFData((__bridge CFMutableDataRef)data);
    CGContextRef context = CGPDFContextCreate(consumer, &bounds, NULL);
    CGDataConsumerRelease(consumer);
    if (!context) return nil;
    CGPDFContextBeginPage(context, NULL);
    CGContextTranslateCTM(context, 0, bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    [self.layer renderInContext:context];
    CGPDFContextEndPage(context);
    CGPDFContextClose(context);
    CGContextRelease(context);
    return data;
}
- (void)addLayerShadow:(UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius {
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = 1;
    self.layer.masksToBounds = NO;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}


#pragma mark - 递归遍历所有子view
- (void)resetSize {
    [self resetFontSize];
    [self resetConstraint];
}
- (void)resetFontSize {
    [self resetFontSizeByXibWidth:YSCConfigDataInstance.xibWidth];
}
- (void)resetFontSizeByXibWidth:(CGFloat)xibWidth {
    for (UIView *subview in self.subviews) {
        if ([subview respondsToSelector:@selector(setCloseResetFontAndConstraint:)]) {
            continue;
        }
        if ([subview isMemberOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)subview;
            label.font = AUTOLAYOUT_FONT_W(label.font.pointSize, xibWidth);
        }
        else if ([subview isMemberOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            button.titleLabel.font = AUTOLAYOUT_FONT_W(button.titleLabel.font.pointSize, xibWidth);
            button.contentEdgeInsets = UIEdgeInsetsMake(AUTOLAYOUT_LENGTH_W(button.contentEdgeInsets.top, xibWidth),
                                                        AUTOLAYOUT_LENGTH_W(button.contentEdgeInsets.left, xibWidth),
                                                        AUTOLAYOUT_LENGTH_W(button.contentEdgeInsets.bottom, xibWidth),
                                                        AUTOLAYOUT_LENGTH_W(button.contentEdgeInsets.right, xibWidth));
            
            button.titleEdgeInsets = UIEdgeInsetsMake(AUTOLAYOUT_LENGTH_W(button.titleEdgeInsets.top, xibWidth),
                                                      AUTOLAYOUT_LENGTH_W(button.titleEdgeInsets.left, xibWidth),
                                                      AUTOLAYOUT_LENGTH_W(button.titleEdgeInsets.bottom, xibWidth),
                                                      AUTOLAYOUT_LENGTH_W(button.titleEdgeInsets.right, xibWidth));
            
            button.imageEdgeInsets = UIEdgeInsetsMake(AUTOLAYOUT_LENGTH_W(button.imageEdgeInsets.top, xibWidth),
                                                      AUTOLAYOUT_LENGTH_W(button.imageEdgeInsets.left, xibWidth),
                                                      AUTOLAYOUT_LENGTH_W(button.imageEdgeInsets.bottom, xibWidth),
                                                      AUTOLAYOUT_LENGTH_W(button.imageEdgeInsets.right, xibWidth));
        }
        else if ([subview isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)subview;
            textField.font = AUTOLAYOUT_FONT_W(textField.font.pointSize, xibWidth);
        }
        else if ([subview isKindOfClass:[UITextView class]]) {
            UITextView *textView = (UITextView *)subview;
            textView.font = AUTOLAYOUT_FONT_W(textView.font.pointSize, xibWidth);
        }
        [subview resetFontSizeByXibWidth:xibWidth];
    }
}
- (void)resetConstraint {
    [self resetConstraintByXibWidth:YSCConfigDataInstance.xibWidth];
}
- (void)resetConstraintByXibWidth:(CGFloat)xibWidth {
    for (NSLayoutConstraint *constraint in self.constraints) {
        if (constraint.constant > 0) {
            constraint.constant = AUTOLAYOUT_LENGTH_W((constraint.constant), xibWidth);
        }
    }
    if ([self respondsToSelector:@selector(setCloseResetFontAndConstraint:)]) {
        return;
    }
    
    if ([self.subviews count] > 0) {
        for (UIView *subView in self.subviews) {
            [subView resetConstraintByXibWidth:xibWidth];
        }
    }
}
@end


/** 手势处理 */
@implementation UIView (Gesture)
// tap gesture
- (void)addSingleTapWithBlock:(void (^)(void))block {
    [self _addTapWithTouches:1 tapped:1 handler:block];
}
- (void)reAddSingleTapWithBlock:(void (^)(void))block {
    [self removeAllGestureRecognizers];
    [self addSingleTapWithBlock:block];
}
- (void)addDoubleTapWithBlock:(void (^)(void))block {
    [self _addTapWithTouches:1 tapped:2 handler:block];
}
- (void)reAddDoubleTapWithBlock:(void (^)(void))block {
    [self removeAllGestureRecognizers];
    [self addDoubleTapWithBlock:block];
}
- (void)removeAllTapGestures {
    for (UIGestureRecognizer *gesture in self.gestureRecognizers) {
        if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
            [self removeGestureRecognizer:gesture];
        }
    }
}
- (void)_addTapWithTouches:(NSUInteger)numberOfTouches
                    tapped:(NSUInteger)numberOfTaps
                   handler:(void (^)(void))block {
    if (!block) return;
    self.tapBlock = block;
    
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleAction:)];
    gesture.numberOfTouchesRequired = numberOfTouches;
    gesture.numberOfTapsRequired = numberOfTaps;
    [self.gestureRecognizers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![obj isKindOfClass:[UITapGestureRecognizer class]]) return;
        UITapGestureRecognizer *tap = obj;
        BOOL rightTouches = (tap.numberOfTouchesRequired == numberOfTouches);
        BOOL rightTaps = (tap.numberOfTapsRequired == numberOfTaps);
        if (rightTouches && rightTaps) {
            [gesture requireGestureRecognizerToFail:tap];
        }
    }];
    [self addGestureRecognizer:gesture];
}
- (void)_handleAction:(UIGestureRecognizer *)recognizer {
    if (UIGestureRecognizerStateRecognized == recognizer.state) {
        if (self.tapBlock) {
            self.tapBlock();
        }
    }
}
- (void)setTapBlock:(void (^)(void))object {
    [self willChangeValueForKey:@"tapBlock"];
    objc_setAssociatedObject(self, _cmd, object, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"tapBlock"];
}
- (void (^)(void))tapBlock {
    return objc_getAssociatedObject(self, @selector(setTapBlock:));
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
- (void)flipWithTransition:(UIViewAnimationTransition)transition duration:(CGFloat)duration {
    [UIView beginAnimations:@"animationID" context:nil];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationTransition:transition forView:self cache:YES];
    [UIView commitAnimations];
}
@end



/** 坐标转换 reference: UIView+YYAdd */
@implementation UIView (ConvertPoint)
- (CGPoint)convertPoint:(CGPoint)point toViewOrWindow:(UIView *)view {
    if (!view) {
        if ([self isKindOfClass:[UIWindow class]]) {
            return [((UIWindow *)self) convertPoint:point toWindow:nil];
        } else {
            return [self convertPoint:point toView:nil];
        }
    }
    
    UIWindow *from = [self isKindOfClass:[UIWindow class]] ? (id)self : self.window;
    UIWindow *to = [view isKindOfClass:[UIWindow class]] ? (id)view : view.window;
    if ((!from || !to) || (from == to)) return [self convertPoint:point toView:view];
    point = [self convertPoint:point toView:from];
    point = [to convertPoint:point fromWindow:from];
    point = [view convertPoint:point fromView:to];
    return point;
}
- (CGPoint)convertPoint:(CGPoint)point fromViewOrWindow:(UIView *)view {
    if (!view) {
        if ([self isKindOfClass:[UIWindow class]]) {
            return [((UIWindow *)self) convertPoint:point fromWindow:nil];
        } else {
            return [self convertPoint:point fromView:nil];
        }
    }
    
    UIWindow *from = [view isKindOfClass:[UIWindow class]] ? (id)view : view.window;
    UIWindow *to = [self isKindOfClass:[UIWindow class]] ? (id)self : self.window;
    if ((!from || !to) || (from == to)) return [self convertPoint:point fromView:view];
    point = [from convertPoint:point fromView:view];
    point = [to convertPoint:point fromWindow:from];
    point = [self convertPoint:point fromView:to];
    return point;
}
- (CGRect)convertRect:(CGRect)rect toViewOrWindow:(UIView *)view {
    if (!view) {
        if ([self isKindOfClass:[UIWindow class]]) {
            return [((UIWindow *)self) convertRect:rect toWindow:nil];
        } else {
            return [self convertRect:rect toView:nil];
        }
    }
    
    UIWindow *from = [self isKindOfClass:[UIWindow class]] ? (id)self : self.window;
    UIWindow *to = [view isKindOfClass:[UIWindow class]] ? (id)view : view.window;
    if (!from || !to) return [self convertRect:rect toView:view];
    if (from == to) return [self convertRect:rect toView:view];
    rect = [self convertRect:rect toView:from];
    rect = [to convertRect:rect fromWindow:from];
    rect = [view convertRect:rect fromView:to];
    return rect;
}
- (CGRect)convertRect:(CGRect)rect fromViewOrWindow:(UIView *)view {
    if (!view) {
        if ([self isKindOfClass:[UIWindow class]]) {
            return [((UIWindow *)self) convertRect:rect fromWindow:nil];
        } else {
            return [self convertRect:rect fromView:nil];
        }
    }
    
    UIWindow *from = [view isKindOfClass:[UIWindow class]] ? (id)view : view.window;
    UIWindow *to = [self isKindOfClass:[UIWindow class]] ? (id)self : self.window;
    if ((!from || !to) || (from == to)) return [self convertRect:rect fromView:view];
    rect = [from convertRect:rect fromView:view];
    rect = [to convertRect:rect fromWindow:from];
    rect = [self convertRect:rect fromView:to];
    return rect;
}
@end

