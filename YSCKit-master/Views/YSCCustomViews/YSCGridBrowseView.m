//
//  YSCGridBrowseView.m
//  YSCKit
//
//  Created by yangshengchao on 15/8/12.
//  Copyright (c) 2015年 Builder. All rights reserved.
//

#import "YSCGridBrowseView.h"

@interface YSCGridBrowseView () <UICollectionViewDataSource, UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout>

@end

@implementation YSCGridBrowseView

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
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = YES;
    self.minimumLineSpacing = 20;
    self.itemEdgeTop = self.itemEdgeLeft = self.itemEdgeBottom = self.itemEdgeRight = 20;
    self.isScrollHor = YES;//默认是水平滚动
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
    if (self.isScrollHor) {
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
    [self.collectionView registerNib:[UINib nibWithNibName:collectionViewCell bundle:nil]
          forCellWithReuseIdentifier:kItemCellIdentifier];
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
    YSCBaseCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:kItemCellIdentifier forIndexPath:indexPath];
    if ([cell isKindOfClass:[YSCBaseCollectionViewCell class]]) {
        [cell layoutObject:self.dataArray[indexPath.row]];
    }
    return cell;
}

#pragma mark - UICollectionFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([NSString isNotEmpty:self.collectionViewCell] &&
        [NSClassFromString(self.collectionViewCell) isSubclassOfClass:[YSCBaseCollectionViewCell class]]) {
        return [NSClassFromString(self.collectionViewCell) SizeOfCellByObject:nil];
    }
    return CGSizeMake(290, 290);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return AUTOLAYOUT_EDGEINSETS(self.itemEdgeTop, self.itemEdgeLeft, self.itemEdgeBottom, self.itemEdgeRight);
}
//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return AUTOLAYOUT_LENGTH(self.minimumLineSpacing);
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
