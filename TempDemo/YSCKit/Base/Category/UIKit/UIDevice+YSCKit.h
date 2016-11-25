//
//  UIDevice+YSCKit.h
//  YSCKit
//
//  Created by  YangShengchao on 14-2-13.
//  Copyright (c) 2014年  YangShengchao. All rights reserved.
//  FORMATED!
//

#import <UIKit/UIKit.h>
enum {
    DeviceTypeUnknown = 0,
    DeviceTypeiPhone320x480,        // iPhone 1,3,3GS (320x480px)
    DeviceTypeiPhone640x960,        // iPhone 4,4S (640x960px)
    DeviceTypeiPhone640x1136,       // iPhone 5,5c,5s (640x1136px)
    DeviceTypeiPhone750x1334,       // iPhone 6 (750x1334px)
    DeviceTypeiPhone1242x2208,      // iPhone 6 plus (1242x2208px)
    
    DeviceTypeiPad1024x768,         // iPad 1,2 (1024x768px)
    DeviceTypeiPad2048x1536         // iPad 3 High Resolution(2048x1536px)
    
    //TODO:ipad mini
    
}; typedef NSUInteger DeviceType;

@interface UIDevice (YSCKit)
//Available device memory in MB
@property(readonly) double availableMemory;

+ (DeviceType)currentDeviceType;
+ (BOOL)isRunningOnSimulator;
+ (NSString *)platformString;
// 通过UMeng集成的相关方法获取设备唯一编号
+ (NSString *)openUdid;
// 获取所有与设备相关的信息
+ (NSString *)deviceInfo;
+ (NSString *)stringWithUUID;

// 只能判断摄像头是否可用，但不能判断是否被用户禁用了!
+ (BOOL)isCameraAvailable;
+ (BOOL)isFrontCameraAvailable;
+ (BOOL)isBackCameraAvailable;

//判断是否可用使用摄像头
+ (BOOL)isCanUseCamera;
//判断是否可用打电话
+ (BOOL)isCanMakeCall;
//判断定位是否可用(包括已经授权和没有决定)
+ (BOOL)isLocationAvaible;
// 相册是否可用
+ (BOOL)isPhotoLibraryAvailable;
// 照片流是否可用
+ (BOOL)isPhotoLiabaryAvailable;
// 闪光灯是否可用
+ (BOOL)isCameraFlashAvailable;
// 检测陀螺仪是否可用
+ (BOOL)isGyroscopeAvailable;
// 检测指南针或磁力计
+ (BOOL)isHandingAvailable;
// 检查摄像头是否支持录像
+ (BOOL)isCameraSupportShootingVideos;
// 检查摄像头是否支持拍照
+ (BOOL)isCameraSupportTakingPhotos;
// 是否可以在相册中选择视频
+ (BOOL)isCanUserPickVideosFromPhotoLibrary;
// 是否可以在相册中选择图片
+ (BOOL)isCanUserPickPhotosFromPhotoLibrary;
//判断是否允许后台刷新程序
+ (BOOL)isBackgroundRefreshable;
//强制修改设备的方向
+ (void)forceToChangeInterfaceOrientation:(UIInterfaceOrientation)orientation;
@end


// @see https://github.com/ibireme/YYKit/blob/master/YYKit/Base/UIKit/UIDevice%2BYYAdd.h
@interface UIDevice (YYAdd)
#pragma mark - Device Information
///=============================================================================
/// @name Device Information
///=============================================================================

/// Device system version (e.g. 8.1)
+ (double)systemVersion;

/// Whether the device is iPad/iPad mini.
@property (nonatomic, readonly) BOOL isPad;

/// Whether the device is a simulator.
@property (nonatomic, readonly) BOOL isSimulator;

/// Whether the device is jailbroken.
@property (nonatomic, readonly) BOOL isJailbroken;

/// The device's machine model.  e.g. "iPhone6,1" "iPad4,6"
/// @see http://theiphonewiki.com/wiki/Models
@property (nonatomic, readonly) NSString *machineModel;

/// The device's machine model name. e.g. "iPhone 5s" "iPad mini 2"
/// @see http://theiphonewiki.com/wiki/Models
@property (nonatomic, readonly) NSString *machineModelName;

/// The System's startup time.
@property (nonatomic, readonly) NSDate *systemUptime;


#pragma mark - Network Information
///=============================================================================
/// @name Network Information
///=============================================================================

/// WIFI IP address of this device (can be nil). e.g. @"192.168.1.111"
@property (nonatomic, readonly) NSString *ipAddressWIFI;

/// Cell IP address of this device (can be nil). e.g. @"10.2.2.222"
@property (nonatomic, readonly) NSString *ipAddressCell;


#pragma mark - Disk Space
///=============================================================================
/// @name Disk Space
///=============================================================================

/// Total disk space in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t diskSpace;

/// Free disk space in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t diskSpaceFree;

/// Used disk space in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t diskSpaceUsed;


#pragma mark - Memory Information
///=============================================================================
/// @name Memory Information
///=============================================================================

/// Total physical memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t memoryTotal;

/// Used (active + inactive + wired) memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t memoryUsed;

/// Free memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t memoryFree;

/// Acvite memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t memoryActive;

/// Inactive memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t memoryInactive;

/// Wired memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t memoryWired;

/// Purgable memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t memoryPurgable;

#pragma mark - CPU Information
///=============================================================================
/// @name CPU Information
///=============================================================================

/// Avaliable CPU processor count.
@property (nonatomic, readonly) NSUInteger cpuCount;

/// Current CPU usage, 1.0 means 100%. (-1 when error occurs)
@property (nonatomic, readonly) float cpuUsage;

/// Current CPU usage per processor (array of NSNumber), 1.0 means 100%. (nil when error occurs)
@property (nonatomic, readonly) NSArray *cpuUsagePerProcessor;
@end

