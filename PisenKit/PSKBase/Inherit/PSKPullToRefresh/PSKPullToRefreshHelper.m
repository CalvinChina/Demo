//
//  PSKPullToRefreshHelper.m
//  PisenKit
//
//  Created by 杨胜超 on 16/7/1.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import "PSKPullToRefreshHelper.h"
#import "PSKTipsView.h"
#import "PSKRequestManager.h"
#import "PSKDataBaseModel.h"
#import "MJRefresh.h"

@interface PSKPullToRefreshHelper ()
@property (nonatomic, strong) NSMutableArray *sectionKeyArray;//用于存储分组的判断依据
@end

@implementation PSKPullToRefreshHelper
- (void)dealloc {
    PRINT_DEALLOCING
}
- (id)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)setup {
    self.sectionKeyArray = [NSMutableArray array];
    //基本属性
    self.headerDataArray = [NSMutableArray array];
    self.footerDataArray = [NSMutableArray array];
    self.cellDataArray = [NSMutableArray array];
    self.currentPageIndex = PSKConfigManagerInstance.defaultPageStartIndex;
    self.requestType = PSKRequestTypeGET;
    self.tipsTimeoutIcon = PSKConfigManagerInstance.defaultTimeoutImageName;
    self.tipsFailedIcon = PSKConfigManagerInstance.defaultErrorImageName;
    self.tipsEmptyIcon = PSKConfigManagerInstance.defaultEmptyImageName;
    
    //必要的属性
    self.paramSetBlock = ^NSDictionary *(NSInteger pageIndex) {
        return @{@"pageIndex" : @(pageIndex),
                 @"pageSize" : @(PSKConfigManagerInstance.defaultPageSize)};
    };
    
    //只要该block不能为nil！
    self.preProcessBlock = ^NSArray *(NSArray *array) {
        return array;
    };
}

#pragma mark - 属性设置
- (NSString *)prefixOfUrl {
    if (OBJECT_IS_EMPTY(_prefixOfUrl)) {
        return kPathAppBaseUrl;
    }
    return  _prefixOfUrl;
}
- (void)setEnableRefresh:(BOOL)enableRefresh {
    _enableRefresh = enableRefresh;
    if (enableRefresh) {
        @weakiy(self);
        self.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            if (weak_self.customRefreshBlock) {
                weak_self.customRefreshBlock(PSKConfigManagerInstance.defaultPageStartIndex);
            }
            else {
                [weak_self refreshByInitialObject:nil];
            }
        }];
    }
    else {
        self.scrollView.mj_header  = nil;
    }
}
- (void)setEnableLoadMore:(BOOL)enableLoadMore {
    _enableLoadMore = enableLoadMore;
    if (enableLoadMore) {
        @weakiy(self);
        self.scrollView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            if (weak_self.customRefreshBlock) {
                weak_self.customRefreshBlock(weak_self.currentPageIndex + 1);
            }
            else {
                [weak_self loadDataByPageIndex:weak_self.currentPageIndex + 1 initialObject:nil error:nil];
            }
        }];
    }
    else {
        self.scrollView.mj_footer = nil;
    }
}
- (void)setEnableTips:(BOOL)enableTips {
    _enableTips = enableTips;
    if (enableTips) {
        @weakiy(self);
        if ( ! self.tipsView) {
            self.tipsView = [PSKTipsView createPSKTipsViewOnView:self.scrollView
                                                    buttonAction:^{
                                                        [weak_self.scrollView.mj_header beginRefreshing];
                                                    }];
        }
        self.tipsView.hidden = YES;
    }
    else {
        if (self.tipsView) {
            [self.tipsView removeFromSuperview];
            self.tipsView = nil;
        }
    }
}

