//
//  CommonItemModel.h
//  PisenKitDemo
//
//  Created by 杨胜超 on 16/7/8.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import "PSKDataBaseModel.h"

@interface CommonItemModel : PSKDataBaseModel
@property (nonatomic, strong) NSString *sectionTitle;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *viewController;
+ (instancetype)createItemBySectionTitle:(NSString *)section title:(NSString *)title viewController:(NSString *)viewController;
@end
