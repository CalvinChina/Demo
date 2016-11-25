//
//  YSCPullToRefreshHelper.h
//  KanPian
//
//  Created by 杨胜超 on 16/3/26.
//  Copyright © 2016年 SMIT. All rights reserved.
//

#import "YSCTipsView.h"

/** 定义(分页)加载功能用到的block */
typedef NSDictionary *(^YSCIntegerSetBlock)(NSInteger pageIndex);
typedef NSArray *(^YSCArraySetBlock)(NSArray *array);
typedef CGFloat (^YSCObjectIndexPathSetBlock)(NSObject *object, NSIndexPath *indexPath);
typedef CGFloat (^YSCObjectSectionSetBlock)(NSObject *object, NSInteger section);
typedef CGFloat (^YSCSectionSetBlock)(NSInteger section);
typedef NSString *(^YSCCellNameSetBlock)(NSObject *object, NSIndexPath *indexPath);
typedef NSString *(^YSCHeaderFooterNameSetBlock)(NSObject *object, NSInteger section);
typedef CGSize (^YSCHeaderFooterSizeSetBlock)(NSObject *object, NSInteger section);
typedef CGSize (^YSCCellSizeSetBlock)(NSObject *object, NSIndexPath *indexPath);
typedef void(^YSCLoadMoreBlock) (NSIndexSet *, NSArray<NSIndexPath *> *);
typedef void (^YSCObjectIndexPathBlock)(NSObject *object, NSIndexPath *indexPath);
typedef void (^YSCViewObjectIndexPathBlock)(UIView *view, NSObject *object, NSIndexPath *indexPath);
typedef void (^YSCIntegerBlock)(NSInteger pageIndex);

//------------------------------------
//  作用：
//      1. 封装UITableView和UICollectionView(分页)加载功能
//      2. 管理数据为空的tipsView显示
//
//------------------------------------
@interface YSCPullToRefreshHelper : NSObject
// view
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) YSCTipsView *tipsView;
@property (nonatomic, strong) NSString *tipsEmptyText;
@property (nonatomic, strong) NSString *tipsEmptyIcon;
@property (nonatomic, strong) NSString *tipsFailedIcon;
@property (nonatomic, strong) NSString *tipsTimeoutIcon;
@property (nonatomic, strong) NSString *tipsButtonTitle;
@property (nonatomic, assign) BOOL enableTips;//当列表为空时，是否显示tipsView(YES)

// 基本属性
@property (nonatomic, strong) NSMutableArray *headerDataArray;
@property (nonatomic, strong) NSMutableArray *footerDataArray;
@property (nonatomic, strong) NSMutableArray *cellDataArray;
@property (nonatomic, assign) NSInteger currentPageIndex;
@property (nonatomic, assign) YSCRequestType requestType;
@property (nonatomic, strong) NSString *apiName;
@property (nonatomic, strong) NSString *modelName;
@property (nonatomic, strong) NSString *prefixOfUrl;//接口地址前缀
@property (nonatomic, assign) BOOL enableRefresh;   //是否启用下拉刷新(YES)
@property (nonatomic, assign) BOOL enableLoadMore;  //是否启用上拉加载更多(YES)
@property (nonatomic, strong) NSString *requestId;  //当前网络请求Id

// blocks
@property (nonatomic, copy) YSCIntegerSetBlock dictParamBlock;
@property (nonatomic, copy) YSCIntegerBlock customRefreshBlock;
@property (nonatomic, copy) YSCObjectBlock startLoadBlock;      // 开始数据加载
@property (nonatomic, copy) YSCObjectBlock finishLoadBlock;     // 加载数据结束
@property (nonatomic, copy) YSCArraySetBlock preProcessBlock;//对于下载回来的一维数组进行清洗过滤
@property (nonatomic, copy) YSCLoadMoreBlock loadMoreBlock;

// 设置ScrollViewDelegate相关的回调
@property (nonatomic, copy) YSCBlock willBeginDraggingBlock;
@property (nonatomic, copy) YSCBlock didEndDraggingBlock;
@property (nonatomic, copy) YSCBlock didScrollBlock;
@property (nonatomic, copy) YSCBlock didEndScrollingAnimationBlock;
@property (nonatomic, copy) YSCBlock willBeginDeceleratingBlock;
@property (nonatomic, copy) YSCBlock didEndDeceleratingBlock;

// 是否正在加载数据
- (BOOL)isLoading;

// 启动刷新(能加载一次缓存)
- (void)beginRefreshing;
- (void)beginRefreshingByAnimation:(BOOL)animation;

// 取消网络请求
- (void)cancelRequesting;
- (void)endRefreshing;

// 刷新列表
- (void)refreshWithObjects:(NSObject *)objects;
// 兼容第三方数据源
- (void)loadDataByPageIndex:(NSInteger)pageIndex response:(NSObject *)initObject error:(NSString *)errorMessage;

- (void)beginRefreshingWhenCellDataIsEmpty;             //当数据为空时执行下拉刷新
- (void)clearDataAndRefreshView;                        //清空列表并刷新界面
- (void)enableCacheWithFileName:(NSString *)fileName;   //开启缓存功能
- (BOOL)isCellDataEmpty;
- (BOOL)isLastCellByIndexPath:(NSIndexPath *)indexPath;
- (BOOL)isLastSectionByIndexPath:(NSIndexPath *)indexPath;
- (NSObject *)getObjectByIndexPath:(NSIndexPath *)indexPath;
- (void)removeDataAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathByObject:(NSObject *)object;
@end

