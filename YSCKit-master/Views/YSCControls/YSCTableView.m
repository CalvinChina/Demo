//
//  YSCTableView.m
//  YSCKit
//
//  Created by yangshengchao on 15/8/26.
//  Copyright (c) 2015年 Builder. All rights reserved.
//

#import "YSCTableView.h"
#import "MJRefresh.h"

#define KeyOfHeaderData         @"KeyOfHeaderData"
#define KeyOfCellData           @"KeyOfCellData"
#define KeyOfFooterData         @"KeyOfFooterData"
#define KeyOfSectionKey         @"KeyOfSectionKey"

@interface YSCTableView () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *sectionKeyArray;//用于存储分组的判断依据
@property (nonatomic, assign) BOOL isLoadedCache;//控制缓存只加载一次

@property (nonatomic, assign) BOOL enableCache;//是否启用缓存(NO)
@property (nonatomic, strong) NSString *cacheFileName;//缓存数据保存的文件名称
@end

@implementation YSCTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self setup];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

//初始化配置参数
- (void)setup {
    //基本属性
    self.sectionKeyArray = [NSMutableArray array];
    self.headerDataArray = [NSMutableArray array];
    self.footerDataArray = [NSMutableArray array];
    self.cellDataArray = [NSMutableArray array];
    self.currentPageIndex = kDefaultPageStartIndex;
    self.requestType = RequestTypeGET;
    
    //必要的属性
    self.dictParamBlock = ^NSDictionary *(NSInteger pageIndex) {
        return @{kParamPageIndex : @(pageIndex),
                 kParamPageSize : @(kDefaultPageSize)};
    };
    
    //设置默认属性
    self.tipsEmptyText = kDefaultTipsEmptyText;
    self.tipsEmptyIcon = kDefaultTipsEmptyIcon;
    self.tipsFailedIcon = kDefaultTipsFailedIcon;
    self.tipsButtonTitle = kDefaultTipsButtonTitle;
    
    self.enableCache = NO;
    self.enableRefresh = YES;
    self.enableLoadMore = YES;
    self.enableTips = YES;
    
    //只要该block不能为nil！
    self.preProcessBlock = ^NSArray *(NSArray *array) {
        return array;
    };
    
    [self initTableView];//初始化tableView
}
- (void)initTableView {
    //1. 注册cell、header、footer
    [self registerHeaderName:self.headerName];
    [self registerCellName:self.cellName];
    [self registerFooterName:self.footerName];
    
    //2. 设置cell的分割线
    [self resetCellEdgeInsets];
    self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.separatorColor = kDefaultBorderColor;//NOTE:xib < this
    
    //3. 设置其他参数
    self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.01)];
    self.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.01)];
    self.dataSource = self;
    self.delegate = self;
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark - 属性设置
- (NSString *)prefixOfUrl {
    if (isEmpty(_prefixOfUrl)) {
        return kResPathAppBaseUrl;
    }
    return  _prefixOfUrl;
}
- (void)setCellName:(NSString *)cellName {
    _cellName = cellName;
    [self registerCellName:cellName];
}
- (void)setHeaderName:(NSString *)headerName {
    _headerName = headerName;
    [self registerHeaderName:headerName];
}
- (void)setFooterName:(NSString *)footerName {
    _footerName = footerName;
    [self registerFooterName:footerName];
}
- (void)setCellSeperatorLeft:(CGFloat)cellSeperatorLeft {
    _cellSeperatorLeft = cellSeperatorLeft;
    [self resetCellEdgeInsets];
}
- (void)setCellSeperatorRight:(CGFloat)cellSeperatorRight {
    _cellSeperatorRight = cellSeperatorRight;
    [self resetCellEdgeInsets];
}
- (void)setEnableRefresh:(BOOL)enableRefresh {
    _enableRefresh = enableRefresh;
    if (enableRefresh) {
        WEAKSELF
        self.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf refreshAtPageIndex:kDefaultPageStartIndex];
        }];
    }
    else {
        self.header  = nil;
    }
}
- (void)setEnableLoadMore:(BOOL)enableLoadMore {
    _enableLoadMore = enableLoadMore;
    if (enableLoadMore) {
        WEAKSELF
        self.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf refreshAtPageIndex:weakSelf.currentPageIndex + 1];
        }];
    }
    else {
        self.footer = nil;
    }
}
- (void)setEnableTips:(BOOL)enableTips {
    _enableTips = enableTips;
    if (enableTips && isEmpty(self.tipsView)) {
        WEAKSELF
        self.tipsView = [YSCKTipsView CreateYSCTipsViewOnView:self
                                                   edgeInsets:UIEdgeInsetsZero
                                                  withMessage:self.tipsEmptyText
                                                    iconImage:[UIImage imageNamed:self.tipsEmptyIcon]
                                                  buttonTitle:self.tipsButtonTitle
                                                 buttonAction:^{
                                                     [weakSelf.header beginRefreshing];
                                                 }];
        self.tipsView.hidden = YES;
        self.tipsView.actionButton.hidden = YES;
    }
    else {
        if (self.tipsView) {
            [self.tipsView removeFromSuperview];
            self.tipsView = nil;
        }
    }
}


