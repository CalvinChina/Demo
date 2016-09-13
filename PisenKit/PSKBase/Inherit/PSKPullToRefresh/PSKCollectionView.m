//
//  PSKCollectionView.m
//  PisenKit
//
//  Created by 杨胜超 on 16/7/1.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import "PSKCollectionView.h"

@interface PSKCollectionView () <
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout>
@end
@implementation PSKCollectionView
- (void)dealloc {
    PRINT_DEALLOCING
}
- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self setup];
    }
    return self;
}
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


#pragma mark - 初始化配置参数
- (void)setup {
    self.helper = [[PSKPullToRefreshHelper alloc] init];
    self.helper.scrollView = self;
    //设置默认属性
    self.helper.enableRefresh = YES;
    self.helper.enableLoadMore = YES;
    self.helper.enableTips = YES;
    self.cellEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    self.minimumLineSpacingBlock = ^CGFloat(NSInteger section) {
        return 10;
    };
    self.minimumInteritemSpacingBlock = ^CGFloat(NSInteger section) {
        return 0;
    };
    @weakiy(self);
    self.helper.loadMoreBlock = ^(NSIndexSet *sections, NSArray<NSIndexPath *> *indexPaths) {
        [weak_self performBatchUpdates:^{
            [weak_self insertSections:sections];
            [weak_self insertItemsAtIndexPaths:indexPaths];
        } completion:^(BOOL finished) {
            
        }];
    };
    [self initCollectionView];
}
- (void)initCollectionView {
    // 0. 注册cell、header、footer
    [self registerHeaderName:self.headerName];
    [self registerCellName:self.cellName];
    [self registerFooterName:self.footerName];
    
    // 1. 设置参数
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = YES;
    self.alwaysBounceVertical = YES;
    self.backgroundColor = [UIColor clearColor];
    self.delegate = self;
    self.dataSource = self;
}


#pragma mark - 属性设置
- (void)setApiName:(NSString *)apiName {
    self.helper.apiName = apiName;
    _apiName = apiName;
}
- (void)setModelName:(NSString *)modelName {
    self.helper.modelName = modelName;
    _modelName = modelName;
}
- (void)setCellName:(NSString *)cellName {
    _cellName = cellName;
    [self registerCellName:cellName];
}
- (void)setHeaderName:(NSString *)headerName {
    _headerName = headerName;
    [self registerHeaderName:headerName];
}
- (void)setFooterName:(NSString *)footerName {
    _footerName = footerName;
    [self registerFooterName:footerName];
}


