//
//  PSKBaseCollectionHeaderFooterView.m
//  PisenKit
//
//  Created by 杨胜超 on 16/7/1.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import "PSKBaseCollectionHeaderFooterView.h"

@implementation PSKBaseCollectionHeaderFooterView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.clipsToBounds = YES;
}

+ (void)registerHeaderFooterToCollectionView:(UICollectionView *)collectionView kind:(NSString *)kind {
    NSString *headerFooterName = NSStringFromClass(self.class);
    if (IS_NIB_EXISTS(headerFooterName)) {
        [collectionView registerNib:[UINib nibWithNibName:headerFooterName bundle:nil]
         forSupplementaryViewOfKind:kind
                withReuseIdentifier:headerFooterName];
    }
    else {
        [collectionView registerClass:self.class
           forSupplementaryViewOfKind:kind
                  withReuseIdentifier:headerFooterName];
    }
}
+ (instancetype)dequeueHeaderFooterByCollectionView:(UICollectionView *)collectionView kind:(NSString *)kind forIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass(self.class) forIndexPath:indexPath];
}

+ (CGSize)sizeOfViewByObject:(NSObject *)object {
    return CGSizeMake(SCREEN_WIDTH, 35.0f);
}
- (void)layoutObject:(NSObject *)object {}

@end
