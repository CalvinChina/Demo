//
//  UITableView+PisenKit.h
//  PisenKit
//
//  Created by 杨胜超 on 16/6/30.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import <UIKit/UIKit.h>

//==============================================================================
//
//  常用方法
//
//==============================================================================
@interface UITableView (PisenKit)
- (void)psk_updateWithBlock:(void (^)(UITableView *tableView))block;
- (void)psk_scrollToRow:(NSUInteger)row inSection:(NSUInteger)section atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated;
- (void)psk_insertRow:(NSUInteger)row inSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;
- (void)psk_reloadRow:(NSUInteger)row inSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;
- (void)psk_deleteRow:(NSUInteger)row inSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;
- (void)psk_insertRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation;
- (void)psk_reloadRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation;
- (void)psk_deleteRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation;
- (void)psk_insertSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;
- (void)psk_deleteSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;
- (void)psk_reloadSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;
- (void)psk_clearSelectedRowsAnimated:(BOOL)animated;
@end
