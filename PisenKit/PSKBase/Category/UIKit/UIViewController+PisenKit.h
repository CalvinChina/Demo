//
//  UIViewController+PisenKit.h
//  PisenKit
//
//  Created by 杨胜超 on 16/6/30.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import <UIKit/UIKit.h>

//==============================================================================
//
//  基本切换功能
//
//==============================================================================
@interface UIViewController (PisenKit)
@property (nonatomic, strong) NSMutableDictionary *psk_params;

- (void)psk_hideKeyboard;

/** push view controller */
- (void)psk_pushViewController:(NSString *)className;
- (void)psk_pushViewController:(NSString *)className withParams:(NSDictionary *)params;
- (void)psk_pushViewController:(NSString *)className withParams:(NSDictionary *)params animated:(BOOL)animated;

/** pop & dismiss view controller */
- (void)psk_popViewController;          //返回上一级，最多到根
- (void)psk_popViewControllerWithStep:(NSInteger)step;  //向后回退的步数
- (void)psk_backViewController;         //返回上一级，直到dismiss

/** present viewcontroller
 *  [presentingViewController -> self -> presentedViewController] */
- (void)psk_presentViewController:(NSString *)className;
- (void)psk_presentViewController:(NSString *)className withParams:(NSDictionary *)params;
- (void)psk_presentViewController:(NSString *)className withParams:(NSDictionary *)params animated:(BOOL)animated;

/** dismiss viewcontroller */
- (void)psk_dismissOnPresentingViewController;  //在self上一级viewController调用dismiss（通常情况下使用该方法）
- (void)psk_dismissOnPresentedViewController;   //在self下一级viewController调用dismiss
@end


//==============================================================================
//
//  实例化viewController
//
//==============================================================================
@interface UIViewController (PisenKit_CreateNew)
/**  */
+ (instancetype)psk_createNew;
+ (instancetype)psk_createNewByName:(NSString *)name;
+ (UINavigationController *)psk_createNewNavigationByRootName:(NSString *)rootName;
@end