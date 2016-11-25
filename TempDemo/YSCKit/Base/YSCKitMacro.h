//
//  YSCKitMacro.h
//  YSCKit
//
//  Created by 杨胜超 on 16/3/22.
//  Copyright (c) 2015年 Builder. All rights reserved.
//

#import <sys/time.h>

#ifndef YSCKitMacro_h
#define YSCKitMacro_h

// 定义通用的block
typedef void (^YSCBlock)();
typedef void (^YSCObjectBlock)(NSObject *object);
typedef void (^YSCObjectErrorBlock)(NSObject *object, NSError *error);
typedef void (^YSCObjectErrorMessageBlock)(NSObject *object, NSString *errorMessage);
typedef void (^YSCIdErrorBlock)(id object, NSError *error);
typedef void (^YSCIdErrorMessageBlock)(id object, NSString *errorMessage);
typedef void (^YSCIntegerErrorBlock)(NSInteger, NSError *);


// 方法或属性过期标志
#define YSCDeprecated(explain)      NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, explain)

// 是否处于debug模式
#define DEBUG_MODE                  YSCConfigDataInstance.isDebugMode

// 是否处于debug或develop模式
#define DEBUG_OR_DEVELOP_MODE       (DEBUG_MODE || [YSCManager isArchiveByDevelopment])

// 是否可以输出log
#define IS_LOG_AVAILABLE            (DEBUG_OR_DEVELOP_MODE || YSCConfigDataInstance.isOutputLog)

// 定义NSLog
#define __NSLog(s, ...) do { \
        if (IS_LOG_AVAILABLE) { \
            NSMutableString *logString = [NSMutableString stringWithFormat:@"[%@(%d)] ",[[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__]; \
            if (s) { \
                [logString appendFormat:(s), ##__VA_ARGS__]; \
            } \
            else { \
                [logString appendString:@"(null)"]; \
            } \
            NSLog(@"%@", logString); \
            [YSCLogManager saveLog:logString]; \
        } \
    } while (0)
#define NSLog(...) __NSLog(__VA_ARGS__)

#define LOG_POINT(point)    NSLog(@"%s = { x:%f, y:%f }", #point, point.x, point.y)
#define LOG_SIZE(size)      NSLog(@"%s = { w:%f, h:%f }", #size, size.width, size.height)
#define LOG_RECT(rect)      NSLog(@"%s =\r { x:%f, y:%f, w:%f, h:%f }", #rect, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)


// 去掉字符串的头尾空格
#define TRIM_STRING(_string) (\
        ( ! [_string isKindOfClass:[NSString class]]) ? \
        @"" : [_string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] \
        )


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
 *  Swizzling
 */
#ifndef SWIZZLING_INSTANCE_METHOD
    #define SWIZZLING_INSTANCE_METHOD(clazz, originalSelector, swizzledSelector) { \
        Method originalMethod = class_getInstanceMethod(clazz, originalSelector); \
        Method swizzledMethod = class_getInstanceMethod(clazz, swizzledSelector); \
        BOOL isAddedMethod = class_addMethod(clazz, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod)); \
        if (isAddedMethod) { \
            class_replaceMethod(clazz, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod)); \
        } \
        else { \
            method_exchangeImplementations(originalMethod, swizzledMethod); \
        } }
#endif


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
#define CREATE_NSERROR_WITH_Code(c,m)   [NSError errorWithDomain:@"YSCKit" code:c userInfo:@{NSLocalizedDescriptionKey : m}]
#define CREATE_NSERROR(m)               CREATE_NSERROR_WITH_Code(0,m)
#define GET_NSERROR_MESSAGE(e)          ((NSError *)e).userInfo[NSLocalizedDescriptionKey]  //=e.localizedDescription
#define KEY_WINDOW                      [UIApplication sharedApplication].keyWindow
#define FUNCTION_NAME                   [NSString stringWithUTF8String:__FUNCTION__]
#define IS_NIB_EXISTS(nib)              [[NSFileManager defaultManager] fileExistsAtPath:[[NSBundle mainBundle] pathForResource:nib ofType:@"nib"]]
#define PRINT_DEALLOCING                NSLog(@"[%@] is deallocing...",NSStringFromClass(self.class));



/**
 *  自动布局相关代码段简写
 */
