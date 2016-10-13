//
//  YSCDefaults.h
//  YSCKit
//
//  Created by yangshengchao on 16/2/15.
//  Copyright © 2016年 Builder. All rights reserved.
//

#ifndef YSCKit_YSCDefaults_h
#define YSCKit_YSCDefaults_h

/**
 *  定义YSCKit中的默认变量
 */

//常量
#ifndef kLogManageType
    #define kLogManageType                  @"1"
#endif
#ifndef kDefaultTipsEmptyText
    #define kDefaultTipsEmptyText           @"暂无数据"
#endif
#ifndef kDefaultTipsEmptyIcon
    #define kDefaultTipsEmptyIcon           @"icon_empty"           //列表为空时的默认icon名称
#endif
#ifndef kDefaultTipsFailedIcon
    #define kDefaultTipsFailedIcon          @"icon_failed"          //列表加载失败时的默认icon名称
#endif
#ifndef kDefaultTipsButtonTitle
    #define kDefaultTipsButtonTitle         @"重新加载"              //列表加载失败、为空时的按钮名称
#endif
#ifndef kDefaultDuration
    #define kDefaultDuration                0.3f                    //默认动画时间
#endif
#ifndef kDefaultPageStartIndex
    #define kDefaultPageStartIndex          1                       //默认分页起始页码
#endif
#ifndef kDefaultPageSize
    #define kDefaultPageSize                10                      //默认分页每页的条数
#endif
#ifndef kDefaultRequestTimeOut
    #define kDefaultRequestTimeOut          18.0f                   //网络访问超时(s)
#endif

//颜色
#ifndef kDefaultViewColor
    #define kDefaultViewColor               RGB(238, 238, 238)      //self.view的默认背景颜色
#endif
#ifndef kDefaultColor
    #define kDefaultColor                   RGB(47, 152, 233)       //app默认主色(普通按钮+文本)
#endif
#ifndef kDefaultBorderColor
    #define kDefaultBorderColor             RGB(218, 218, 218)      //默认边框颜色
#endif
#ifndef kDefaultPlaceholderColor
    #define kDefaultPlaceholderColor        RGB(200, 200, 200)      //默认占位字符颜色
#endif
#ifndef kDefaultTipViewButtonColor
    #define kDefaultTipViewButtonColor      [UIColor redColor]      //默认【重新加载】按钮背景色
#endif
#ifndef kDefaultImageBackColor
    #define kDefaultImageBackColor          RGB(240, 240, 240)      //默认图片背景色
#endif
#ifndef kDefaultNaviBarTintColor
    #define kDefaultNaviBarTintColor        RGB(47, 152, 233)       //导航栏默认文字、icon的颜色
#endif
#ifndef kDefaultNaviBarTitleColor
    #define kDefaultNaviBarTitleColor       RGB(10, 10, 10)         //导航栏标题颜色
#endif
#ifndef kDefaultNaviBarItemColor
    #define kDefaultNaviBarItemColor        kDefaultNaviBarTintColor//导航栏左右文字颜色
#endif
#ifndef kDefaultNaviTintColor
    #define kDefaultNaviTintColor           RGBA(255, 255, 255, 1)  //系统导航栏背景颜色(包括了StatusBar)
#endif
#ifndef kDefaultCustomNaviTintColor
    #define kDefaultCustomNaviTintColor     RGB(234, 106, 84)       //自定义导航栏背景颜色(包括了StatusBar)
#endif
#ifndef kDefaultNaviBarTitleFont
    #define kDefaultNaviBarTitleFont        [UIFont boldSystemFontOfSize:AUTOLAYOUT_LENGTH(34)]    //导航栏标题字体大小
#endif
#ifndef kDefaultNaviBarItemFont
    #define kDefaultNaviBarItemFont         AUTOLAYOUT_FONT(28)     //导航栏左右文字大小
#endif
#ifndef kDefaultNaviBarSubTitleFont
    #define kDefaultNaviBarSubTitleFont     AUTOLAYOUT_FONT(26)     //导航栏副标题字体大小
#endif
#ifndef kDefaultNaviBarSubTitleColor
    #define kDefaultNaviBarSubTitleColor    kDefaultNaviBarTitleColor     //导航栏副标题字体颜色
#endif


//图片
#ifndef kDefaultAvatar
    #define kDefaultAvatar                  [UIImage imageNamed:@"default_avatar"]
#endif
#ifndef kDefaultImage
    #define kDefaultImage                   [UIImage imageNamed:@"default_image"]
#endif
#ifndef kDefaultMaleImage
    #define kDefaultMaleImage               [UIImage imageNamed:@"icon_gender_male"]
#endif
#ifndef kDefaultFemaleImage
    #define kDefaultFemaleImage             [UIImage imageNamed:@"icon_gender_female"]
#endif
#ifndef kDefaultNaviBarPopImage
    #define kDefaultNaviBarPopImage         [UIImage imageNamed:@"arrow_left_blue_11x21"]
#endif
#ifndef kDefaultNaviBarBackImage
    #define kDefaultNaviBarBackImage        [UIImage imageNamed:@"bg_navigationbar0"]
#endif


//代码段简写
#ifndef kDBRealPath
    #define kDBRealPath                     [[YSCFileManager DirectoryPathOfDocuments] stringByAppendingPathComponent:@"local_cache.sqlite"]
#endif
#ifndef isEmpty
    #define isEmpty(object) (object == nil \
                            || [object isKindOfClass:[NSNull class]] \
                            || ([object respondsToSelector:@selector(length)] && [(NSData *)object length] == 0) \
                            || ([object respondsToSelector:@selector(count)]  && [(NSArray *)object count] == 0))
#endif

#ifndef isNotEmpty
    #define isNotEmpty(object) (! isEmpty(object))
#endif

#ifndef WeakSelfType
    #define WeakSelfType __weak __typeof(&*self)
#endif

#ifndef WEAKSELF
    #define WEAKSELF WeakSelfType weakSelf = self;
#endif

#endif /* YSCKit_YSCDefaults_h */
