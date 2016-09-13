//
//  PSKPhotoBrowseView.m
//  PisenKit
//
//  Created by 杨胜超 on 16/7/5.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import "PSKPhotoBrowseView.h"

@implementation PSKPhotoBrowseView

- (void)refreshCollectionViewByItemArray:(NSArray *)itemArray {
    [super refreshCollectionViewByItemArray:itemArray];
    if (self.scrollAtIndex && OBJECT_ISNOT_EMPTY(itemArray)) {
        self.scrollAtIndex(0);
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.pagingEnabled = YES;
    if (self.isScrollHorizontal) {
        self.collectionView.frame = CGRectMake(-self.minimumLineSpacing / 2, 0,
                                               CGRectGetWidth(self.bounds) + self.minimumLineSpacing,
                                               CGRectGetHeight(self.bounds));
    }
    else {
        self.collectionView.frame = CGRectMake(0, -self.minimumLineSpacing / 2,
                                               CGRectGetWidth(self.bounds),
                                               CGRectGetHeight(self.bounds) + self.minimumLineSpacing);
    }
}
- (void)resetCurrentIndex:(NSInteger)index {
    if (index >= [self.dataArray count] || index < 0) {
        return;
    }
    if (self.isScrollHorizontal) {
        [self.collectionView setContentOffset:CGPointMake(index * self.collectionView.psk_width, 0) animated:NO];
    }
    else {
        [self.collectionView setContentOffset:CGPointMake(0, index * self.collectionView.psk_height) animated:NO];
    }
}

#pragma mark - UICollectionViewDataSource

#pragma mark - UICollectionFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.bounds.size;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (self.isScrollHorizontal) {
        return UIEdgeInsetsMake(0, self.minimumLineSpacing / 2, 0, self.minimumLineSpacing / 2);
    }
    else {
        return UIEdgeInsetsMake(self.minimumLineSpacing / 2, 0, self.minimumLineSpacing / 2, 0);
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
    CGFloat pageWidth = scrollView.psk_width;
    int pageIndex = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (self.scrollAtIndex) {
        self.scrollAtIndex(pageIndex);
    }
}

@end
