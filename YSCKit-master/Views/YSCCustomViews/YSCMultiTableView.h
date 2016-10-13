//
//  YSCMultiTableView.h
//  YSCKit
//
//  Created by yangshengchao on 15/9/8.
//  Copyright (c) 2015年 Builder. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef UITableView *(^YSCTableViewSetBlock)(NSInteger pageIndex);

@interface YSCMultiTableView : UIView <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

//关闭YSCBaseViewController中对该view的subview进行缩放
@property (nonatomic, assign) BOOL closeResetFontAndConstraint;

//TableView之间的间隔
@property (nonatomic, assign) IBInspectable CGFloat seperatorSpace;
@property (nonatomic, assign) IBInspectable NSInteger numbersOfTableView;

@property (nonatomic, copy) YSCTableViewSetBlock tableViewBlock;
@property (nonatomic, copy) YSCIntegerResultBlock scrollAtIndex;

//刷新列表
- (void)reloadTableViews;
//滚动到指定页面
- (void)scrollToPage:(NSInteger)pageIndex;
- (void)scrollToPage:(NSInteger)pageIndex animated:(BOOL)animated;

@end
