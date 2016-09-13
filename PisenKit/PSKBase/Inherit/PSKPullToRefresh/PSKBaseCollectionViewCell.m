//
//  PSKBaseCollectionViewCell.m
//  PisenKit
//
//  Created by 杨胜超 on 16/7/1.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import "PSKBaseCollectionViewCell.h"

@implementation PSKBaseCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.clipsToBounds = YES;
}

+ (void)registerCellToCollectionView:(UICollectionView *)collectionView {
    NSString *cellName = NSStringFromClass(self.class);
    if (IS_NIB_EXISTS(cellName)) {
        [collectionView registerNib:[UINib nibWithNibName:cellName bundle:nil]
        forCellWithReuseIdentifier:cellName];
    }
    else {
        [collectionView registerClass:self.class forCellWithReuseIdentifier:cellName];
    }
}
+ (instancetype)dequeueCellByCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(self.class) forIndexPath:indexPath];
}

+ (CGSize)sizeOfCellByObject:(NSObject *)object {
    return CGSizeMake(145, 145);
}
- (void)layoutObject:(NSObject *)object {}

@end
