//
//  YSCCameraManager.h
//  KanPian
//
//  Created by 杨胜超 on 16/3/25.
//  Copyright © 2016年 SMIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSCCameraManager : NSObject
//弹出选择器
+ (UIActionSheet *)showImagePickerActionSheetonViewController:(UIViewController *)viewController
                                            numberOfSelection:(NSInteger)numberOfSelection;
+ (UIActionSheet *)showImagePickerActionSheetonViewController:(UIViewController *)viewController
                                            numberOfSelection:(NSInteger)numberOfSelection
                                                  cameraTitle:(NSString *)cameraTitle
                                             imagePickerTitle:(NSString *)imagePickerTitle;
//弹出系统相机进行拍照
+ (void)presentCameraPickerOnViewController:(UIViewController *)viewController;
//弹出图片选择器
+ (void)presentImagePickerOnViewController:(UIViewController *)viewController numberOfSelection:(NSInteger)numberOfSelection;
//统一创建UIImagePickerController
+ (UIImagePickerController *)createImagePickerController:(UIImagePickerControllerSourceType)sourceType
                                           allowsEditing:(BOOL)allowsEditing
                                                delegate:(id)delegate;
@end