#pragma mark - 外部可调用的方法
//注册header、cell、footer
- (void)registerHeaderName:(NSString *)headerName {
    if (isNotEmpty(headerName) && [NSClassFromString(headerName) isSubclassOfClass:[YSCBaseTableHeaderFooterView class]]) {
        [NSClassFromString(headerName) registerHeaderFooterToTableView:self];
    }
}
- (void)registerCellName:(NSString *)cellName {
    if (isNotEmpty(cellName) && [NSClassFromString(cellName) isSubclassOfClass:[YSCBaseTableViewCell class]]) {
        [NSClassFromString(cellName) registerCellToTableView:self];
    }
}
- (void)registerFooterName:(NSString *)footerName {
    if (isNotEmpty(footerName) && [NSClassFromString(footerName) isSubclassOfClass:[YSCBaseTableHeaderFooterView class]]) {
        [NSClassFromString(footerName) registerHeaderFooterToTableView:self];
    }
}
//创建对象，不用xib布局时使用
+ (instancetype)CreateYSCTableViewOnView:(UIView *)view {
    YSCTableView *tableView = [[YSCTableView alloc] initWithFrame:view.bounds];
    [view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_top);
        make.left.equalTo(view.mas_left);
        make.bottom.equalTo(view.mas_bottom);
        make.right.equalTo(view.mas_right);
    }];
    return tableView;
}
//启动刷新(能加载一次缓存)
- (void)beginRefreshing {
    [self beginRefreshingByAnimation:YES];
}
- (void)beginRefreshingByAnimation:(BOOL)animation {
    [self loadCacheArray];//加载缓存
    if (animation) {
        [self.header beginRefreshing];
    }
    else {
        [self refreshAtPageIndex:kDefaultPageStartIndex];
    }
}
//当数据为空时执行下拉刷新
- (void)refreshWhenCellDataEmpty {
    if ([self isCellDataEmpty]) {
        [self beginRefreshing];
    }
}
//清空数据列表
- (void)clearData {
    [self.headerDataArray removeAllObjects];
    [self.cellDataArray removeAllObjects];
    [self.footerDataArray removeAllObjects];
    self.tipsView.hidden = NO;
    [self reloadData];
}

//开启缓存模式
- (void)enableCacheWithFileName:(NSString *)fileName {
    ReturnWhenObjectIsEmpty(fileName)
    self.enableCache = YES;
    self.cacheFileName = fileName;
}

