//
//  UIAlertController+Util.h
//  CalvinUtils
//
//  Created by pisen on 16/2/4.
//  Copyright © 2016年 Calvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (Util)

+ (UIAlertController *)alertViewWithTitle:(NSString *)title message:(NSString *)message actions:(NSArray *)actions handler:(void (^)(NSUInteger idx))handler;

+ (UIAlertController *)alertActionSheetWithTitle:(NSString *)title message:(NSString *)message actions:(NSArray *)actions cancel:(NSString *)cancel cancelHandle:(void (^)(void))cancelHandler handler:(void (^)(NSUInteger idx))handler;

@end
