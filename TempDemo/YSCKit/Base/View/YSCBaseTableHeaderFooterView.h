//
//  BaseTableViewHeaderFooterView.h
//  YSCKit
//
//  Created by yangshengchao on 14/11/20.
//  Copyright (c) 2014年 yangshengchao. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const kParamHeaderIdentifier     = @"YSCKit_Header";
static NSString * const kParamFooterIdentifier     = @"YSCKit_Footer";

@interface YSCBaseTableHeaderFooterView : UITableViewHeaderFooterView

#pragma mark - 计算高度
+ (CGFloat)heightOfViewByObject:(NSObject *)object;//NOTE:子类只能实现这个

#pragma mark - 呈现数据
- (void)layoutObject:(NSObject *)object;

@end
