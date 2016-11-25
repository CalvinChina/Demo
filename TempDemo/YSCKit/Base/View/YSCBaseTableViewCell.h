//
//  BaseTableViewCell.h
//  YSCKit
//
//  Created by yangshengchao on 14-11-1.
//  Copyright (c) 2014年 yangshengchao. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const kParamCellIdentifier = @"YSCKit_Cell";

@interface YSCBaseTableViewCell : UITableViewCell

#pragma mark - 计算高度
+ (CGFloat)heightOfCellByObject:(NSObject *)object;

#pragma mark - 呈现数据
- (void)layoutObject:(NSObject *)object;

@end
