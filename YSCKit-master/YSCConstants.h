//
//  YSCConstants.h
//  YSCKit
//
//  Created by yangshengchao on 15/8/13.
//  Copyright (c) 2015年 Builder. All rights reserved.
//

#ifndef YSCKit_YSCConstants_h
#define YSCKit_YSCConstants_h

//定义通用的block
typedef void (^YSCBlock)();
typedef void (^YSCResultBlock)(NSObject *object);
typedef void (^YSCStringResultBlock)(NSString *string, NSError *error);
typedef void (^YSCBooleanResultBlock)(BOOL succeeded, NSError *error);
typedef void (^YSCFloatBlock)(CGFloat percentDone);
typedef void (^YSCIntegerResultBlock)(NSInteger number, NSError *error);
typedef void (^YSCIdResultBlock)(id object, NSError *error);
typedef void (^YSCObjectResultBlock)(NSObject *object, NSError *error);
typedef void (^YSCArrayResultBlock)(NSArray *objects, NSError *error);
typedef void (^YSCSetResultBlock)(NSSet *channels, NSError *error);
typedef void (^YSCDataResultBlock)(NSData *data, NSError *error);
typedef void (^YSCImageResultBlock)(UIImage *image, NSError *error);
typedef void (^YSCDictionaryResultBlock)(NSDictionary *dict, NSError *error);
typedef void (^YSCResponseErrorMessageBlock)(NSObject *object, NSString *errorMessage);


//时间格式常量
#define kDateFormat1                    @"yyyy-MM-dd HH:mm:ss"
#define kDateFormat2                    @"yyyy.MM.dd HH:mm"
#define kDateFormat3                    @"yyyy-MM-dd"
#define kDateFormat4                    @"yyyy.MM.dd"
#define kDateFormat5                    @"yyyy年M月d日"
#define kDateFormat6                    @"yyyy-MM-dd HH:mm"
#define kDateFormat7                    @"yyyy年M月d日 HH:mm"
#define kDateFormat8                    @"M月d日"
#define kDateFormat9                    @"yyyy年M月"
#define kDateFormat10                   @"yyyy-MM-dd ccc HH:mm"//2015-12-24 周四 11:32
#define kDateFormat11                   @"yyyy-MM-dd cccc HH:mm"//2015-12-24 星期四 11:32
#define kDateFormat20                   @"yyyy年M月d日 HH:mm:ss"
#define kDateFormat21                   @"HH:mm"
#define kDateFormat22                   @"MM月dd日 HH:mm"
#define kDateFormat23                   @"M月d日 HH:mm"


//字符串常量
#define kCachedUserModel                @"UserModel"
#define kCachedUserName                 @"UserName"
#define kCachedPassWord                 @"PassWord"
#define kCachedUserToken                @"UserToken"
#define kCellIdentifier                 @"Cell"
#define kFooterIdentifier               @"Footer"
#define kHeaderIdentifier               @"Header"
#define kItemCellIdentifier             @"ItemCell"             //UICollectionView要用的


//方法或属性过期标志
#define YSCDeprecated(explain) __attribute__((deprecated(explain)))


//控制调试信息的输出
#define DEBUGMODEL                      [YSCGetObject(@"DEBUG") boolValue]
#define SwitchToDebug                   YSCSaveObject(@(YES), @"DEBUG")
#define SwitchToNormal                  YSCSaveObject(@(NO), @"DEBUG")

