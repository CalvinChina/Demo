//
//  PSKBaseTableViewCell.h
//  PisenKit
//
//  Created by 杨胜超 on 16/7/1.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSKBaseTableViewCell : UITableViewCell

/** 注册 */
+ (void)registerCellToTableView:(UITableView *)tableView;
/** 重用 */
+ (instancetype)dequeueCellByTableView:(UITableView *)tableView;

/** 计算高度 */
+ (CGFloat)heightOfCellByObject:(NSObject *)object;
/** 显示数据 */
- (void)layoutObject:(NSObject *)object;

@end
