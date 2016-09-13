//
//  PSKDataBaseModel.h
//  PisenKit
//
//  Created by 杨胜超 on 16/7/1.
//  Copyright © 2016年 Pisen. All rights reserved.
//

//------------------------------------------------
//
//  PSKModel.data模型的基类
//  功能：序列化、简单网络请求、与json互转、分组标记
//
//------------------------------------------------
@interface PSKDataBaseModel : NSObject <NSCopying>
/** 分组标记 */
@property (nonatomic, strong) NSString *sectionKey;

/** json -> model */
+ (id)objectWithKeyValues:(id)keyValues;
/** model -> json */
- (NSString *)toJSONString;

/** 接口访问方法GET */
+ (NSString *)getByApi:(NSString *)apiName params:(NSDictionary *)params block:(PSKObjectErrorMessageBlock)block;
/** 接口访问方法POST */
+ (NSString *)postByApi:(NSString *)apiName params:(NSDictionary *)params block:(PSKObjectErrorMessageBlock)block;
/** 接口访问方法post body data */
+ (NSString *)requestByApi:(NSString *)apiName params:(NSDictionary *)params block:(PSKObjectErrorMessageBlock)block;
@end