#define AUTOLAYOUT_LENGTH(x)            ((x) * YSCConfigDataInstance.autoLayoutScale)       //计算缩放后的大小point
#define AUTOLAYOUT_LENGTH_W(x,w)        ((x) * (YSCConfigDataInstance.screenWidth / (w)))   //计算任意xib布局的真实大小point
#define AUTOLAYOUT_FONT(f)              [UIFont systemFontOfSize:AUTOLAYOUT_LENGTH(f)]
#define AUTOLAYOUT_FONT_W(f,w)          [UIFont systemFontOfSize:AUTOLAYOUT_LENGTH_W(f,w)]

#define AUTOLAYOUT_SIZE_WH(w,h)         CGSizeMake(AUTOLAYOUT_LENGTH(w), AUTOLAYOUT_LENGTH(h))
#define AUTOLAYOUT_SIZE(s)              AUTOLAYOUT_SIZE_WH(s.width, s.height)
#define AUTOLAYOUT_EDGEINSETS_TLBR(t,l,b,r)     UIEdgeInsetsMake(AUTOLAYOUT_LENGTH(t), AUTOLAYOUT_LENGTH(l), AUTOLAYOUT_LENGTH(b), AUTOLAYOUT_LENGTH(r))
#define AUTOLAYOUT_EDGEINSETS(e)        AUTOLAYOUT_EDGEINSETS_TLBR(e.top, e.left, e.bottom, e.right)
#define AUTOLAYOUT_RECT_XYWH(x,y,w,h)   CGRectMake(AUTOLAYOUT_LENGTH(x), AUTOLAYOUT_LENGTH(y), AUTOLAYOUT_LENGTH(w), AUTOLAYOUT_LENGTH(h))
#define AUTOLAYOUT_RECT(r)              AUTOLAYOUT_RECT_XYWH(r.origin.x, r.origin.y, r.size.width, r.size.height)


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
 * usage:
 *   @interface NSObject (MyAdd)
 *       @property (nonatomic, assign) BOOL isError;
 *   @end
 *
 *   #import <objc/runtime.h>
 *   @implementation NSObject (MyAdd)
 *       YSC_DYNAMIC_PROPERTY_BOOL(isError, setIsError)
 *   @end
 */
