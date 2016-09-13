//
//  PSKBaseViewController.h
//  PisenKit
//
//  Created by 杨胜超 on 16/7/5.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSKBaseViewController : UIViewController

/** APP恢复运行 */
- (void)didAppBecomeActive;
/** APP进入后台 */
- (void)didAppEnterBackground;

/** 添加网络请求 */
- (void)addRequestId:(NSString *)requestId forKey:(NSString *)requestKey;
/** 移除网络请求 */
- (void)removeRequestIdByKey:(NSString *)requestKey;
/** 取消网络请求 */
- (void)cancelRequestIdByKey:(NSString *)requestKey;

@end
