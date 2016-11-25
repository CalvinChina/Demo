//
//  BaseCollectionHeaderFooterView.h
//  YSCKit
//
//  Created by yangshengchao on 14/11/24.
//  Copyright (c) 2014年 yangshengchao. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const kParamItemHeaderIdentifier     = @"YSCKit_ItemHeader";
static NSString * const kParamItemFooterIdentifier     = @"YSCKit_ItemFooter";

@interface YSCBaseCollectionHeaderFooterView : UICollectionReusableView

#pragma mark - 计算大小
+ (CGSize)sizeOfViewByObject:(NSObject *)object;

#pragma mark - 呈现数据
- (void)layoutObject:(NSObject *)object;

@end
