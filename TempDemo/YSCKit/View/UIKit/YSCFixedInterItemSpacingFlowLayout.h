//
//  YSCFixedInterItemSpacingFlowLayout.h
//  YSCKit
//
//  Created by 杨胜超 on 16/5/3.
//  Copyright © 2016年 SMIT. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 固定同行item之间的间隔 */
@interface YSCFixedInterItemSpacingFlowLayout : UICollectionViewFlowLayout
/** 预先计算好所有item的frame */
@property (nonatomic, strong) NSMutableArray *layoutAttributesArray;
@end
