//
//  PSKMacros.h
//  PisenKit
//
//  Created by 杨胜超 on 16/6/29.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import <sys/time.h>

#ifndef PSKMacros_h
#define PSKMacros_h

// 定义NSLog
#define __NSLog(s, ...) do { \
            NSMutableString *logString = [NSMutableString stringWithFormat:@"[%@(%d)] ",[[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__]; \
            if (s) { \
                [logString appendFormat:(s), ##__VA_ARGS__]; \
            } \
            else { \
                [logString appendString:@"(null)"]; \
            } \
            NSLog(@"%@", logString); \
        } while (0)
#define NSLog(...) __NSLog(__VA_ARGS__)

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
#ifndef SWIZZLING_INSTANCE_METHODS
    #define SWIZZLING_INSTANCE_METHODS(clazz, originalSelector, swizzledSelector) \
        Method originalMethod = class_getInstanceMethod(clazz, originalSelector); \
        Method swizzledMethod = class_getInstanceMethod(clazz, swizzledSelector); \
        BOOL isAddedMethod = class_addMethod(clazz, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod)); \
        if (isAddedMethod) { \
            class_replaceMethod(clazz, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod)); \
        } \
        else { \
            method_exchangeImplementations(originalMethod, swizzledMethod); \
        }
#endif



/**
 *  代码段简写
 */
#define RGBA(r, g, b, a)                [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:a]
#define RGB(r, g, b)                    RGBA(r,g,b,1.0f)
#define RGB_GRAY(c)                     RGBA(c,c,c,1.0f)
#define RANDOM_INT(from,to)             ((int)((from) + arc4random() % ((to)-(from) + 1)))  //随机数 [from,to] 之间
#define GET_NSERROR_MESSAGE(e)          ((NSError *)e).userInfo[NSLocalizedDescriptionKey]  //=e.localizedDescription
#define KEY_WINDOW                      [UIApplication sharedApplication].keyWindow
#define FUNCTION_NAME                   [NSString stringWithUTF8String:__FUNCTION__]

#define IS_NIB_EXISTS(nib)              [[NSFileManager defaultManager] fileExistsAtPath:[[NSBundle mainBundle] pathForResource:nib ofType:@"nib"]]
#define CREATE_NSERROR_WITH_Code(c,m)   [NSError errorWithDomain:@"PisenKit" code:c userInfo:@{NSLocalizedDescriptionKey : m}]
#define CREATE_NSERROR(m)               CREATE_NSERROR_WITH_Code(0,m)
#define PRINT_DEALLOCING                NSLog(@"[%@] is deallocing...",NSStringFromClass(self.class));


/**
 * 1. if (NSOrderedAscending != COMPARE_VERSION(v1,v2))  { //v1 >= v2 }
 * 2. if (NSOrderedDescending == COMPARE_VERSION(v1,v2)) { //v1 > v2 }
 * 3. if (NSOrderedAscending == COMPARE_VERSION(v1,v2))  { //v1 < v2 }
 */
#define COMPARE_VERSION(v1,v2)          [v1 compare:v2 options:NSNumericSearch]
#define COMPARE_CURRENT_VERSION(v)      COMPARE_VERSION([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], (v))
#define APP_SKIP_VERSION(v)             [NSString stringWithFormat:@"APP_SKIP_VERSION_%@", v]
#define APP_LAUNCH_VERSION(v)           [NSString stringWithFormat:@"APP_LAUNCH_VERSION_%@", v]


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
 Usage:
 PSKBenchmark(^{
 // code
 }, ^(double ms) {
 NSLog(@"time cost: %.2f ms",ms);
 });
 */
static inline void PSKBenchmark(void (^block)(void), void (^complete)(double ms)) {
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
 * usage:
 *   @interface NSObject (MyAdd)
 *       @property (nonatomic, assign) BOOL isError;
 *   @end
 *
 *   #import <objc/runtime.h>
 *   @implementation NSObject (MyAdd)
 *       PSK_DYNAMIC_PROPERTY_BOOL(isError, setIsError)
 *   @end
 */
#ifndef PSK_DYNAMIC_PROPERTY_BOOL
    #define PSK_DYNAMIC_PROPERTY_BOOL(_getter_, _setter_) \
        - (void)_setter_:(BOOL)value { \
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
 Synthsize a dynamic object property in @implementation scope.
 It allows us to add custom properties to existing classes in categories.
 
 @param association  ASSIGN / RETAIN / COPY / RETAIN_NONATOMIC / COPY_NONATOMIC
 @warning #import <objc/runtime.h>
 *******************************************************************************
 Usage:
 @interface NSObject (MyAdd)
     @property (nonatomic, retain) UIColor *myColor;
 @end
 
 #import <objc/runtime.h>
 @implementation NSObject (MyAdd)
     PSK_DYNAMIC_PROPERTY_OBJECT(myColor, setMyColor, RETAIN_NONATOMIC, UIColor *)
 @end
 */
#ifndef PSK_DYNAMIC_PROPERTY_OBJECT
    #define PSK_DYNAMIC_PROPERTY_OBJECT(_getter_, _setter_, _association_, _type_) \
        - (void)_setter_:(_type_)object { \
            [self willChangeValueForKey:@#_getter_]; \
            objc_setAssociatedObject(self, _cmd, object, OBJC_ASSOCIATION_##_association_); \
            [self didChangeValueForKey:@#_getter_]; \
        } \
        - (_type_)_getter_ { \
            return objc_getAssociatedObject(self, @selector(_setter_:)); \
        }
#endif


/**
 Usage:
 @interface NSObject (MyAdd)
     @property (nonatomic, retain) CGPoint myPoint;
 @end
 
 #import <objc/runtime.h>
 @implementation NSObject (MyAdd)
     PSK_DYNAMIC_PROPERTY_CTYPE(myPoint, setMyPoint, CGPoint)
 @end
 */
#ifndef PSK_DYNAMIC_PROPERTY_CTYPE
    #define PSK_DYNAMIC_PROPERTY_CTYPE(_getter_, _setter_, _type_) \
        - (void)_setter_:(_type_)object { \
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
 Usage:
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

#endif /* PSKMacros_h */
