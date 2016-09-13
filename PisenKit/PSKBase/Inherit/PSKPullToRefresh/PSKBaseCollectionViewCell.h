//
//  PSKBaseCollectionViewCell.h
//  PisenKit
//
//  Created by 杨胜超 on 16/7/1.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSKBaseCollectionViewCell : UICollectionViewCell

/** 注册 */
+ (void)registerCellToCollectionView:(UICollectionView *)collectionView;
/** 重用 */
+ (instancetype)dequeueCellByCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;

/** 计算大小 */
+ (CGSize)sizeOfCellByObject:(NSObject *)object;
/** 显示数据 */
- (void)layoutObject:(NSObject *)object;

@end
