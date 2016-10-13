//
//  YSCPhotoBrowseViewController.m
//  YSCKit
//
//  Created by yangshengchao on 15/8/23.
//  Copyright (c) 2015年 Builder. All rights reserved.
//

#import "YSCPhotoBrowseViewController.h"
#import "YSCPhotoBrowseViewCell.h"
#import "YSCPhotoBrowseView.h"

@interface YSCPhotoBrowseViewController ()

@property (weak, nonatomic) IBOutlet YSCPhotoBrowseView *photoBrowseView;
@property (weak, nonatomic) IBOutlet UILabel *indexLabel;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (assign, nonatomic) NSInteger currentIndex;

@end

@implementation YSCPhotoBrowseViewController

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
    //隐藏naviBar
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:self.params];
    tempDict[kParamIsHideNavBar] = @(YES);
    self.params = tempDict;
    
    self.view.backgroundColor = [UIColor blackColor];
    [self.indexLabel makeRoundWithRadius:AUTOLAYOUT_LENGTH(40) / 2];
    [self.saveButton makeBorderWithColor:[UIColor lightGrayColor] borderWidth:1];
    [self.closeButton makeBorderWithColor:[UIColor lightGrayColor] borderWidth:1];
    
    //1. 初始化数据源模型数组
    self.dataArray = [NSMutableArray array];
    if (self.params[kParamImageUrls]) {
        for (NSString *imageUrl in (NSArray *)self.params[kParamImageUrls] ) {
            YSCPhotoBrowseCellModel *model = [YSCPhotoBrowseCellModel CreateModelByImageUrl:imageUrl image:nil];
            [self.dataArray addObject:model];
        }
    }
    else if (self.params[kParamImages]) {
        for (UIImage *image in (NSArray *)self.params[kParamImages]) {
            YSCPhotoBrowseCellModel *model = [YSCPhotoBrowseCellModel CreateModelByImageUrl:nil image:image];
            [self.dataArray addObject:model];
        }
    }
    else if (self.params[kParamImageModels]) {//直接传入模型数组，解决数据源单一问题(即同时支持image和url的图片显示)
        NSArray *array = self.params[kParamImageModels];
        if ([array isKindOfClass:[NSArray class]] && [array count] > 0) {
            [self.dataArray addObjectsFromArray:array];
        }
    }
    //2. 刷新数据源
    [self initPhotoBrowseView];
    
    //3. 初始化当前页码
    if (self.params[kParamIndex]) {
        self.photoBrowseView.hidden = YES;
        WEAKSELF
        [self bk_performBlock:^(id obj) {
            weakSelf.photoBrowseView.hidden = NO;
            [weakSelf.photoBrowseView resetCurrentIndex:[weakSelf.params[kParamIndex] integerValue]];
        } afterDelay:0.3];
        self.currentIndex = [self.params[kParamIndex] integerValue];
    }
    else {
        self.currentIndex = 0;
    }
}
- (void)initPhotoBrowseView {
    WEAKSELF
    self.photoBrowseView.tapPageAtIndex = ^(NSInteger index, NSError *error) {
        [weakSelf.navigationController popViewControllerAnimated:NO];
    };
    self.photoBrowseView.scrollAtIndex = ^(NSInteger index, NSError *error) {
        weakSelf.currentIndex = index;
    };
    self.photoBrowseView.minimumLineSpacing = 10;
    [self.photoBrowseView refreshCollectionViewByItemArray:self.dataArray];
}
- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    self.indexLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)(self.currentIndex + 1), (long)[self.dataArray count]];
}

#pragma mark - 按钮事件
- (IBAction)saveButtonClicked:(id)sender {
    YSCPhotoBrowseViewCell *cell = (YSCPhotoBrowseViewCell *)[self.photoBrowseView.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
    if (cell.savedImage) {
        [UIView showHUDLoadingOnWindow:@"正在保存"];
        UIImageWriteToSavedPhotosAlbum(cell.savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    else {
        [UIView showResultThenHideOnWindow:@"图片为空"];
    }
}
- (IBAction)closeButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}
// 写到文件的完成时执行
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (nil == error) {
        [UIView showResultThenHideOnWindow:@"保存成功"];
    }
    else {
        [UIView showResultThenHideOnWindow:@"保存失败！"];
    }
}

@end
