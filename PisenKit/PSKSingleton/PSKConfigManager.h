//
//  PSKConfigManager.h
//  PisenKit
//
//  Created by 杨胜超 on 16/6/29.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PSKConfigManagerInstance            [PSKConfigManager sharedInstance]
// 自动布局相关代码段简写
#define AUTOLAYOUT_LENGTH(x)                ((x) * PSKConfigManagerInstance.autoLayoutScale)       //计算缩放后的大小point
#define AUTOLAYOUT_LENGTH_W(x,w)            ((x) * (PSKConfigManagerInstance.screenWidth / (w)))   //计算任意xib布局的真实大小point
#define AUTOLAYOUT_FONT(f)                  [UIFont systemFontOfSize:AUTOLAYOUT_LENGTH(f)]
#define AUTOLAYOUT_FONT_W(f,w)              [UIFont systemFontOfSize:AUTOLAYOUT_LENGTH_W(f,w)]

#define AUTOLAYOUT_SIZE_WH(w,h)             CGSizeMake(AUTOLAYOUT_LENGTH(w), AUTOLAYOUT_LENGTH(h))
#define AUTOLAYOUT_SIZE(s)                  AUTOLAYOUT_SIZE_WH(s.width, s.height)
#define AUTOLAYOUT_EDGEINSETS_TLBR(t,l,b,r) UIEdgeInsetsMake(AUTOLAYOUT_LENGTH(t), AUTOLAYOUT_LENGTH(l), AUTOLAYOUT_LENGTH(b), AUTOLAYOUT_LENGTH(r))
#define AUTOLAYOUT_EDGEINSETS(e)            AUTOLAYOUT_EDGEINSETS_TLBR(e.top, e.left, e.bottom, e.right)
#define AUTOLAYOUT_RECT_XYWH(x,y,w,h)       CGRectMake(AUTOLAYOUT_LENGTH(x), AUTOLAYOUT_LENGTH(y), AUTOLAYOUT_LENGTH(w), AUTOLAYOUT_LENGTH(h))
#define AUTOLAYOUT_RECT(r)                  AUTOLAYOUT_RECT_XYWH(r.origin.x, r.origin.y, r.size.width, r.size.height)

//=========================================================================
//
//  PisenKit所有的配置参数类
//
//=========================================================================
@interface PSKConfigManager : NSObject
+ (instancetype)sharedInstance;

/** 在线参数是否改动了 */
@property (nonatomic, assign) BOOL isOnlineParamsChanged;
#pragma mark - 全局开关
/** 是否通过数据连接下载图片 */
@property (nonatomic, assign) BOOL isDownloadImageViaWWAN;
/** 是否可以激活debugModel(在线参数值只有在on sale状态之前有效！on sale状态之后固定为NO) */
@property (nonatomic, assign) BOOL isDebugModelAvailable;
/** 是否处于测试模式(不检测在线参数) */
@property (nonatomic, assign) BOOL isDebugModel;
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
/** AppStore上线后的唯一编号 */
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

#pragma mark - 常用正则表达式
/** 电话号码(座机+手机) */
@property (nonatomic, strong) NSString *regexPhone;
/** 手机号码 */
@property (nonatomic, strong) NSString *regexMobilePhone;
/** 电子邮件 */
@property (nonatomic, strong) NSString *regexEmail;
/** 网页地址 */
@property (nonatomic, strong) NSString *regexWebUrl;

// 缓存属性至运行时配置文件
- (void)saveIsDownloadImageViaWWAN:(BOOL)isDownloadImageViaWWAN;
- (void)saveIsDebugModel:(BOOL)isDebugModel;

// 存取运行时配置文件的通用方法
- (void)saveValue:(NSObject *)value toLocalConfigByName:(NSString *)name;
- (NSObject *)getLocalConfigValueByName:(NSString *)name;

// 管理配置文件里的参数
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