#pragma mark - 外部调用方法
// 是否正在加载数据
- (BOOL)isLoading {
    return self.scrollView.mj_header.isRefreshing || self.scrollView.mj_footer.isRefreshing;
}
// 启动刷新(能加载一次缓存)
- (void)beginRefreshing {
    [self beginRefreshingByAnimation:YES];
}
- (void)beginRefreshingByAnimation:(BOOL)animation {
    [self _reloadData];
    if (animation) {
        [self.scrollView.mj_header beginRefreshing];
    }
    else {
        if (self.customRefreshBlock) {
            self.customRefreshBlock(PSKConfigManagerInstance.defaultPageStartIndex);
        }
        else {
            [self refreshByInitialObject:nil];
        }
    }
}
// 取消网络请求
- (void)cancelRequesting {
    RETURN_WHEN_OBJECT_IS_EMPTY(self.requestId);
    [PSKRequestManagerInstance cancelRequestById:self.requestId];
    self.requestId = nil;// 因为会延迟一段时间才调用resultBlock，这里先置nil，防止重复cancel request
}
// 刷新列表
- (void)refreshByInitialObject:(NSObject *)object {
    [self loadDataByPageIndex:PSKConfigManagerInstance.defaultPageStartIndex initialObject:object error:nil];
}
- (void)loadDataByPageIndex:(NSInteger)pageIndex initialObject:(NSObject *)initialObject error:(NSString *)errorMessage {
    if (self.requestType <= PSKRequestTypePostBodyData) {
        @weakiy(self);
        self.requestId = [PSKRequestManagerInstance requestFromUrl:self.prefixOfUrl
                                                           withApi:self.apiName
                                                            params:self.paramSetBlock(pageIndex)
                                                         dataModel:NSClassFromString(self.modelName)
                                                              type:self.requestType
                                                           success:^(id responseObject) {
                                                               NSMutableArray *dataArray = [NSMutableArray array];
                                                               if ([responseObject isKindOfClass:[NSArray class]]) {
                                                                   [dataArray addObjectsFromArray:(NSArray *)responseObject];
                                                               }
                                                               else {
                                                                   if (OBJECT_ISNOT_EMPTY(responseObject)) {
                                                                       dataArray = [@[responseObject] mutableCopy];
                                                                   }
                                                               }
                                                               // 兼容外部数据源
                                                               if (OBJECT_ISNOT_EMPTY(initialObject) && [initialObject isKindOfClass:[NSArray class]]) {
                                                                   [dataArray addObjectsFromArray:(NSArray *)initialObject];
                                                               }
                                                               
                                                               [weak_self layoutDataByObject:dataArray errorMessage:nil pageIndex:pageIndex];
                                                           }
                                                            failed:^(NSString *PSKErrorType, NSError *error) {
                                                                NSString *errorMessage = [PSKRequestManagerInstance resolvePSKErrorType:PSKErrorType andError:error];
                                                                [weak_self layoutDataByObject:initialObject errorMessage:errorMessage pageIndex:pageIndex];
                                                            }];
        if (self.startLoadingBlock) {
            self.startLoadingBlock(self.requestId);
        }
    }
    else {
        [self layoutDataByObject:initialObject errorMessage:errorMessage];
    }
}
// 显示数据
- (void)layoutDataByObject:(NSObject *)object {
    [self layoutDataByObject:object errorMessage:nil];
}
- (void)layoutDataByObject:(NSObject *)object errorMessage:(NSString *)errorMessage {
    [self layoutDataByObject:object errorMessage:errorMessage pageIndex:PSKConfigManagerInstance.defaultPageStartIndex];
}
- (void)layoutDataByObject:(NSObject *)object errorMessage:(NSString *)errorMessage pageIndex:(NSInteger)pageIndex {
    @weakiy(self);
    self.requestId = nil;
    BOOL isPullToRefresh = (PSKConfigManagerInstance.defaultPageStartIndex == pageIndex); //是否下拉刷新
    isPullToRefresh ? [self.scrollView.mj_header endRefreshing] : [self.scrollView.mj_footer endRefreshing];
    if (errorMessage) {
        if (self.tipsView) {
            [self.tipsView resetMessage:errorMessage];
            if ([PSKConfigManagerInstance.networkErrorTimeout isEqualToString:errorMessage]) {
                [self.tipsView resetImageName:self.tipsTimeoutIcon];
            }
            else if ([PSKConfigManagerInstance.networkErrorReturnEmptyData isEqualToString:errorMessage]) {
                [self.tipsView resetImageName:self.tipsEmptyIcon];
            }
            else {
                [self.tipsView resetImageName:self.tipsFailedIcon];
            }
            [self.tipsView resetActionWithButtonTitle:self.tipsButtonTitle buttonAction:^{
                [weak_self beginRefreshing];
            }];
        }
    }
    else {
        //1. 根据组装后的数组刷新列表
        NSArray *newDataArray = nil;
        if (OBJECT_ISNOT_EMPTY(object)) {
            self.currentPageIndex = pageIndex;  //只要接口成功返回了数据，就把当前请求的页码保存起来
            if (self.preProcessBlock) {
                newDataArray = self.preProcessBlock((NSArray *)object);
            }
        }
        
        //-----------开始对tableView进行操作-----------
        if (isPullToRefresh) {
            [self.sectionKeyArray removeAllObjects];
            [self.headerDataArray removeAllObjects];
            [self.footerDataArray removeAllObjects];
            [self.cellDataArray removeAllObjects];
        }
        
        //3. 根据新数组刷新界面显示(包括下拉刷新、上拉加载更多、并且支持多section)
        if ([newDataArray count] > 0) {
            //>>>>>>>>>>>>>>>>>>>>多section的更新>>>>>>>>>>>>>>>>>>>>
            NSMutableArray *insertedIndexPaths = [NSMutableArray array];
            NSMutableIndexSet *insertedSections = [NSMutableIndexSet indexSet];
            // 3.1 遍历数据源
            for (NSObject *object in newDataArray) {
                NSInteger row = 0, section = 0;
                NSString *sectionKey = @"";//NOTE:兼容object是数组的情况
                if ([object isKindOfClass:[PSKDataBaseModel class]]) {
                    sectionKey = TRIM_STRING(((PSKDataBaseModel *)object).sectionKey);
                }
                
                if ([self.sectionKeyArray containsObject:sectionKey]) {
                    section = [self.sectionKeyArray indexOfObject:sectionKey];
                    NSMutableArray *tempArray = self.cellDataArray[section];
                    [tempArray addObject:object];
                    row = [tempArray count] - 1;
                }
                else {
                    row = 0;
                    section = [self.sectionKeyArray count];
                    [self.sectionKeyArray addObject:sectionKey];
                    
                    //处理section header model(直接保存原始的model，在具体显示的时候再确定显示哪个属性)
                    [self.headerDataArray addObject:object];
                    [self.footerDataArray addObject:object];
                    
                    NSMutableArray *tempArray = [NSMutableArray array];
                    [tempArray addObject:object];
                    [self.cellDataArray addObject:tempArray];
                    
                    //add new section
                    if (( ! isPullToRefresh) && OBJECT_ISNOT_EMPTY(sectionKey)) {
                        [insertedSections addIndex:section];
                    }
                }
                //add new row
                if ( ! isPullToRefresh) {
                    [insertedIndexPaths addObject:[NSIndexPath indexPathForRow:row inSection:section]];
                }
            }
            
            // 3.2 更新列表
            if (isPullToRefresh) {
                [self _reloadData];
            }
            else {
                if (self.loadMoreBlock) {
                    self.loadMoreBlock(insertedSections, insertedIndexPaths);
                }
            }
            //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        }
        else {
            if (isPullToRefresh) {
                [self _reloadData];//防止旧数据得不到清除
            }
            else {
                [PSKHUDHelper showHUDThenHideOnKeyWindowWithMessage:PSKConfigManagerInstance.defaultNoMoreMessage];
            }
        }
        
        //4. 数据为空的tips
        if (self.tipsView) {
            self.tipsView.actionButton.hidden = YES;
            [self.tipsView resetMessage:self.tipsEmptyText];
            [self.tipsView resetImageName:self.tipsEmptyIcon];
        }
    }
    
    self.tipsView.hidden = ( ! [self isCellDataEmpty]);
    if (self.finishLoadingBlock) {
        self.finishLoadingBlock(errorMessage);
    }
}

//当数据为空时执行下拉刷新
- (void)beginRefreshingWhenCellDataIsEmpty {
    if ([self isCellDataEmpty]) {
        [self beginRefreshing];
    }
}
//清空列表并刷新界面
- (void)clearDataAndRefreshView {
    [self.headerDataArray removeAllObjects];
    [self.cellDataArray removeAllObjects];
    [self.footerDataArray removeAllObjects];
    if (self.enableTips && self.tipsView.hidden) {
        self.tipsView.hidden = NO;
    }
    [self _reloadData];
}
- (BOOL)isCellDataEmpty {
    if (OBJECT_IS_EMPTY(self.cellDataArray)) {
        return YES;
    }
    //如果有空数组
    for (NSArray *array in self.cellDataArray) {
        if (OBJECT_ISNOT_EMPTY(array)) {
            return NO;
        }
    }
    return YES;
}
- (BOOL)isLastCellByIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == [self.cellDataArray count] - 1) {
        NSArray *array = self.cellDataArray[indexPath.section];
        if (indexPath.row == [array count] - 1) {
            return YES;
        }
        else {
            return NO;
        }
    }
    else {
        return NO;
    }
}
- (BOOL)isLastSectionByIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == [self.headerDataArray count] - 1;
}
- (NSObject *)getObjectByIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= 0 && indexPath.section >= [self.cellDataArray count]) {
        return nil;
    }
    NSArray *array = self.cellDataArray[indexPath.section];
    if (indexPath.row >= 0 && indexPath.row >= [array count]) {
        return nil;
    }
    return array[indexPath.row];
}
- (void)removeDataAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < [self.cellDataArray count]) {
        NSMutableArray *array = self.cellDataArray[indexPath.section];
        if (indexPath.row < [array count]) {
            [array removeObjectAtIndex:indexPath.row];
        }
    }
}
- (NSIndexPath *)indexPathByObject:(NSObject *)object {
    NSIndexPath *indexPath = nil;
    for (int i = 0; i < [self.cellDataArray count]; i++) {
        NSArray *array = self.cellDataArray[i];
        for (int j = 0; j < [array count]; j++) {
            NSObject *tempObject = array[j];
            if ([tempObject isEqual:object]) {
                indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                break;
            }
        }
    }
    return indexPath;
}

// 刷新界面
- (void)_reloadData {
    if ([self.scrollView respondsToSelector:@selector(reloadData)]) {
        [self.scrollView performSelector:@selector(reloadData)];
    }
}
@end
