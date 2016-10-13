//
//  UIDevice+Additions.h
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

@interface UIDevice (Additions)
/*
 * Available device memory in MB
 */
@property(readonly) double availableMemory;

+ (DeviceType)currentDeviceType;
+ (BOOL)isRunningOnSimulator;
+ (NSString *)platformString;
// 通过UMeng集成的相关方法获取设备唯一编号
+ (NSString *)openUdid;
//获取所有与设备相关的信息
+ (NSString *)deviceInfo;

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

@end
