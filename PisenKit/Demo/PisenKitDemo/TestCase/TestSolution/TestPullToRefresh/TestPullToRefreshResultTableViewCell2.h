//
//  TestPullToRefreshResultTableViewCell2.h
//  PisenKitDemo
//
//  Created by 杨胜超 on 16/7/14.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestPullToRefreshResultTableViewCell2 : PSKBaseTableViewCell
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *containerViewCollection;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageViewCollection;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *nameLabelCollection;
@end
