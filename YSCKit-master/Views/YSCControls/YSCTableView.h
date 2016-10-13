//
//  YSCTableView.h
//  YSCKit
//
//  Created by yangshengchao on 15/8/26.
//  Copyright (c) 2015年 Builder. All rights reserved.
//

#import <UIKit/UIKit.h>

//-------------定义block类型-------------
typedef NSArray *(^YSCArraySetBlock)(NSArray *array);
typedef void (^YSCObjectIndexPathResultBlock)(NSObject *object, NSIndexPath *indexPath);
typedef void (^YSCObjectIndexResultBlock)(NSObject *object, NSInteger section);
typedef void (^YSCViewObjectResultBlock)(UIView *view, NSObject *object);
typedef NSDictionary *(^YSCDictionarySetBlock)(NSInteger pageIndex);
typedef CGFloat (^YSCCellHeightSetBlock)(NSIndexPath *indexPath);
typedef CGFloat (^YSCHeaderFooterHeightSetBlock)(NSInteger section);
typedef NSString *(^YSCCellNameSetBlock)(NSObject *object, NSIndexPath *indexPath);
typedef NSString *(^YSCHeaderFooterNameSetBlock)(NSObject *object, NSInteger section);


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

//关闭YSCBaseViewController中对该view的subview进行缩放
@property (nonatomic, assign) BOOL closeResetFontAndConstraint;

#pragma mark - 基本属性
@property (nonatomic, strong) NSMutableArray *headerDataArray;
@property (nonatomic, strong) NSMutableArray *footerDataArray;
@property (nonatomic, strong) NSMutableArray *cellDataArray;
@property (nonatomic, assign) NSInteger currentPageIndex;
@property (nonatomic, assign) RequestType requestType;
@property (nonatomic, strong) YSCKTipsView *tipsView;   //提示信息，默认隐藏

#pragma mark - 必要的属性
@property (nonatomic, copy) YSCDictionarySetBlock dictParamBlock;
@property (nonatomic, strong) IBInspectable NSString *methodName;
@property (nonatomic, strong) IBInspectable NSString *modelName;
@property (nonatomic, strong) IBInspectable NSString *cellName;

#pragma mark - 已有默认定义的属性
@property (nonatomic, strong) IBInspectable NSString *prefixOfUrl;//接口地址前缀(kResPathBaseUrl)
@property (nonatomic, strong) IBInspectable NSString *tipsEmptyText;//内容为空时提示文本()
@property (nonatomic, strong) IBInspectable NSString *tipsEmptyIcon;//
@property (nonatomic, strong) IBInspectable NSString *tipsFailedIcon;//
@property (nonatomic, strong) IBInspectable NSString *tipsButtonTitle;//

@property (nonatomic, strong) IBInspectable NSString *headerName;//默认为空
@property (nonatomic, strong) IBInspectable NSString *footerName;//默认为空
@property (nonatomic, assign) IBInspectable CGFloat cellSeperatorLeft;
@property (nonatomic, assign) IBInspectable CGFloat cellSeperatorRight;

@property (nonatomic, assign) IBInspectable BOOL enableRefresh;//是否启用下拉刷新(YES)
@property (nonatomic, assign) IBInspectable BOOL enableLoadMore;//是否启用上拉加载更多(YES)
@property (nonatomic, assign) IBInspectable BOOL enableTips;//当列表为空时，是否显示tipsView(YES)
@property (nonatomic, assign) IBInspectable BOOL enableCellEdit;//是否开启删除功能(NO)

#pragma mark - 设置和回传
@property (nonatomic, copy) YSCResultBlock finishLoadBlock;//用来代替之前的successBlock和failedBlock
@property (nonatomic, copy) YSCArraySetBlock preProcessBlock;//对于下载回来的一维数组进行清洗过滤
@property (nonatomic, copy) YSCObjectIndexResultBlock clickHeaderBlock;
@property (nonatomic, copy) YSCObjectIndexResultBlock clickFooterBlock;
@property (nonatomic, copy) YSCObjectIndexPathResultBlock clickCellBlock;
@property (nonatomic, copy) YSCObjectIndexPathResultBlock deleteCellBlock;
@property (nonatomic, copy) YSCViewObjectResultBlock layoutHeaderView;
@property (nonatomic, copy) YSCViewObjectResultBlock layoutCellView;
@property (nonatomic, copy) YSCViewObjectResultBlock layoutFooterView;
@property (nonatomic, copy) YSCHeaderFooterHeightSetBlock headerHeightBlock;
@property (nonatomic, copy) YSCCellHeightSetBlock cellHeightBlock;
@property (nonatomic, copy) YSCHeaderFooterHeightSetBlock footerHeightBlock;

@property (nonatomic, copy) YSCHeaderFooterNameSetBlock headerNameBlock;
@property (nonatomic, copy) YSCCellNameSetBlock cellNameBlock;
@property (nonatomic, copy) YSCHeaderFooterNameSetBlock footerNameBlock;

#pragma mark - 设置ScrollViewDelegate相关的回调
@property (nonatomic, copy) YSCBlock willBeginDraggingBlock;
@property (nonatomic, copy) YSCBlock didEndDraggingBlock;
@property (nonatomic, copy) YSCBlock didScrollBlock;
@property (nonatomic, copy) YSCBlock didEndScrollingAnimationBlock;
@property (nonatomic, copy) YSCBlock willBeginDeceleratingBlock;
@property (nonatomic, copy) YSCBlock didEndDeceleratingBlock; 

//创建对象，不用xib布局时使用
+ (instancetype)CreateYSCTableViewOnView:(UIView *)view;
//注册header、cell、footer
- (void)registerHeaderName:(NSString *)headerName;
- (void)registerCellName:(NSString *)cellName;
- (void)registerFooterName:(NSString *)footerName;
//启动刷新(能加载一次缓存)
- (void)beginRefreshing;
- (void)beginRefreshingByAnimation:(BOOL)animation;
//当数据为空时执行下拉刷新
- (void)refreshWhenCellDataEmpty;
//清空数据列表
- (void)clearData;

//开启缓存模式
- (void)enableCacheWithFileName:(NSString *)fileName;

//下载数据(可重写)
- (void)refreshAtPageIndex:(NSInteger)pageIndex;
//下载数据(兼容外部数据源)
- (void)refreshAtPageIndex:(NSInteger)pageIndex response:(NSObject *)initObject error:(NSString *)errorMessage;

- (BOOL)isCellDataEmpty;//判断cell数组是否为空
- (BOOL)isLastCellByIndexPath:(NSIndexPath *)indexPath;//判断cell是否最后一个
- (BOOL)isLastSectionByIndexPath:(NSIndexPath *)indexPath;//判断section是否最后一个

@end
