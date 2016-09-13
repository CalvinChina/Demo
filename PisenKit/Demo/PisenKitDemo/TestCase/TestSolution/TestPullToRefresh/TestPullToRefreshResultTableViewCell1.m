//
//  TestPullToRefreshResultTableViewCell1.m
//  PisenKitDemo
//
//  Created by 杨胜超 on 16/7/14.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import "TestPullToRefreshResultTableViewCell1.h"

@implementation TestPullToRefreshResultTableViewCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = kDefaultGrayColor1;
    [self.playButton psk_addCornerWithRadius:40 / 2];
    [self.playButton psk_makeBorderWithColor:kDefaultBlueColor1 borderWidth:1];
}
+ (CGFloat)heightOfCellByObject:(NSObject *)object {
    return 115;
}
- (void)layoutObject:(SearchResultModel *)model {
    [self.coverImageView psk_setImageWithURLString:model.pictureUrl];
    self.nameLabel.text = TRIM_STRING(model.title);
}

@end
