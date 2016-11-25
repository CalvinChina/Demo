//
//  YSCSNSShareData.h
//  YSCKit
//
//  Created by yangshengchao on 16/1/28.
//  Copyright © 2016年 YingChuangKeXun. All rights reserved.
//


/**
 *  第三方分享单例类
 *  作用：封装第三方分享业务逻辑
 *  TODO:第三方平台分享需要解耦UMeng(用钩子函数截获第三方app的交互参数)
 */

#define YSCSNSInstance          [YSCSNSShareData SharedInstance]

typedef NS_ENUM(NSInteger, YSCShareType) {
    YSCShareTypeWeiboSina = 1,     //新浪微博(分享+登录)
    YSCShareTypeMobileQQ = 2,      //手机QQ(登录)
    YSCShareTypeWeiXin = 3,        //微信(登录)
    YSCShareTypeAlipay,            //暂时没有用!
    YSCShareTypeWeiboTencent,      //腾讯微博(分享)
    YSCShareTypeQQZone,            //QQ空间(分享)
    YSCShareTypeWechatSession,     //微信好友(分享)
    YSCShareTypeWechatTimeline,    //微信朋友圈(分享)
    YSCShareTypeWechatFavorite,    //微信收藏(分享)
};

@interface YSCSNSShareData : NSObject
+ (instancetype)SharedInstance;
+ (BOOL)IsOauthAndTokenNotExpired:(YSCShareType)shareType;

// 兼容分享到多个平台
- (void)shareWithContent:(NSString *)content
                   image:(UIImage *)image
              shareTypes:(NSArray *)shareTypes
                     url:(NSString *)url
     presentedController:(UIViewController *)viewController
              completion:(YSCObjectBlock)completion;
@end
