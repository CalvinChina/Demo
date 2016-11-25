//
//  BaseCollectionHeaderFooterView.m
//  YSCKit
//
//  Created by yangshengchao on 14/11/24.
//  Copyright (c) 2014年 yangshengchao. All rights reserved.
//

#import "YSCBaseCollectionHeaderFooterView.h"

@implementation YSCBaseCollectionHeaderFooterView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.clipsToBounds = YES;
    [self resetSize];
}

#pragma mark - 计算大小
+ (CGSize)sizeOfViewByObject:(NSObject *)object {
    return CGSizeMake(SCREEN_WIDTH, 35.0f);
}

#pragma mark - 呈现数据
- (void)layoutObject:(NSObject *)object {}

@end
