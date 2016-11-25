//
//  YSCCameraManager.m
//  KanPian
//
//  Created by 杨胜超 on 16/3/25.
//  Copyright © 2016年 SMIT. All rights reserved.
//

#import "YSCCameraManager.h"
#import "ZYQAssetPickerController.h"

@interface YSCCameraManager () <UIActionSheetDelegate>
@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, assign) NSInteger numberOfSelection;
@property (nonatomic, copy) NSString *cameraTitle;
@property (nonatomic, copy) NSString *imagePickerTitle;
@end

@implementation YSCCameraManager
//弹出actionSheet选择器
+ (UIActionSheet *)showImagePickerActionSheetonViewController:(UIViewController *)viewController
                                            numberOfSelection:(NSInteger)numberOfSelection {
    return [self showImagePickerActionSheetonViewController:viewController
                                          numberOfSelection:numberOfSelection
                                                cameraTitle:@"拍摄照片"
                                           imagePickerTitle:@"选取照片"];
}
+ (UIActionSheet *)showImagePickerActionSheetonViewController:(UIViewController *)viewController
                                            numberOfSelection:(NSInteger)numberOfSelection
                                                  cameraTitle:(NSString *)cameraTitle
                                             imagePickerTitle:(NSString *)imagePickerTitle {
    YSCCameraManager *cameraManager = [YSCCameraManager new];
    cameraManager.viewController = viewController;
    cameraManager.numberOfSelection = numberOfSelection;
    cameraManager.cameraTitle = TRIM_STRING(cameraTitle);
    cameraManager.imagePickerTitle = TRIM_STRING(imagePickerTitle);
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:cameraManager cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:cameraTitle, imagePickerTitle, nil];
    [actionSheet showInView:viewController.view];
    return actionSheet;
}
//弹出系统相机进行拍照
+ (void)presentCameraPickerOnViewController:(UIViewController *)viewController {
    if ( ! [UIDevice isCanUseCamera]) {
        [YSCHUDManager showHUDThenHideOnKeyWindowWithMessage:@"请在设置->隐私->相机,打开本应用的权限"];
    }
    else {
        UIImagePickerController *imagePickerController = [self createImagePickerController:UIImagePickerControllerSourceTypeCamera allowsEditing:NO delegate:(id)viewController];
        [viewController presentViewController:imagePickerController animated:YES completion:nil];
    }
}
//弹出图片选择器
+ (void)presentImagePickerOnViewController:(UIViewController *)viewController numberOfSelection:(NSInteger)numberOfSelection {
    if ( ! [UIDevice isPhotoLibraryAvailable]) {
        [YSCHUDManager showHUDThenHideOnKeyWindowWithMessage:@"请在设置->隐私->照片,打开本应用的权限"];
    }
    else {
        if (numberOfSelection > 1) {//多张图片
            ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
            picker.delegate = (id)viewController;
            picker.maximumNumberOfSelection = numberOfSelection;
            picker.assetsFilter = [ALAssetsFilter allPhotos];
            picker.showEmptyGroups = NO;
            picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
                    NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
                    return duration >= 5;
                } else {
                    return YES;
                }
            }];
            [YSCConfigManager configNavigationBar:picker.navigationBar];
            [viewController presentViewController:picker animated:YES completion:NULL];
        }
        else {//选择相册里单张图片
            UIImagePickerController *imagePickerController = [self createImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary allowsEditing:NO delegate:(id)viewController];
            [viewController presentViewController:imagePickerController animated:YES completion:nil];
        }
    }
}
//统一创建UIImagePickerController
+ (UIImagePickerController *)createImagePickerController:(UIImagePickerControllerSourceType)sourceType
                                           allowsEditing:(BOOL)allowsEditing
                                                delegate:(id)delegate {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = delegate;
    imagePickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagePickerController.allowsEditing = allowsEditing;
    imagePickerController.sourceType = sourceType;
    [YSCConfigManager configNavigationBar:imagePickerController.navigationBar];
    return imagePickerController;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.cameraTitle == [actionSheet buttonTitleAtIndex:buttonIndex]) {
        [YSCCameraManager presentCameraPickerOnViewController:self.viewController];
    }
    else if (self.imagePickerTitle == [actionSheet buttonTitleAtIndex:buttonIndex]) {
        [YSCCameraManager presentImagePickerOnViewController:self.viewController
                                           numberOfSelection:self.numberOfSelection];
    }
}
@end
