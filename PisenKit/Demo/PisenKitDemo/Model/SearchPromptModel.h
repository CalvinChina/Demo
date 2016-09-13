//
//  SearchPromptModel.h
//  PisenKitDemo
//
//  Created by 杨胜超 on 16/7/14.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import "PSKDataBaseModel.h"

@interface SearchPromptModel : PSKDataBaseModel
@property (nonatomic, assign) NSInteger promptId;
@property (nonatomic, strong) NSString *promptName;
@property (nonatomic, assign) NSInteger promptType;
@end
