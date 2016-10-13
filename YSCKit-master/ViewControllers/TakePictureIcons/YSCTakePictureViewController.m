//
//  YSCTakePictureViewController.m
//  EZGoal
//
//  Created by yangshengchao on 15/7/2.
//  Copyright (c) 2015年 Builder. All rights reserved.
//

#import "YSCTakePictureViewController.h"
#import "CameraImageHelper.h"
#import "TOCropViewController.h"
#import <UIImage+Resize.h>

@interface YSCTakePictureViewController ()
@property (nonatomic, strong) CameraImageHelper *imageHelper;
@property (nonatomic, weak) IBOutlet UIView *topView;

@property (nonatomic, weak) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *takePictureButton;

@end

@implementation YSCTakePictureViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
}
- (void)viewDidDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [super viewDidDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.imageHelper = [CameraImageHelper new];
    [self.imageHelper embedPreviewInView:self.view];
    [self.imageHelper startRunning];
    [self.view bringSubviewToFront:self.topView];
    [self.view bringSubviewToFront:self.bottomView];
}

//执行拍照动作
- (IBAction)takePictureButtonClicked:(id)sender {
    WeakSelfType blockSelf = self;
    [self.imageHelper doCaptureimageWithBlock:^(UIImage *image) {
        //NOTE:这里可以根据frame大小剪切图片  [image croppedImage:CGRectMake(0, 0, 1000, 500)];然后直接返回
        
        //NOTE:进一步剪裁图片
        TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:image];
        [blockSelf presentViewController:cropController animated:YES completion:nil];
    }];
}

#pragma mark - InterfaceOrientation
//- (BOOL)shouldAutorotate {
//    return YES;
//}
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskLandscapeRight;
//}

@end
