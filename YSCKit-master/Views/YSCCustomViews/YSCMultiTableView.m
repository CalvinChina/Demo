//
//  YSCMultiTableView.m
//  YSCKit
//
//  Created by yangshengchao on 15/9/8.
//  Copyright (c) 2015年 Builder. All rights reserved.
//

#import "YSCMultiTableView.h"

@implementation YSCMultiTableView

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
- (void)setup {
    self.seperatorSpace = 20;
    self.clipsToBounds = YES;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left).offset(-self.seperatorSpace);
        make.right.equalTo(self.mas_right);
    }];
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    
    self.tableViewBlock = ^UITableView *(NSInteger pageIndex) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        return tableView;
    };
}
- (void)setSeperatorSpace:(CGFloat)seperatorSpace {
    _seperatorSpace = AUTOLAYOUT_LENGTH(seperatorSpace);
}

//刷新列表
- (void)reloadTableViews {
    //重置scrollView的约束
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left).offset(-self.seperatorSpace);
        make.right.equalTo(self.mas_right);
    }];
    
    //设置scrollView所有子view的约束
    [self.scrollView removeAllSubviews];
    for (int i = 0; i < self.numbersOfTableView; i++) {
        UITableView *tableView = self.tableViewBlock(i);
        if (nil == tableView) {
            continue;
        }
        
        [self.scrollView addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.mas_height);
            make.width.equalTo(self.mas_width);
            make.top.equalTo(self.scrollView.mas_top);
            make.bottom.equalTo(self.scrollView.mas_bottom);
            
            if (0 == i) {//第一个
                make.left.equalTo(self.scrollView.mas_left).offset(self.seperatorSpace);
            }
            else {
                UITableView *leftTableView = self.scrollView.subviews[i - 1];
                make.left.equalTo(leftTableView.mas_right).offset(self.seperatorSpace);
                if (self.numbersOfTableView - 1 == i) {//最后一个
                    make.right.equalTo(self.scrollView.mas_right);
                }
            }
        }];
    }
}
//滚动到指定页面
- (void)scrollToPage:(NSInteger)pageIndex {
    [self scrollToPage:pageIndex animated:YES];
}
- (void)scrollToPage:(NSInteger)pageIndex animated:(BOOL)animated {
    CGFloat pageWidth = self.scrollView.width;
    [self.scrollView setContentOffset:CGPointMake(pageIndex * pageWidth, 0) animated:animated];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self didWhenScrollViewEnded:scrollView];
}
- (void)didWhenScrollViewEnded:(UIScrollView *)scrollView {
    if (scrollView != self.scrollView) {//屏蔽contentView回调该方法
        return;
    }
    CGFloat pageWidth = scrollView.width;
    int pageIndex = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (self.scrollAtIndex) {
        self.scrollAtIndex(pageIndex, nil);
    }
}

@end
