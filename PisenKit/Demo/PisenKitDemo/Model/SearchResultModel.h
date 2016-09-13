//
//  SearchResultModel.h
//  PisenKitDemo
//
//  Created by 杨胜超 on 16/7/14.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import "PSKDataBaseModel.h"

@interface SearchResultModel : PSKDataBaseModel
@property (nonatomic, strong) NSString *programId;
@property (nonatomic, strong) NSString *programType;
@property (nonatomic, strong) NSArray *actors;
@property (nonatomic, strong) NSArray *areas;
@property (nonatomic, assign) BOOL isBest;
@property (nonatomic, strong) NSArray *kinds;
@property (nonatomic, strong) NSString *lastUpdateEpisode;
@property (nonatomic, strong) NSString *pictureUrl;
@property (nonatomic, strong) NSString *title;
@end

@interface SearchResultListModel : PSKDataBaseModel
@property (nonatomic, assign) NSInteger rowCount;
@property (nonatomic, assign) BOOL isLastPage;
@property (nonatomic, strong) NSArray *movieList;
@end