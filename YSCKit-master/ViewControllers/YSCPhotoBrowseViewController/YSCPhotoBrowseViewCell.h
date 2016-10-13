//
//  YSCPhotoBrowseViewCell.h
//  YSCKit
//
//  Created by yangshengchao on 15/8/23.
//  Copyright (c) 2015年 Builder. All rights reserved.
//


@interface YSCPhotoBrowseViewCell : YSCBaseCollectionViewCell

@property (weak, nonatomic) IBOutlet UIScrollView *zoomScrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (weak, nonatomic) IBOutlet UILabel *indicatorLabel;
@property (strong, nonatomic) UIImage *savedImage;//按下【保存】按钮，保存的图片对象

@end
