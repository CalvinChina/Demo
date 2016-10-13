//
//  BasePullToRefreshTableViewController.m
//  YSCKit
//
//  Created by  YangShengchao on 14-4-18.
//  Copyright (c) 2014年 yangshengchao. All rights reserved.
//

#import "YSCPullToRefreshTableViewController.h"

@interface YSCPullToRefreshTableViewController ()

@end

@implementation YSCPullToRefreshTableViewController

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
    
    //1. 注册cell
    if ([NSString isNotEmpty:[self nibNameOfCell]]) {
        [self.tableView registerNib:[UINib nibWithNibName:[self nibNameOfCell] bundle:nil] forCellReuseIdentifier:kCellIdentifier];
    }
    //2. 设置cell的分割线
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:[self edgeInsetsOfCellSeperator]];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:[self edgeInsetsOfCellSeperator]];
    }
    //3. 设置其他参数
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.01)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.01)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = kDefaultViewColor;
    self.tableView.separatorColor = kDefaultBorderColor;
}

#pragma mark - 私有方法子类无需重写

- (void)reloadByAdding:(NSArray *)anArray {
    [super reloadByAdding:anArray];
    NSInteger displayedSectionIndex = [self.dataArray count];
    NSMutableArray *insertedIndexPaths = [NSMutableArray array];
    for (NSUInteger insertedIndex = 0, insertedCount = [anArray count]; insertedIndex < insertedCount; insertedIndex ++) {
        [insertedIndexPaths addObject:[NSIndexPath indexPathForRow:displayedSectionIndex + insertedIndex inSection:0]];
    }
    NSIndexSet *insertedIndexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(displayedSectionIndex, [anArray count])];
    [self.tableView beginUpdates];
    [self.dataArray insertObjects:anArray atIndexes:insertedIndexSet];
    [self.tableView insertRowsAtIndexPaths:insertedIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

- (UIScrollView *)contentScrollView {
    return self.tableView;
}

- (void)reloadData {
    [self.tableView reloadData];
}

#pragma mark - 子类必须重写的方法

- (UIView *)layoutCellWithData:(id)object atIndexPath:(NSIndexPath *)indexPath {
	YSCBaseTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if ([cell isKindOfClass:[YSCBaseTableViewCell class]]) {
        [cell layoutObject:object];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return cell;
}

#pragma mark - UITableView特有的方法

- (CGFloat)tableViewCellHeightForData:(id)object atIndexPath:(NSIndexPath *)indexPath {
    NSString *nibName = [self nibNameOfCell];
    if ([NSString isNotEmpty:nibName] &&
        [NSClassFromString(nibName) isSubclassOfClass:[YSCBaseTableViewCell class]]) {
        return [NSClassFromString(nibName) HeightOfCellByObject:nil];
    }
    else {
        return 44.0f;
    }
}
- (UIEdgeInsets)edgeInsetsOfCellSeperator {
    //生效的条件：
    //1. iOS7只需要设置tableView.seperatorInset
    //2. iOS8除了设置上面的参数外还需要设置另外两个：
    //   (1) tableView.layoutMargins
    //   (2) cell.layoutMargins(在回调方法tableView:tableView willDisplayCell:forRowAtIndexPath:)
    return AUTOLAYOUT_EDGEINSETS(0, 10, 0, 0);
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self cellCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id objectModel = nil;
    if (indexPath.row < [self.dataArray count]) {
        objectModel = [self.dataArray objectAtIndex:indexPath.row];
    }
    UITableViewCell *cell = (UITableViewCell *)[self layoutCellWithData:objectModel atIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id objectModel = nil;
    if (indexPath.row < [self.dataArray count]) {
        objectModel = [self.dataArray objectAtIndex:indexPath.row];
    }
    CGFloat rowHeight = [self tableViewCellHeightForData:objectModel atIndexPath:indexPath];
    return rowHeight;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id objectModel = nil;
    if (indexPath.row < [self.dataArray count]) {
        objectModel = [self.dataArray objectAtIndex:indexPath.row];
    }
    [self clickedCell:objectModel atIndexPath:indexPath];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:[self edgeInsetsOfCellSeperator]];
    }
}

@end
