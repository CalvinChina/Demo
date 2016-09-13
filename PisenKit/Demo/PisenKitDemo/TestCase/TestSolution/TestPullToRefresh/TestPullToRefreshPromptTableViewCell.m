//
//  TestPullToRefreshPromptTableViewCell.m
//  PisenKitDemo
//
//  Created by 杨胜超 on 16/7/14.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import "TestPullToRefreshPromptTableViewCell.h"

@implementation TestPullToRefreshPromptTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

+ (CGFloat)heightOfCellByObject:(NSObject *)object {
    return 30;
}

- (void)layoutObject:(SearchPromptModel *)model {
    self.promptTitleLabel.text = TRIM_STRING(model.promptName);
}

@end
