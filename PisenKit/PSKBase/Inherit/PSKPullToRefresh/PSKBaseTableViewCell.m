//
//  PSKBaseTableViewCell.m
//  PisenKit
//
//  Created by 杨胜超 on 16/7/1.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import "PSKBaseTableViewCell.h"

@implementation PSKBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

+ (void)registerCellToTableView:(UITableView *)tableView {
    NSString *cellName = NSStringFromClass(self.class);
    if (IS_NIB_EXISTS(cellName)) {
        [tableView registerNib:[UINib nibWithNibName:cellName bundle:nil]
        forCellReuseIdentifier:cellName];
    }
    else {
        [tableView registerClass:self.class forCellReuseIdentifier:cellName];
    }
}
+ (instancetype)dequeueCellByTableView:(UITableView *)tableView {
    return [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self.class)];
}

+ (CGFloat)heightOfCellByObject:(NSObject *)object {
    return 44;
}
- (void)layoutObject:(NSObject *)object { }

@end
