//
//  YSCSegmentedView.m
//  YSCKit
//
//  Created by yangshengchao on 15/9/8.
//  Copyright (c) 2015年 Builder. All rights reserved.
//

#import "YSCSegmentedView.h"

@implementation YSCSegmentedView

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
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    
    self.segmentedViewSetBlock = ^UIView *(NSInteger pageIndex) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        return tableView;
    };
}
- (void)setSeperatorSpace:(CGFloat)seperatorSpace {
    _seperatorSpace = AUTOLAYOUT_LENGTH(seperatorSpace);
}
//刷新列表
- (void)reloadSegmentedViews {
    //重置scrollView的约束
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left).offset(-self.seperatorSpace);
        make.right.equalTo(self.mas_right);
    }];
    
    //设置scrollView所有子view的约束
    [self.scrollView removeAllSubviews];
    for (int i = 0; i < self.numbersOfViews; i++) {
        UIView *segmentedView = self.segmentedViewSetBlock(i);
        if ( ! segmentedView) {
            continue;
        }
        
        [self.scrollView addSubview:segmentedView];
        [segmentedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.scrollView.mas_height);
            make.width.equalTo(self.scrollView.mas_width);
            make.top.equalTo(self.scrollView.mas_top);
            make.bottom.equalTo(self.scrollView.mas_bottom);
            
            if (0 == i) {//第一个
                make.left.equalTo(self.scrollView.mas_left).offset(self.seperatorSpace);
            }
            else {
                UIView *leftView = self.scrollView.subviews[i - 1];
                make.left.equalTo(leftView.mas_right).offset(self.seperatorSpace);
                if (self.numbersOfViews - 1 == i) {//最后一个
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
    if (self.scrollToPageBlock) {
        self.scrollToPageBlock(pageIndex, nil);
    }
}

@end