#ifndef YSC_DYNAMIC_PROPERTY_BOOL
    #define YSC_DYNAMIC_PROPERTY_BOOL(_getter_, _setter_) \
            - (void)_setter_ : (BOOL)value { \
                NSNumber *number = [NSNumber numberWithBool:value]; \
                [self willChangeValueForKey:@#_getter_]; \
                objc_setAssociatedObject(self, _cmd, number, OBJC_ASSOCIATION_RETAIN); \
                [self didChangeValueForKey:@#_getter_]; \
            } \
            - (BOOL)_getter_ { \
                NSNumber *number = objc_getAssociatedObject(self, @selector(_setter_:)); \
                return [number boolValue]; \
            }
#endif

/**
 * usage:
 *   @interface NSObject (MyAdd)
 *       @property (nonatomic, strong) NSMutableArray *textFields;
 *   @end
 *
 *   #import <objc/runtime.h>
 *   @implementation NSObject (MyAdd)
 *       YSC_DYNAMIC_PROPERTY_LAZYLOAD(textFields, NSMutableArray *, [NSMutableArray new])
 *   @end
 */
#ifndef YSC_DYNAMIC_PROPERTY_LAZYLOAD
    #define YSC_DYNAMIC_PROPERTY_LAZYLOAD(_getter_, _type_, _initObject_) \
            - (_type_)_getter_ { \
                _type_ target = objc_getAssociatedObject(self, _cmd); \
                if ( ! target) { \
                    target = _initObject_; \
                    objc_setAssociatedObject(self, _cmd, target, OBJC_ASSOCIATION_RETAIN_NONATOMIC); \
                } \
                return target; \
            }
#endif



//----------------------------------------------------------------------------//
//
//  以下宏定义参考了YYKitMacro.h
//  https://github.com/ibireme/YYKit/blob/master/YYKit/Base/YYKitMacro.h
//
//----------------------------------------------------------------------------//

/**
 Profile time cost.
 @param ^block     code to benchmark
 @param ^complete  code time cost (millisecond)
 
 Usage:
 YSCBenchmark(^{
     // code
 }, ^(double ms) {
     NSLog(@"time cost: %.2f ms",ms);
 });
 */
static inline void YSCBenchmark(void (^block)(void), void (^complete)(double ms)) {
    // <QuartzCore/QuartzCore.h> version
    /*
     extern double CACurrentMediaTime (void);
     double begin, end, ms;
     begin = CACurrentMediaTime();
     block();
     end = CACurrentMediaTime();
     ms = (end - begin) * 1000.0;
     complete(ms);
     */
    
    // <sys/time.h> version
    struct timeval t0, t1;
    gettimeofday(&t0, NULL);
    block();
    gettimeofday(&t1, NULL);
    double ms = (double)(t1.tv_sec - t0.tv_sec) * 1e3 + (double)(t1.tv_usec - t0.tv_usec) * 1e-3;
    complete(ms);
}

/**
 Add this macro before each category implementation, so we don't have to use
 -all_load or -force_load to load object files from static libraries that only
 contain categories and no classes.
 More info: http://developer.apple.com/library/mac/#qa/qa2006/qa1490.html .
 *******************************************************************************
 Example:
 YYSYNTH_DUMMY_CLASS(NSString_YYAdd)
 */
#ifndef YYSYNTH_DUMMY_CLASS
    #define YYSYNTH_DUMMY_CLASS(_name_) \
            @interface YYSYNTH_DUMMY_CLASS_ ## _name_ : NSObject @end \
            @implementation YYSYNTH_DUMMY_CLASS_ ## _name_ @end
#endif


/**
 Synthsize a dynamic object property in @implementation scope.
 It allows us to add custom properties to existing classes in categories.
 
 @param association  ASSIGN / RETAIN / COPY / RETAIN_NONATOMIC / COPY_NONATOMIC
 @warning #import <objc/runtime.h>
 *******************************************************************************
 Example:
 @interface NSObject (MyAdd)
     @property (nonatomic, retain) UIColor *myColor;
 @end
 
 #import <objc/runtime.h>
 @implementation NSObject (MyAdd)
     YYSYNTH_DYNAMIC_PROPERTY_OBJECT(myColor, setMyColor, RETAIN, UIColor *)
 @end
 */
#ifndef YYSYNTH_DYNAMIC_PROPERTY_OBJECT
    #define YYSYNTH_DYNAMIC_PROPERTY_OBJECT(_getter_, _setter_, _association_, _type_) \
            - (void)_setter_ : (_type_)object { \
                [self willChangeValueForKey:@#_getter_]; \
                objc_setAssociatedObject(self, _cmd, object, OBJC_ASSOCIATION_ ## _association_); \
                [self didChangeValueForKey:@#_getter_]; \
            } \
            - (_type_)_getter_ { \
                return objc_getAssociatedObject(self, @selector(_setter_:)); \
            }
#endif


/**
 Synthsize a dynamic c type property in @implementation scope.
 It allows us to add custom properties to existing classes in categories.
 
 @warning #import <objc/runtime.h>
 *******************************************************************************
 Example:
 @interface NSObject (MyAdd)
 @property (nonatomic, retain) CGPoint myPoint;
 @end
 
 #import <objc/runtime.h>
 @implementation NSObject (MyAdd)
 YYSYNTH_DYNAMIC_PROPERTY_CTYPE(myPoint, setMyPoint, CGPoint)
 @end
 */
#ifndef YYSYNTH_DYNAMIC_PROPERTY_CTYPE
    #define YYSYNTH_DYNAMIC_PROPERTY_CTYPE(_getter_, _setter_, _type_) \
    - (void)_setter_ : (_type_)object { \
        [self willChangeValueForKey:@#_getter_]; \
        NSValue *value = [NSValue value:&object withObjCType:@encode(_type_)]; \
        objc_setAssociatedObject(self, _cmd, value, OBJC_ASSOCIATION_RETAIN); \
        [self didChangeValueForKey:@#_getter_]; \
    } \
    - (_type_)_getter_ { \
        _type_ cValue = { 0 }; \
        NSValue *value = objc_getAssociatedObject(self, @selector(_setter_:)); \
        [value getValue:&cValue]; \
        return cValue; \
    }
#endif

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


#endif /* YSCKitMacro_h */
