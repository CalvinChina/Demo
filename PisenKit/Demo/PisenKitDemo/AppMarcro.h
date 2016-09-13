//
//  AppMarcro.h
//  PisenKit
//
//  Created by 杨胜超 on 16/7/5.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#ifndef AppMarcro_h
#define AppMarcro_h

/** 定义默认值 */
#define kDefaultBlackColor              RGB_GRAY(102)           //黑色
#define kDefaultBlueColor               RGB(106, 202, 249)      //蓝色
#define kDefaultBlueColor1              RGB(24, 167, 244)       //蓝色
#define kDefaultBlueColor2              RGB(103, 191, 250)      //蓝色
#define kDefaultBlueColor3              RGB(84, 149, 253)       //蓝色
#define kDefaultBlueColor4              RGB(47, 176, 249)       //蓝色
#define kDefaultBlueColor5              RGB(0, 162, 227)        //蓝色
#define kDefaultGrayColor               RGB_GRAY(204)           //灰色
#define kDefaultGrayColor1              RGB_GRAY(240)           //灰色
#define kDefaultGrayColor2              RGB_GRAY(153)           //灰色
#define kDefaultGrayColor3              RGB(245, 248, 249)      //灰色
#define kDefaultOrangeColor             RGB(251, 130, 41)       //橘色
#define kDefaultOrangeColor1            RGB(235, 92, 6)         //橘色
#define kDefaultOrangeColor2            RGB(253, 153, 95)       //橘色

/** 获取配置信息 */
#define kPathDomain                     @"http://test.api.piseneasy.com:9212"
#ifdef kPathAppBaseUrl
    #undef kPathAppBaseUrl
#endif
#define kPathAppBaseUrl                 [kPathDomain stringByAppendingString:@"/Router/Rest/Post"]
#define kKanPianAppKey                  @"16031014"
#define kKanPianAppSecret               @"a674125b391e4b09ae6734aaf5475458"
#define kPathVitamio                    @"http://ps.api.ip008.com"



/** 定义接口地址 */
static NSString * const kMethodSearchPromptList         = @"KanPian.Service.Contract.IApplicationService.SearchPromptList";
static NSString * const kMethodSearch                   = @"KanPian.Service.Contract.IApplicationService.Search";

/** 定义接口参数名称 */
static NSString * const kParamCoverUrl                  = @"coverUrl";
static NSString * const kParamPlayUrl                   = @"playUrl";
static NSString * const kParamPlayUrls                  = @"playUrls";
static NSString * const kParamPlayName                  = @"playName";
static NSString * const kParamFileId                    = @"fileId";
static NSString * const kParamProgramId                 = @"programId";
static NSString * const kParamProgramType               = @"programType";
static NSString * const kParamEpisode                   = @"episode";
static NSString * const kParamWebsite                   = @"website";

#pragma mark - 影片四种类型在服务器上对应的编号

static NSInteger const kFilmTypeMovie = 10;
static NSInteger const kFilmTypeSeries = 20;
static NSInteger const kFilmTypeEntertainment = 30;
static NSInteger const kFilmTypeCartoon = 40;
static NSInteger const kFilmTypeExpressNews = 50;

#pragma mark - ViewController应用的类名，可以通过类名直接跳转界面，减少控制器之间的耦合

static NSString * const kRouteSiftViewController = @"SiftViewController";

#pragma mark - 通知的name
static NSString * const kNotifyApplicationSpotlight          = @"kNotifyApplicationSpotlight";
static NSString * const kNotifyFilmsPlayCacheListChanged     = @"kNotifyFilmsPlayCacheListChanged";
static NSString * const kNotifyFilmsDownloadCacheListChanged = @"kNotifyFilmsDownloadCacheListChanged";
static NSString * const kNotifyApplicationRate               = @"kNotifyApplicationRate";
static NSString * const kNotifyApplicationToday              = @"kNotifyApplicationToday";
static NSString * const kNotifyReplayFromToday               = @"kNotifyReplayFromToday";
static NSString * const kNotifyReplayFromSearch              = @"kNotifyReplayFromSearch";
static NSString * const kNotifyShowPlayer                    = @"kNotifyShowPlayer";

#endif /* AppMarcro_h */
