//
//  PFMTitleBarView.h
//  PisenFM
//
//  Created by pisen on 16/10/27.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol changePageDelegate <NSObject>

- (void)changePage:(NSInteger) selectIndex;

@end

@interface PFMTitleBarView : UIScrollView

// 初始化方法
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *) titleArray;

@property (nonatomic ,assign)id <changePageDelegate> pageDelegate;

// 让标题栏滚动到某个位置
- (void)scrollToIndex:(NSInteger)index;

@end
