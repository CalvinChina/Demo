//
//  DWKAlertManager.h
//  DWKKit
//
//  Created by pisen on 16/10/20.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
/** 定义按钮类型 */
typedef NS_ENUM(NSInteger, DWKAlertActionStyle) {
    DWKAlertActionStyleDefault = 0,
    DWKAlertActionStyleCancel,              // 取消功能，始终在最后的位置
    DWKAlertActionStyleDestructive          // 删除功能，红色字体
};

/** 定义alert显示类型 */
typedef NS_ENUM(NSInteger, DWKAlertControllerStyle) {
    DWKAlertControllerStyleActionSheet = 0, // actionSheet外观
    DWKAlertControllerStyleAlert            // alert外观
};


//=============================================================
//
// 封装Alert和ActionSheet功能
//  iOS7 - UIAlertView和UIActionSheet
//  iOS8及以后 - UIAlertControl
//
//=============================================================
@interface DWKAlertManager : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign, readonly) DWKAlertControllerStyle preferredStyle;
@property (nonatomic, strong, readonly) id alertResponder;
@property (nullable, nonatomic, readonly) NSArray *textFields;

/** 创建对象 */
+ (instancetype)alertWithTitle:(nullable NSString *)title message:(nullable NSString *)message;
/** 根据类型style创建对象 */
+ (instancetype)alertWithTitle:(nullable NSString *)title message:(nullable NSString *)message style:(DWKAlertControllerStyle)style;

/** 添加普通按钮 */
- (void)addActionWithTitle:(nullable NSString *)title handler:(nullable void (^)(void))block;
/** 添加取消功能，始终在最后的位置 */
- (void)addCancelActionWithTitle:(nullable NSString *)title handler:(nullable void (^)(void))block;
/** 添加删除功能，红色字体 */
- (void)addDestructiveActionWithTitle:(nullable NSString *)title handler:(nullable void (^)(void))block;
/** 根据按钮类型添加功能 */
- (void)addActionWithTitle:(nullable NSString *)title style:(DWKAlertActionStyle)style enable:(BOOL)enable handler:(nullable void (^)(void))block;

/**
 *  添加textField
 *  针对<=iOS7的情况最多只能添加两个UITextField
 */
- (void)addTextFieldWithHandler:(nullable void (^)(UITextField *textField))block;

/** 显示alert */
- (void)showOnViewController:(UIViewController *)viewController;
- (void)showOnViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(nullable void (^)(void))completion;

/** 显示alert提示信息（最简单的用法） */
+ (void)showAlertViewWithMessage:(NSString *)message;
/** 显示alert提示信息（带确定按钮回调） */
+ (void)showAlertViewWithMessage:(NSString *)message block:(nullable void (^)(void))block;
@end


/** 可以自定义的alertView */
@interface DWKCustomAlertView : UIView
//@property (nonatomic, weak) UIView *customView;
@property (nonatomic, assign) CGFloat animateDuration;
/** 点击范围之外是否dismiss */
@property (nonatomic, assign) BOOL isDismissByClickingOutOfArea;
@property (nonatomic, assign, readonly) DWKAlertControllerStyle preferredStyle;
@property (nonatomic, copy) dispatch_block_t didDismissBlock;

+ (instancetype)showCustomView:(nonnull UIView *)customView onView:(nonnull UIView *)superView;
+ (instancetype)showCustomView:(nonnull UIView *)customView onView:(nonnull UIView *)superView style:(DWKAlertControllerStyle)style;
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
