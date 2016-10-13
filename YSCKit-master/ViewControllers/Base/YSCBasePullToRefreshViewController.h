//
//  BasePullToRefreshViewController.h
//  YSCKit
//
//  Created by  YangShengchao on 14-4-18.
//  Copyright (c) 2014年 yangshengchao. All rights reserved.
//  FORMATED!
//

/**
 *  下拉刷新的基类，兼容TableView和CollectionView的情况
 *
 *  @return
 */
#import "YSCBaseViewController.h"
#import "MJRefresh.h"

// 缓存数组的唯一键
#define KeyOfCachedArray      @"KeyOfCachedArray"

typedef void(^PullToRefreshSuccessed)(void);
typedef void(^PullToRefreshFailed)(void);

// TODO:
// 1. 目前暂时不支持一个VC有多个下拉刷新的情况
// 2. 多个section的也不支持
@interface YSCBasePullToRefreshViewController : YSCBaseViewController

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger currentPageIndex;   //分页的页码指针

@property (nonatomic, copy) PullToRefreshFailed failedBlock;
@property (nonatomic, copy) PullToRefreshSuccessed successBlock;

#pragma mark - 下拉刷新和上拉加载更多方法

//刷新列表
- (void)refreshWithSuccessed:(PullToRefreshSuccessed)successed failed:(PullToRefreshFailed)failed;
- (void)refreshWithSuccessed:(PullToRefreshSuccessed)successed failed:(PullToRefreshFailed)failed withRequestType:(RequestType)requestType;
//加载更多
- (void)loadMoreWithSuccessed:(PullToRefreshSuccessed)successed failed:(PullToRefreshFailed)failed;
- (void)loadMoreWithSuccessed:(PullToRefreshSuccessed)successed failed:(PullToRefreshFailed)failed withRequestType:(RequestType)requestType;
//以下两个方法是为了兼容返回model不规范的情况，子类可以重写
- (void)getDataByParam:(NSDictionary *)param successed:(RequestSuccessed)successed failed:(RequestFailure)failed;
- (void)postDataByParam:(NSDictionary *)param successed:(RequestSuccessed)successed failed:(RequestFailure)failed;

//刷新列表
- (void)reloadByReplacing:(NSArray *)anArray;
//添加新内容刷新列表
- (void)reloadByAdding:(NSArray *)anArray;

- (void)addRefreshHeaderView;
- (void)addRefreshFooterView;

- (void)setIsTipsViewHidden:(BOOL)isTipsViewHidden withTipText:(NSString *)tipText;


#pragma mark - 可选的重写方法

- (NSArray *)loadCacheArray;                        //本类特有：加载缓存数组
- (NSArray *)preProcessData:(NSArray *)anArray;     //对数组进行预处理
- (BOOL)shouldCacheArray;                           //是否缓存下拉刷新的数组对象（默认NO）
- (BOOL)shouldRefreshWhenEntered;                   //界面初始化后是否立即刷新（默认YES）
- (BOOL)loadMoreEnable;                             //是否开放加载更多的功能（默认YES）
- (BOOL)refreshEnable;                              //是否支持刷新（默认YES）
- (NSInteger)cellCount;                             //Cell数量
- (NSString *)prefixOfUrl;                          //接口前缀(默认是业务接口前缀kResPathBaseUrl)
- (NSString *)hintStringWhenNoData;                 //当没有数据的时候显示提示文本
- (BOOL)tipsViewEnable;                             //当没有数据的时候是否显示tipsview（默认YES）
- (UIView *)layoutCellWithData:(id)object atIndexPath:(NSIndexPath *)indexPath;     //根据数据来布局界面
- (void)clickedCell:(id)object atIndexPath:(NSIndexPath *)indexPath;
- (UIEdgeInsets)tipsViewEdgeInsets;

#pragma mark - 最终的子类必须重写的方法

- (NSString *)methodWithPath;                       //接口方法
- (NSDictionary *)dictParamWithPage:(NSInteger)page;//请求参数封装
- (Class)modelClassOfData;                          //BaseDataModel
- (NSString *)nibNameOfCell;                        //自定义的cell布局文件

#pragma mark - 必须且只在一级子类里重写的方法

/**
 *  目前只支持UItableView和UICollectionView
 */
- (UIScrollView *)contentScrollView;
- (void)reloadData;

@end