//定义NSLog
#define __NSLog(s, ...) do { \
    NSString *logString = [NSString stringWithFormat:@"[%@(%d)] %@",[[NSString stringWithUTF8String:__FILE__] lastPathComponent],__LINE__,[NSString stringWithFormat:(s), ##__VA_ARGS__]]; \
    NSLog(@"%@", logString); \
    [YSCLogManager SaveLog:logString]; \
} while (0)

#define NSLog(...) __NSLog(__VA_ARGS__)


//单例
#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
static dispatch_once_t pred = 0; \
__strong static id _sharedObject = nil; \
dispatch_once(&pred, ^{ \
_sharedObject = block(); \
}); \
return _sharedObject;


/**
 *  代码段简写
 */
#define RGB(r, g, b)                                [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:1.0f]
#define RGBA(r, g, b, a)                            [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:a]
#define RGBHEX(hexstring)                           [UIColor colorWithHexString:[NSString replaceString:hexstring byRegex:@"[#]" to:@""]]
#define kDefaultColorRGB(c)                         RGB(c, c, c)
#define ViewInXib(_xibName, _index)                 [[[NSBundle mainBundle] loadNibNamed:(_xibName) owner:nil options:nil] objectAtIndex:(_index)]
#define FirstViewInXib(_xibName)                    ViewInXib(_xibName, 0)
#define NavigationViewController(x)                 [[UINavigationController alloc]initWithRootViewController:[[NSClassFromString(x) alloc] initWithNibName:nil bundle:nil]]
#define ViewController(x)                           [[NSClassFromString(x) alloc] initWithNibName:x bundle:nil]
#define KeyWindow                                   [UIApplication sharedApplication].keyWindow
#define FileDefaultManager                          [NSFileManager defaultManager]
#define ReturnWhenObjectIsEmpty(object)             if ([NSObject isEmpty:object]) { return ;    }
#define ReturnNilWhenObjectIsEmpty(object)          if ([NSObject isEmpty:object]) { return nil; }
#define ReturnEmptyWhenObjectIsEmpty(object)        if ([NSObject isEmpty:object]) { return @""; }
#define ReturnYESWhenObjectIsEmpty(object)          if ([NSObject isEmpty:object]) { return YES; }
#define ReturnNOWhenObjectIsEmpty(object)           if ([NSObject isEmpty:object]) { return NO;  }
#define ReturnZeroWhenObjectIsEmpty(object)         if ([NSObject isEmpty:object]) { return 0;  }
#define Trim(x)                                     [NSString trimString:x]
#define RandomInt(from,to)                          ((int)((from) + arc4random() % ((to)-(from) + 1)))  //随机数 [from,to] 之间
#define CreateNSErrorCode(c,errMsg)                 [NSError errorWithDomain:@"YSCKit" code:c userInfo:@{NSLocalizedDescriptionKey : Trim(errMsg)}]
#define CreateNSError(errMsg)                       CreateNSErrorCode(0,errMsg)
#define GetNSErrorMsg(e)                            ((NSError *)e).userInfo[NSLocalizedDescriptionKey]  //=e.localizedDescription
#define CURRENTDATE                                 YSCInstance.currentDate    //当前(服务器端)时间
#define AppUpdateUrl                                [@"https://itunes.apple.com/app/id" stringByAppendingString:kAppStoreId]//App升级url


/**
 *  版本相关
 */
#define AppVersion                      [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]//app的版本号(三位数如1.0.1)
#define BundleVersion                   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]    //内部小版本号(一位数如3)
#define ProductVersion                  [NSString stringWithFormat:@"%@ (%@)", AppVersion, BundleVersion]           //产品版本(1.0.1 (15))
#define BundleIdentifier                [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]
#define WelcomeVersion                  [NSString stringWithFormat:@"Welcome_V%@.%@", AppVersion, BundleVersion]
#define SkipVersion(x)                  [NSString stringWithFormat:@"SkipVersion_V%@", x]
#define VersionEqualsOrLater(v)         (NSOrderedAscending != [AppVersion compare:v options:NSNumericSearch])      //判断当前APP的版本号等于或大于v
#define VersionLater(v)                 (NSOrderedDescending == [AppVersion compare:v options:NSNumericSearch])     //判断当前APP的版本号大于v
#define VersionBefore(v)                (NSOrderedAscending == [AppVersion compare:v options:NSNumericSearch])      //判断当前APP的版本号小于v
#define IsLoadGuideView                 [YSCGetObject(WelcomeVersion) boolValue]                                       //判断是否加载过欢迎页面


/**
 *  判断设备的相关参数
 */
#define SYSTEM_VERSION_IS_8_0_X         ([[[UIDevice currentDevice] systemVersion] hasPrefix:@"8.0"])
#define IOS_VERSION                     ([[[UIDevice currentDevice] systemVersion] floatValue])
#define IOS7_OR_LATER                   __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
#define IOS8_OR_LATER                   (IOS_VERSION >= 8.0f)
#define IOS7_OR_EARLIER                 (IOS_VERSION < 8.0f)
#define SCREEN_WIDTH                    ([UIScreen mainScreen].bounds.size.width) //屏幕的宽度(point)
#define SCREEN_HEIGHT                   ([UIScreen mainScreen].bounds.size.height)//屏幕的高度(point)
#define STATUSBAR_HEIGHT                20.0f
#define NAVIGATIONBAR_HEIGHT            44.0f
#define TITLEBAR_HEIGHT                 64.0f       //等于STATUSBAR_HEIGHT + NAVIGATIONBAR_HEIGHT
#define TABBAR_HEIGHT                   49.0f
#define KEYBOARD_HEIGHT                 216.0f      //默认键盘高度
#define XIB_WIDTH                       640.0f      //xib布局时的宽度(point)，主要用于计算缩放比例


/**
 *  自动布局相关代码段简写
 */
#define AUTOLAYOUT_SCALE                (SCREEN_WIDTH / XIB_WIDTH)          //缩放比例 (当前屏幕的真实宽度point / xib布局的宽度point)
#define AUTOLAYOUT_LENGTH(x)            ((x) * AUTOLAYOUT_SCALE)            //计算缩放后的大小point
#define AUTOLAYOUT_LENGTH_W(x,w)        ((x) * (SCREEN_WIDTH / (w)))        //计算任意布局的真实大小point
#define AUTOLAYOUT_SIZE_WH(w,h)         CGSizeMake(AUTOLAYOUT_LENGTH(w), AUTOLAYOUT_LENGTH(h))
#define AUTOLAYOUT_SIZE(size)           CGSizeMake(AUTOLAYOUT_LENGTH(size.width), AUTOLAYOUT_LENGTH(size.height))//计算自动布局后的size
#define AUTOLAYOUT_EDGEINSETS(t,l,b,r)  UIEdgeInsetsMake(AUTOLAYOUT_LENGTH(t), AUTOLAYOUT_LENGTH(l), AUTOLAYOUT_LENGTH(b), AUTOLAYOUT_LENGTH(r))
#define AUTOLAYOUT_CGRECT(x,y,w,h)      CGRectMake(AUTOLAYOUT_LENGTH(x),AUTOLAYOUT_LENGTH(y),AUTOLAYOUT_LENGTH(w),AUTOLAYOUT_LENGTH(h))
#define AUTOLAYOUT_FONT(f)              ([UIFont systemFontOfSize:((f) * AUTOLAYOUT_SCALE)])
#define SCREEN_WIDTH_SCALE              (SCREEN_WIDTH / AUTOLAYOUT_SCALE)
#define SCREEN_HEIGHT_SCALE             (SCREEN_HEIGHT / AUTOLAYOUT_SCALE)


/**
 *  注册通知与发送通知
 */
#define addNObserver(_selector,_name)               ([[NSNotificationCenter defaultCenter] addObserver:self selector:_selector name:_name object:nil])
#define addNObserverWithObj(_selector,_name,_obj)   ([[NSNotificationCenter defaultCenter] addObserver:self selector:_selector name:_name object:_obj])
#define removeNObserver(_name)                      ([[NSNotificationCenter defaultCenter] removeObserver:self name:_name object:nil])
#define removeAllObservers(_self)                   ([[NSNotificationCenter defaultCenter] removeObserver:_self])
#define postN(_name)                                ([[NSNotificationCenter defaultCenter] postNotificationName:_name object:nil userInfo:nil])
#define postNWithObj(_name,_obj)                    ([[NSNotificationCenter defaultCenter] postNotificationName:_name object:(_obj) userInfo:nil])
#define postNWithInfo(_name,_info)                  ([[NSNotificationCenter defaultCenter] postNotificationName:_name object:nil userInfo:(_info)])

#endif /* YSCKit_YSCConstants_h */

