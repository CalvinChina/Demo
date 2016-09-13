//
//  PSKBaseCollectionHeaderFooterView.h
//  PisenKit
//
//  Created by 杨胜超 on 16/7/1.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSKBaseCollectionHeaderFooterView : UICollectionReusableView

/** 注册 */
+ (void)registerHeaderFooterToCollectionView:(UICollectionView *)collectionView kind:(NSString *)kind;
/** 重用 */
+ (instancetype)dequeueHeaderFooterByCollectionView:(UICollectionView *)collectionView kind:(NSString *)kind forIndexPath:(NSIndexPath *)indexPath;

/** 计算高度 */
+ (CGSize)sizeOfViewByObject:(NSObject *)object;
/** 显示数据 */
- (void)layoutObject:(NSObject *)object;

@end
