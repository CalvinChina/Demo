//
//  PSKManager.h
//  PisenKit
//
//  Created by 杨胜超 on 16/6/29.
//  Copyright © 2016年 Pisen. All rights reserved.
//

/**
 *  单例类
 *  作用：存储整个项目运行过程中用到的变量
 *       常用的单例变量管理
 */

#define PSKManagerInstance             [PSKManager sharedInstance]

//--------------------------------------
//  定义全局变量
//--------------------------------------
@interface PSKManager : NSObject

@property (nonatomic, weak) UIViewController *currentViewController;
/** APP是否通过了苹果审核 */
@property (nonatomic, assign) BOOL isAppApproved;
/** 是否处于联网状态 */
@property (nonatomic, assign) BOOL isReachable;
/** 是否通过wifi联网 */
@property (nonatomic, assign) BOOL isReachableViaWiFi;
/** 设备唯一编号(UMeng) */
@property (nonatomic, strong) NSString *udid;

+ (instancetype)sharedInstance;

@end
