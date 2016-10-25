//
//  Hmacsha1.m
//  Qianjituan
//
//  Created by zengbixing on 15/9/22.
//  Copyright © 2015年 ios-mac. All rights reserved.
//

#import "Hmacsha1.h"
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
#include "NSData+Base64.h"

@implementation Hmacsha1

+ (NSString *)hmacsha1:(NSString *)text key:(NSString *)secret {
    
    NSData *secretData = [secret dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *clearTextData = [text dataUsingEncoding:NSUTF8StringEncoding];
    
    unsigned char result[20];
    
    CCHmac(kCCHmacAlgSHA1, [secretData bytes], [secretData length], [clearTextData bytes], [clearTextData length], result);

    NSInteger len = strlen(result);
    
    NSData* xmlData = [NSData dataWithBytes:result length:20];
    
    NSString *b = [xmlData base64EncodedString];
    
    return b;
}

@end
