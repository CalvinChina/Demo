//
//  UIView+PisenKit.m
//  PisenKit
//
//  Created by 杨胜超 on 16/6/30.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import "UIView+PisenKit.h"
#import <objc/runtime.h>

//==============================================================================
//
//  常用方法
//
//==============================================================================
@implementation UIView (PisenKit)
- (CGFloat)psk_left {
    return self.frame.origin.x;
}
- (void)setPsk_left:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
- (CGFloat)psk_top {
    return self.frame.origin.y;
}
- (void)setPsk_top:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (CGFloat)psk_width {
    return self.frame.size.width;
}
- (void)setPsk_width:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (CGFloat)psk_height {
    return self.frame.size.height;
}
- (void)setPsk_height:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
- (CGFloat)psk_centerX {
    return self.center.x;
}
- (void)setPsk_centerX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}
- (CGFloat)psk_centerY {
    return self.center.y;
}
- (void)setPsk_centerY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}
- (CGPoint)psk_origin {
    return self.frame.origin;
}
- (void)setPsk_origin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (void)psk_removeAllGestureRecognizers {
    for (UIGestureRecognizer *gesture in self.gestureRecognizers) {
        [self removeGestureRecognizer:gesture];
    }
}
- (void)psk_removeAllSubviews {
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
}
- (void)psk_removeAllConstraints {
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
        [subView psk_removeAllConstraints];
    }
}
- (void)psk_hideAllSubviews {
    for (UIView *subView in self.subviews) {
        subView.hidden = YES;
    }
}
- (UIViewController *)psk_viewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

#pragma mark - view边框调整
- (void)psk_addCornerWithRadius:(CGFloat)radius {
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}
- (void)psk_makeBorderWithColor:(UIColor *)color borderWidth:(CGFloat)width {
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
}

#pragma mark - 截图
- (UIImage *)psk_snapshotImage {
    UIGraphicsBeginImageContext(self.frame.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    __autoreleasing UIImage *fullImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return fullImage;
}
- (UIImage *)psk_snapshotImageAfterScreenUpdates:(BOOL)afterUpdates {
    if (![self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        return [self psk_snapshotImage];
    }
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:afterUpdates];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}
- (NSData *)psk_snapshotPDF {
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
- (void)psk_addLayerShadow:(UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius {
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = 1;
    self.layer.masksToBounds = NO;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}
@end


//==============================================================================
//
//  手势处理
//
//==============================================================================
@implementation UIView (PisenKit_HandleGesture)
// 添加block属性
PSK_DYNAMIC_PROPERTY_OBJECT(tapBlock, setTapBlock, COPY_NONATOMIC, void (^)(void))

- (void)psk_addSingleTapWithBlock:(void (^)(void))block {
    [self _psk_addTapWithTouches:1 tapped:1 handler:block];
}
- (void)psk_reAddSingleTapWithBlock:(void (^)(void))block {
    [self psk_removeAllGestureRecognizers];
    [self psk_addSingleTapWithBlock:block];
}
- (void)psk_addDoubleTapWithBlock:(void (^)(void))block {
    [self _psk_addTapWithTouches:1 tapped:2 handler:block];
}
- (void)psk_reAddDoubleTapWithBlock:(void (^)(void))block {
    [self psk_removeAllGestureRecognizers];
    [self psk_addDoubleTapWithBlock:block];
}
- (void)psk_removeAllTapGestures {
    for (UIGestureRecognizer *gesture in self.gestureRecognizers) {
        if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
            [self removeGestureRecognizer:gesture];
        }
    }
    
}
- (void)_psk_addTapWithTouches:(NSUInteger)numberOfTouches
                        tapped:(NSUInteger)numberOfTaps
                       handler:(void (^)(void))block {
    if ( ! block) {
        return;
    }
    self.tapBlock = block;
    
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_psk_handleAction:)];
    gesture.numberOfTouchesRequired = numberOfTouches;
    gesture.numberOfTapsRequired = numberOfTaps;
    [self addGestureRecognizer:gesture];
}
- (void)_psk_handleAction:(UIGestureRecognizer *)recognizer {
    if (UIGestureRecognizerStateRecognized == recognizer.state) {
        if (self.tapBlock) {
            self.tapBlock();
        }
    }
}

- (void)psk_animateHorizontalSwipeWithSubType:(NSString *)subtype {
    CATransition *animation = [CATransition animation];
    animation.duration = 0.2;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.type = kCATransitionPush;
    animation.subtype = subtype;
    [self.layer addAnimation:animation forKey:@"animation"];
}
- (void)psk_flipWithTransition:(UIViewAnimationTransition)transition duration:(CGFloat)duration {
    [UIView beginAnimations:@"animationID" context:nil];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationTransition:transition forView:self cache:YES];
    [UIView commitAnimations];
}
@end


//==============================================================================
//
//  自动布局动态计算
//
//==============================================================================
@implementation UIView (PisenKit_AutoLayout)
- (void)psk_resetFontSize {
    [self psk_resetFontSizeByXibWidth:PSKConfigManagerInstance.xibWidth];
}
- (void)psk_resetFontSizeByXibWidth:(CGFloat)xibWidth {
    for (UIView *subview in self.subviews) {
        if ([subview respondsToSelector:@selector(setDoNotResetFont:)]) {
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
        [subview psk_resetFontSizeByXibWidth:xibWidth];
    }
}
- (void)psk_resetConstraint {
    [self psk_resetConstraintByXibWidth:PSKConfigManagerInstance.xibWidth];
}
- (void)psk_resetConstraintByXibWidth:(CGFloat)xibWidth {
    if ([self respondsToSelector:@selector(setDoNotResetConstraint:)]) {
        return;
    }
    for (NSLayoutConstraint *constraint in self.constraints) {
        if (constraint.constant > 0) {
            constraint.constant = AUTOLAYOUT_LENGTH_W((constraint.constant), xibWidth);
        }
    }
    if ([self.subviews count] > 0) {
        for (UIView *subView in self.subviews) {
            [subView psk_resetConstraintByXibWidth:xibWidth];
        }
    }
}
@end


//==============================================================================
//
//  从xib加载新的view
//
//==============================================================================
@implementation UIView (PisenKit_LoadFromNib)
+ (instancetype)psk_loadFromNib {
    NSString *nibName = NSStringFromClass(self.class);
    if ([@"UIView" isEqualToString:nibName]) {
        return nil;
    }
    return [self psk_loadFromNibName:nibName];
}
+ (instancetype)psk_loadFromNibName:(NSString *)nibName {
    return [self psk_loadFromNibName:nibName index:0];
}
+ (instancetype)psk_loadFromNibName:(NSString *)nibName index:(NSInteger)index {
    if ( ! nibName || ! IS_NIB_EXISTS(nibName) || index < 0) {
        return nil;
    }
    NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
    if (index >= [viewArray count]) {
        return nil;
    }
    return viewArray[index];
}
@end


