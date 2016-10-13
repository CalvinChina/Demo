//
//  YSCPhotoBrowseView.m
//  YSCKit
//
//  Created by yangshengchao on 15/8/12.
//  Copyright (c) 2015年 Builder. All rights reserved.
//

#import "YSCPhotoBrowseView.h"

@implementation YSCPhotoBrowseView

- (void)setup {
    [super setup];
    self.collectionView.pagingEnabled = YES;
}
- (void)refreshCollectionViewByItemArray:(NSArray *)itemArray {
    [super refreshCollectionViewByItemArray:itemArray];
    if (self.scrollAtIndex && isNotEmpty(itemArray)) {
        self.scrollAtIndex(0, nil);
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.isScrollHor) {
        self.collectionView.frame = CGRectMake(-AUTOLAYOUT_LENGTH(self.minimumLineSpacing / 2), 0,
                                               CGRectGetWidth(self.bounds) + AUTOLAYOUT_LENGTH(self.minimumLineSpacing),
                                               CGRectGetHeight(self.bounds));
    }
    else {
        self.collectionView.frame = CGRectMake(0, -AUTOLAYOUT_LENGTH(self.minimumLineSpacing / 2),
                                               CGRectGetWidth(self.bounds),
                                               CGRectGetHeight(self.bounds) + AUTOLAYOUT_LENGTH(self.minimumLineSpacing));
    }
}
- (void)resetCurrentIndex:(NSInteger)index {
    if (index >= [self.dataArray count] || index < 0) {
        return;
    }
    if (self.isScrollHor) {
        [self.collectionView setContentOffset:CGPointMake(index * self.collectionView.width, 0) animated:NO];
    }
    else {
        [self.collectionView setContentOffset:CGPointMake(0, index * self.collectionView.height) animated:NO];
    }
}

#pragma mark - UICollectionViewDataSource

#pragma mark - UICollectionFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.bounds.size;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (self.isScrollHor) {
        return AUTOLAYOUT_EDGEINSETS(0, self.minimumLineSpacing / 2, 0, self.minimumLineSpacing / 2);
    }
    else {
        return AUTOLAYOUT_EDGEINSETS(self.minimumLineSpacing / 2, 0, self.minimumLineSpacing / 2, 0);
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self didWhenScrollViewEnded:scrollView];
}
- (void)didWhenScrollViewEnded:(UIScrollView *)scrollView {
    if (scrollView != self.collectionView) {//屏蔽contentView回调该方法
        return;
    }
    CGFloat pageWidth = scrollView.width;
    int pageIndex = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (self.scrollAtIndex) {
        self.scrollAtIndex(pageIndex, nil);
    }
}

@end
