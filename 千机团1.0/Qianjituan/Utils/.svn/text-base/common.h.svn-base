//
//  common.h
//  路由器webDav版
//
//  Created by PDZ-YF3B-P10001 on 14-3-10.
//  曾必兴2014-0603：添加函数注释
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "UIDevice-Hardware.h"

@interface common : NSObject


/**
 * @param Base64加密
 * @brief
 * @return 密文（NSString）
 */
+ (NSString *)encodeUseBase64:(NSString *)text;

/**
 *  @brief Base64解密
 *  @return  解密的明文（NSString）
 */
+ (NSString *)decodeUseBase64:(NSString *)text;

/**
 * @brief DES加密
 * @return 密文（NSString）
 */
+ (NSString*) encryptUseDES:(NSString *)plainText key:(NSString *)key;


//获取文件属性
//filePath:文件路径
//return:属性字典
+ (NSDictionary *)getAttrDic:(NSString *)filePath;

//删除文件
//localName:文件路径名
//return:yes 操作成功, no 失败
+ (BOOL)deleteLocalFile:(NSString *)localName;

//移动文件到新的路径
//srcPath:原始文件路径
//dsrPath:目标路径
//return:yes 操作成功, no 失败
+ (BOOL)moveLocalFile:(NSString *)srcPath toPath:(NSString *)dstPath;

//复制文件到新的路径
//srcPath:原始文件路径
//dsrPath:目标路径
//return:yes 操作成功, no 失败
+ (BOOL)copyLocalFile:(NSString *)srcPath toPath:(NSString *)dstPath;

//根据文件后缀，返回对应的子图标
//str:后缀
//return:图片地址
+ (UIImage *)getSubIconByEx:(NSString*)str;

//判断文件名是否有效
//fileName:文件名
//retyrn:yes 有效, no无效
+ (BOOL)IsValidFileName:(NSString *)fileName;

//获取路由u盘可用状态
//isShowAlert:是否现实提示框
//return:yes 可以操作文件, no 不能进行文件操作
+ (BOOL)getRouterFileState:(BOOL)isShowAlert;

//返回和ios4的屏幕差距
+ (CGFloat)getIos4OffsetY;

//判断是否为空串
//text:输入字符
//return:yes:为kong,no:不为空
+ (BOOL)isInputTextNull:(NSString*)text;

//判断链接是否可用
//url:输入地址
//return:yes:可用,no:无效
+ (BOOL)checkResourceIsReachable:(NSString *)url;

//弹出图片浏览控件
//view:视图指针
//photos:图片数组
//index:起始索引
//return:MWPhotoBrowser指针
+ (id)showMWPhotoBrowser:(UIViewController *)view data:(NSMutableArray *)photos photoIndex:(NSInteger)index showToolbar:(BOOL)bShow;

//按时间排列格式转换
//dateString:时间字符
//return:时间对象
+ (NSDate *)dateFromString:(NSString *)dateString;

//按时间排列格式转换毫秒级
//dateString:时间字符
//return:时间对象
+ (NSDate *)dateFromStringSSS:(NSString *)dateString;

//按时间排列格式转换
//dateString:时间字符
//return:时间对象
+ (NSString *)stringFromDate:(NSDate *)date;

//压缩图片质量
//image:原图
//tranSize:压缩目标大小
//return:压缩后的图片
+ (UIImage *)decodedImageWithImage:(UIImage *)image size:(CGSize)tranSize;

//Photoshop颜色值转换
+ (UIColor *)rgbColor:(char*)color alpha:(float)value;

//显示提示框
+ (void)showCustomAlertView:(UIView *)alertView withString:(NSString *)showStr inBackView:(UIView *)backView;

//判断是否是企业证书证书app
//return:yes是企业证书，no个人证书
+ (BOOL)isEnterpriseApp;

//md5转码
//input:原始地址
//return:md5字符
+ (NSString*)md5HexDigest:(NSString*)input;

//返回机器硬件版本
+ (UIDevicePlatform)getDevicePlatform;

//返回相机授权
//return:yes是授权，no未授权
+ (BOOL) cameraInvalid;

//返回相册授权
//return:yes是授权，no未授权
+ (BOOL) photosAlbumInvalid;

//查询本机ip地址
+ (NSString *)getIPAddress;

//返回是否支持的文件类型
//extension:文件后缀
//return:yes是支持，no不支持
+ (BOOL) isSupportFileType:(NSString*)extension;

//xocde6以后每次启动程序uid都会改变
+ (NSString*)getChangeSysPath:(NSString*)path;

+ (void)updateAlertView:(NSString *)alertStr onView:(UIView *)backView;

+(UIImage*) MyCreateThumbnailImageFromData:(NSData*)data size:(NSInteger)imageSize;

+(NSString*) getNoExitFileName:(NSString*)tagName path:(NSString*)directory;

+ (id) fetchBSSIDInfoMac;

+(id) fetchSSIDInfoMac;
/**MD5加密*/
+ (NSString *)md5OfString:(NSString *)beEncryptedStr offsetStr:(NSString *)offsetStr;

/**
 *  date 格式化为string
 *
 *  @param date    待转化的时间
 *  @param formate 转化格式
 *
 *  @return 转化后的字符串
 */
+ (NSString*) stringFromFomate:(NSDate*)date formate:(NSString*)formate;

/**
 *  string 格式化为 date
 *
 *  @param datestring 需要转化的字符串
 *  @param formate    时间格式
 *
 *  @return 转化后的时间
 */
+ (NSDate *) dateFromFomate:(NSString *)datestring formate:(NSString*)formate;

+ (CGRect) getScreenRect;

+ (void) transformViewByKeyWindows:(UIView*)view tag:(UIView*)toView;

+ (BOOL) IsPad;

+ (NSString *)sizeString:(NSString *)sizeStr;

+ (NSString *)getAppVersion;

+ (void)commonPlayMovie:(NSURL *)movieURL isMusic:(BOOL)bIsMusic;

+ (long long) fileSizeAtPath:(NSString*) filePath;

+ (UIImage*)getFriendHead:(NSString*)index;

+ (NSString*)getHeadString;

/**
 *  正则判断ip是否合法
 */
+ (BOOL)isValidateIP:(NSString *)ipStr;

/**
 *  正在判读密码是否合法
 *
 *  @param pwdStr 输入密码
 *
 *  @return YES合法 NO非法
 */
+ (BOOL)isValidatePwd:(NSString *)pwdStr;

+ (void)PlaySound;

//图片缩略图剪切
+ (UIImage*)getSubImage:(CGRect)rect inputImg:(UIImage *)img;

//用其他方式打开
+ (UIDocumentInteractionController *) setupControllerWithURL:(NSString *)filePath presentInView:(UIView *)view;

//验证码变形
+ (void)generateCode:(NSString *)inputText onLabel:(UILabel *)lbl;
//获取随机两位字符串
+(NSString *)catchStringByRandom;

@end
