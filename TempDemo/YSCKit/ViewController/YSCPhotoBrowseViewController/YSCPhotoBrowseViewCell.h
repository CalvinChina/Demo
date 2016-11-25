//
//  YSCPhotoBrowseViewCell.h
//  YSCKit
//
//  Created by yangshengchao on 15/8/23.
//  Copyright (c) 2015年 Builder. All rights reserved.
//

/** 图片数据模型 */
@interface YSCPhotoBrowseCellModel : YSCDataModel
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) UIImage *image;
+ (instancetype)createModelByImageUrl:(NSString *)imageUrl image:(UIImage *)image;
@end

@interface YSCPhotoBrowseViewCell : YSCBaseCollectionViewCell
@property (weak, nonatomic) IBOutlet UIScrollView *zoomScrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (weak, nonatomic) IBOutlet UILabel *indicatorLabel;
@property (strong, nonatomic) UIImage *savedImage;//按下【保存】按钮，保存的图片对象
@end
