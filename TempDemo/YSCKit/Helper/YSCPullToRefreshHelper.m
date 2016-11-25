//
//  YSCPullToRefreshHelper.m
//  KanPian
//
//  Created by 杨胜超 on 16/3/26.
//  Copyright © 2016年 SMIT. All rights reserved.
//

#import "YSCPullToRefreshHelper.h"
#import "YSCRequestHelper.h"
#import "MJRefresh.h"

NSString * const kCachedHeaderData  = @"kCachedHeaderData";
NSString * const kCachedCellData    = @"kCachedCellData";
NSString * const kCachedFooterData  = @"kCachedFooterData";
NSString * const kCachedSectionKey  = @"kCachedSectionKey";


@interface YSCPullToRefreshHelper ()
@property (nonatomic, strong) NSMutableArray *sectionKeyArray;//用于存储分组的判断依据
@property (nonatomic, assign) BOOL isLoadedCache;//控制缓存只加载一次
@property (nonatomic, strong) NSString *cacheFileName;//缓存数据保存的文件名称
@end

@implementation YSCPullToRefreshHelper

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
    self.currentPageIndex = YSCConfigDataInstance.defaultPageStartIndex;
    self.requestType = YSCRequestTypeGET;
    self.tipsTimeoutIcon = YSCConfigDataInstance.defaultTimeoutImageName;
    self.tipsFailedIcon = YSCConfigDataInstance.defaultErrorImageName;
    self.tipsEmptyIcon = YSCConfigDataInstance.defaultEmptyImageName;
    
    //必要的属性
    self.dictParamBlock = ^NSDictionary *(NSInteger pageIndex) {
        return @{kParamPageIndex : @(pageIndex),
                 kParamPageSize : @(YSCConfigDataInstance.defaultPageSize)};
    };
    
    //只要该block不能为nil！
    self.preProcessBlock = ^NSArray *(NSArray *array) {
        return array;
    };
}
- (void)dealloc {
    NSLog(@"YSCPullToRefreshHelper is deallocing...");
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
                weak_self.customRefreshBlock(YSCConfigDataInstance.defaultPageStartIndex);
            }
            else {
                [weak_self loadDataByPageIndex:YSCConfigDataInstance.defaultPageStartIndex response:nil error:nil];
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
                [weak_self loadDataByPageIndex:weak_self.currentPageIndex + 1 response:nil error:nil];
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
            self.tipsView = [YSCTipsView createYSCTipsViewOnView:self.scrollView
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
    [self _loadCacheData];
    [self _reloadData];
    if (animation) {
        [self.scrollView.mj_header beginRefreshing];
    }
    else {
        if (self.customRefreshBlock) {
            self.customRefreshBlock(YSCConfigDataInstance.defaultPageStartIndex);
        }
        else {
            [self loadDataByPageIndex:YSCConfigDataInstance.defaultPageStartIndex response:nil error:nil];
        }
    }
}
// 取消网络请求
- (void)cancelRequesting {
    RETURN_WHEN_OBJECT_IS_EMPTY(self.requestId);
    [YSCRequestInstance cancelRequestById:self.requestId];
    self.requestId = nil;// 因为会延迟一段时间才调用resultBlock，这里先置nil，防止重复cancel request
}
- (void)endRefreshing {
    if (YSCConfigDataInstance.defaultPageStartIndex == self.currentPageIndex) {
        [self.scrollView.mj_header endRefreshing];
    }
    else {
        [self.scrollView.mj_footer endRefreshing];
    }
}
// 刷新列表
- (void)refreshWithObjects:(NSObject *)objects {
    [self loadDataByPageIndex:YSCConfigDataInstance.defaultPageStartIndex response:objects error:nil];
}
- (void)loadDataByPageIndex:(NSInteger)pageIndex response:(NSObject *)initObject error:(NSString *)errorMessage {
    @weakiy(self);
    YSCObjectErrorMessageBlock resultBlock = ^(NSObject *object, NSString *errorMessage) {
        weak_self.requestId = nil;
        BOOL isPullToRefresh = (YSCConfigDataInstance.defaultPageStartIndex == pageIndex); //是否下拉刷新
        isPullToRefresh ? [weak_self.scrollView.mj_header endRefreshing] : [weak_self.scrollView.mj_footer endRefreshing];
        if (errorMessage) {
            if (weak_self.tipsView) {
                [weak_self.tipsView resetMessage:errorMessage];
                if ([YSCConfigDataInstance.networkErrorTimeout isEqualToString:errorMessage]) {
                    [weak_self.tipsView resetImageName:weak_self.tipsTimeoutIcon];
                }
                else if ([YSCConfigDataInstance.networkErrorReturnEmptyData isEqualToString:errorMessage]) {
                    [weak_self.tipsView resetImageName:weak_self.tipsEmptyIcon];
                }
                else {
                    [weak_self.tipsView resetImageName:weak_self.tipsFailedIcon];
                }
                [weak_self.tipsView resetActionWithButtonTitle:weak_self.tipsButtonTitle buttonAction:^{
                    [weak_self beginRefreshing];
                }];
            }
        }
        else {
            //1. 根据组装后的数组刷新列表
            NSArray *newDataArray = nil;
            if (OBJECT_ISNOT_EMPTY(object)) {
                weak_self.currentPageIndex = pageIndex;  //只要接口成功返回了数据，就把当前请求的页码保存起来
                if (weak_self.preProcessBlock) {
                    newDataArray = weak_self.preProcessBlock((NSArray *)object);
                }
            }
            
            //-----------开始对tableView进行操作-----------
            if (isPullToRefresh) {
                [weak_self.sectionKeyArray removeAllObjects];
                [weak_self.headerDataArray removeAllObjects];
                [weak_self.footerDataArray removeAllObjects];
                [weak_self.cellDataArray removeAllObjects];
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
                    if ([object isKindOfClass:[YSCDataModel class]]) {
                        sectionKey = TRIM_STRING(((YSCDataModel *)object).sectionKey);
                    }
                    
                    if ([weak_self.sectionKeyArray containsObject:TRIM_STRING(sectionKey)]) {
                        section = [weak_self.sectionKeyArray indexOfObject:TRIM_STRING(sectionKey)];
                        NSMutableArray *tempArray = weak_self.cellDataArray[section];
                        [tempArray addObject:object];
                        row = [tempArray count] - 1;
                    }
                    else {
                        row = 0;
                        section = [weak_self.sectionKeyArray count];
                        [weak_self.sectionKeyArray addObject:TRIM_STRING(sectionKey)];
                        
                        //处理section header model(直接保存原始的model，在具体显示的时候再确定显示哪个属性)
                        [weak_self.headerDataArray addObject:object];
                        [weak_self.footerDataArray addObject:object];
                        
                        NSMutableArray *tempArray = [NSMutableArray array];
                        [tempArray addObject:object];
                        [weak_self.cellDataArray addObject:tempArray];
                        
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
                    [weak_self _reloadData];
                }
                else {
                    if (weak_self.loadMoreBlock) {
                        weak_self.loadMoreBlock(insertedSections, insertedIndexPaths);
                    }
                }
                //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
            }
            else {
                if (isPullToRefresh) {
                    [weak_self _reloadData];//防止旧数据得不到清除
                }
                else {
                    [YSCHUDManager showHUDThenHideOnKeyWindowWithMessage:YSCConfigDataInstance.defaultNoMoreMessage];
                }
            }
            
            //4. 数据为空的tips
            if (weak_self.tipsView) {
                weak_self.tipsView.actionButton.hidden = YES;
                [weak_self.tipsView resetMessage:weak_self.tipsEmptyText];
                [weak_self.tipsView resetImageName:weak_self.tipsEmptyIcon];
            }
            
            //5. 缓存数据
            if (OBJECT_ISNOT_EMPTY(weak_self.cacheFileName)) {
                YSCSaveCacheObjectByFile(weak_self.sectionKeyArray, kCachedSectionKey, weak_self.cacheFileName);
                YSCSaveCacheObjectByFile(weak_self.headerDataArray, kCachedHeaderData, weak_self.cacheFileName);
                YSCSaveCacheObjectByFile(weak_self.cellDataArray, kCachedCellData, weak_self.cacheFileName);
                YSCSaveCacheObjectByFile(weak_self.footerDataArray, kCachedFooterData, weak_self.cacheFileName);
            }
        }
        
        weak_self.tipsView.hidden = ( ! [weak_self isCellDataEmpty]);
        if (weak_self.finishLoadBlock) {
            weak_self.finishLoadBlock(errorMessage);
        }
    };
    YSCRequestSuccess successBlock = ^(id responseObject) {
        NSMutableArray *dataArray = [NSMutableArray array];
        if ([responseObject isKindOfClass:[NSArray class]]) {
            [dataArray addObjectsFromArray:(NSArray *)responseObject];
        }
        else {
            if (OBJECT_ISNOT_EMPTY(responseObject)) {
                dataArray = [@[responseObject] mutableCopy];
            }
        }
        //兼容外部数据源
        if (OBJECT_ISNOT_EMPTY(initObject) && [initObject isKindOfClass:[NSArray class]]) {
            [dataArray addObjectsFromArray:(NSArray *)initObject];
        }
        
        resultBlock(dataArray, nil);
    };
    YSCRequestFailed failedBlock = ^(NSString *YSCErrorType, NSError *error) {
        NSString *errorMessage = [YSCRequestInstance resolveYSCErrorType:YSCErrorType andError:error];
        resultBlock(initObject, errorMessage);
    };
    
    //4. 开始网络访问
    if (self.requestType <= YSCRequestTypePostBodyData && ! self.customRefreshBlock) {
        self.requestId = [YSCRequestInstance requestFromUrl:self.prefixOfUrl
                                                    withApi:self.apiName
                                                     params:self.dictParamBlock(pageIndex)
                                                  dataModel:NSClassFromString(self.modelName)
                                                       type:self.requestType
                                                    success:successBlock
                                                     failed:failedBlock];
        if (self.startLoadBlock) {
            self.startLoadBlock(self.requestId);
        }
    }
    else {
        resultBlock(initObject, errorMessage);
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
    [self _reloadData];
    if (self.enableTips && self.tipsView.hidden) {
        self.tipsView.hidden = NO;
    }
}
//开启缓存功能//开启缓存功能
- (void)enableCacheWithFileName:(NSString *)fileName {
    RETURN_WHEN_OBJECT_IS_EMPTY(fileName)
    self.cacheFileName = fileName;
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

// 加载缓存
- (void)_loadCacheData {
    if (OBJECT_ISNOT_EMPTY(self.cacheFileName) && ( ! self.isLoadedCache)) {
        self.isLoadedCache = YES;//控制缓存只加载一次
        
        [self.sectionKeyArray removeAllObjects];
        NSArray *array = YSCGetCacheObjectByFile(kCachedSectionKey, self.cacheFileName);
        if (OBJECT_ISNOT_EMPTY(array)) {
            [self.sectionKeyArray addObjectsFromArray:array];
        }
        
        [self.headerDataArray removeAllObjects];
        array = YSCGetCacheObjectByFile(kCachedHeaderData, self.cacheFileName);
        if (OBJECT_ISNOT_EMPTY(array)) {
            [self.headerDataArray addObjectsFromArray:array];
        }
        
        [self.cellDataArray removeAllObjects];
        array = YSCGetCacheObjectByFile(kCachedCellData, self.cacheFileName);
        if (OBJECT_ISNOT_EMPTY(array)) {
            [self.cellDataArray addObjectsFromArray:array];
        }
        
        [self.footerDataArray removeAllObjects];
        array = YSCGetCacheObjectByFile(kCachedFooterData, self.cacheFileName);
        if (OBJECT_ISNOT_EMPTY(array)) {
            [self.footerDataArray addObjectsFromArray:array];
        }
    }
}
// 刷新界面
- (void)_reloadData {
    if ([self.scrollView respondsToSelector:@selector(reloadData)]) {
        [self.scrollView performSelector:@selector(reloadData)];
    }
}
@end
