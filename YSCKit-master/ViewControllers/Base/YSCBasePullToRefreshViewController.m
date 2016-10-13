//
//  BasePullToRefreshViewController.m
//  YSCKit
//
//  Created by  YangShengchao on 14-4-18.
//  Copyright (c) 2014年 yangshengchao. All rights reserved.
//

#import "YSCBasePullToRefreshViewController.h"

@interface YSCBasePullToRefreshViewController ()

@end

@implementation YSCBasePullToRefreshViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPageIndex = kDefaultPageStartIndex;
    if (self.dataArray == nil) {
        self.dataArray = [NSMutableArray array];
    }
    
    // 空页面与网络错误页面提示
    WeakSelfType blockSelf = self;
    self.successBlock = ^{
        blockSelf.isClicked = NO;
        blockSelf.tipsView.actionButton.hidden = YES;
        blockSelf.tipsView.iconImageView.image = [UIImage imageNamed:@"icon_empty"];
    };
    self.failedBlock= ^{
        blockSelf.isClicked = NO;
        blockSelf.tipsView.actionButton.hidden = NO;
        blockSelf.tipsView.iconImageView.image = [UIImage imageNamed:@"icon_failed"];
        [blockSelf.tipsView.actionButton bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
        [blockSelf.tipsView.actionButton bk_addEventHandler:^(id sender) {
            [blockSelf.contentScrollView.header beginRefreshing];
        } forControlEvents:UIControlEventTouchUpInside];
    };
    
    //加载本地缓存
    if ([self shouldCacheArray]) {
        NSArray *cacheArray = [self loadCacheArray];
        if ([NSObject isNotEmpty:cacheArray]) {
            [self.dataArray addObjectsFromArray:cacheArray];
        }
    }
    
    //判断是否需要刷新功能
    if ([self refreshEnable]) {
		[self addRefreshHeaderView];
		//判断是否进入的时候就刷新
		if ([self shouldRefreshWhenEntered]) {
			[self.contentScrollView.header beginRefreshing];
		}
	}
    
	//判断是否需要加载更多功能
	if ([self loadMoreEnable]) {
		[self addRefreshFooterView];
	}
}

- (void)addRefreshHeaderView {
	WeakSelfType blockSelf = self;
    self.contentScrollView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [blockSelf refreshWithSuccessed:blockSelf.successBlock failed:blockSelf.failedBlock];
    }];
}

- (void)addRefreshFooterView {
	WeakSelfType blockSelf = self;
    self.contentScrollView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [blockSelf loadMoreWithSuccessed:blockSelf.successBlock failed:blockSelf.failedBlock];
    }];
}

/**
 *  设置没有数据的提示view是显示还是隐藏
 *
 *  @param isTipsViewHidden
 */
- (void)setIsTipsViewHidden:(BOOL)isTipsViewHidden {
    [self setIsTipsViewHidden:isTipsViewHidden withTipText:[self hintStringWhenNoData]];
}
- (void)setIsTipsViewHidden:(BOOL)isTipsViewHidden withTipText:(NSString *)tipText {    
    if ([self tipsViewEnable]) {
        WeakSelfType blockSelf = self;
        if (nil == self.tipsView) {
            self.tipsView = [YSCKTipsView CreateYSCTipsViewOnView:[self contentScrollView]
                                                        edgeInsets:[self tipsViewEdgeInsets]
                                                       withMessage:tipText
                                                         iconImage:[UIImage imageNamed:@"icon_failed"]
                                                       buttonTitle:@"重新加载"
                                                      buttonAction:^{
                                                          [blockSelf.contentScrollView.header beginRefreshing];
                                                      }];
        }
        else {
            self.tipsView.messageLabel.text = tipText;
        }
        self.tipsView.hidden = isTipsViewHidden;
    }
}
- (UIEdgeInsets)tipsViewEdgeInsets {
    return AUTOLAYOUT_EDGEINSETS(0, 0, 60, 0);
}

/**
 *  下拉刷新
 *
 *  @param successed
 *  @param failed    
 */
