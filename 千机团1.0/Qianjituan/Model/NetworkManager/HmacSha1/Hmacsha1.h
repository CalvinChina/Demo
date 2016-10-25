//
//  Hmacsha1.h
//  Qianjituan
//
//  Created by zengbixing on 15/9/22.
//  Copyright © 2015年 ios-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Hmacsha1 : NSObject

+ (NSString *)hmacsha1:(NSString *)text key:(NSString *)secret;

@end
