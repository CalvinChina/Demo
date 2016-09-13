//
//  PSKGridBrowseView.m
//  PisenKit
//
//  Created by 杨胜超 on 16/7/5.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import "PSKGridBrowseView.h"

@interface PSKGridBrowseView () <UICollectionViewDataSource, UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout>

@end

@implementation PSKGridBrowseView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _setup];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _setup];
    }
    return self;
}
- (void)_setup {
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = YES;
    self.minimumLineSpacing = 10;
    self.itemEdgeTop = self.itemEdgeLeft = self.itemEdgeBottom = self.itemEdgeRight = 20;
    self.isScrollHorizontal = YES;//默认是水平滚动
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.alwaysBounceHorizontal = YES;
    [self addSubview:self.collectionView];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    self.collectionView.frame = self.bounds;
    if (self.isScrollHorizontal) {
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collectionView.alwaysBounceHorizontal = YES;
        self.collectionView.alwaysBounceVertical = NO;
    }
    else {
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.collectionView.alwaysBounceVertical = YES;
        self.collectionView.alwaysBounceHorizontal = NO;
    }
}
- (void)setCollectionViewCell:(NSString *)collectionViewCell {
    _collectionViewCell = collectionViewCell;
    if (IS_NIB_EXISTS(collectionViewCell)) {
        [self.collectionView registerNib:[UINib nibWithNibName:collectionViewCell bundle:nil]
              forCellWithReuseIdentifier:collectionViewCell];
    }
    else {
        [self.collectionView registerClass:NSClassFromString(collectionViewCell)
                forCellWithReuseIdentifier:collectionViewCell];
    }
}
- (void)refreshCollectionViewByItemArray:(NSArray *)itemArray {
    self.dataArray = itemArray;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataArray count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:self.collectionViewCell forIndexPath:indexPath];
    if ([cell respondsToSelector:@selector(layoutObject:)]) {
        [cell performSelector:@selector(layoutObject:) withObject:self.dataArray[indexPath.row]];
    }
    return cell;
}

#pragma mark - UICollectionFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([NSClassFromString(self.collectionViewCell) respondsToSelector:@selector(sizeOfCellByObject:)]) {
        return [NSClassFromString(self.collectionViewCell) sizeOfCellByObject:nil];
    }
    return CGSizeMake(290, 290);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(self.itemEdgeTop, self.itemEdgeLeft, self.itemEdgeBottom, self.itemEdgeRight);
}
//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return self.minimumLineSpacing;
}
//cell的最小同行的item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tapPageAtIndex) {
        self.tapPageAtIndex(indexPath.row, nil);
    }
}

@end

