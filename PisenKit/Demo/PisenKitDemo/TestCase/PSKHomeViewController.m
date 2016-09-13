//
//  PSKHomeViewController.m
//  PisenKit
//
//  Created by 杨胜超 on 16/7/5.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import "PSKHomeViewController.h"
#import "PSKTableView.h"

//=================================================
//
//  header
//
//=================================================
@interface PSKHomeHeaderView : PSKBaseTableHeaderFooterView
@property (nonatomic, strong) UILabel *titleLabel;
@end
@implementation PSKHomeHeaderView
- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = self.bounds;
    self.titleLabel.psk_left = 10;
}
- (UILabel *)titleLabel {
    if ( ! _titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}
- (void)layoutObject:(CommonItemModel *)model {
    self.titleLabel.text = model.sectionTitle;
}
+ (CGFloat)heightOfViewByObject:(NSObject *)object {
    return 20;
}
@end

//=================================================
//
//  cell
//
//=================================================
@interface PSKHomeCell : PSKBaseTableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@end
@implementation PSKHomeCell
- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(10, 5, 200, 30);
    
}
- (UILabel *)titleLabel {
    if ( ! _titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}
- (void)layoutObject:(CommonItemModel *)model {
    self.titleLabel.text = model.title;
}
+ (CGFloat)heightOfCellByObject:(NSObject *)object {
    return 40;
}
@end


//=================================================
//
//  tableView
//
//=================================================
@interface PSKHomeViewController ()
@property (nonatomic, strong) PSKTableView *tableView;
@property (nonatomic, strong) NSMutableArray *itemArray;
@end
@implementation PSKHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"PisenKitDemo";
    [self setupItems];
    [self setupTableView];
}
/** 初始化测试模块数据源 */
- (void)setupItems {
    self.itemArray = [NSMutableArray array];
    // test base
    [self.itemArray addObject:[CommonItemModel createItemBySectionTitle:@"TestBase" title:@"NSArray" viewController:@""]];
    [self.itemArray addObject:[CommonItemModel createItemBySectionTitle:@"TestBase" title:@"NSData" viewController:@""]];
    [self.itemArray addObject:[CommonItemModel createItemBySectionTitle:@"TestBase" title:@"NSDate" viewController:@""]];
    [self.itemArray addObject:[CommonItemModel createItemBySectionTitle:@"TestBase" title:@"NSDictionary" viewController:@""]];
    [self.itemArray addObject:[CommonItemModel createItemBySectionTitle:@"TestBase" title:@"NSFileManager" viewController:@""]];
    [self.itemArray addObject:[CommonItemModel createItemBySectionTitle:@"TestBase" title:@"NSString" viewController:@""]];
    
    // test adapter
    [self.itemArray addObject:[CommonItemModel createItemBySectionTitle:@"TestAdapter" title:@"PSKHUD" viewController:@"TestAdapterViewController"]];
    
    // test singleton
    [self.itemArray addObject:[CommonItemModel createItemBySectionTitle:@"TestSingleton" title:@"PSKManager" viewController:@"TestSingletonViewController"]];
    [self.itemArray addObject:[CommonItemModel createItemBySectionTitle:@"TestSingleton" title:@"PSKConfigManager" viewController:@"TestSingletonViewController"]];
    [self.itemArray addObject:[CommonItemModel createItemBySectionTitle:@"TestSingleton" title:@"PSKRequestManager" viewController:@"TestSingletonViewController"]];
    
    // test utils
    [self.itemArray addObject:[CommonItemModel createItemBySectionTitle:@"TestUtils" title:@"PSKFormatUtil" viewController:@""]];
    [self.itemArray addObject:[CommonItemModel createItemBySectionTitle:@"TestUtils" title:@"PSKStorageUtil" viewController:@""]];
    [self.itemArray addObject:[CommonItemModel createItemBySectionTitle:@"TestUtils" title:@"PSKLogUtil" viewController:@""]];
    [self.itemArray addObject:[CommonItemModel createItemBySectionTitle:@"TestUtils" title:@"PSKGeneralUtil" viewController:@""]];
    
    // test view
    [self.itemArray addObject:[CommonItemModel createItemBySectionTitle:@"TestView" title:@"PSKTipsView" viewController:@"TestUtilsViewController"]];
    [self.itemArray addObject:[CommonItemModel createItemBySectionTitle:@"TestView" title:@"PSKGridBrowseView" viewController:@"TestUtilsViewController"]];
    [self.itemArray addObject:[CommonItemModel createItemBySectionTitle:@"TestView" title:@"PSKPhotoBrowseView" viewController:@"TestUtilsViewController"]];
    [self.itemArray addObject:[CommonItemModel createItemBySectionTitle:@"TestView" title:@"PSKInfiniteLoopView" viewController:@"TestUtilsViewController"]];
    [self.itemArray addObject:[CommonItemModel createItemBySectionTitle:@"TestView" title:@"PSKZoomScrollView" viewController:@"TestUtilsViewController"]];
    
    // test view controller
    [self.itemArray addObject:[CommonItemModel createItemBySectionTitle:@"TestViewController" title:@"PSKBaseViewController" viewController:@"TestUtilsViewController"]];
    
    // solution
    [self.itemArray addObject:[CommonItemModel createItemBySectionTitle:@"TestSolution" title:@"PullToRefresh" viewController:@"TestPullToRefreshViewController"]];
}
/** 初始化tableview */
- (void)setupTableView {
    @weakiy(self);
    self.tableView.headerName = @"PSKHomeHeaderView";
    self.tableView.cellName = @"PSKHomeCell";
    self.tableView.helper.enableTips = NO;
    self.tableView.helper.enableRefresh = NO;
    self.tableView.helper.enableLoadMore = NO;
    self.tableView.helper.requestType = PSKRequestTypeCustomResponse;
    self.tableView.clickCellBlock = ^(NSObject *object, NSIndexPath *indexPath) {
        CommonItemModel *item = (CommonItemModel *)object;
        if (OBJECT_ISNOT_EMPTY(item.viewController)) {
            [weak_self psk_pushViewController:item.viewController withParams:@{kParamTitle : TRIM_STRING(item.title)}];
        }
        else {
            NSString *message = [NSString stringWithFormat:@"请查看项目PisenKitDemoTests下的Test%@.m", item.title];
            PSKAlertUtil *alertUtil = [PSKAlertUtil alertWithTitle:@"提示" message:message style:PSKAlertControllerStyleAlert];
            [alertUtil addCancelActionWithTitle:@"好的" handler:nil];
            [alertUtil showOnViewController:weak_self];
        }
    };
    [self.tableView.helper refreshByInitialObject:self.itemArray];
}

- (PSKTableView *)tableView {
    if ( ! _tableView) {
        _tableView = [[PSKTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
    NSLog(@"self.tableView.frame=%@", NSStringFromCGRect(self.tableView.frame));
}

@end
