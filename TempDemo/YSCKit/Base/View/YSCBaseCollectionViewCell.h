//
//  BaseCollectionViewCell.h
//  YSCKit
//
//  Created by yangshengchao on 14-11-4.
//  Copyright (c) 2014年 yangshengchao. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const kParamItemCellIdentifier   = @"YSCKit_ItemCell";

@interface YSCBaseCollectionViewCell : UICollectionViewCell

#pragma mark - 计算大小
+ (CGSize)sizeOfCellByObject:(NSObject *)object;

#pragma mark - 呈现数据
- (void)layoutObject:(NSObject *)object;

@end
