//
//  CameraImageHelper.h
//  HelloWorld
//
//  Created by Erica Sadun on 7/21/10.
//  Copyright 2010 Up To No Good, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef void (^CaptureImageBlock)(UIImage *image);
typedef void (^AdjustingFocusBlock)(BOOL focus);

@interface CameraImageHelper : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate>
@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureStillImageOutput *captureOutput;
@property (strong, nonatomic) AVCaptureDeviceInput *captureInput;
@property (strong, nonatomic) UIImage *image;
@property (assign, nonatomic) UIImageOrientation gorientation;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *preview;
@property (copy, nonatomic) AdjustingFocusBlock focusBlock;

- (void)startRunning;
- (void)embedPreviewInView:(UIView *)aView;
- (void)doCaptureimageWithBlock:(CaptureImageBlock)block;
- (void)changePreviewOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (void)stopRunning;

/**
 *	翻转相机前/后摄像头
 *
 *	@return	是否翻转成功
 */
- (BOOL)toggleCamera;
/**
 *	是否在使用后置摄像头取景
 *
 *	@return	当前是否正使用后置摄像头
 */
- (BOOL)isBackFacingCamera;
/**
 *	设备后置摄像头是否支持闪光灯
 *
 *	@return	设备后置摄像头是否支持闪光灯
 */
- (BOOL)isBackCameraSupportFlash;
/**
 *	设备后置摄像头闪光灯是否支持自动模式
 *
 *	@return	设备后置摄像头闪光灯是否支持自动模式
 */
- (BOOL)isBackCameraFlashSupportAutoMode;
/**
 *	设备后置摄像头闪光灯是否支持开启模式
 *
 *	@return	设备后置摄像头闪光灯是否支持开启模式
 */
- (BOOL)isBackCameraFlashSupportOnMode;
/**
 *	设备后置摄像头闪光灯是否支持关闭模式
 *
 *	@return	设备后置摄像头闪光灯是否支持关闭模式
 */
- (BOOL)isBackCameraFlashSupportOffMode;
/**
 *	将设备后置摄像头闪光灯模式置为自动
 */
- (void)changeBackCameraFlashModeToAuto;
/**
 *	将设备后置摄像头闪光灯模式置为开启
 */
- (void)changeBackCameraFlashModeToOn;
/**
 *	将设备后置摄像头闪光灯模式置为关闭
 */
- (void)changeBackCameraFlashModeToOff;
@end