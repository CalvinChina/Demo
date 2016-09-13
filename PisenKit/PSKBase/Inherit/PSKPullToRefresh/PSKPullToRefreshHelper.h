//
//  PSKPullToRefreshHelper.h
//  PisenKit
//
//  Created by 杨胜超 on 16/7/1.
//  Copyright © 2016年 Pisen. All rights reserved.
//

@class PSKTipsView;

/** 定义(分页)加载功能用到的block */
typedef NSDictionary *(^PSKIntegerSetBlock)(NSInteger pageIndex);
typedef NSArray *(^PSKArraySetBlock)(NSArray *array);
typedef CGFloat (^PSKObjectIndexPathSetBlock)(NSObject *object, NSIndexPath *indexPath);
typedef CGFloat (^PSKObjectSectionSetBlock)(NSObject *object, NSInteger section);
typedef CGFloat (^PSKSectionSetBlock)(NSInteger section);
typedef NSString *(^PSKCellNameSetBlock)(NSObject *object, NSIndexPath *indexPath);
typedef NSString *(^PSKHeaderFooterNameSetBlock)(NSObject *object, NSInteger section);
typedef CGSize (^PSKHeaderFooterSizeSetBlock)(NSObject *object, NSInteger section);
typedef CGSize (^PSKCellSizeSetBlock)(NSObject *object, NSIndexPath *indexPath);
typedef void(^PSKLoadMoreBlock) (NSIndexSet *, NSArray<NSIndexPath *> *);
typedef void (^PSKObjectIndexPathBlock)(NSObject *object, NSIndexPath *indexPath);
typedef void (^PSKViewObjectIndexPathBlock)(UIView *view, NSObject *object, NSIndexPath *indexPath);
typedef void (^PSKIntegerBlock)(NSInteger pageIndex);


//------------------------------------
//  作用：
//      1. 封装UITableView和UICollectionView的分页加载功能
//      2. 管理数据为空的tipsView显示
//
//------------------------------------
@interface PSKPullToRefreshHelper : NSObject
// view
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) PSKTipsView *tipsView;
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
@property (nonatomic, assign) PSKRequestType requestType;
@property (nonatomic, strong) NSString *apiName;
@property (nonatomic, strong) NSString *modelName;
@property (nonatomic, strong) NSString *prefixOfUrl;//接口地址前缀
@property (nonatomic, assign) BOOL enableRefresh;   //是否启用下拉刷新(YES)
@property (nonatomic, assign) BOOL enableLoadMore;  //是否启用上拉加载更多(YES)
@property (nonatomic, strong) NSString *requestId;  //当前网络请求Id

// blocks
@property (nonatomic, copy) PSKIntegerSetBlock paramSetBlock;
@property (nonatomic, copy) PSKIntegerBlock customRefreshBlock;
@property (nonatomic, copy) PSKObjectBlock startLoadingBlock;      // 开始数据加载
@property (nonatomic, copy) PSKObjectBlock finishLoadingBlock;     // 加载数据结束
@property (nonatomic, copy) PSKArraySetBlock preProcessBlock;//对于下载回来的一维数组进行清洗过滤
@property (nonatomic, copy) PSKLoadMoreBlock loadMoreBlock;

// 设置ScrollViewDelegate相关的回调
@property (nonatomic, copy) PSKBlock willBeginDraggingBlock;
@property (nonatomic, copy) PSKBlock didEndDraggingBlock;
@property (nonatomic, copy) PSKBlock didScrollBlock;
@property (nonatomic, copy) PSKBlock didEndScrollingAnimationBlock;
@property (nonatomic, copy) PSKBlock willBeginDeceleratingBlock;
@property (nonatomic, copy) PSKBlock didEndDeceleratingBlock;

/** 是否正在加载数据 */
- (BOOL)isLoading;
/** 取消网络请求 */
- (void)cancelRequesting;

// 启动刷新
- (void)beginRefreshing;
- (void)beginRefreshingByAnimation:(BOOL)animation;

// 分页加载列表数据
- (void)refreshByInitialObject:(NSObject *)object;
- (void)loadDataByPageIndex:(NSInteger)pageIndex initialObject:(NSObject *)initialObject error:(NSString *)errorMessage;

// 显示数据
- (void)layoutDataByObject:(NSObject *)object;
- (void)layoutDataByObject:(NSObject *)object errorMessage:(NSString *)errorMessage;
- (void)layoutDataByObject:(NSObject *)object errorMessage:(NSString *)errorMessage pageIndex:(NSInteger)pageIndex;

/** 当数据为空时执行下拉刷新 */
- (void)beginRefreshingWhenCellDataIsEmpty;
/** 清空列表并刷新界面 */
- (void)clearDataAndRefreshView;

// 常用判断方法
- (BOOL)isCellDataEmpty;
- (BOOL)isLastCellByIndexPath:(NSIndexPath *)indexPath;
- (BOOL)isLastSectionByIndexPath:(NSIndexPath *)indexPath;
- (NSObject *)getObjectByIndexPath:(NSIndexPath *)indexPath;
- (void)removeDataAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathByObject:(NSObject *)object;
@end
