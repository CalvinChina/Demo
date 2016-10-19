//
//  DWKDataModel.h
//  DWKKit
//
//  Created by pisen on 16/10/18.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

#import <Foundation/Foundation.h>

//--------------------------
//
//  data模型的基类
//  作用：序列化、简单网络请求、与json互转、分组标记
//
//--------------------------
@interface DWKDataModel : NSObject <NSCopying>
// 用于多section的TableView封装
@property (nonatomic, strong) NSString *sectionKey;

// 处理与json对象之间的转换
+ (id)objectWithKeyValues:(id)keyValues;
- (NSString *)toJSONString;

// 接口访问方法
+ (NSString *)getByApi:(NSString *)apiName params:(NSDictionary *)params block:(DWKObjectErrorMessageBlock)block;
+ (NSString *)postByApi:(NSString *)apiName params:(NSDictionary *)params block:(DWKObjectErrorMessageBlock)block;
// 统一规范参数的提交方式：加密的json字符串写入httpBody
+ (NSString *)requestByApi:(NSString *)apiName params:(NSDictionary *)params block:(DWKObjectErrorMessageBlock)block;
@end

