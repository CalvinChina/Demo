//
//  YSCGridBrowseView.h
//  YSCKit
//
//  Created by yangshengchao on 15/8/12.
//  Copyright (c) 2015年 Builder. All rights reserved.
//

#import <UIKit/UIKit.h>

//宫格浏览器
//1. 支持水平和垂直两个方向浏览
@interface YSCGridBrowseView : UIView

@property (nonatomic, assign) IBInspectable CGFloat minimumLineSpacing; //间隔默认20px
@property (nonatomic, assign) IBInspectable CGFloat itemEdgeTop;      //item的四周间隔
@property (nonatomic, assign) IBInspectable CGFloat itemEdgeLeft;
@property (nonatomic, assign) IBInspectable CGFloat itemEdgeBottom;
@property (nonatomic, assign) IBInspectable CGFloat itemEdgeRight;
@property (nonatomic, assign) IBInspectable BOOL isScrollHor;//Default YES
@property (nonatomic, strong) IBInspectable NSString *collectionViewCell;
@property (nonatomic, copy) YSCIntegerResultBlock tapPageAtIndex;//点击某个图片后回调

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, weak) NSArray *dataArray;

- (void)setup;
- (void)refreshCollectionViewByItemArray:(NSArray *)itemArray;

@end
