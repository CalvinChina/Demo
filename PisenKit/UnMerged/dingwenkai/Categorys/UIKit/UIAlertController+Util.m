//
//  UIAlertController+Util.m
//  CalvinUtils
//
//  Created by pisen on 16/2/4.
//  Copyright © 2016年 Calvin. All rights reserved.
//

#import "UIAlertController+Util.h"

@implementation UIAlertController (Util)

+ (UIAlertController *)alertViewWithTitle:(NSString *)title message:(NSString *)message actions:(NSArray *)actions handler:(void (^)(NSUInteger idx))handler {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [actions enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (handler) {
                handler(idx);
            }
        }];
        [ac addAction:action];
    }];
    return ac;
}

+ (UIAlertController *)alertActionSheetWithTitle:(NSString *)title message:(NSString *)message actions:(NSArray *)actions cancel:(NSString *)cancel cancelHandle:(void (^)(void))cancelHandler handler:(void (^)(NSUInteger idx))handler {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    [actions enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (handler) {
                handler(idx);
            }
        }];
        [ac addAction:action];
    }];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (cancelHandler) {
            cancelHandler();
        }
    }];
    [ac addAction:action];
    
    return ac;
}

@end
