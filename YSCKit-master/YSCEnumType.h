//
//  YSCEnumType.h
//  YSCKit
//
//  Created by yangshengchao on 15/8/27.
//  Copyright (c) 2015年 Builder. All rights reserved.
//

#ifndef YSCKit_YSCEnumType_h
#define YSCKit_YSCEnumType_h

//检测新版本的几种方法
typedef NS_ENUM(NSInteger, CheckNewVersionType) {
    CheckNewVersionTypeNone         = 0,//关闭更新功能
    CheckNewVersionTypeServer       = 1,//后台接口
    CheckNewVersionTypeAppStore     = 2,//直接检测AppStore是否有新版本上线
};

//错误类型定义
typedef NS_ENUM(NSInteger, ErrorType) {
    //网络层错误
    ErrorTypeDisconnected           = 10,//网络处于断开状态(访问网络之前)
    ErrorTypeConnectionFailed       = 11,//网络错误(网络访问过程中statusCode != 200)
    ErrorTypeServerFailed           = 12,//服务器错误(statusCode == 200, 服务器不可访问)
    ErrorTypeInternalServer         = 13,//服务器内部错误(需要进一步解析dataModel.state 和 message)
    
    //合法性判断错误
    ErrorTypeCopyFileFailed         = 100,//拷贝文件出错
    ErrorTypeURLInvalid             = 101,//url非法
    ErrorTypeDataEmpty              = 102,//返回数据为空
    ErrorTypeDataMappingFailed      = 103,//数据映射出错
    
    //业务层错误
    ErrorTypeLoginExpired           = 200,//登录过期
};

typedef NS_ENUM(NSInteger, ShareType) {
    ShareTypeWeiboSina = 1,     //新浪微博(分享+登录)
    ShareTypeMobileQQ = 2,      //手机QQ(登录)
    ShareTypeWeiXin = 3,        //微信(登录)
    ShareTypeAlipay,            //暂时没有用!
    ShareTypeWeiboTencent,      //腾讯微博(分享)
    ShareTypeQQZone,            //QQ空间(分享)
    ShareTypeWechatSession,     //微信好友(分享)
    ShareTypeWechatTimeline,    //微信朋友圈(分享)
    ShareTypeWechatFavorite,    //微信收藏(分享)
};

typedef NS_ENUM(NSInteger, RegexType) {
    RegexTypeEmail          = 0,
    RegexTypeMobilePhone,
    RegexTypeUserName,
    RegexTypePassword,
    RegexTypeNickName,
    RegexTypeIdentityCard,
    RegexTypeAllNumbers
};

typedef NS_ENUM (NSInteger, RequestType) {
    RequestTypeGET = 0,
    RequestTypePOST,
    RequestTypePostBodyData,
    RequestTypeUploadFile,
    RequestTypeDownloadFile,
    RequestTypeCustomResponse       //数据来源不是YSCRequestManager
};

typedef NS_ENUM(NSInteger, AudioType) {
    AudioTypeStart = 0,
    AudioTypeMoreItem,
    AudioTypePanicSuccess,
    AudioTypeMore,
    AudioTypeMenuOpen,
    AudioTypeMenuClose,
    AudioTypeShare,
    AudioTypeHeartbeat,
    AudioTypePush,
    AudioTypeAddAlert
};

typedef NS_ENUM(NSInteger, VersionCompareResult) {
    VersionCompareResultAscending = -1,
    VersionCompareResultSame = 0,
    VersionCompareResultDescending = 1
};

/*  图片质量
 *  高质量：原图
 *  中等质量：原图大小的70%。最小宽度：480 最大宽度：720
 *  低质量：原图大小的50%。最小宽度：320 最大宽度：480
 */
typedef NS_ENUM(NSInteger, ImageQuality) {
    ImageQualityLow = 0,        //低质量图片
    ImageQualityNormal = 1,     //中等质量图片
    ImageQualityHigh = 2,       //高质量图片
    ImageQualityAuto = 10       //根据网络自动选择图片质量
};

typedef NS_ENUM(NSInteger, BackType) {
    BackTypeDefault = 0,
    BackTypeImage,
    BackTypeSliding,
    BackTypeDismiss NS_DEPRECATED_IOS(2_0, 3_0)
};

#endif /* YSCKit_YSCEnumType_h */
