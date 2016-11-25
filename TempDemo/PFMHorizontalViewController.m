//
//  PFMHorizontalViewController.m
//  PisenFM
//
//  Created by pisen on 16/10/27.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import "PFMHorizontalViewController.h"

#import "PFMCategorySubViewController.h"

@interface PFMHorizontalViewController ()<UIScrollViewDelegate>

@end

@implementation PFMHorizontalViewController
{
    NSArray * _viewControllers; // 保存所有的子视图控制器
    UIScrollView * _scrollView; // 作为切换视图的滚动视图
}

- (instancetype)initWithControllers:(NSArray *)controllers
{
    if (self = [super init]) {
        // 赋值
        _viewControllers = controllers;
        for (UIViewController * vc in _viewControllers) {
            // 将这些视图控制器作为本视图控制器的子视图控制器
            [self addChildViewController:vc];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 创建UI
- (void)setupUI
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, self.view.psk_height)];
    // 按页显示
    _scrollView.pagingEnabled = YES;
    // 关闭弹簧效果
    _scrollView.bounces = NO;
    
    CGFloat scrollViewWidth = _scrollView.frame.size.width;
    CGFloat scrollViewHeight = _scrollView.frame.size.height;
    
    // 遍历数组
    [_viewControllers enumerateObjectsUsingBlock:^(UIViewController * vc, NSUInteger idx, BOOL * stop) {
        // 先修改视图控制器上的View的frame，每一个视图控制器创建好后，它的view的大小是屏幕的大小
        CGRect rect = CGRectMake(idx*scrollViewWidth, 0, scrollViewWidth, scrollViewHeight);
        
        vc.view.frame = rect;
        // 将子视图控制器上的view添加到UIScrollView中
        [_scrollView addSubview:vc.view];
    }];
    // 设置UIScrollView的contentSize
    _scrollView.contentSize = CGSizeMake(_viewControllers.count * scrollViewWidth, scrollViewHeight);
    
    // 将UIScrollView的滚动条隐藏
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    
    // 设置UIScrollView的代理
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
}

// 点击按钮切换视图的实现方法
- (void)changePage:(NSInteger)selectIndex{
    
    CGPoint contentOffset = CGPointMake(selectIndex * _scrollView.frame.size.width, 0);
    
    [self reloadImage:selectIndex];
    // 滚动起来
    [_scrollView setContentOffset:contentOffset animated:YES];
}


#pragma mark - UIScrollViewDelegate
// 减速结束方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 计算当前滚动的位置对应的页数
    NSInteger page = scrollView.contentOffset.x / scrollView.frame.size.width;
    [self reloadImage:page];
    // 通过block传值
    if (self.ChangeSubViewControllerBlock) {
        self.ChangeSubViewControllerBlock(page);
    }
}

- (void)reloadImage:(NSInteger)index{
    for (NSInteger i = 0; i < _viewControllers.count; i++) {
        PFMCategorySubViewController *vc = [_viewControllers objectAtIndex:i];
        
        if (i == index) {
            vc.allowLoadImage = YES;
            [vc reloadUI];
        }
        else {
            vc.allowLoadImage = NO;
        }
    }
}

@end
