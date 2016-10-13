//
//  BasePullToRefreshCollectionViewController.h
//  YSCKit
//
//  Created by  YangShengchao on 14-3-27.
//  Copyright (c) 2014年 yangshengchao. All rights reserved.
//  FORMATED!
//

#import "YSCBasePullToRefreshViewController.h"

@interface YSCPullToRefreshCollectionViewController : YSCBasePullToRefreshViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) IBOutlet UICollectionView * collectionView;

#pragma mark - UICollectionView特有的方法

- (CGSize)itemSize;                                                     //item大小
- (UIEdgeInsets)itemEdgeInsets;                                         //item边距
- (CGFloat)minimumLineSpacingForSectionAtIndex:(NSInteger)section;      //cell的最小行间距
- (CGFloat)minimumInteritemSpacingForSectionAtIndex:(NSInteger)section; //cell的最小列间距

@end
