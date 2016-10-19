//
//  DWKKitMacro.h
//  DWKKit
//
//  Created by pisen on 16/10/13.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

#import <sys/time.h>

#ifndef DWKKitMacro_h
#define DWKKitMacro_h


typedef void (^DWKBlock)();
typedef void (^DWKObjectBlock)(NSObject * obj);
typedef void (^DWKObjectErrorBlock)(NSObject * obj,NSError * error);
typedef void (^DWKObjectErrorMessageBlock)(NSObject * obj,NSString * errorMessage);
typedef void (^DWKIdErrorBlock)(id obj,NSError * error);
typedef void (^DWKIdErrorMessageBlock)(id obj,NSString * errorMessage);
typedef void (^DWKIntegerErrorMessageBlock)(NSInteger,NSString * errorMessage);


/**
 *  对象判空
 *  注意：只对原始数据进行判断，即全空的字符串不为空
 */
#define OBJECT_IS_EMPTY(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)]  && [(NSArray *)_object count] == 0))
#define OBJECT_ISNOT_EMPTY(_object) ( ! OBJECT_IS_EMPTY(_object))
#define RETURN_WHEN_OBJECT_IS_EMPTY(_object)        if (OBJECT_IS_EMPTY(_object)) { return ;    }
#define RETURN_NIL_WHEN_OBJECT_IS_EMPTY(_object)    if (OBJECT_IS_EMPTY(_object)) { return nil; }
#define RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(_object)  if (OBJECT_IS_EMPTY(_object)) { return @""; }
#define RETURN_YES_WHEN_OBJECT_IS_EMPTY(_object)    if (OBJECT_IS_EMPTY(_object)) { return YES; }
#define RETURN_NO_WHEN_OBJECT_IS_EMPTY(_object)     if (OBJECT_IS_EMPTY(_object)) { return NO;  }
#define RETURN_ZERO_WHEN_OBJECT_IS_EMPTY(_object)   if (OBJECT_IS_EMPTY(_object)) { return 0;   }


/**
 *  创建单例
 */
#ifndef DEFINE_SHARED_INSTANCE_USING_BLOCK
#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
static dispatch_once_t pred = 0; \
__strong static id _sharedObject = nil; \
dispatch_once(&pred, ^{ \
_sharedObject = block(); \
}); \
return _sharedObject;
#endif


/**
 *  注册通知与发送通知
 */
//注册通知
#define ADD_OBSERVER_WITH_OBJECT(_selector, _name, _object) \
([[NSNotificationCenter defaultCenter] addObserver:self selector:_selector name:_name object:_object])
#define ADD_OBSERVER(_selector,_name) \
ADD_OBSERVER_WITH_OBJECT(_selector, _name, nil)
//发送通知
#define POST_NOTIFICATION_WITH_OBJECT_AND_INFO(_name, _object, _info) \
([[NSNotificationCenter defaultCenter] postNotificationName:_name object:_object userInfo:(_info)])
#define POST_NOTIFICATION(_name) \
POST_NOTIFICATION_WITH_OBJECT_AND_INFO(_name, nil, nil)
#define POST_NOTIFICATION_WITH_OBJECT(_name, _object) \
POST_NOTIFICATION_WITH_OBJECT_AND_INFO(_name, _object, nil)
#define POST_NOTIFICATION_WITH_INFO(_name, _info) \
POST_NOTIFICATION_WITH_OBJECT_AND_INFO(_name, nil, _info)
//移除通知
#define REMOVE_OBSERVER(_name) \
([[NSNotificationCenter defaultCenter] removeObserver:self name:_name object:nil])
#define REMOVE_ALL_OBSERVERS(_self) \
([[NSNotificationCenter defaultCenter] removeObserver:_self])



/**
 *  代码段简写
 */
#define RGBA(r, g, b, a)                [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:a]
#define RGB(r, g, b)                    RGBA(r,g,b,1.0f)
#define RGB_GRAY(c)                     RGBA(c,c,c,1.0f)
#define RANDOM_INT(from,to)             ((int)((from) + arc4random() % ((to)-(from) + 1)))  //随机数 [from,to] 之间
#define VIEW_IN_XIB(x, i)               [[[NSBundle mainBundle] loadNibNamed:(x) owner:nil options:nil] objectAtIndex:(i)]
#define FIRST_VIEW_IN_XIB(x)            VIEW_IN_XIB(x, 0)
#define CREATE_VIEW_CONTROLLER(x)              [[NSClassFromString(x) alloc] initWithNibName:x bundle:nil]
#define CREATE_NAVIGATION_VIEW_CONTROLLER(x)   [[UINavigationController alloc]initWithRootViewController:CREATE_VIEW_CONTROLLER(x)]
#define CREATE_NSERROR_WITH_Code(c,m)   [NSError errorWithDomain:@"DWKKit" code:c userInfo:@{NSLocalizedDescriptionKey : m}]
#define CREATE_NSERROR(m)               CREATE_NSERROR_WITH_Code(0,m)
#define GET_NSERROR_MESSAGE(e)          ((NSError *)e).userInfo[NSLocalizedDescriptionKey]  //=e.localizedDescription
#define KEY_WINDOW                      [UIApplication sharedApplication].keyWindow
#define FUNCTION_NAME                   [NSString stringWithUTF8String:__FUNCTION__]
#define IS_NIB_EXISTS(nib)              [[NSFileManager defaultManager] fileExistsAtPath:[[NSBundle mainBundle] pathForResource:nib ofType:@"nib"]]
#define PRINT_DEALLOCING                NSLog(@"[%@] is deallocing...",NSStringFromClass(self.class));

// 去掉字符串的头尾空格
#define TRIM_STRING(_string) (\
( ! [_string isKindOfClass:[NSString class]]) ? \
@"" : [_string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] \
)


// 是否处于debug或develop模式
#define DEBUG_OR_DEVELOP_MODE       (DEBUG_MODE || [YSCManager isArchiveByDevelopment])

// 是否可以输出log
#define IS_LOG_AVAILABLE            (DEBUG_OR_DEVELOP_MODE || DWKConfigDataInstance.isOutputLog)



/**
 Synthsize a weak or strong reference.
 
 Example:
 @weakiy(self)
 [self doSomething^{
 @strongiy(self)
 if (!self) return;
 ...
 }];
 
 */
#ifndef weakiy
#if DEBUG
#if __has_feature(objc_arc)
#define weakiy(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakiy(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakiy(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakiy(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongiy
#if DEBUG
#if __has_feature(objc_arc)
#define strongiy(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongiy(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongiy(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongiy(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif


#endif /* DWKKitMacro_h */
