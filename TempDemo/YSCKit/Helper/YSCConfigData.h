//
//  YSCConfigData.h
//  KanPian
//
//  Created by 杨胜超 on 16/4/8.
//  Copyright © 2016年 SMIT. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  YSCKit基础框架所有的配置参数类
 */

#define YSCConfigDataInstance               [YSCConfigData sharedInstance]


@interface YSCConfigData : NSObject
+ (instancetype)sharedInstance;

//=========================================================================
// 属性开关
//=========================================================================
#pragma mark - 全局开关
/** 是否通过数据连接下载图片 */
@property (nonatomic, assign) BOOL isDownloadImageViaWWAN;
/** 是否可以激活debugMode*/
@property (nonatomic, assign) BOOL isDebugModeAvailable;
/** 是否处于测试模式 */
@property (nonatomic, assign) BOOL isDebugMode;
/** 是否可以输出log */
@property (nonatomic, assign) BOOL isOutputLog;
/** 是否启用httpHeader的signature变量 */
@property (nonatomic, assign) BOOL isUseHttpHeaderSignature;
/** 是否启用httpHeader的httpToken变量 */
@property (nonatomic, assign) BOOL isUseHttpHeaderToken;
/** 是否自动取消之前未完成的网络请求 */
@property (nonatomic, assign) BOOL isAutoCancelTheLastSameRequesting;


#pragma mark - 相对布局
/** xib布局宽度(默认750point) */
@property (nonatomic, assign) CGFloat xibWidth;
/** 用于计算缩放比例(只能初始化一次！否则会导致旋转后屏幕计算不正确) */
@property (nonatomic, assign) CGFloat screenWidth;
/** 缩放比例 (当前屏幕的真实宽度point / xib布局的宽度point) 程序启动后必须固定的参数，防止在旋转后计算不正确 */
@property (nonatomic, assign) CGFloat autoLayoutScale;


#pragma mark - app属性
/**  */
@property (nonatomic, strong) NSString *appStoreId;
/** app发布的渠道(默认AppStore) */
@property (nonatomic, strong) NSString *appChannel;
/** app的版本号(三位数如1.0.1) */
@property (nonatomic, strong) NSString *appShortVersion;
/** 编译号(一位数如3) */
@property (nonatomic, strong) NSString *appBundleVersion;
/** 产品版本(如1.0.1 (15)) */
@property (nonatomic, strong) NSString *appVersion;
/** com.builder.app */
@property (nonatomic, strong) NSString *appBundleIdentifier;
/** 定义正式环境配置文件 */
@property (nonatomic, strong) NSString *appConfigPlistName;
/** 定义测试环境配置文件 */
@property (nonatomic, strong) NSString *appConfigDebugPlistName;


#pragma mark - 设置默认颜色
/** app默认主色 */
@property (nonatomic, strong) UIColor *defaultColor;
/** self.view的默认背景颜色 */
@property (nonatomic, strong) UIColor *defaultViewColor;
/** 默认边框颜色 */
@property (nonatomic, strong) UIColor *defaultBorderColor;
/** 默认占位字符颜色 */
@property (nonatomic, strong) UIColor *defaultPlaceholderColor;
/** 默认图片背景色 */
@property (nonatomic, strong) UIColor *defaultImageBackColor;


#pragma mark - 设置默认图片名称及提示语
/** app默认图片名称 */
@property (nonatomic, strong) NSString *defaultImageName;
/** tipsview提示数据为空的icon */
@property (nonatomic, strong) NSString *defaultEmptyImageName;
/** tipsview发生错误的icon */
@property (nonatomic, strong) NSString *defaultErrorImageName;
/** tipsview请求超时的icon */
@property (nonatomic, strong) NSString *defaultTimeoutImageName;
/** 导航栏返回按钮默认图片名称 */
@property (nonatomic, strong) NSString *defaultBackButtonImageName;
/** app默认导航栏背景图片名称 */
@property (nonatomic, strong) NSString *defaultNaviBackgroundImageName;
/** 上拉加载更多没有数据的提示语 */
@property (nonatomic, strong) NSString *defaultNoMoreMessage;
/** tipsview数据为空的默认提示语 */
@property (nonatomic, strong) NSString *defaultEmptyMessage;
/** 默认分页起始页码 */
@property (nonatomic, assign) NSInteger defaultPageStartIndex;
/** 默认分页每页的条数 */
@property (nonatomic, assign) NSInteger defaultPageSize;
/** 网络连接超时时间(s) */
@property (nonatomic, assign) CGFloat defaultRequestTimeOut;


#pragma mark - 网络访问错误提示
/** 网络未连接：网络处于断开状态 -1009 == statusCode || -1004 == statusCode */
@property (nonatomic, strong) NSString *networkErrorDisconnected;
/** 服务器连接失败：statusCode == 200, 网络是正常的，服务器不可访问*/
@property (nonatomic, strong) NSString *networkErrorServerFailed;
/** 网络连接超时：statusCode == 1001 */
@property (nonatomic, strong) NSString *networkErrorTimeout;
/** 网络连接取消：0 == statusCode */
@property (nonatomic, strong) NSString *networkErrorCancel;
/** 网络连接失败：statusCode其它值 */
@property (nonatomic, strong) NSString *networkErrorConnectionFailed;
/** 创建网络连接失败 */
@property (nonatomic, strong) NSString *networkErrorRequesFailed;
/** 网络请求的URL不合法 */
@property (nonatomic, strong) NSString *networkErrorURLInvalid;
/** 返回数据为空 */
@property (nonatomic, strong) NSString *networkErrorReturnEmptyData;
/** 数据映射本地模型失败 */
@property (nonatomic, strong) NSString *networkErrorDataMappingFailed;
/** 数据获取中 */
@property (nonatomic, strong) NSString *networkErrorRequesting;


//=========================================================================
// 缓存属性至运行时配置文件
//=========================================================================
- (void)saveIsDownloadImageViaWWAN:(BOOL)isDownloadImageViaWWAN;
- (void)saveIsDebugMode:(BOOL)isDebugMode;
- (void)saveIsOutputLog:(BOOL)isOutputLog;

// 存取运行时配置文件的通用方法
- (void)saveValue:(NSObject *)value toLocalConfigByName:(NSString *)name;
- (NSObject *)getLocalConfigValueByName:(NSString *)name;

//=========================================================================
// 管理配置文件里的参数
//=========================================================================
/** 重置参数键值对*/
- (void)resetConfigParams;
/** 缓存至内存中，方便快速读取 */
- (void)saveObject:(NSObject *)object toMemoryByName:(NSString *)name;

- (BOOL)boolFromConfigByName:(NSString *)name;
- (float)floatFromConfigByName:(NSString *)name;
- (NSInteger)intFromConfigByName:(NSString *)name;
- (UIColor *)colorFromConfigByName:(NSString *)name;
- (UIImage *)imageFromConfigByName:(NSString *)name;
- (NSString *)stringFromConfigByName:(NSString *)name;
@end
