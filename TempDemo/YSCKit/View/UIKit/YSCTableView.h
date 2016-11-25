//
//  YSCTableView.h
//  YSCKit
//
//  Created by yangshengchao on 15/8/26.
//  Copyright (c) 2015年 Builder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSCPullToRefreshHelper.h"

//------------------------------------
//  支持的功能：
//      1. 多section的上拉加载更多、下拉刷新
//      2. GET、POST
//      3. 列表为空的提示信息
//      4. cell左右边界设置
//      5. 对数据进行缓存
//      6. 自定义任意单一确定的数据源
//      7. 动态设置header、cell、footer的高度
//      8. 支持多种header、cell、footer的注册
//      9. 兼容外部数据源(前提是必须和列表数据源类型一致)
//------------------------------------
@interface YSCTableView : UITableView
//关闭subview的缩放
@property (nonatomic, assign) BOOL closeResetFontAndConstraint;
// 封装了网络请求和tipsView的处理
@property (nonatomic, strong) YSCPullToRefreshHelper *helper;

@property (nonatomic, strong) IBInspectable NSString *apiName;
@property (nonatomic, strong) IBInspectable NSString *modelName;
@property (nonatomic, strong) IBInspectable NSString *cellName;
@property (nonatomic, strong) IBInspectable NSString *headerName;
@property (nonatomic, strong) IBInspectable NSString *footerName;
@property (nonatomic, assign) IBInspectable CGFloat cellSeperatorLeft;
@property (nonatomic, assign) IBInspectable CGFloat cellSeperatorRight;

// blocks
@property (nonatomic, copy) YSCObjectIndexPathBlock deleteCellBlock;
//  height
@property (nonatomic, copy) YSCObjectSectionSetBlock headerHeightBlock;
@property (nonatomic, copy) YSCObjectIndexPathSetBlock cellHeightBlock;
@property (nonatomic, copy) YSCObjectSectionSetBlock footerHeightBlock;
//  name
@property (nonatomic, copy) YSCHeaderFooterNameSetBlock headerNameBlock;
@property (nonatomic, copy) YSCCellNameSetBlock cellNameBlock;
@property (nonatomic, copy) YSCHeaderFooterNameSetBlock footerNameBlock;
//  click
@property (nonatomic, copy) YSCObjectIndexPathBlock clickCellBlock;
//  layout
@property (nonatomic, copy) YSCViewObjectIndexPathBlock layoutHeaderView;
@property (nonatomic, copy) YSCViewObjectIndexPathBlock layoutCellView;
@property (nonatomic, copy) YSCViewObjectIndexPathBlock layoutFooterView;

// 注册header、cell、footer
- (void)registerHeaderName:(NSString *)headerName;
- (void)registerCellName:(NSString *)cellName;
- (void)registerFooterName:(NSString *)footerName;

@end
