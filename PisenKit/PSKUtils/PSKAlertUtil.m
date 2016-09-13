//
//  PSKAlertUtil.m
//  PisenKitDemo
//
//  Created by 杨胜超 on 16/7/12.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import "PSKAlertUtil.h"
#import <objc/runtime.h>

#define kIsUseAlertController   IOS8_OR_LATER       // 是否启用UIAlertController，默认从iOS8开始启用

#if ! kIsUseAlertController
// 扩展UIAlertView
@interface UIAlertView (PisenKit_iOS7)
@property (nonatomic, strong) NSMutableDictionary *actionHandlerDictionary;
@end
@implementation UIAlertView (PisenKit_iOS7)
- (void)dealloc {
    PRINT_DEALLOCING
}
- (NSMutableDictionary *)actionHandlerDictionary {
    NSMutableDictionary *targets = objc_getAssociatedObject(self, _cmd);
    if (!targets) {
        targets = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, _cmd, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return targets;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    id key = @(buttonIndex);
    void (^block)(void) = [self actionHandlerDictionary][key];
    if (block) {
        block();
    }
}
@end

// 扩展UIActionSheet
@interface UIActionSheet (PisenKit_iOS7)
@property (nonatomic, strong) NSMutableDictionary *actionHandlerDictionary;
@end
@implementation UIActionSheet (PisenKit_iOS7)
- (void)dealloc {
    PRINT_DEALLOCING
}
- (NSMutableDictionary *)actionHandlerDictionary {
    NSMutableDictionary *targets = objc_getAssociatedObject(self, _cmd);
    if (!targets) {
        targets = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, _cmd, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return targets;
}
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
@interface PSKAlertUtil ()
@property (nonatomic, assign) PSKAlertControllerStyle preferredStyle;
@property (nonatomic, strong) id alertResponder;
@end

@implementation PSKAlertUtil

- (void)dealloc {
    PRINT_DEALLOCING
}
+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message {
    return [self alertWithTitle:title message:message style:PSKAlertControllerStyleAlert];
}
+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message style:(PSKAlertControllerStyle) style {
    PSKAlertUtil *alertUtil = [PSKAlertUtil new];
    alertUtil.title = title;
    alertUtil.message = message;
    alertUtil.preferredStyle = style;
#if kIsUseAlertController
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyle)style];
    alertUtil.alertResponder = alertController;
#else
    if (PSKAlertControllerStyleActionSheet == style) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        actionSheet.delegate = actionSheet;
        alertUtil.alertResponder = actionSheet;
    }
    else if (PSKAlertControllerStyleAlert == style) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        alertView.delegate = alertView;
        alertUtil.alertResponder = alertView;
    }
#endif
    return alertUtil;
}

/** 添加普通按钮 */
- (void)addActionWithTitle:(NSString *)title handler:(void (^)(void))block {
    [self addActionWithTitle:title style:PSKAlertActionStyleDefault handler:block];
}
/** 添加取消功能，始终在最后的位置 */
- (void)addCancelActionWithTitle:(NSString *)title handler:(void (^)(void))block {
    [self addActionWithTitle:title style:PSKAlertActionStyleCancel handler:block];
}
/** 添加删除功能，红色字体 */
- (void)addDestructiveActionWithTitle:(NSString *)title handler:(void (^)(void))block {
    [self addActionWithTitle:title style:PSKAlertActionStyleDestructive handler:block];
}
/** 根据按钮类型添加功能 */
- (void)addActionWithTitle:(NSString *)title style:(PSKAlertActionStyle)style handler:(void (^)(void))block {
#if kIsUseAlertController
    UIAlertController *alertController = self.alertResponder;
    [alertController addAction:[UIAlertAction actionWithTitle:title style:(UIAlertActionStyle)style handler:^(UIAlertAction * _Nonnull action) {
        if (block) {
            block();
        }
    }]];
#else
    // 定位button的位置
    NSInteger buttonIndex = -1;
    if (PSKAlertControllerStyleActionSheet == self.preferredStyle) {
        UIActionSheet *actionSheet = self.alertResponder;
        buttonIndex = [actionSheet addButtonWithTitle:title];
        if (PSKAlertActionStyleCancel == style) {
            actionSheet.cancelButtonIndex = buttonIndex;
        }
        else if (PSKAlertActionStyleDestructive == style) {
            actionSheet.destructiveButtonIndex = buttonIndex;
        }
        if (block) {
            actionSheet.actionHandlerDictionary[@(buttonIndex)] = block;
        }
        else {
            [actionSheet.actionHandlerDictionary removeObjectForKey:@(buttonIndex)];
        }
    }
    else if (PSKAlertControllerStyleAlert == self.preferredStyle) {
        UIAlertView *alertView = self.alertResponder;
        buttonIndex = [alertView addButtonWithTitle:title];
        if (PSKAlertActionStyleCancel == style) {
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
- (void)addTextFieldWithHandler:(void (^)(UITextField *textField))block {
    if (PSKAlertControllerStyleAlert == self.preferredStyle) {
#if kIsUseAlertController
        UIAlertController *alertController = self.alertResponder;
        [alertController addTextFieldWithConfigurationHandler:block];
#else
        //TODO:
#endif
    }
}

/** 显示alert */
- (void)showOnViewController:(UIViewController *)viewController {
#if kIsUseAlertController
    [viewController presentViewController:self.alertResponder animated:YES completion:nil];
#else
    if (PSKAlertControllerStyleActionSheet == self.preferredStyle) {
        [((UIActionSheet *)self.alertResponder) showInView:viewController.view];
    }
    else if (PSKAlertControllerStyleAlert == self.preferredStyle) {
        [((UIAlertView *)self.alertResponder) show];
    }
#endif
}

@end
