//
//  PSKManager.m
//  PisenKit
//
//  Created by 杨胜超 on 16/6/29.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import "PSKManager.h"

@implementation PSKManager

- (void)dealloc {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
+ (instancetype)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[PSKManager alloc] init];
    });
    return _sharedObject;
}
- (id)init {
    self = [super init];
    if (self) {
        ADD_OBSERVER(@selector(_didAppBecomeActive), UIApplicationDidBecomeActiveNotification);
        ADD_OBSERVER(@selector(_didAppEnterBackground), UIApplicationDidEnterBackgroundNotification);
        [self _setupCustomValues];
    }
    return self;
}
- (void)_setupCustomValues {
    // 在category中重写该方法可以修改默认值
}
- (void)_didAppBecomeActive {
    [self _checkAppApproved];
}
- (void)_didAppEnterBackground {
    
}
- (void)_checkAppApproved {
    if ( ! [PSKGetObject(@"PSKManager_isAppApproved") boolValue]) {
        @weakiy(self);
        [PSKGeneralUtil checkOnAppStoreStatus:nil block:^(NSDictionary *releaseItem) {
            NSString *onlineVersion = releaseItem[@"version"];
            if (OBJECT_ISNOT_EMPTY(onlineVersion) &&
                NSOrderedDescending != COMPARE_CURRENT_VERSION(onlineVersion)) {
                PSKSaveObject(@(YES), @"PSKManager_isAppApproved");// 一旦通过了审核就不再检测
                weak_self.isAppApproved = YES;
            }
            else {
                weak_self.isAppApproved = NO;
            }
            NSLog(@"isAppApproved = %@", weak_self.isAppApproved ? @"YES" : @"NO");
        }];
    }
}

#pragma mark - getter
- (NSString *)udid {
    if ( ! _udid) {
        NSString *tempUdid = PSKGetObject(@"OpenUDID");
        if (OBJECT_IS_EMPTY(tempUdid)) {
            tempUdid = [UIDevice psk_openUdid];//保证只获取一次udid就保存在内存中！
            if (OBJECT_ISNOT_EMPTY(tempUdid)) {
                PSKSaveObject(tempUdid, @"OpenUDID");
            }
        }
        _udid = tempUdid;
    }
    return _udid == nil ? @"" : _udid;
}

@end
