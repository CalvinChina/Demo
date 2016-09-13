//
//  NSData+PisenKit.m
//  PisenKit
//
//  Created by 杨胜超 on 16/6/30.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import "NSData+PisenKit.h"

@implementation NSData (PisenKit)
- (NSString *)byteString {
    Byte *bytes = (Byte *)[self bytes];
    NSMutableString* resultString = [NSMutableString stringWithCapacity:[self length]];
    for (int i = 0; i < [self length]; i++) {
        [resultString appendFormat:@"%02x", bytes[i]];
    }
    return resultString;
}
- (NSString *)base64String {
    NSData *base64Data = [self base64EncodedDataWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    return [[NSString alloc] initWithData:base64Data encoding:NSUTF8StringEncoding];
}
@end


//==============================================================================
//
//  常用方法
//
//==============================================================================
@implementation NSData (CommonHMAC)
- (NSData *)psk_HMACWithAlgorithm:(CCHmacAlgorithm)algorithm {
    return [self psk_HMACWithAlgorithm:algorithm key:nil];
}
- (NSData *)psk_HMACWithAlgorithm:(CCHmacAlgorithm)algorithm key:(id)key {
    NSParameterAssert(key == nil || [key isKindOfClass: [NSData class]] || [key isKindOfClass: [NSString class]]);
    
    NSData *keyData = nil;
    if ([key isKindOfClass:[NSString class]]) {
        keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    }
    else {
        keyData = (NSData *)key;
    }
    
    if (kCCHmacAlgSHA1 == algorithm) {
        unsigned char buf[CC_SHA1_DIGEST_LENGTH];
        CCHmac(algorithm, [keyData bytes], [keyData length], [self bytes], [self length], buf);
        return [NSData dataWithBytes:buf length:CC_SHA1_DIGEST_LENGTH];
    }
    else if (kCCHmacAlgMD5 == algorithm) {
        unsigned char buf[CC_MD5_DIGEST_LENGTH];
        CCHmac(algorithm, [keyData bytes], [keyData length], [self bytes], [self length], buf);
        return [NSData dataWithBytes:buf length:CC_MD5_DIGEST_LENGTH];
    }
    else if (kCCHmacAlgSHA256 == algorithm) {
        unsigned char buf[CC_SHA256_DIGEST_LENGTH];
        CCHmac(algorithm, [keyData bytes], [keyData length], [self bytes], [self length], buf);
        return [NSData dataWithBytes:buf length:CC_SHA256_DIGEST_LENGTH];
    }
    else if (kCCHmacAlgSHA384 == algorithm) {
        unsigned char buf[CC_SHA384_DIGEST_LENGTH];
        CCHmac(algorithm, [keyData bytes], [keyData length], [self bytes], [self length], buf);
        return [NSData dataWithBytes:buf length:CC_SHA384_DIGEST_LENGTH];
    }
    else if (kCCHmacAlgSHA512 == algorithm) {
        unsigned char buf[CC_SHA512_DIGEST_LENGTH];
        CCHmac(algorithm, [keyData bytes], [keyData length], [self bytes], [self length], buf);
        return [NSData dataWithBytes:buf length:CC_SHA512_DIGEST_LENGTH];
    }
    else if (kCCHmacAlgSHA224 == algorithm) {
        unsigned char buf[CC_SHA224_DIGEST_LENGTH];
        CCHmac(algorithm, [keyData bytes], [keyData length], [self bytes], [self length], buf);
        return [NSData dataWithBytes:buf length:CC_SHA224_DIGEST_LENGTH];
    }
    return nil;
}
@end
