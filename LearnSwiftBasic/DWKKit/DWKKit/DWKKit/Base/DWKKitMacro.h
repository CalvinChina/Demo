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





#endif /* DWKKitMacro_h */
