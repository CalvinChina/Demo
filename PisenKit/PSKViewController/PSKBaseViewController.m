//
//  PSKBaseViewController.m
//  PisenKit
//
//  Created by 杨胜超 on 16/7/5.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import "PSKBaseViewController.h"

@interface PSKBaseViewController ()
@property (nonatomic, strong) NSMutableDictionary *requestIdDictionary;
@end


@implementation PSKBaseViewController

- (void)dealloc {
    // 取消未结束的网络请求
    NSArray *requestIds = [self.requestIdDictionary.allValues copy];
    for (NSString *requestId in requestIds) {
        [PSKRequestManagerInstance cancelRequestById:requestId];
    }
    [self.requestIdDictionary removeAllObjects];
    self.requestIdDictionary = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 采用Override Method的方式就直接覆盖原来的方法，本质是Override
    PRINT_DEALLOCING
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    PSKManagerInstance.currentViewController = self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.requestIdDictionary = [NSMutableDictionary dictionary];
    if ( ! self.psk_params) {
        self.psk_params = [NSMutableDictionary dictionary];
    }
    NSLog(@"self.params = %@", self.psk_params);
    
    self.title = TRIM_STRING(self.psk_params[kParamTitle]);
    self.view.backgroundColor = PSKConfigManagerInstance.defaultViewColor;
    self.hidesBottomBarWhenPushed = YES;
    self.view.clipsToBounds = YES;
    self.view.layer.masksToBounds = YES;
    // self.view自动让出navigationBar的位置
    [self setEdgesForExtendedLayout:UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight];
    
    ADD_OBSERVER(@selector(didAppBecomeActive), UIApplicationDidBecomeActiveNotification);
    ADD_OBSERVER(@selector(didAppEnterBackground), UIApplicationDidEnterBackgroundNotification);
}

#pragma mark - 监控APP恢复运行、按下home键
- (void)didAppBecomeActive { }
- (void)didAppEnterBackground { }

#pragma mark - 管理网络请求队列
- (void)addRequestId:(NSString *)requestId forKey:(NSString *)requestKey {
    RETURN_WHEN_OBJECT_IS_EMPTY(requestId);
    RETURN_WHEN_OBJECT_IS_EMPTY(requestKey);
    self.requestIdDictionary[requestKey] = requestId;
}
- (void)removeRequestIdByKey:(NSString *)requestKey {
    RETURN_WHEN_OBJECT_IS_EMPTY(requestKey);
    NSString *requestId = self.requestIdDictionary[requestKey];
    if (requestId && ! PSKRequestManagerInstance.requestQueue[requestId]) {
        // 只有当网络请求队列里移除了requestId才移除对应的requestKey
        [self.requestIdDictionary removeObjectForKey:requestKey];
    }
}
- (void)cancelRequestIdByKey:(NSString *)requestKey {
    NSString *requestId = self.requestIdDictionary[requestKey];
    if (requestId) {
        [PSKRequestManagerInstance cancelRequestById:requestId];
        [self.requestIdDictionary removeObjectForKey:requestKey];
    }
}

@end
