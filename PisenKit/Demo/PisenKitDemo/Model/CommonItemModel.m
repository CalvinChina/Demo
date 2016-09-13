//
//  CommonItemModel.m
//  PisenKitDemo
//
//  Created by 杨胜超 on 16/7/8.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import "CommonItemModel.h"
#import <objc/runtime.h>

@implementation CommonItemModel
+ (instancetype)createItemBySectionTitle:(NSString *)sectionTitle title:(NSString *)title viewController:(NSString *)viewController {
    CommonItemModel *item = [CommonItemModel new];
    item.sectionKey = sectionTitle;
    item.sectionTitle = sectionTitle;
    item.title = title;
    item.viewController = viewController;
    return item;
}
@end
