//
//  PSKBaseTableHeaderFooterView.h
//  PisenKit
//
//  Created by 杨胜超 on 16/7/1.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSKBaseTableHeaderFooterView : UITableViewHeaderFooterView

/** 注册 */
+ (void)registerHeaderFooterToTableView:(UITableView *)tableView;
/** 重用 */
+ (instancetype)dequeueHeaderFooterByTableView:(UITableView *)tableView;

/** 计算高度 */
+ (CGFloat)heightOfViewByObject:(NSObject *)object;
/** 显示数据 */
- (void)layoutObject:(NSObject *)object;

@end
