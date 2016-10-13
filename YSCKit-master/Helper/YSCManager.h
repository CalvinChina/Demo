//
//  YSCManager.h
//  YSCKit
//
//  Created by yangshengchao on 16/1/28.
//  Copyright © 2016年 Builder. All rights reserved.
//


/**
 *  公共方法类
 *  作用：管理各种小方法(convenient methods)
 */


//--------------------------------------
//  常用操作
//--------------------------------------
@interface YSCManager : NSObject
// 检测新版本
+ (void)CheckNewVersion;
+ (void)CheckNewVersionOnAppStore;

// 打电话
+ (void)MakeCall:(NSString *)phoneNumber;
+ (void)MakeCall:(NSString *)phoneNumber success:(YSCBlock)block;

// NSURL获取参数
+ (NSDictionary *)GetParamsInNSURL:(NSURL *)url;
+ (NSDictionary *)GetParamsInQueryString:(NSString *)queryString;

// 获取wifi的mac地址
+ (id)FetchSSIDInfo;
+ (NSString *)CurrentWifiBSSID;

// 解析错误信息并格式化输出
+ (NSString *)ResolveErrorType:(ErrorType)errorType andError:(NSError *)error;
+ (NSString *)ResolveErrorType:(ErrorType)errorType;
+ (void)SaveNSError:(NSError *)error;

// UIView(UILabel、UITextField、UITextView)上显示HTML
// 只能显示HTML内容，但不能点击链接
+ (void)LayoutHtmlString:(NSString *)htmlString onView:(UIView *)view;
// 根据正则表达式设置attributedString的各项参数
//  regular: 正则表达式
//  attributes: 每个满足ragular的attri
+ (void)FillMutableAttributedString:(NSMutableAttributedString *)attributedString byRegular:(NSRegularExpression *)regular attributes:(NSDictionary *)attributes;
@end


//--------------------------------------
//  设置全局参数
//--------------------------------------
@interface YSCManager (Config)
+ (void)ConfigNavigationBar;
+ (void)ConfigPullToBack;
+ (void)RegisterForRemoteNotification;
@end


//--------------------------------------
//  格式化数据
//--------------------------------------
@interface YSCManager (Format)
// 常用的价格字符串格式化方法（默认：显示￥、显示小数点）
+ (NSString *)FormatPrice:(NSNumber *)price;
// 常用的价格字符串格式化方法（默认：显示￥、显示小数点、显示元）
+ (NSString *)FormatPriceWithUnit:(NSNumber *)price;
+ (NSString *)FormatPrice:(NSNumber *)price showMoneyTag:(BOOL)isTagUsed showDecimalPoint:(BOOL) isDecimal useUnit:(BOOL)isUnitUsed;
//规范化：如果有小数点才显示两位，否则就不显示小数点
+ (NSString *)FormatNumberValue:(NSNumber *)value;
+ (NSString *)FormatFloatValue:(CGFloat)value;
// 规范化mac地址 xx:xx:xx:xx:xx:xx
+ (NSString *)FormatMacAddress:(NSString *)macAddress;
// 格式化输出json到console(格式化失败返回empty)
+ (NSString *)FormatPrintJsonStringOnConsole:(NSString *)jsonString;
@end


//--------------------------------------
//  Sqlite操作
//--------------------------------------
@interface YSCManager (Sqlite)
+ (BOOL)SqliteUpdate:(NSString *)sql;
+ (BOOL)SqliteUpdate:(NSString *)sql dbPath:(NSString *)dbPath;
+ (BOOL)SqliteCheckIfExists:(NSString *)sql;
+ (BOOL)SqliteCheckIfExists:(NSString *)sql dbPath:(NSString *)dbPath;
+ (int)SqliteGetRows:(NSString *)sql;
+ (int)SqliteGetRows:(NSString *)sql dbPath:(NSString *)dbPath;
@end


//--------------------------------------
//  打开设置里面的某个功能页面
//--------------------------------------
@interface YSCManager (Setting)
// 打开 设置->隐私
+ (void)OpenPrivacyOfSetting;
@end



//--------------------------------------
//  Request
//--------------------------------------
@interface YSCManager (Request)
//格式化所有提交的参数
+ (NSDictionary *)FormatRequestParams:(NSDictionary *)params;
//对参数进行签名
+ (NSString *)SignatureWithParams:(NSDictionary *)params;
//组装httpheader的加密token
+ (NSString *)EncryptHttpHeaderToken;
//对postBody参数进行加密
+ (NSString *)EncryptPostBodyParam:(NSString *)bodyParam;
//解析接口返回的数据
+ (NSString *)ResolveResponseObject:(id)responseObject;
@end