- (void)refreshWithSuccessed:(PullToRefreshSuccessed)successed failed:(PullToRefreshFailed)failed {
    [self refreshWithSuccessed:successed failed:failed withRequestType:RequestTypeGET];
}

- (void)refreshWithSuccessed:(PullToRefreshSuccessed)successed failed:(PullToRefreshFailed)failed withRequestType:(RequestType)requestType {
    WeakSelfType blockSelf = self;
    RequestSuccessed requestSuccessedBlock = ^(id responseObject){
        [blockSelf.contentScrollView.header endRefreshing];
        [blockSelf hideHUDLoading];
        blockSelf.currentPageIndex = kDefaultPageStartIndex;
        
        //1. 获取结果数组
        NSArray *dataArray = nil;
        if ([responseObject isKindOfClass:[NSArray class]]) {
            dataArray = (NSArray *)responseObject;
        }
        else if([responseObject isKindOfClass:[BaseDataModel class]]){
            dataArray = @[responseObject];
        }
        //------------
        
        //2. 根据组装后的数组刷新列表
        NSArray *newDataArray = nil;
        if ([dataArray count] > 0) {
            newDataArray = [blockSelf preProcessData:dataArray];
        }
        if ([newDataArray count] > 0) {
            blockSelf.isTipsViewHidden = YES;
            [blockSelf reloadByReplacing:newDataArray];
        }
        else {
            //清空已有的数据
            [blockSelf.dataArray removeAllObjects];
            blockSelf.isTipsViewHidden = NO;
        }
        //------------
        
        if (successed) {
            successed();
        }
        [blockSelf reloadData];
    };
    
    RequestFailure requestFailureBlock = ^(ErrorType errorType, NSError *error) {
        [blockSelf.contentScrollView.header endRefreshing];
        
        //1. 如果没有数据就将错误信息显示在tipsView上
        if ([NSArray isEmpty:blockSelf.dataArray]) {
            [blockSelf setIsTipsViewHidden:NO withTipText:error.localizedDescription];
        }
        else {
            blockSelf.isTipsViewHidden = YES;
        }
        
        //2. 回调
        if (failed) {
            failed();
        }
    };
    if(requestType == RequestTypeGET) {
        [self getDataByParam:[self dictParamWithPage:kDefaultPageStartIndex] successed:requestSuccessedBlock failed:requestFailureBlock];
    }
    else if(requestType == RequestTypePOST) {
        [self postDataByParam:[self dictParamWithPage:kDefaultPageStartIndex]  successed:requestSuccessedBlock failed:requestFailureBlock];
    }
}
- (void)reloadByReplacing:(NSArray *)anArray {
	[self.dataArray removeAllObjects];
	[self.dataArray addObjectsFromArray:anArray];
    
	//保存数组至本地缓存（注意：只保存下拉刷新的数组！）
	if ([self shouldCacheArray]) {
		[self saveObject:anArray forKey:KeyOfCachedArray];
	}
}

/**
 *  上拉加载更多
 *
 *  @param successed
 *  @param failed
 */
- (void)loadMoreWithSuccessed:(PullToRefreshSuccessed)successed failed:(PullToRefreshFailed)failed {
	[self loadMoreWithSuccessed:successed failed:failed withRequestType:RequestTypeGET];
}

