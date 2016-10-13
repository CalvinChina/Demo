//
//  BaseCollectionViewCell.m
//  YSCKit
//
//  Created by yangshengchao on 14-11-4.
//  Copyright (c) 2014年 yangshengchao. All rights reserved.
//

#import "YSCBaseCollectionViewCell.h"

@implementation YSCBaseCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.clipsToBounds = YES;
    [self resetFontSizeOfView];
    [self resetConstraintOfView];
}

#pragma mark - 注册与重用
+ (void)registerCellToCollectionView:(UICollectionView *)collectionView {
    [collectionView registerNib:[[self class] NibNameOfCell] forCellWithReuseIdentifier:[[self class] identifier]];
}
+ (instancetype)dequeueCellByCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath*)indexPath {
    YSCBaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[[self class] identifier] forIndexPath:indexPath];
    return cell;
}
+ (NSString *)identifier {
    return NSStringFromClass(self.class);
}
+ (UINib *)NibNameOfCell {
    return [UINib nibWithNibName:NSStringFromClass(self.class) bundle:nil];
}

#pragma mark - 计算大小
+ (CGSize)SizeOfCellByObject:(NSObject *)object {
    return CGSizeMake(145, 145);
}

#pragma mark - 呈现数据
- (void)layoutObject:(NSObject *)object {}

@end