//下载数据(可重写)
- (void)refreshAtPageIndex:(NSInteger)pageIndex {
    [self refreshAtPageIndex:pageIndex response:nil error:nil];
}
- (void)refreshAtPageIndex:(NSInteger)pageIndex response:(NSObject *)initObject error:(NSString *)errorMessage {
    WEAKSELF
    YSCResponseErrorMessageBlock resultBlock = ^(NSObject *object, NSString *errorMessage) {
        BOOL isPullToRefresh = (kDefaultPageStartIndex == pageIndex); //是否下拉刷新
        isPullToRefresh ? [weakSelf.header endRefreshing] : [weakSelf.footer endRefreshing];
        //处理返回结果
        if (errorMessage) {
            //数据加载失败的tips
            if (weakSelf.tipsView) {
                weakSelf.tipsView.iconImageView.image = [UIImage imageNamed:weakSelf.tipsFailedIcon];
                weakSelf.tipsView.messageLabel.text = errorMessage;
            }
            weakSelf.tipsView.actionButton.hidden = NO;
            [weakSelf.tipsView.actionButton setTitle:@"重新加载" forState:UIControlStateNormal];
            [weakSelf.tipsView.actionButton bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
            [weakSelf.tipsView.actionButton bk_addEventHandler:^(id sender) {
                [YSCInstance resetAppParams];//NOTE:初始化在线参数
                [weakSelf beginRefreshing];
            } forControlEvents:UIControlEventTouchUpInside];
        }
        else {
            //1. 根据组装后的数组刷新列表
            NSArray *newDataArray = nil;
            if (isNotEmpty(object)) {
                weakSelf.currentPageIndex = pageIndex;  //只要接口成功返回了数据，就把当前请求的页码保存起来
                if (weakSelf.preProcessBlock) {
                    newDataArray = weakSelf.preProcessBlock((NSArray *)object);
                }
            }
            
            //-----------开始对tableView进行操作-----------
            if (isPullToRefresh) {
                [weakSelf.sectionKeyArray removeAllObjects];
                [weakSelf.headerDataArray removeAllObjects];
                [weakSelf.footerDataArray removeAllObjects];
                [weakSelf.cellDataArray removeAllObjects];
            }
            else {
                [weakSelf beginUpdates];
            }
            
            //3. 根据新数组刷新界面显示(包括下拉刷新、上拉加载更多、并且支持多section)
            if ([newDataArray count] > 0) {
                //-----------------多section的刷新--------------
                NSMutableArray *insertedIndexPaths = [NSMutableArray array];
                for (NSObject *object in newDataArray) {
                    NSInteger row = 0, section = 0;
                    NSString *sectionKey = @"";//NOTE:兼容object是数组的情况
                    if ([object isKindOfClass:[BaseDataModel class]]) {
                        sectionKey = Trim(((BaseDataModel *)object).sectionKey);
                    }
                    
                    if ([weakSelf.sectionKeyArray containsObject:Trim(sectionKey)]) {
                        section = [weakSelf.sectionKeyArray indexOfObject:Trim(sectionKey)];
                        NSMutableArray *tempArray = weakSelf.cellDataArray[section];
                        [tempArray addObject:object];
                        row = [tempArray count] - 1;
                    }
                    else {
                        row = 0;
                        section = [weakSelf.sectionKeyArray count];
                        [weakSelf.sectionKeyArray addObject:Trim(sectionKey)];
                        
                        //处理section header model(直接保存原始的model，在具体显示的时候再确定显示哪个属性)
                        [weakSelf.headerDataArray addObject:object];
                        [weakSelf.footerDataArray addObject:object];
                        
                        NSMutableArray *tempArray = [NSMutableArray array];
                        [tempArray addObject:object];
                        [weakSelf.cellDataArray addObject:tempArray];
                        
                        if (NO == isPullToRefresh && isNotEmpty(sectionKey)) {//insert section
                            [weakSelf insertSections:[NSIndexSet indexSetWithIndex:section]
                                    withRowAnimation:UITableViewRowAnimationNone];
                        }
                    }
                    //add new row
                    if (NO == isPullToRefresh) {
                        [insertedIndexPaths addObject:[NSIndexPath indexPathForRow:row inSection:section]];
                    }
                }
                //--------------------------------------------
                
                if (NO == isPullToRefresh) {//insert rows
                    [weakSelf insertRowsAtIndexPaths:insertedIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }
            else {
                if (NO == isPullToRefresh) {
                    [UIView showResultThenHideOnWindow:@"没有更多了"];
                }
            }
            
            //---------结束对tableView的操作-----------
            if (isPullToRefresh) {
                [weakSelf reloadData];
            }
            else {
                [weakSelf endUpdates];
            }
            
            
            //4. 数据为空的tips
            if (weakSelf.tipsView) {
                weakSelf.tipsView.iconImageView.image = [UIImage imageNamed:weakSelf.tipsEmptyIcon];
                weakSelf.tipsView.messageLabel.text = weakSelf.tipsEmptyText;
            }
            weakSelf.tipsView.actionButton.hidden = YES;
            
            //5. 缓存数据
            if (weakSelf.enableCache && isNotEmpty(weakSelf.cacheFileName)) {
                YSCSaveCacheObjectByFile(weakSelf.sectionKeyArray, KeyOfSectionKey, weakSelf.cacheFileName);
                YSCSaveCacheObjectByFile(weakSelf.headerDataArray, KeyOfHeaderData, weakSelf.cacheFileName);
                YSCSaveCacheObjectByFile(weakSelf.cellDataArray, KeyOfCellData, weakSelf.cacheFileName);
                YSCSaveCacheObjectByFile(weakSelf.footerDataArray, KeyOfFooterData, weakSelf.cacheFileName);
            }
        }
        weakSelf.tipsView.hidden = (! [weakSelf isCellDataEmpty]);

        //最后回调(可能会处理tipsView的显示与否的问题)
        YSCBaseViewController *currentVC = (YSCBaseViewController *)YSCInstance.currentViewController;
        if ([currentVC isKindOfClass:[YSCBaseViewController class]]) {
            currentVC.isClicked = NO;
        }
        if (weakSelf.finishLoadBlock) {
            weakSelf.finishLoadBlock(errorMessage);
        }
    };
    RequestSuccessed successBlock = ^(id responseObject) {
        NSMutableArray *dataArray = [NSMutableArray array];
        if ([responseObject isKindOfClass:[NSArray class]]) {
            [dataArray addObjectsFromArray:(NSArray *)responseObject];
        }
        else {
            if (isNotEmpty(responseObject)) {
                dataArray = [@[responseObject] mutableCopy];
            }
        }
        //兼容外部数据源
        if (isNotEmpty(initObject) && [initObject isKindOfClass:[NSArray class]]) {
            [dataArray addObjectsFromArray:(NSArray *)initObject];
        }
        
        resultBlock(dataArray, nil);
    };
    RequestFailure failureBlock = ^(ErrorType errorType, NSError *error) {
        resultBlock(initObject, [YSCManager ResolveErrorType:errorType andError:error]);
    };
    
    //4. 开始网络访问
    if (self.requestType <= RequestTypePostBodyData) {
        [YSCRequestManager RequestFromUrl:self.prefixOfUrl
                                  withAPI:self.methodName
                                   params:self.dictParamBlock(pageIndex)
                                dataModel:NSClassFromString(self.modelName)
                              requestType:self.requestType
                         requestSuccessed:successBlock
                           requestFailure:failureBlock];
    }
    else {
        resultBlock(initObject, errorMessage);
    }
}

//判断是否为空
- (BOOL)isCellDataEmpty {
    if (isEmpty(self.cellDataArray)) {
        return YES;
    }
    //如果有空数组
    for (NSArray *array in self.cellDataArray) {
        if (isNotEmpty(array)) {
            return NO;
        }
    }
    return YES;
}
//判断cell是否最后一个
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
//判断section是否最后一个
- (BOOL)isLastSectionByIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == [self.headerDataArray count] - 1;
}

#pragma mark - 私有方法
//加载缓存数组
- (void)loadCacheArray {
    if (self.enableCache && NO == self.isLoadedCache) {
        self.isLoadedCache = YES;//控制缓存只加载一次
        
        [self.sectionKeyArray removeAllObjects];
        NSArray *array = YSCGetCacheObjectByFile(KeyOfSectionKey, self.cacheFileName);
        if (isNotEmpty(array)) {
            [self.sectionKeyArray addObjectsFromArray:array];
        }
        
        [self.headerDataArray removeAllObjects];
        array = YSCGetCacheObjectByFile(KeyOfHeaderData, self.cacheFileName);
        if (isNotEmpty(array)) {
            [self.headerDataArray addObjectsFromArray:array];
        }
        
        [self.cellDataArray removeAllObjects];
        array = YSCGetCacheObjectByFile(KeyOfCellData, self.cacheFileName);
        if (isNotEmpty(array)) {
            [self.cellDataArray addObjectsFromArray:array];
        }
        
        [self.footerDataArray removeAllObjects];
        array = YSCGetCacheObjectByFile(KeyOfFooterData, self.cacheFileName);
        if (isNotEmpty(array)) {
            [self.footerDataArray addObjectsFromArray:array];
        }
        [self reloadData];
    }
}
- (void)resetCellEdgeInsets {
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, self.cellSeperatorLeft, 0, self.cellSeperatorRight);
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:edgeInsets];
    }
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:edgeInsets];
    }
}


