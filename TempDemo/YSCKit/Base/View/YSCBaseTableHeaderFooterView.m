//
//  BaseTableViewHeaderFooterView.m
//  YSCKit
//
//  Created by yangshengchao on 14/11/20.
//  Copyright (c) 2014年 yangshengchao. All rights reserved.
//

#import "YSCBaseTableHeaderFooterView.h"

@implementation YSCBaseTableHeaderFooterView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.clipsToBounds = YES;
    [self resetSize];
}

#pragma mark - 计算高度
+ (CGFloat)heightOfViewByObject:(NSObject *)object {
    return 35.0f;
}

#pragma mark - 呈现数据
- (void)layoutObject:(NSObject *)object {}

@end
