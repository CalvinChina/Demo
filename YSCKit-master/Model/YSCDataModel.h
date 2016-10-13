//
//  YSCDataModel.h
//  YSCKit
//
//  Created by yangshengchao on 16/1/26.
//  Copyright © 2016年 Builder. All rights reserved.
//

#import <Foundation/Foundation.h>

//--------------------------
//
//  公共model的基类
//
//--------------------------
@interface BaseDataModel : NSObject <NSCopying>
//用于多section的TableView封装
@property (nonatomic, strong) NSString *sectionKey;

+ (id)ObjectWithKeyValues:(id)keyValues;
//接口访问方法
+ (void)GetByMethod:(NSString *)method params:(NSDictionary *)params block:(YSCResponseErrorMessageBlock)block;
+ (void)PostByMethod:(NSString *)method params:(NSDictionary *)params block:(YSCResponseErrorMessageBlock)block;
//统一规范参数的提交方式：加密的json字符串写入httpBody
+ (void)RequestByMethod:(NSString *)method params:(NSDictionary *)params block:(YSCResponseErrorMessageBlock)block;
- (NSString *)toJSONString;
@end


//--------------------------
//
//  YSCKit中用到的model
//
//--------------------------
@interface YSCPhotoBrowseCellModel : BaseDataModel
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) UIImage *image;

+ (instancetype)CreateModelByImageUrl:(NSString *)imageUrl image:(UIImage *)image;
@end