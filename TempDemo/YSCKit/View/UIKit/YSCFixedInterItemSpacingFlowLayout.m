//
//  YSCFixedInterItemSpacingFlowLayout.m
//  YSCKit
//
//  Created by 杨胜超 on 16/5/3.
//  Copyright © 2016年 SMIT. All rights reserved.
//

#import "YSCFixedInterItemSpacingFlowLayout.h"

@implementation YSCFixedInterItemSpacingFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    self.layoutAttributesArray = [NSMutableArray array];
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    for (NSInteger section = 0; section < numberOfSections; section++){
        NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
        NSMutableArray *rowArray = [NSMutableArray arrayWithCapacity:numberOfItems];
        for (NSInteger item = 0; item < numberOfItems; item++){
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            [rowArray addObject:attributes];
        }
        [self.layoutAttributesArray addObject:rowArray];
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *originalAttributes = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *updatedAttributes = [NSMutableArray arrayWithArray:originalAttributes];
    for (UICollectionViewLayoutAttributes *attributes in originalAttributes) {
        NSIndexPath *indexPath = attributes.indexPath;
        if (UICollectionElementCategoryCell == attributes.representedElementCategory) {
            /** 只处理item的frame */
            NSUInteger index = [originalAttributes indexOfObject:attributes];
            if (indexPath.section < [self.layoutAttributesArray count]) {
                NSArray *rowArray = self.layoutAttributesArray[indexPath.section];
                if (indexPath.row < [rowArray count]) {
                    updatedAttributes[index] = rowArray[indexPath.row];
                }
            }
        }
    }
    return updatedAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *currentItemAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    UIEdgeInsets sectionInset = [self evaluatedSectionInsetForItemAtIndex:indexPath.section];
    
    BOOL isFirstItemInSection = (0 == indexPath.item);
    if (isFirstItemInSection) {
        CGRect frame = currentItemAttributes.frame;
        frame.origin.x = sectionInset.left;
        currentItemAttributes.frame = frame;
    }
    else {
        NSIndexPath *previousIndexPath = [NSIndexPath indexPathForItem:indexPath.item - 1 inSection:indexPath.section];
        CGRect previousFrame = [self layoutAttributesForItemAtIndexPath:previousIndexPath].frame;
        CGRect currentFrame = currentItemAttributes.frame;
        CGFloat layoutWidth = CGRectGetWidth(self.collectionView.frame) - sectionInset.left - sectionInset.right;
        CGRect strecthedCurrentFrame = CGRectMake(sectionInset.left,
                                                  currentFrame.origin.y,
                                                  layoutWidth,
                                                  currentFrame.size.height);
        BOOL isFirstItemInRow = ! CGRectIntersectsRect(previousFrame, strecthedCurrentFrame);
        if (isFirstItemInRow) {
            CGRect frame = currentItemAttributes.frame;
            frame.origin.x = sectionInset.left;
            currentItemAttributes.frame = frame;
        }
        else {
            CGRect frame = currentItemAttributes.frame;
            frame.origin.x = CGRectGetMaxX(previousFrame) + [self evaluatedMinimumInteritemSpacingForSectionAtIndex:indexPath.section];
            currentItemAttributes.frame = frame;
        }
    }
    return currentItemAttributes;
}

- (UIEdgeInsets)evaluatedSectionInsetForItemAtIndex:(NSInteger)index {
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        id delegate = self.collectionView.delegate;
        return [delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:index];
    } else {
        return self.sectionInset;
    }
}

- (CGFloat)evaluatedMinimumInteritemSpacingForSectionAtIndex:(NSInteger)sectionIndex {
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        id delegate = self.collectionView.delegate;
        return [delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:sectionIndex];
    }
    else {
        return self.minimumInteritemSpacing;
    }
}

@end
