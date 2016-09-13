//
//  PSKFormatUtil.h
//  PisenKit
//
//  Created by 杨胜超 on 16/7/1.
//  Copyright © 2016年 Pisen. All rights reserved.
//

//====================================
//
// 格式化数据
//
//====================================
@interface PSKFormatUtil : NSObject
// 常用的价格字符串格式化方法（默认：显示￥、显示小数点）
+ (NSString *)formatPrice:(NSNumber *)price;
// 常用的价格字符串格式化方法（默认：显示￥、显示小数点、显示元）
+ (NSString *)formatPriceWithUnit:(NSNumber *)price;
+ (NSString *)formatPrice:(NSNumber *)price showMoneyTag:(BOOL)isTagUsed showDecimalPoint:(BOOL) isDecimal useUnit:(BOOL)isUnitUsed;
//规范化：如果有小数点才显示两位，否则就不显示小数点
+ (NSString *)formatNumberValue:(NSNumber *)value;
+ (NSString *)formatFloatValue:(CGFloat)value;
// 规范化mac地址 xx:xx:xx:xx:xx:xx
+ (NSString *)formatMacAddress:(NSString *)macAddress;
// 格式化输出json到console(格式化失败返回empty)
+ (NSString *)formatPrintJsonStringOnConsole:(NSString *)jsonString;
@end
