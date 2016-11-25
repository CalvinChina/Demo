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
//  data模型的基类
//  作用：序列化、简单网络请求、与json互转、分组标记
//
//--------------------------
@interface YSCDataModel : NSObject <NSCopying>
// 用于多section的TableView封装
@property (nonatomic, strong) NSString *sectionKey;

// 处理与json对象之间的转换
+ (id)objectWithKeyValues:(id)keyValues;
- (NSString *)toJSONString;

// 接口访问方法
+ (NSString *)getByApi:(NSString *)apiName params:(NSDictionary *)params block:(YSCObjectErrorMessageBlock)block;
+ (NSString *)postByApi:(NSString *)apiName params:(NSDictionary *)params block:(YSCObjectErrorMessageBlock)block;
// 统一规范参数的提交方式：加密的json字符串写入httpBody
+ (NSString *)requestByApi:(NSString *)apiName params:(NSDictionary *)params block:(YSCObjectErrorMessageBlock)block;
@end
