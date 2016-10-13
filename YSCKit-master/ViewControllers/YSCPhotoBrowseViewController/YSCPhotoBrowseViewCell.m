//
//  YSCPhotoBrowseViewCell.m
//  YSCKit
//
//  Created by yangshengchao on 15/8/23.
//  Copyright (c) 2015年 Builder. All rights reserved.
//

#import "YSCPhotoBrowseViewCell.h"

@interface YSCPhotoBrowseViewCell () <UIScrollViewDelegate>
@property (strong, nonatomic) UIImageView *photoImageView;
@end

@implementation YSCPhotoBrowseViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.photoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.photoImageView.backgroundColor = [UIColor clearColor];
    self.photoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.zoomScrollView addSubview:self.photoImageView];
    
    self.zoomScrollView.backgroundColor = [UIColor clearColor];
    self.zoomScrollView.minimumZoomScale = 1.0;
    self.zoomScrollView.maximumZoomScale = 3.0;
    self.zoomScrollView.showsHorizontalScrollIndicator = NO;
    self.zoomScrollView.showsVerticalScrollIndicator = NO;
    self.zoomScrollView.delegate = self;
    self.zoomScrollView.userInteractionEnabled = YES;
    [self.zoomScrollView bk_whenTapped:^{
        UIViewController *controller = YSCInstance.currentViewController;
        [controller.navigationController popViewControllerAnimated:NO];
    }];
}
- (void)layoutObject:(YSCPhotoBrowseCellModel *)dataModel {
    [self.zoomScrollView setZoomScale:1 animated:NO];
    if (isNotEmpty(dataModel.image)) {
        [self layoutPhotoImage:dataModel.image];
    }
    else {
        self.indicatorLabel.hidden = self.indicatorView.hidden = NO;
        self.zoomScrollView.hidden = YES;
        self.indicatorLabel.text = @"图片加载中";
        if ([NSString isNotUrl:dataModel.imageUrl]) {
            UIImage *cacheImage = [UIImage imageWithContentsOfFile:dataModel.imageUrl];
            if (cacheImage) {
                [self layoutPhotoImage:cacheImage];
            }
            else {
                [self loadImageFailed];
            }
        }
        else {
            WEAKSELF
            [self.indicatorView startAnimating];
            [self.photoImageView setImageWithURLString:dataModel.imageUrl completed:^(UIImage *image, NSError *error) {
                [weakSelf.indicatorView stopAnimating];
                if (image) {
                    weakSelf.photoImageView.contentMode = UIViewContentModeScaleAspectFit;
                    [weakSelf layoutPhotoImage:image];
                }
                else {
                    [weakSelf loadImageFailed];
                }
            }];
        }
    }
}
//这里需要根据image的大小动态计算imageView的大小
- (void)layoutPhotoImage:(UIImage *)image {
    self.indicatorLabel.hidden = self.indicatorView.hidden = YES;
    self.zoomScrollView.hidden = NO;
    self.savedImage = image;
    
    self.photoImageView.image = image;
    CGFloat imageWidth = MIN(SCREEN_WIDTH, image.size.width);
    CGFloat imageHeight = image.size.height * imageWidth / image.size.width;
    if (imageHeight > SCREEN_HEIGHT) {
        imageHeight = SCREEN_HEIGHT;
        imageWidth = image.size.width * imageHeight / image.size.height;
    }
    self.photoImageView.size = CGSizeMake(imageWidth, imageHeight);
    self.photoImageView.center = CGPointMake(SCREEN_WIDTH / 2.0f, SCREEN_HEIGHT / 2.0f);//center的设置必须在size设置之后！
}
//图片加载失败
- (void)loadImageFailed {
    self.indicatorView.hidden = YES;
    self.indicatorLabel.hidden = NO;
    self.indicatorLabel.text = @"图片加载失败";
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.photoImageView;//contentSize根据该缩放view的size等比例缩放
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {//在缩放过程中，动态设置图片的中心点始终处于屏幕中心
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) /2 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) /2 : 0.0;
    self.photoImageView.center = CGPointMake(scrollView.contentSize.width / 2 + offsetX,
                                             scrollView.contentSize.height / 2 + offsetY);
}

@end
