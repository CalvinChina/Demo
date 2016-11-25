//
//  UITableView+YSCKit.h
//  YSCKit
//
//  Created by 杨胜超 on 16/3/30.
//  Copyright © 2016年 SMIT. All rights reserved.
//

@interface UITableView (YSCKit)
- (void)updateWithBlock:(void (^)(UITableView *tableView))block;
- (void)scrollToRow:(NSUInteger)row inSection:(NSUInteger)section atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated;
- (void)insertRow:(NSUInteger)row inSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;
- (void)reloadRow:(NSUInteger)row inSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;
- (void)deleteRow:(NSUInteger)row inSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;
- (void)insertRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation;
- (void)reloadRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation;
- (void)deleteRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation;
- (void)insertSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;
- (void)deleteSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;
- (void)reloadSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;
- (void)clearSelectedRowsAnimated:(BOOL)animated;
@end