- (void)loadMoreWithSuccessed:(PullToRefreshSuccessed)successed failed:(PullToRefreshFailed)failed withRequestType:(RequestType)requestType{
    WeakSelfType blockSelf = self;
    RequestSuccessed requestSuccessedBlock = ^(id responseObject){
        [blockSelf.contentScrollView.footer endRefreshing];
        [blockSelf hideHUDLoading];
        
        //1. 获取结果数组
        NSArray *dataArray = nil;
        if ([responseObject isKindOfClass:[NSArray class]]) {
            dataArray = (NSArray *)responseObject;
        }
        else if([responseObject isKindOfClass:[BaseDataModel class]]){
            dataArray = @[responseObject];
        }
        //------------
        
        //2. 根据组装后的数组刷新列表
        NSArray *newDataArray = nil;
        if ([dataArray count] > 0) {
            blockSelf.currentPageIndex++;//只要返回有数据就自增
            newDataArray = [blockSelf preProcessData:dataArray];
        }
        if ([newDataArray count] > 0) {
            blockSelf.isTipsViewHidden = YES;
            [blockSelf reloadByAdding:newDataArray];
        }
        else {
            if ([blockSelf.dataArray count] == 0) {//判断总的数组是否为空
                blockSelf.isTipsViewHidden = NO;
            }
            [blockSelf showResultThenHide:@"没有更多了"];
        }
        //------------
        
        if (successed) {
            successed();
        }
    };
    
    
    RequestFailure requestFailureBlock = ^(ErrorType errorType, NSError *error) {
        [blockSelf.contentScrollView.footer endRefreshing];

        //1. 如果没有数据就将错误信息显示在tipsView上
        if ([NSArray isEmpty:blockSelf.dataArray]) {
            [blockSelf setIsTipsViewHidden:NO withTipText:error.localizedDescription];
        }
        else {
            blockSelf.isTipsViewHidden = YES;
        }
        
        //2. 回调
        if (failed) {
            failed();
        }
    };
    
    if(requestType == RequestTypeGET) {
        [self getDataByParam:[self dictParamWithPage:self.currentPageIndex + 1] successed:requestSuccessedBlock failed:requestFailureBlock];
    }
    else if(requestType == RequestTypePOST) {
        [self postDataByParam:[self dictParamWithPage:self.currentPageIndex + 1]  successed:requestSuccessedBlock failed:requestFailureBlock];
    }
}

//以下两个方法是为了兼容返回model不规范的情况，子类可以重写
- (void)getDataByParam:(NSDictionary *)param successed:(RequestSuccessed)successed failed:(RequestFailure)failed {
    [YSCRequestManager RequestFromUrl:[self prefixOfUrl] withAPI:[self methodWithPath] params:param dataModel:[self modelClassOfData] requestType:RequestTypeGET requestSuccessed:successed requestFailure:failed];
}
- (void)postDataByParam:(NSDictionary *)param successed:(RequestSuccessed)successed failed:(RequestFailure)failed {
    [YSCRequestManager RequestFromUrl:[self prefixOfUrl] withAPI:[self methodWithPath] params:param dataModel:[self modelClassOfData] requestType:RequestTypePOST requestSuccessed:successed requestFailure:failed];
}


- (void)reloadByAdding:(NSArray *)anArray {
	
}

#pragma mark - 可选的重写方法

//下拉刷新特有的缓存加载方法被基类的loadCache方法调用
- (NSArray *)loadCacheArray {
	NSArray *cachedArray = [self cachedObjectForKey:KeyOfCachedArray];
	if ([cachedArray isKindOfClass:[NSArray class]] && [NSArray isNotEmpty:cachedArray]) {
		return cachedArray;
	}
	else { //没有缓存内容
		return nil;
	}
}

- (NSArray *)preProcessData:(NSArray *)anArray {
	return anArray;
}

- (BOOL)shouldCacheArray {
	return NO;
}

- (BOOL)shouldRefreshWhenEntered {
	return YES;
}
- (BOOL)loadMoreEnable {
	return YES;
}

- (BOOL)refreshEnable {
	return YES;
}

- (NSInteger)cellCount {
	return [self.dataArray count];
}

- (NSString *)prefixOfUrl {
    return kResPathAppBaseUrl;
}

- (NSString *)hintStringWhenNoData {
    return kDefaultTipsEmptyText;
}

- (BOOL)tipsViewEnable {
    return YES;
}

#pragma mark - 必须重写的方法

- (NSString *)methodWithPath {
	return @"";
}

- (NSString *)nibNameOfCell {
	return @"";
}

- (NSDictionary *)dictParamWithPage:(NSInteger)page {
	return @{};
}

- (Class)modelClassOfData {
    return [BaseDataModel class];
}

- (UIView *)layoutCellWithData:(id)object atIndexPath:(NSIndexPath *)indexPath {
	return nil;
}

- (void)clickedCell:(id)object atIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - 必须在一级子类里重写的方法

/**
 *  目前只支持UItableView和UICollectionView
 */
- (UIScrollView *)contentScrollView {
    return nil;
}
- (void)reloadData {

}

@end
