//
//  UIDevice+PisenKit.h
//  PisenKit
//
//  Created by 杨胜超 on 16/6/30.
//  Copyright © 2016年 Pisen. All rights reserved.
//

/**
 *  判断设备的相关参数
 */
#ifndef SCREEN_WIDTH
    #define SCREEN_WIDTH            ([UIScreen mainScreen].bounds.size.width) //屏幕的宽度(point)
#endif
#ifndef SCREEN_HEIGHT
    #define SCREEN_HEIGHT           ([UIScreen mainScreen].bounds.size.height)//屏幕的高度(point)
#endif
#ifndef IOS7_OR_LATER
    #define IOS7_OR_LATER           __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
#endif
#ifndef IOS8_OR_LATER
    #define IOS8_OR_LATER           __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
#endif
#ifndef IOS9_OR_LATER
    #define IOS9_OR_LATER           __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
#endif

typedef NS_ENUM(NSInteger, PSKDeviceType) {
    PSKDeviceTypeUnknown = 0,
    PSKDeviceTypeiPhone320x480,        // iPhone 1,3,3GS (320x480px)
    PSKDeviceTypeiPhone640x960,        // iPhone 4,4S (640x960px)
    PSKDeviceTypeiPhone640x1136,       // iPhone 5,5c,5s (640x1136px)
    PSKDeviceTypeiPhone750x1334,       // iPhone 6 (750x1334px)
    PSKDeviceTypeiPhone1242x2208,      // iPhone 6 plus (1242x2208px)
    
    PSKDeviceTypeiPad1024x768,         // iPad 1,2 (1024x768px)
    PSKDeviceTypeiPad2048x1536         // iPad 3 High Resolution(2048x1536px)
};


//==============================================================================
//
//  常用方法
//
//==============================================================================
@interface UIDevice (PisenKit)

+ (PSKDeviceType)psk_currentDeviceType;
+ (BOOL)psk_isPad;
+ (BOOL)psk_isPhone;
+ (BOOL)psk_isRunningOnSimulator;

/** device info */
+ (NSString *)psk_openUdid;
+ (NSString *)psk_deviceInfo;
+ (NSString *)psk_stringWithUUID;
+ (NSString *)psk_machineModel;
+ (NSString *)psk_machineModelName;

// 只能判断摄像头是否可用，但不能判断是否被用户禁用了!
+ (BOOL)psk_isCameraAvailable;
+ (BOOL)psk_isFrontCameraAvailable;
+ (BOOL)psk_isBackCameraAvailable;

//判断是否可用使用摄像头
+ (BOOL)psk_isCanUseCamera;
//判断是否可用打电话
+ (BOOL)psk_isCanMakeCall;
//判断定位是否可用(包括已经授权和没有决定)
+ (BOOL)psk_isLocationAvaible;
// 相册是否可用
+ (BOOL)psk_isPhotoLibraryAvailable;
// 照片流是否可用
+ (BOOL)psk_isSavedPhotosAlbumAvailable;
// 闪光灯是否可用
+ (BOOL)psk_isCameraFlashAvailable;
// 检测陀螺仪是否可用
+ (BOOL)psk_isGyroscopeAvailable;
// 检测指南针或磁力计
+ (BOOL)psk_isHandingAvailable;
// 检查摄像头是否支持录像
+ (BOOL)psk_isCameraSupportShootingVideos;
// 检查摄像头是否支持拍照
+ (BOOL)psk_isCameraSupportTakingPhotos;
// 是否可以在相册中选择视频
+ (BOOL)psk_isCanUserPickVideosFromPhotoLibrary;
// 是否可以在相册中选择图片
+ (BOOL)psk_isCanUserPickPhotosFromPhotoLibrary;
//强制修改设备的方向
+ (void)psk_forceToChangeInterfaceOrientation:(UIInterfaceOrientation)orientation;

/** Disk Space */
+ (int64_t)psk_diskSpace;
+ (int64_t)psk_diskSpaceFree;
+ (int64_t)psk_diskSpaceUsed;

/** Memory Information */
+ (int64_t)psk_memoryTotal;
+ (int64_t)psk_memoryFree;
+ (int64_t)psk_memoryErasable;//erasable memory
+ (int64_t)psk_memoryUsed;// = active + inactive + wired
+ (int64_t)psk_memoryActive;
+ (int64_t)psk_memoryInactive;
+ (int64_t)psk_memoryWired;

/** CPU Information */
+ (NSUInteger)psk_cpuCount;
+ (float)psk_cpuUsage;//1.0 means 100%
+ (NSArray *)psk_cpuUsagePerProcessor;//1.0 means 100%

@end
