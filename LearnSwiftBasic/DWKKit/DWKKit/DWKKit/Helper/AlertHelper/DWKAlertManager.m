//
//  DWKAlertManager.m
//  DWKKit
//
//  Created by pisen on 16/10/20.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

#import "DWKAlertManager.h"
#import <objc/runtime.h>
#import "UIGestureRecognizer+BlocksKit.h"

#define kIsUseAlertController   IOS8_OR_LATER       // 是否启用UIAlertController，默认从iOS8开始启用

#if ! kIsUseAlertController
// 扩展UIAlertView
@implementation UIAlertView (PisenKit_iOS7)
DWK_DYNAMIC_PROPERTY_LAZYLOAD(actionHandlerDictionary, NSMutableDictionary *, [NSMutableDictionary dictionary])
DWK_DYNAMIC_PROPERTY_LAZYLOAD(textFields, NSMutableArray *, [NSMutableArray array])
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    id key = @(buttonIndex);
    void (^block)(void) = [self actionHandlerDictionary][key];
    if (block) {
        block();
    }
}
@end

// 扩展UIActionSheet
@implementation UIActionSheet (PisenKit_iOS7)
DWK_DYNAMIC_PROPERTY_LAZYLOAD(actionHandlerDictionary, NSMutableDictionary *, [NSMutableDictionary dictionary])
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    id key = @(buttonIndex);
    void (^block)(void) = [self actionHandlerDictionary][key];
    if (block) {
        block();
    }
}
@end
#endif



//=============================================================
//
// 封装Alert和ActionSheet功能
//  iOS7 - UIAlertView和UIActionSheet
//  iOS8及以后 - UIAlertControl
//
//=============================================================
@interface DWKAlertManager ()
@property (nonatomic, assign) DWKAlertControllerStyle preferredStyle;
@property (nonatomic, strong) id alertResponder;
@end

@implementation DWKAlertManager
+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message {
    return [self alertWithTitle:title message:message style:DWKAlertControllerStyleAlert];
}
+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message style:(DWKAlertControllerStyle)style {
    DWKAlertManager *alertUtil = [DWKAlertManager new];
    alertUtil.title = title;
    alertUtil.message = message;
    alertUtil.preferredStyle = style;
#if kIsUseAlertController
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyle)style];
    alertUtil.alertResponder = alertController;
#else
    if (DWKAlertControllerStyleActionSheet == style) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        actionSheet.delegate = actionSheet;
        alertUtil.alertResponder = actionSheet;
    }
    else if (DWKAlertControllerStyleAlert == style) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        alertView.delegate = alertView;
        alertUtil.alertResponder = alertView;
    }
#endif
    return alertUtil;
}

- (NSArray *)textFields {
#if kIsUseAlertController
    UIAlertController *alertController = self.alertResponder;
    return alertController.textFields;
#else
    UIAlertView *alertView = self.alertResponder;
    return alertView.textFields;
#endif
}

/** 添加普通按钮 */
- (void)addActionWithTitle:(NSString *)title handler:(nullable void (^)(void))block {
    [self addActionWithTitle:title style:DWKAlertActionStyleDefault enable:YES handler:block];
}
/** 添加取消功能，始终在最后的位置 */
- (void)addCancelActionWithTitle:(NSString *)title handler:(nullable void (^)(void))block {
    [self addActionWithTitle:title style:DWKAlertActionStyleCancel enable:YES handler:block];
}
/** 添加删除功能，红色字体 */
- (void)addDestructiveActionWithTitle:(NSString *)title handler:(nullable void (^)(void))block {
    [self addActionWithTitle:title style:DWKAlertActionStyleDestructive enable:YES handler:block];
}
/** 根据按钮类型添加功能 */
- (void)addActionWithTitle:(NSString *)title style:(DWKAlertActionStyle)style enable:(BOOL)enable handler:(nullable void (^)(void))block {
#if kIsUseAlertController
    UIAlertController *alertController = self.alertResponder;
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:title style:(UIAlertActionStyle)style handler:^(UIAlertAction * _Nonnull action) {
        if (block) {
            block();
        }
    }];
    alertAction.enabled = enable;
    [alertController addAction:alertAction];
#else
    // 定位button的位置
    NSInteger buttonIndex = -1;
    if (DWKAlertControllerStyleActionSheet == self.preferredStyle) {
        UIActionSheet *actionSheet = self.alertResponder;
        buttonIndex = [actionSheet addButtonWithTitle:title];
        if (DWKAlertActionStyleCancel == style) {
            actionSheet.cancelButtonIndex = buttonIndex;
        }
        else if (DWKAlertActionStyleDestructive == style) {
            actionSheet.destructiveButtonIndex = buttonIndex;
        }
        if (block) {
            actionSheet.actionHandlerDictionary[@(buttonIndex)] = block;
        }
        else {
            [actionSheet.actionHandlerDictionary removeObjectForKey:@(buttonIndex)];
        }
    }
    else if (DWKAlertControllerStyleAlert == self.preferredStyle) {
        UIAlertView *alertView = self.alertResponder;
        buttonIndex = [alertView addButtonWithTitle:title];
        if (DWKAlertActionStyleCancel == style) {
            alertView.cancelButtonIndex = buttonIndex;
        }
        if (block) {
            alertView.actionHandlerDictionary[@(buttonIndex)] = block;
        }
        else {
            [alertView.actionHandlerDictionary removeObjectForKey:@(buttonIndex)];
        }
    }
#endif
}

