//
//  YSCSegmentedView.h
//  YSCKit
//
//  Created by yangshengchao on 15/9/8.
//  Copyright (c) 2015年 Builder. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef UIView *(^YSCSegmentedViewSetBlock)(NSInteger pageIndex);

@interface YSCSegmentedView : UIView <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

//关闭subview的缩放
@property (nonatomic, assign) BOOL closeResetFontAndConstraint;

//view之间的间隔
@property (nonatomic, assign) IBInspectable CGFloat seperatorSpace;
@property (nonatomic, assign) IBInspectable NSInteger numbersOfViews;

@property (nonatomic, copy) YSCSegmentedViewSetBlock segmentedViewSetBlock;
@property (nonatomic, copy) YSCIntegerErrorBlock scrollToPageBlock;

//刷新列表
- (void)reloadSegmentedViews;
//滚动到指定页面
- (void)scrollToPage:(NSInteger)pageIndex;
- (void)scrollToPage:(NSInteger)pageIndex animated:(BOOL)animated;

@end