#pragma mark - 注册header、cell、footer
- (void)registerHeaderName:(NSString *)headerName {
    if (OBJECT_ISNOT_EMPTY(headerName)) {
        _headerName = headerName;
        if (IS_NIB_EXISTS(headerName)) {
            [self registerNib:[UINib nibWithNibName:headerName bundle:nil]
   forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
          withReuseIdentifier:headerName];
        }
        else{
            [self registerClass:NSClassFromString(headerName)
   forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
          withReuseIdentifier:headerName];
        }
    }
}
- (void)registerCellName:(NSString *)cellName {
    if (OBJECT_ISNOT_EMPTY(cellName)) {
        _cellName = cellName;
        if (IS_NIB_EXISTS(cellName)) {
            [self registerNib:[UINib nibWithNibName:cellName bundle:nil]
   forCellWithReuseIdentifier:cellName];
        }
        else {
            [self registerClass:NSClassFromString(cellName)
   forCellWithReuseIdentifier:cellName];
        }
    }
}
- (void)registerFooterName:(NSString *)footerName {
    if (OBJECT_ISNOT_EMPTY(footerName)) {
        _footerName = footerName;
        if (IS_NIB_EXISTS(footerName)) {
            [self registerNib:[UINib nibWithNibName:footerName bundle:nil]
   forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
          withReuseIdentifier:footerName];
        }
        else {
            [self registerClass:NSClassFromString(footerName)
   forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
          withReuseIdentifier:footerName];
        }
    }
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.helper.cellDataArray count];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *array = self.helper.cellDataArray[section];
    return [array count];
}
// HEADER & FOOTER
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader] ||
        [kind isEqualToString:UICollectionElementKindSectionFooter]) {
        NSInteger section = indexPath.section;
        NSObject *reusableObject = nil;
        NSString *reusableName = nil;
        // 判断HEADER or FOOTER
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            if ((section >= 0 && section < [self.helper.headerDataArray count])) {
                reusableName = self.headerName;
                reusableObject = self.helper.headerDataArray[section];
                if (self.headerNameBlock) {
                    reusableName = self.headerNameBlock(reusableObject, section);
                }
            }
        }
        else {
            if ((section >= 0 && section < [self.helper.footerDataArray count])) {
                reusableName = self.footerName;
                reusableObject = self.helper.footerDataArray[section];
                if (self.footerNameBlock) {
                    reusableName = self.footerNameBlock(reusableObject, section);
                }
            }
        }
        // 组装数据
        if (OBJECT_ISNOT_EMPTY(reusableName)) {
            reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                              withReuseIdentifier:reusableName
                                                                     forIndexPath:indexPath];
            if ([reusableView respondsToSelector:@selector(layoutObject:)]) {
                [reusableView performSelector:@selector(layoutObject:) withObject:reusableObject];
            }
            if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
                if (self.layoutHeaderView) {
                    self.layoutHeaderView(reusableView, reusableObject, indexPath);
                }
            }
            else {
                if (self.layoutFooterView) {
                    self.layoutFooterView(reusableView, reusableObject, indexPath);
                }
            }
        }
    }
    return reusableView;
}
// CELL
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = nil;
    NSObject *cellObject = [self.helper getObjectByIndexPath:indexPath];
    NSString *cellName = self.cellName;
    if (self.cellNameBlock) {
        NSString *tempName = self.cellNameBlock(cellObject, indexPath);
        if (OBJECT_ISNOT_EMPTY(tempName)) {
            cellName = tempName;
        }
    }
    cell = [self dequeueReusableCellWithReuseIdentifier:cellName forIndexPath:indexPath];
    if ([cell respondsToSelector:@selector(layoutObject:)]) {
        [cell performSelector:@selector(layoutObject:) withObject:cellObject];
    }
    if (self.layoutCellView) {
        self.layoutCellView(cell, cellObject, indexPath);
    }
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if ((section < 0 || section >= [self.helper.headerDataArray count])) {
        return CGSizeZero;
    }
    
    NSObject *headerObject = self.helper.headerDataArray[section];
    NSString *headerName = self.headerName;
    if (self.headerNameBlock) {
        NSString *tempName = self.headerNameBlock(headerObject, section);
        if (OBJECT_ISNOT_EMPTY(tempName)) {
            headerName = tempName;
        }
    }
    if (OBJECT_ISNOT_EMPTY(headerName)) {
        if (self.headerSizeBlock) {
            return self.headerSizeBlock(headerObject, section);
        }
        else if ([NSClassFromString(headerName) respondsToSelector:@selector(sizeOfViewByObject:)]) {
            return [NSClassFromString(headerName) sizeOfViewByObject:headerObject];
        }
    }
    return CGSizeZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if ((section < 0 || section >= [self.helper.footerDataArray count])) {
        return CGSizeZero;
    }
    
    NSObject *footerObject = self.helper.footerDataArray[section];
    NSString *footerName = self.footerName;
    if (self.footerNameBlock) {
        NSString *tempName = self.footerNameBlock(footerObject, section);
        if (OBJECT_ISNOT_EMPTY(tempName)) {
            footerName = tempName;
        }
    }
    if (OBJECT_ISNOT_EMPTY(footerName)) {
        if (self.footerSizeBlock) {
            return self.footerSizeBlock(footerObject, section);
        }
        else if ([NSClassFromString(footerName) respondsToSelector:@selector(sizeOfViewByObject:)]) {
            return [NSClassFromString(footerName) sizeOfViewByObject:footerObject];
        }
    }
    return CGSizeZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSObject *cellObject = [self.helper getObjectByIndexPath:indexPath];
    NSString *cellName = self.cellName;
    if (self.cellNameBlock) {
        NSString *tempName = self.cellNameBlock(cellObject, indexPath);
        if (OBJECT_ISNOT_EMPTY(tempName)) {
            cellName = tempName;
        }
    }
    if (OBJECT_ISNOT_EMPTY(cellName)) {
        if (self.cellSizeBlock) {
            return self.cellSizeBlock(cellObject, indexPath);
        }
        else if ([NSClassFromString(cellName) respondsToSelector:@selector(sizeOfCellByObject:)]) {
            return [NSClassFromString(cellName) sizeOfCellByObject:cellObject];
        }
    }
    return CGSizeMake(290, 290);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return self.cellEdgeInsets;
}
//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (self.minimumLineSpacingBlock) {
        return self.minimumLineSpacingBlock(section);
    }
    else {
        return 10;
    }
}
//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (self.minimumInteritemSpacingBlock) {
        return self.minimumInteritemSpacingBlock(section);
    }
    else {
        return 10;
    }
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.clickCellBlock) {
        NSObject *object = [self.helper getObjectByIndexPath:indexPath];
        self.clickCellBlock(object, indexPath);
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.helper.willBeginDraggingBlock) {
        self.helper.willBeginDraggingBlock();
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.helper.didEndDraggingBlock) {
        self.helper.didEndDraggingBlock();
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.helper.didScrollBlock) {
        self.helper.didScrollBlock();
    }
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (self.helper.didEndScrollingAnimationBlock) {
        self.helper.didEndScrollingAnimationBlock();
    }
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (self.helper.willBeginDeceleratingBlock) {
        self.helper.willBeginDeceleratingBlock();
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.helper.didEndDeceleratingBlock) {
        self.helper.didEndDeceleratingBlock();
    }
}

@end