#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.cellDataArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.cellDataArray[section];
    return [array count];
}
//HEADER
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ((section >= 0 && section < [self.headerDataArray count])) {
        NSString *headerName = self.headerName;
        NSObject *headerObject = self.headerDataArray[section];
        if (self.headerNameBlock) {
            headerName = self.headerNameBlock(headerObject, section);
        }
        if (isNotEmpty(headerName)) { 
            if (self.headerHeightBlock) {
                return self.headerHeightBlock(section);
            }
            else {
                if ([NSClassFromString(headerName) isSubclassOfClass:[YSCBaseTableHeaderFooterView class]]) {
                    return [NSClassFromString(headerName) HeightOfViewByObject:headerObject];
                }
            }
        }
    }
    
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YSCBaseTableHeaderFooterView *header = nil;
    if ((section >= 0 && section < [self.headerDataArray count])) {
        NSString *headerName = self.headerName;
        NSObject *headerObject = self.headerDataArray[section];
        if (self.headerNameBlock) {
            headerName = self.headerNameBlock(headerObject, section);
        }
        
        if (isNotEmpty(headerName)) {
            header = [NSClassFromString(headerName) dequeueHeaderFooterByTableView:tableView];
            if ([header isKindOfClass:[YSCBaseTableHeaderFooterView class]]) {
                [header layoutObject:headerObject];
            }
            if (self.layoutHeaderView) {
                self.layoutHeaderView(header, headerObject);
            }
            
            WEAKSELF
            [header removeAllGestureRecognizers];
            [header bk_whenTapped:^{
                if (weakSelf.clickHeaderBlock) {
                    weakSelf.clickHeaderBlock(headerObject, section);
                }
            }];
        }
    }
    return header;
}
//CELL
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //1. 屏蔽通用cell的高度
    if (self.cellHeightBlock) {
        return self.cellHeightBlock(indexPath);
    }
    //2. 单个情况下的高度
    NSArray *array = self.cellDataArray[indexPath.section];
    NSObject *cellObject = array[indexPath.row];
    NSString *cellName = self.cellName;
    if (self.cellNameBlock) {
        NSString *tempName = self.cellNameBlock(cellObject, indexPath);
        if (isNotEmpty(tempName)) {
            cellName = tempName;
        }
    }
    if (isNotEmpty(cellName) && [NSClassFromString(cellName) isSubclassOfClass:[YSCBaseTableViewCell class]]) {
        return [NSClassFromString(cellName) HeightOfCellByObject:cellObject];
    }
    else {
        return 44;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSCBaseTableViewCell *cell = nil;
    NSArray *array = self.cellDataArray[indexPath.section];
    NSObject *cellObject = array[indexPath.row];
    NSString *cellName = self.cellName;
    if (self.cellNameBlock) {
        NSString *tempName = self.cellNameBlock(cellObject, indexPath);
        if (isNotEmpty(tempName)) {
            cellName = tempName;
        }
    }
    cell = [NSClassFromString(cellName) dequeueCellByTableView:tableView];
    
    if ([cell isKindOfClass:[YSCBaseTableViewCell class]]) {
        [cell layoutObject:cellObject];
    }
    if (self.layoutCellView) {
        self.layoutCellView(cell, cellObject);
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
//FOOTER
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ((section >= 0 && section < [self.footerDataArray count])) {
        NSString *footerName = self.footerName;
        NSObject *footerObject = self.footerDataArray[section];
        if (self.footerNameBlock) {
            footerName = self.footerNameBlock(footerObject, section);
        }
        if (isNotEmpty(footerName)) {
            if (self.footerHeightBlock) {
                return self.footerHeightBlock(section);
            }
            else {
                if ([NSClassFromString(footerName) isSubclassOfClass:[YSCBaseTableHeaderFooterView class]]) {
                    return [NSClassFromString(footerName) HeightOfViewByObject:footerObject];
                }
            }
        }
    }
    
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    YSCBaseTableHeaderFooterView *footer = nil;
    if ((section >= 0 && section < [self.footerDataArray count])) {
        NSString *footerName = self.footerName;
        NSObject *footerObject = self.footerDataArray[section];
        if (self.footerNameBlock) {
            footerName = self.footerNameBlock(footerObject, section);
        }
        
        if (isNotEmpty(footerName)) {
            footer = [NSClassFromString(footerName) dequeueHeaderFooterByTableView:tableView];
            if ([footer isKindOfClass:[YSCBaseTableHeaderFooterView class]]) {
                [footer layoutObject:footerObject];
            }
            if (self.layoutFooterView) {
                self.layoutFooterView(footer, footerObject);
            }
            
            WEAKSELF
            [footer removeAllGestureRecognizers];
            [footer bk_whenTapped:^{
                if (weakSelf.clickFooterBlock) {
                    weakSelf.clickFooterBlock(footerObject, section);
                }
            }];
        }
    }
    return footer;
}
//选择cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = self.cellDataArray[indexPath.section];
    if (self.clickCellBlock) {
        self.clickCellBlock(array[indexPath.row], indexPath);
    }
}
//
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, self.cellSeperatorLeft, 0, self.cellSeperatorRight);
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:edgeInsets];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (self.deleteCellBlock) {
            NSArray *array = self.cellDataArray[indexPath.section];
            self.deleteCellBlock(array[indexPath.row], indexPath);
        }
    }
}
//NOTE:系统自动多语言返回"删除"
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return @"删除";
//}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.deleteCellBlock) {
        return YES;
    }
    else {
        return NO;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.willBeginDraggingBlock) {
        self.willBeginDraggingBlock();
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.didEndDraggingBlock) {
        self.didEndDraggingBlock();
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.didScrollBlock) {
        self.didScrollBlock();
    }
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (self.didEndScrollingAnimationBlock) {
        self.didEndScrollingAnimationBlock();
    }
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (self.willBeginDeceleratingBlock) {
        self.willBeginDeceleratingBlock();
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.didEndDeceleratingBlock) {
        self.didEndDeceleratingBlock();
    }
}

@end
