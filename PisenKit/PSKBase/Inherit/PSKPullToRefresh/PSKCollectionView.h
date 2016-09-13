//
//  PSKCollectionView.h
//  PisenKit
//
//  Created by 杨胜超 on 16/7/1.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import "PSKPullToRefreshHelper.h"

//------------------------------------
//  支持的功能：
//      1. 多section的上拉加载更多、下拉刷新
//      2. GET、POST
//      3. 列表为空的提示信息
//      4. 自定义任意单一确定的数据源
//      5. 动态设置header、cell、footer的size
//      6. 支持多种header、cell、footer的注册
//      7. 兼容外部数据源(前提是必须和列表数据源类型一致)
//------------------------------------
@interface PSKCollectionView : UICollectionView
// 封装了网络请求和tipsView的处理
@property (nonatomic, strong) PSKPullToRefreshHelper *helper;

@property (nonatomic, strong) IBInspectable NSString *apiName;
@property (nonatomic, strong) IBInspectable NSString *modelName;
@property (nonatomic, strong) IBInspectable NSString *cellName;
@property (nonatomic, strong) IBInspectable NSString *headerName;
@property (nonatomic, strong) IBInspectable NSString *footerName;
@property (nonatomic, assign) IBInspectable UIEdgeInsets cellEdgeInsets;

// blocks
/** 最小行间距 */
@property (nonatomic, copy) PSKSectionSetBlock minimumLineSpacingBlock;
/** 最小列间距 */
@property (nonatomic, copy) PSKSectionSetBlock minimumInteritemSpacingBlock;
/** 点击cell */
@property (nonatomic, copy) PSKObjectIndexPathBlock clickCellBlock;

//  name
@property (nonatomic, copy) PSKHeaderFooterNameSetBlock headerNameBlock;
@property (nonatomic, copy) PSKCellNameSetBlock cellNameBlock;
@property (nonatomic, copy) PSKHeaderFooterNameSetBlock footerNameBlock;

//  size
@property (nonatomic, copy) PSKHeaderFooterSizeSetBlock headerSizeBlock;
@property (nonatomic, copy) PSKCellSizeSetBlock cellSizeBlock;
@property (nonatomic, copy) PSKHeaderFooterSizeSetBlock footerSizeBlock;

//  layout
@property (nonatomic, copy) PSKViewObjectIndexPathBlock layoutHeaderView;
@property (nonatomic, copy) PSKViewObjectIndexPathBlock layoutCellView;
@property (nonatomic, copy) PSKViewObjectIndexPathBlock layoutFooterView;

// 注册header、cell、footer
- (void)registerHeaderName:(NSString *)headerName;
- (void)registerCellName:(NSString *)cellName;
- (void)registerFooterName:(NSString *)footerName;
@end