/** 添加textField */
- (void)addTextFieldWithHandler:(nullable void (^)(UITextField *textField))block {
    if (DWKAlertControllerStyleAlert == self.preferredStyle) {
#if kIsUseAlertController
        UIAlertController *alertController = self.alertResponder;
        [alertController addTextFieldWithConfigurationHandler:block];
#else
        UIAlertView *alertView = (UIAlertView *)self.alertResponder;
        UITextField *textField = nil;
        if (0 == [alertView.textFields count]) {
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            textField = [alertView textFieldAtIndex:0];
        }
        else if (1 == [alertView.textFields count]) {
            alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
            textField = [alertView textFieldAtIndex:1];
        }
        if (textField) {
            [alertView.textFields addObject:textField];
        }
        if (block) {
            block(textField);
        }
#endif
    }
}

/** 显示alert */
- (void)showOnViewController:(UIViewController *)viewController {
    [self showOnViewController:viewController animated:YES completion:nil];
}
- (void)showOnViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^ __nullable)(void))completion {
#if kIsUseAlertController
    [viewController presentViewController:self.alertResponder animated:animated completion:completion];
#else
    if (DWKAlertControllerStyleActionSheet == self.preferredStyle) {
        [((UIActionSheet *)self.alertResponder) showInView:viewController.view];
    }
    else if (DWKAlertControllerStyleAlert == self.preferredStyle) {
        [((UIAlertView *)self.alertResponder) show];
    }
#endif
}

/** 显示alert提示信息（最简单的用法） */
+ (void)showAlertViewWithMessage:(NSString *)message {
    [self showAlertViewWithMessage:message block:nil];
}
/** 显示alert提示信息（带确定按钮回调） */
+ (void)showAlertViewWithMessage:(NSString *)message block:(nullable void (^)(void))block {
    DWKAlertManager *alertManager = [DWKAlertManager alertWithTitle:@"提示" message:message];
    [alertManager addCancelActionWithTitle:@"确定" handler:block];
#if kIsUseAlertController
    [DWKDataInstance.currentViewController presentViewController:alertManager.alertResponder
                                                        animated:YES
                                                      completion:block];
#else
    [((UIAlertView *)alertManager.alertResponder) show];
#endif
}
- (void)dealloc {
    PRINT_DEALLOCING
}
@end




@interface DWKCustomAlertView ()
@property (nonatomic, assign) DWKAlertControllerStyle preferredStyle;
@end
@implementation DWKCustomAlertView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.isDismissByClickingOutOfArea = YES;
        self.animateDuration = 0.2;
    }
    return self;
}
+ (instancetype)showCustomView:(nonnull UIView *)customView onView:(nonnull UIView *)superView {
    return [self showCustomView:customView onView:superView style:DWKAlertControllerStyleAlert];
}
+ (instancetype)showCustomView:(nonnull UIView *)customView onView:(nonnull UIView *)superView style:(DWKAlertControllerStyle)style {
    if ( ! customView || ! superView) {
        return nil;
    }
    customView.tag = 92378;
    customView.hidden = NO;
    
    // 1. 创建背景view
    DWKCustomAlertView *customAlertView = [[DWKCustomAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    customAlertView.preferredStyle = style;
    customAlertView.backgroundColor = RGBA(0, 0, 0, 0.3);
    [customAlertView addSubview:customView];
    [superView addSubview:customAlertView];
    
    // 2. 添加点击空白处关闭手势
    __weak DWKCustomAlertView *tempAlertView = customAlertView;// 这里必须是弱引用！否则无法dealloc
    UITapGestureRecognizer *tap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        if ( ! CGRectContainsPoint(customView.frame, location) &&
            tempAlertView.isDismissByClickingOutOfArea) {
            [tempAlertView dismiss];
        }
    }];
    tap.cancelsTouchesInView = NO;// 底层接收到点击手势后仍然需要继续往子view传递！
    [customAlertView addGestureRecognizer:tap];
    
    // 3. 初始化customView坐标
    if (DWKAlertControllerStyleAlert == style) {
        customAlertView.isDismissByClickingOutOfArea = NO;// 如果是alert形式，则默认点击空白处不消失
        customView.center = customAlertView.center;
        customView.alpha = 0;
    }
    else {
        customAlertView.isDismissByClickingOutOfArea = YES;
        customView.top = customAlertView.height;
        customView.centerX = customAlertView.centerX;
    }
    
    // 4. show
    [customAlertView show];
    
    return customAlertView;
}
- (void)show {
    UIView *customView = [self viewWithTag:92378];
    if (DWKAlertControllerStyleAlert == self.preferredStyle) {
        customView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    }
    //    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.65 initialSpringVelocity:0.5 options:0 animations:^{
    [UIView animateWithDuration:self.animateDuration animations:^{
        if (DWKAlertControllerStyleActionSheet == self.preferredStyle) {
            customView.top = self.height - customView.height;
        }
        else {
            customView.transform = CGAffineTransformIdentity;
            customView.alpha = 1;
        }
    } completion:nil];
}
- (void)dismiss {
    UIView *customView = [self viewWithTag:92378];
    [UIView animateWithDuration:self.animateDuration animations:^{
        if (DWKAlertControllerStyleActionSheet == self.preferredStyle) {
            customView.top = self.height;
        }
        else {
            customView.alpha = 0;
        }
    } completion:^(BOOL finished) {
        if (self.didDismissBlock) {
            self.didDismissBlock();
        }
        [customView removeFromSuperview];
        [self removeFromSuperview];
    }];
}
- (void)dealloc {
    PRINT_DEALLOCING
}
@end
