//
//  YSCSNSShareData.m
//  YSCKit
//
//  Created by yangshengchao on 16/1/28.
//  Copyright © 2016年 YingChuangKeXun. All rights reserved.
//

#import "YSCSNSShareData.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentApiInterface.h>

//Umeng
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"

@interface YSCSNSShareData ()<UMSocialUIDelegate>
@property (nonatomic, copy) YSCObjectBlock completion;
@end
@implementation YSCSNSShareData
+ (instancetype)SharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^ {
        return [[self alloc] init];
    })
}
+ (BOOL)IsOauthAndTokenNotExpired:(YSCShareType)shareType {
    NSString *platformName = [YSCSNSInstance _PlatformTypeOfUMeng:shareType];
    return [UMSocialAccountManager isOauthAndTokenNotExpired:platformName];
}
- (NSString *)_PlatformTypeOfUMeng:(YSCShareType)shareType {
    NSString *platformName = nil;
    if (YSCShareTypeWeiboSina == shareType) {
        platformName = UMShareToSina;
    }
    else if (YSCShareTypeWeiboTencent == shareType) {
        platformName = UMShareToTencent;
    }
    else if (YSCShareTypeWechatSession == shareType || YSCShareTypeWeiXin == shareType) {
        platformName = UMShareToWechatSession;
    }
    else if (YSCShareTypeWechatTimeline == shareType) {
        platformName = UMShareToWechatTimeline;
    }
    else if (YSCShareTypeWechatFavorite == shareType) {
        platformName = UMShareToWechatFavorite;
    }
    else if (YSCShareTypeMobileQQ == shareType) {
        platformName = UMShareToQQ;
    }
    else if (YSCShareTypeQQZone == shareType) {
        platformName = UMShareToQzone;
    }
    
    return platformName;
}

- (void)shareWithContent:(NSString *)content
                   image:(UIImage *)image
              shareTypes:(NSArray *)shareTypes
                     url:(NSString *)url
     presentedController:(UIViewController *)viewController
              completion:(YSCObjectBlock)completion {
    self.completion = completion;
    NSMutableArray *umengPlatforms = [NSMutableArray array];
    for (NSNumber *platform in shareTypes) {
        YSCShareType shareType = [platform integerValue];
        NSString *umengPlatformName = [self _PlatformTypeOfUMeng:shareType];
        if ((YSCShareTypeWechatSession == shareType ||
             YSCShareTypeWechatTimeline == shareType ||
             YSCShareTypeWechatFavorite == shareType) &&
            [WXApi isWXAppInstalled]) {
            if (YSCShareTypeWechatSession == shareType) {
                [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
            }
            else if (YSCShareTypeWechatTimeline == shareType) {
                [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
            }
            [umengPlatforms addObject:umengPlatformName];
        }
        //分享到QQ空间必须同时设置文本和图片
        else if (YSCShareTypeQQZone == shareType && OBJECT_ISNOT_EMPTY(content) && OBJECT_ISNOT_EMPTY(image) &&
                 ([TencentApiInterface isTencentAppInstall:kIphoneQQ] || [TencentApiInterface isTencentAppInstall:kIphoneQZONE])) {
            [umengPlatforms addObject:umengPlatformName];
        }
        else if (YSCShareTypeMobileQQ == shareType && [TencentApiInterface isTencentAppInstall:kIphoneQQ]) {
            [umengPlatforms addObject:umengPlatformName];
        }
        else if (YSCShareTypeWeiboSina == shareType) {
            [umengPlatforms addObject:umengPlatformName];
        }
    }
    if (1 == [umengPlatforms count]) {//只有一个分享平台就直接打开
        [YSCHUDManager showHUDThenHideOnView:[UIApplication sharedApplication].keyWindow message:@"正在分享中" afterDelay:3];
        UMSocialUrlResource *urlResource = nil;
        if (OBJECT_ISNOT_EMPTY(url)) {
            urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:url];
        }
        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[umengPlatforms[0]]
                                                           content:content
                                                             image:image
                                                          location:nil
                                                       urlResource:urlResource
                                               presentedController:viewController
                                                        completion:^(UMSocialResponseEntity *response) {
                                                            NSString *errorMessage = nil;
                                                            if (UMSResponseCodeSuccess == response.responseCode) {
                                                                errorMessage = @"分享成功";
                                                            }
                                                            else if (UMSResponseCodeCancel == response.responseCode) {
                                                                errorMessage = @"取消分享";
                                                                [YSCHUDManager hideHUDOnKeyWindow];
                                                            }
                                                            else {
                                                                errorMessage = [NSString stringWithFormat:@"分享失败(%d)", response.responseCode];
                                                                [YSCHUDManager hideHUDOnKeyWindow];
                                                            }
                                                            [YSCHUDManager showHUDThenHideOnKeyWindowWithMessage:errorMessage];
                                                            
                                                            if (completion) {
                                                                completion(response);
                                                            }
                                                        }];
    }
    else if ([umengPlatforms count] > 1) {//超过一个分享平台需要弹出选择框
        [UMSocialSnsService presentSnsIconSheetView:viewController
                                             appKey:[UMSocialData appKey]
                                          shareText:content
                                         shareImage:image
                                    shareToSnsNames:umengPlatforms
                                           delegate:self];
    }
    else {
        if (completion) {
            completion(nil);
        }
        [YSCAlertManager showAlertViewWithMessage:@"请先安装要分享的平台APP"];
    }
}

#pragma mark - UMSocialUIDelegate
// 配置点击分享列表后是否弹出分享内容编辑页面，再弹出分享，默认需要弹出分享编辑页面
- (BOOL)isDirectShareInIconActionSheet {
    return YES;
}
//各个页面执行授权完成、分享完成、或者评论完成时的回调函数
- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response {
    NSString *errorMessage = nil;
    if (UMSResponseCodeSuccess == response.responseCode) {
        errorMessage = @"分享成功";
    }
    else if (UMSResponseCodeCancel == response.responseCode) {
        errorMessage = @"取消分享";
    }
    else {
        errorMessage = [NSString stringWithFormat:@"分享失败(%d)", response.responseCode];
    }
    [YSCHUDManager showHUDThenHideOnKeyWindowWithMessage:errorMessage];
    if (self.completion) {
        self.completion(response);
    }
}
@end
