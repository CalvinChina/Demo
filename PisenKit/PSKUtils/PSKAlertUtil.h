//
//  PSKAlertUtil.h
//  PisenKitDemo
//
//  Created by 杨胜超 on 16/7/12.
//  Copyright © 2016年 Pisen. All rights reserved.
//


/** 定义按钮类型 */
typedef NS_ENUM(NSInteger, PSKAlertActionStyle) {
    PSKAlertActionStyleDefault = 0,
    PSKAlertActionStyleCancel,              // 取消功能，始终在最后的位置
    PSKAlertActionStyleDestructive          // 删除功能，红色字体
};

/** 定义alert显示类型 */
typedef NS_ENUM(NSInteger, PSKAlertControllerStyle) {
    PSKAlertControllerStyleActionSheet = 0, // actionSheet外观
    PSKAlertControllerStyleAlert            // alert外观
};


//=============================================================
//
// 封装Alert和ActionSheet功能
//  iOS7 - UIAlertView和UIActionSheet
//  iOS8及以后 - UIAlertControl
//
//=============================================================
@interface PSKAlertUtil : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign, readonly) PSKAlertControllerStyle preferredStyle;
@property (nonatomic, strong, readonly) id alertResponder;

/** 创建对象 */
+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message;
/** 根据类型style创建对象 */
+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message style:(PSKAlertControllerStyle) style;

/** 添加普通按钮 */
- (void)addActionWithTitle:(NSString *)title handler:(void (^)(void))block;
/** 添加取消功能，始终在最后的位置 */
- (void)addCancelActionWithTitle:(NSString *)title handler:(void (^)(void))block;
/** 添加删除功能，红色字体 */
- (void)addDestructiveActionWithTitle:(NSString *)title handler:(void (^)(void))block;
/** 根据按钮类型添加功能 */
- (void)addActionWithTitle:(NSString *)title style:(PSKAlertActionStyle)style handler:(void (^)(void))block;

/** 添加textField */
- (void)addTextFieldWithHandler:(void (^)(UITextField *textField))block;

/** 显示alert */
- (void)showOnViewController:(UIViewController *)viewController;

@end
