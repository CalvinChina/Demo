//
//  TestPullToRefreshResultTableViewCell2.m
//  PisenKitDemo
//
//  Created by 杨胜超 on 16/7/14.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import "TestPullToRefreshResultTableViewCell2.h"

@implementation TestPullToRefreshResultTableViewCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = kDefaultGrayColor2;
}

+ (CGFloat)heightOfCellByObject:(NSObject *)object {
    return 130;
}

- (void)layoutObject:(NSArray *)objects {
    for (UIView *containerView in self.containerViewCollection) {
        [containerView psk_removeAllTapGestures];
        containerView.hidden = YES;
    }
    
    for (int i = 0; i < [objects count]; i++) {
        SearchResultModel *model = objects[i];
        UIView *containerView = self.containerViewCollection[i];
        UIImageView *imageView = self.imageViewCollection[i];
        UILabel *nameLabel = self.nameLabelCollection[i];
        
        [imageView psk_setImageWithURLString:model.pictureUrl animation:NO];
        nameLabel.text = TRIM_STRING(model.title);
        containerView.hidden = NO;
        [containerView psk_addSingleTapWithBlock:^{
            NSLog(@"点击：%@", model.title);
        }];
    }
}

@end
