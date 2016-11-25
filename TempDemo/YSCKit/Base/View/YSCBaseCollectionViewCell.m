//
//  BaseCollectionViewCell.m
//  YSCKit
//
//  Created by yangshengchao on 14-11-4.
//  Copyright (c) 2014年 yangshengchao. All rights reserved.
//

#import "YSCBaseCollectionViewCell.h"

@implementation YSCBaseCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.clipsToBounds = YES;
    [self resetSize];
}

#pragma mark - 计算大小
+ (CGSize)sizeOfCellByObject:(NSObject *)object {
    return CGSizeMake(145, 145);
}

#pragma mark - 呈现数据
- (void)layoutObject:(NSObject *)object {}

@end
