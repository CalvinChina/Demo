//
//  CameraImageHelper.m
//  HelloWorld
//
//  Created by Erica Sadun on 7/21/10.
//  Copyright 2010 Up To No Good, Inc. All rights reserved.
//

#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>
#import "CameraImageHelper.h"
#import <ImageIO/ImageIO.h>
#import <UIImage+Resize.h>

@implementation CameraImageHelper

- (id)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}
- (void)initialize {
    //1.创建会话层
    self.session = [[AVCaptureSession alloc] init];
    [self.session setSessionPreset:AVCaptureSessionPresetPhoto];
    
    //2.创建、配置输入设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device addObserver:self forKeyPath:@"adjustingFocus" options:NSKeyValueObservingOptionNew context:nil];//监听自动对焦
    
    NSError *error;
    self.captureInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (nil == self.captureInput) {
        NSLog(@"Error: %@", error);
        return;
    }
    [self.session addInput:self.captureInput];
    
    //3.创建、配置输出
    self.captureOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    [self.captureOutput setOutputSettings:outputSettings];
    
    [self.session addOutput:self.captureOutput];
}
//释放对象
- (void)dealloc {
    //移除对焦监听事件
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device removeObserver:self forKeyPath:@"adjustingFocus"];
    
    self.session = nil;
    self.image = nil;
}
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}
- (AVCaptureDevice *)backFacingCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}
- (AVCaptureDevice *)frontCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

//对焦回调
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"adjustingFocus"] ){
        BOOL adjustingFocus = [ [change objectForKey:NSKeyValueChangeNewKey] isEqualToNumber:[NSNumber numberWithInt:1] ];
        NSLog(@"Is adjusting focus? %@", adjustingFocus ? @"YES" : @"NO" );
        NSLog(@"Change dictionary: %@", change);
        if (self.focusBlock) {
            self.focusBlock(adjustingFocus);
        }
    }
}
//开始获取图像
- (void)startRunning {
    if (self.session) {
        [self.session startRunning];
    }
}
//将摄像头图像放在view上
- (void)embedPreviewInView:(UIView *) aView {
    if (nil == self.session)
        return;
    //设置取景
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.frame = aView.bounds;
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preview.position = CGPointMake(CGRectGetMidX(aView.bounds), CGRectGetMidY(aView.bounds));
    [aView.layer addSublayer:self.preview];
}
//执行拍照动作
- (void)doCaptureimageWithBlock:(CaptureImageBlock)block {
    //get connection
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.captureOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }
    
    //get UIImage
    [self.captureOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:
     ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
         UIImage *image = nil;
         if (imageSampleBuffer != NULL) {
             NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
             image = [[UIImage alloc] initWithData:imageData];
             image = [image resizedImage:CGSizeMake(image.size.width, image.size.height) interpolationQuality:kCGInterpolationDefault];
         }
         if (block) {
             block(image);
         }
     }];
}
//处理屏幕旋转
- (void)changePreviewOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (nil == self.preview) {
        return;
    }
    [CATransaction begin];
    if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        self.gorientation = UIImageOrientationUp;
        self.preview.connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
        
    }else if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
        self.gorientation = UIImageOrientationDown;
        self.preview.connection.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
        
    }else if (interfaceOrientation == UIDeviceOrientationPortrait){
        self.gorientation = UIImageOrientationRight;
        self.preview.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
        
    }else if (interfaceOrientation == UIDeviceOrientationPortraitUpsideDown){
        self.gorientation = UIImageOrientationLeft;
        self.preview.connection.videoOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
    }
    [CATransaction commit];
}
//结束获取图像
- (void)stopRunning {
    if (self.session) {
        [self.session stopRunning];
    }
}

//翻转摄像头
- (BOOL)toggleCamera {
    BOOL success = NO;
    NSInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    if (cameraCount > 1) {
        NSError *error;
        AVCaptureDeviceInput *newVideoInput;
        AVCaptureDevicePosition position = [[self.captureInput device] position];
        
        if (position == AVCaptureDevicePositionBack)
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self frontCamera] error:&error];
        else if (position == AVCaptureDevicePositionFront)
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backFacingCamera] error:&error];
        else
            goto bail;
        
        if (newVideoInput != nil) {
            [[self session] beginConfiguration];
            [[self session] removeInput:self.captureInput];
            if ([[self session] canAddInput:newVideoInput]) {
                [[self session] addInput:newVideoInput];
                self.captureInput = newVideoInput;
            }
            else {
                [[self session] addInput:self.captureInput];
            }
            [[self session] commitConfiguration];
            success = YES;
        }
        else if (error) {
            NSLog(@"切换镜头出错:%@",error);
        }
    }
bail:
    return success;
}
- (BOOL)isBackFacingCamera {
    BOOL isUse;
    AVCaptureDevicePosition position = [[self.captureInput device] position];
    
    if (position == AVCaptureDevicePositionBack){
        isUse = YES;
    }else if (position == AVCaptureDevicePositionFront){
        isUse = NO;
    }else{
        isUse = NO;
    }
    return isUse;
}
- (BOOL)isBackCameraSupportFlash {
    if ([[self backFacingCamera] hasFlash]) {
        return YES;
    }
    return NO;
}
- (BOOL)isBackCameraFlashSupportAutoMode {
    if ([[self backFacingCamera] hasFlash]) {
        if ([[self backFacingCamera] isFlashModeSupported:AVCaptureFlashModeAuto]) {
            return YES;
        }
    }
    return NO;
}
- (BOOL)isBackCameraFlashSupportOnMode {
    if ([[self backFacingCamera] hasFlash]) {
        if ([[self backFacingCamera] isFlashModeSupported:AVCaptureFlashModeOn]) {
            return YES;
        }
    }
    return NO;
}
- (BOOL)isBackCameraFlashSupportOffMode {
    if ([[self backFacingCamera] hasFlash]) {
        if ([[self backFacingCamera] isFlashModeSupported:AVCaptureFlashModeOff]) {
            return YES;
        }
    }
    return NO;
}
- (void)changeBackCameraFlashModeToAuto {
    if ([[self backFacingCamera] hasFlash]) {
        if ([[self backFacingCamera] lockForConfiguration:nil]) {
            if ([[self backFacingCamera] isFlashModeSupported:AVCaptureFlashModeAuto]) {
                [[self backFacingCamera] setFlashMode:AVCaptureFlashModeAuto];
            }
            [[self backFacingCamera] unlockForConfiguration];
        }
    }
}
- (void)changeBackCameraFlashModeToOn {
    if ([[self backFacingCamera] hasFlash]) {
        if ([[self backFacingCamera] lockForConfiguration:nil]) {
            if ([[self backFacingCamera] isFlashModeSupported:AVCaptureFlashModeOn]) {
                [[self backFacingCamera] setFlashMode:AVCaptureFlashModeOn];
            }
            [[self backFacingCamera] unlockForConfiguration];
        }
    }
}
- (void)changeBackCameraFlashModeToOff {
    if ([[self backFacingCamera] hasFlash]) {
        if ([[self backFacingCamera] lockForConfiguration:nil]) {
            if ([[self backFacingCamera] isFlashModeSupported:AVCaptureFlashModeOff]) {
                [[self backFacingCamera] setFlashMode:AVCaptureFlashModeOff];
            }
            [[self backFacingCamera] unlockForConfiguration];
        }
    }
}

@end