//
//  NSString+PisenKit.m
//  PisenKit
//
//  Created by 杨胜超 on 16/6/30.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import "NSString+PisenKit.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation NSString (PisenKit)
+ (BOOL)psk_isEmptyConsiderWhitespace:(NSString *)string {
    RETURN_YES_WHEN_OBJECT_IS_EMPTY(string)
    return ![[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length];
}
+ (BOOL)psk_isNotEmptyConsiderWhitespace:(NSString *)string {
    return ( ! [self psk_isEmptyConsiderWhitespace:string]);
}
+ (BOOL)psk_isContains:(NSString *)subString inString:(NSString *)string {
    RETURN_NO_WHEN_OBJECT_IS_EMPTY(string)
    return [string psk_isContains:subString];
}
- (BOOL)psk_isContains:(NSString *)subString {
    RETURN_NO_WHEN_OBJECT_IS_EMPTY(subString)
    return [self rangeOfString:subString].location != NSNotFound;
}
+ (BOOL)psk_isMatchRegex:(NSString*)pattern withString:(NSString *)string {
    RETURN_NO_WHEN_OBJECT_IS_EMPTY(string)
    return [string psk_isMatchRegex:pattern options:NSRegularExpressionCaseInsensitive];
}
+ (BOOL)psk_isMatchRegex:(NSString*)pattern withString:(NSString *)string options:(NSRegularExpressionOptions)options {
    RETURN_NO_WHEN_OBJECT_IS_EMPTY(string)
    return [string psk_isMatchRegex:pattern options:options];
}
- (BOOL)psk_isMatchRegex:(NSString *)pattern options:(NSRegularExpressionOptions)options {
    RETURN_NO_WHEN_OBJECT_IS_EMPTY(pattern)
    
    //方法一：缺点是无法兼容大小写的情况
    //	NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    //	return [identityCardPredicate evaluateWithObject:self];
    
    //方法二：
    NSError *error = nil;
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                                options:options
                                                                                  error:&error];
    if (error) {
        NSLog(@"Error by creating Regex: %@",[error description]);
        return NO;
    }
    
    return ([expression numberOfMatchesInString:self options:0 range:NSMakeRange(0, [self length])] > 0);
}
+ (BOOL)psk_isWebUrlByString:(NSString *)string {
    return [NSString psk_isMatchRegex:PSKConfigManagerInstance.regexWebUrl withString:string];
}
+ (BOOL)psk_isNotWebUrlByString:(NSString *)string {
    return ! [self psk_isWebUrlByString:string];
}

// 字符串简单变换
+ (NSString *)psk_trimString:(NSString *)string {
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(string)
    return [string psk_trimString];
}
- (NSString *)psk_trimString {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
//将json字符串转换成dict
+ (NSObject *)psk_jsonObjectOfString:(NSString *)string {
    RETURN_NIL_WHEN_OBJECT_IS_EMPTY(string)
    return [string psk_jsonObjectOfString];
}
- (NSObject *)psk_jsonObjectOfString {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSObject *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    return json;
}
//将id对象转换成json字符串
+ (NSString *)psk_jsonStringWithObject:(id)object {
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(object)
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] > 0  || error == nil){
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }else{
        return @"";
    }
}

+ (NSString *)psk_replaceString:(NSString *)string byRegex:(NSString *)pattern to:(NSString *)toString {
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(string)
    return [string psk_replaceByRegex:pattern to:toString options:NSRegularExpressionCaseInsensitive];
}
+ (NSString *)psk_replaceString:(NSString *)string byRegex:(NSString *)pattern to:(NSString *)toString options:(NSRegularExpressionOptions)options {
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(string)
    return [string psk_replaceByRegex:pattern to:toString options:options];
}
- (NSString *)psk_replaceByRegex:(NSString *)pattern to:(NSString *)toString options:(NSRegularExpressionOptions)options{
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(pattern)
    //方法一：缺点是仅仅用于普通字符串，无法兼容正则表达式的情况
    //	return [self stringByReplacingOccurrencesOfString:pattern withString:toString];
    
    //方法二：
    NSError *error = nil;
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                                options:options
                                                                                  error:&error];
    if (error) {
        NSLog(@"Error by creating Regex: %@",[error description]);
        return @"";
    }
    return [[expression stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, [self length]) withTemplate:toString] psk_trimString];
}
//计算字符串的长度（1个英文字母为1个字节，1个汉字为2个字节）
+ (NSInteger)psk_stringLength:(NSString *)string {
    RETURN_ZERO_WHEN_OBJECT_IS_EMPTY(string)
    return [string psk_stringLength];
}
- (NSInteger)psk_stringLength {
    //    //方法一：有的汉字长度为1，如 '开'
    //    int strlength = 0;
    //    char* p = (char*)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    //    for (int i=0 ; i<[self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
    //        if (*p) {
    //            p++;
    //            strlength++;
    //        }
    //        else {
    //            p++;
    //        }
    //    }
    //    return strlength;
    //
    //    //方法二：有的汉字长度为1，如 '开'
    //    NSUInteger words = 0;
    //    NSScanner *scanner = [NSScanner scannerWithString:self];
    //    NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    //    while ([scanner scanUpToCharactersFromSet:whiteSpace intoString:nil])
    //        words++;
    //    return words;
    
    //方法三：暂时没有发现汉字计算错误的情况
    int l = 0,a = 0,b = 0;
    unichar c;
    for(int i = 0; i < [self length]; i++){
        c = [self characterAtIndex:i];
        if(isblank(c)) {
            b++;
        }
        else if(isascii(c)) {
            a++;
        }
        else {
            l++;
        }
    }
    return 2 * l + (a + b);
}
//移除字符串最后一个字符
+ (NSString *)psk_removeLastCharOfString:(NSString *)string {
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(string)
    return [string psk_removeLastChar];
}
- (NSString *)psk_removeLastChar {
    return [self substringToIndex:[self length] - 1];
}
+ (void)psk_removeLastCharOfMutableString:(NSMutableString *)mutableString {
    RETURN_WHEN_OBJECT_IS_EMPTY(mutableString)
    [mutableString deleteCharactersInRange:NSMakeRange([mutableString length] - 1, 1)];
}
//获取末尾N个字符
+ (NSString *)psk_substringFromEnding:(NSString *)string count:(NSInteger)count {
    return [string psk_substringFromEnding:count];
}
- (NSString *)psk_substringFromEnding:(NSInteger)count {
    NSString *str = TRIM_STRING(self);
    return [str substringFromIndex:MAX((int)[str length] - count, 0)];
}

// 汉字转拼音
+ (NSString *)psk_toPinYin:(NSString *)hanzi {
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(hanzi)
    return [hanzi psk_toPinYin];
}
- (NSString *)psk_toPinYin {
    NSMutableString *mutableString = [NSMutableString stringWithString:self];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    mutableString = (NSMutableString *)[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    return [NSString stringWithString:mutableString];
}

// 字符串分解
+ (NSArray *)psk_splitString:(NSString *)string byRegex:(NSString *)pattern {
    if (OBJECT_IS_EMPTY(string)) {
        return @[];
    }
    return [string psk_splitByRegex:pattern options:NSRegularExpressionCaseInsensitive];
}
+ (NSArray *)psk_splitString:(NSString *)string byRegex:(NSString *)pattern options:(NSRegularExpressionOptions)options{
    if (OBJECT_IS_EMPTY(string)) {
        return @[];
    }
    return [string psk_splitByRegex:pattern options:options];
}
- (NSArray *)psk_splitByRegex:(NSString *)pattern {
    return [self psk_splitByRegex:pattern options:NSRegularExpressionCaseInsensitive];
}
- (NSArray *)psk_splitByRegex:(NSString *)pattern options:(NSRegularExpressionOptions)options {
    if (OBJECT_IS_EMPTY(pattern)) {
        return @[];
    }
#define SpecialPlaceholderString @"_&&_"   //特殊占位符
    NSString *newString = [self psk_replaceByRegex:pattern to:SpecialPlaceholderString options:options];
    NSArray *sourceArray = [newString componentsSeparatedByString:SpecialPlaceholderString];
    NSMutableArray *components = [NSMutableArray array];
    for (NSString *component in sourceArray) {
        if (![NSString psk_isEmptyConsiderWhitespace:component]) {
            [components addObject:[component psk_trimString]];
        }
    }
    return components;
}

+ (NSArray *)psk_matchesInString:(NSString *)string byRegex:(NSString *)pattern {
    if (OBJECT_IS_EMPTY(string)) {
        return @[];
    }
    return [string psk_matchesByRegex:pattern options:NSRegularExpressionCaseInsensitive];
}
+ (NSArray *)psk_matchesInString:(NSString *)string byRegex:(NSString *)pattern options:(NSRegularExpressionOptions)options {
    if (OBJECT_IS_EMPTY(string)) {
        return @[];
    }
    return [string psk_matchesByRegex:pattern options:options];
}
- (NSArray *)psk_matchesByRegex:(NSString *)pattern options:(NSRegularExpressionOptions)options {
    if (OBJECT_IS_EMPTY(pattern)) {
        return @[];
    }
    
    NSError *error = nil;
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                                options:options
                                                                                  error:&error];
    if (error) {
        NSLog(@"Error by creating Regex: %@",[error description]);
        return @[];
    }
    
    //方法一：
    //    NSArray *matchesRangeArray = [expression matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    //    NSMutableArray *matchesArray = [NSMutableArray new];
    //    for (NSTextCheckingResult *match in matchesRangeArray) {
    //        NSString* substringForMatch = [self substringWithRange:match.range];
    //        //match.numberOfRanges 只有在pattern是分组的情况下，会大于1，通常这样的情况很少
    //        [matchesArray addObject:substringForMatch];
    //    }
    
    //方法二：
    __block NSMutableArray *matchesArray = [NSMutableArray array];
    [expression enumerateMatchesInString:self
                                 options:0
                                   range:NSMakeRange(0, [self length])
                              usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                  NSString* substringForMatch = [self substringWithRange:result.range];
                                  [matchesArray addObject:substringForMatch];
                              }];
    
    return matchesArray;
}
@end



//==============================================================================
//
//  针对NSString扩展——加密解密
//
//==============================================================================
@implementation NSString (Security)
#define DEFAULT_KEY      @"&65Rfh'}00000000"                     //默认秘钥

// base64加密解密(标准的)
+ (NSString *)psk_Base64Encrypt:(NSString *)string {
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(string)
    return [string psk_Base64EncryptString];
}
- (NSString *)psk_Base64EncryptString {
    return [NSString psk_EncodeBase64Data:[self dataUsingEncoding:NSUTF8StringEncoding]];
}
+ (NSString *)psk_EncodeBase64Data:(NSData *)data {
    NSData *encryptBase64Data = [data base64EncodedDataWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    return [[NSString alloc] initWithData:encryptBase64Data encoding:NSUTF8StringEncoding];
}
+ (NSString *)psk_Base64Decrypt:(NSString *)string {
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(string)
    return [string psk_Base64DecryptString];
}
- (NSString *)psk_Base64DecryptString {
    return [NSString psk_DecodeBase64Data:[self dataUsingEncoding:NSUTF8StringEncoding]];
}
+ (NSString *)psk_DecodeBase64Data:(NSData *)data {
    NSData *decryptData = [[NSData alloc] initWithBase64EncodedData:data options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];
}

// AES加密解密(标准的)
+ (NSString *)psk_AESEncrypt:(NSString *)string {
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(string)
    return [string psk_AESEncryptString];
}
- (NSString *)psk_AESEncryptString {
    return [NSString psk_AESEncrypt:self byKey:DEFAULT_KEY];
}
+ (NSString *)psk_AESEncrypt:(NSString *)string byKey:(NSString *)key {
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(string)
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(key)
    NSData *sourceData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptData = [self _psk_AESEncryptData:sourceData byKey:key];
    return [NSString psk_EncodeBase64Data:encryptData];
}
+ (NSData *)_psk_AESEncryptData:(NSData *)data byKey:(NSString *)key {
    char keyPtr[kCCKeySizeAES256 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}
+ (NSString *)psk_AESDecrypt:(NSString *)string {
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(string)
    return [string psk_AESDecryptString];
}
- (NSString *)psk_AESDecryptString {
    return [NSString psk_AESDecrypt:self byKey:DEFAULT_KEY];
}
+ (NSString *)psk_AESDecrypt:(NSString *)string byKey:(NSString *)key {
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(string)
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(key)
    NSData *encryptData = [[NSData alloc] initWithBase64EncodedData:[string dataUsingEncoding:NSUTF8StringEncoding] options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *decryptData = [self _psk_AESDecryptData:encryptData byKey:key];
    return [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];
}
+ (NSData *)_psk_AESDecryptData:(NSData *)data byKey:(NSString *)key {
    char keyPtr[kCCKeySizeAES256 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer);
    return nil;
}

// DES加密解密
+ (NSString *)psk_DESEncrypt:(NSString *)string {
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(string)
    return [string psk_DESEncryptString];
}
- (NSString *)psk_DESEncryptString {
    return [NSString psk_DESEncrypt:self byKey:DEFAULT_KEY];
}
+ (NSString *)psk_DESEncrypt:(NSString *)string byKey:(NSString *)key {
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(string)
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(key)
    NSData *sourceData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptData = [self _psk_DESEncryptData:sourceData byKey:key];
    return [NSString psk_EncodeBase64Data:encryptData];
}
+ (NSData *)_psk_DESEncryptData:(NSData *)data byKey:(NSString *)key {
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeDES;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}
+ (NSString *)psk_DESDecrypt:(NSString *)string {
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(string)
    return [string psk_DESDecryptString];
}
- (NSString *)psk_DESDecryptString {
    return [NSString psk_DESDecrypt:self byKey:DEFAULT_KEY];
}
+ (NSString *)psk_DESDecrypt:(NSString *)string byKey:(NSString *)key {
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(string)
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(key)
    NSData *encryptData = [[NSData alloc] initWithBase64EncodedData:[string dataUsingEncoding:NSUTF8StringEncoding] options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *decryptData = [self _psk_DESDecryptData:encryptData byKey:key];
    return [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];
}
+ (NSData *)_psk_DESDecryptData:(NSData *)data byKey:(NSString *)key {
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeDES;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer);
    return nil;
}

// MD5加密(标准的)
+ (NSString *)psk_MD5Encrypt:(NSString *)string {
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(string)
    return [string psk_MD5EncryptString];
}
- (NSString *)psk_MD5EncryptString {
    NSData *sourceData = [self dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5([sourceData bytes], (unsigned int)[sourceData length], result);
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

// SHA1HASH加密
+ (NSString *)psk_Sha1Hash:(NSString *)string {
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(string)
    return [string psk_Sha1HashString];
}
- (NSString *)psk_Sha1HashString {
    NSData *sourceData = [self dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1([sourceData bytes], (unsigned int)[sourceData length], result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15],
            result[16], result[17], result[18], result[19]
            ];
}

// UTF8编码解码
+ (NSString *)psk_UTF8Encoded:(NSString *)string {
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(string)
    return [string psk_UTF8EncodedString];
}
- (NSString *)psk_UTF8EncodedString {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                 (CFStringRef)self,
                                                                                 NULL,
                                                                                 CFSTR("!*'();@&=+$,?%#[]"),
                                                                                 kCFStringEncodingUTF8));
}
+ (NSString *)psk_UTF8Decoded:(NSString *)string {
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(string)
    return [string psk_UTF8DecodedString];
}
- (NSString *)psk_UTF8DecodedString {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                                 (CFStringRef)self,
                                                                                                 CFSTR(""),
                                                                                                 kCFStringEncodingUTF8));
}

// URL编码解码=UTF8
+ (NSString *)psk_URLEncode:(NSString *)string {
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(string)
    return [string psk_URLEncodeString];
}
- (NSString *)psk_URLEncodeString {
    return  [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
+ (NSString *)psk_URLDecode:(NSString *)string {
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(string)
    return [string psk_URLDecodeString];
}
- (NSString *)psk_URLDecodeString {
    return [self psk_UTF8DecodedString];
}
@end



//==============================================================================
//
//  NSString扩展——常用目录
//
//==============================================================================
@implementation NSString (Directory)
+ (NSString *)psk_directoryPathOfBundle {
    static dispatch_once_t pred = 0;
    __strong static NSString *path = @"";
    dispatch_once(&pred, ^{
        path = [[NSBundle mainBundle] resourcePath];
    });
    return path;
}
+ (NSString *)psk_directoryPathOfHome {
    static dispatch_once_t pred = 0;
    __strong static NSString *path = @"";
    dispatch_once(&pred, ^{
        path = NSHomeDirectory();
    });
    return path;
}
+ (NSString *)psk_directoryPathOfDocuments {
    static dispatch_once_t pred = 0;
    __strong static NSString *path = @"";
    dispatch_once(&pred, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if ([paths count] > 0) {
            path = [NSString stringWithFormat:@"%@", paths[0]];
        }
    });
    return path;
}
+ (NSString *)psk_directoryPathOfLibrary {
    static dispatch_once_t pred = 0;
    __strong static NSString *path = @"";
    dispatch_once(&pred, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        if ([paths count] > 0) {
            path = [NSString stringWithFormat:@"%@", paths[0]];
        }
    });
    return path;
}
+ (NSString *)psk_directoryPathOfLibraryCaches {
    static dispatch_once_t pred = 0;
    __strong static NSString *path = @"";
    dispatch_once(&pred, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        if ([paths count] > 0) {
            path = [NSString stringWithFormat:@"%@", paths[0]];
        }
    });
    return path;
}
+ (NSString *)psk_directoryPathOfLibraryCachesBundleIdentifier {
    static dispatch_once_t pred = 0;
    __strong static NSString *path = @"";
    dispatch_once(&pred, ^{
        NSString *appBundleId = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
        path = [[self psk_directoryPathOfLibraryCaches] stringByAppendingPathComponent:appBundleId];
    });
    return path;
}
+ (NSString *)psk_directoryPathOfLibraryPreferences {
    static dispatch_once_t pred = 0;
    __strong static NSString *path = @"";
    dispatch_once(&pred, ^{
        path = [[self psk_directoryPathOfLibrary] stringByAppendingPathComponent:@"Preferences"];
    });
    return path;
}
+ (NSString *)psk_directoryPathOfTmp {
    static dispatch_once_t pred = 0;
    __strong static NSString *path = @"";
    dispatch_once(&pred, ^{
        path = NSTemporaryDirectory();
    });
    return path;
}
@end



//==============================================================================
//
//  针对NSString扩展——动态大小
//
//==============================================================================
@implementation NSString (DynamicSize)
+ (CGFloat)psk_heightOfNormalString:(NSString*)string maxWidth:(CGFloat)width withFont:(UIFont*)font {
    CGSize size;
#if IOS7_OR_LATER
    size = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                             attributes:@{NSFontAttributeName : font}
                                context:nil].size;
#else
    size = [string sizeWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
#endif
    return size.height;
}
+ (CGFloat)psk_widthOfNormalString:(NSString*)string maxHeight:(CGFloat)height withFont:(UIFont*)font {
    CGSize size;
#if IOS7_OR_LATER
    size = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX,height)
                                options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                             attributes:@{NSFontAttributeName : font}
                                context:nil].size;
#else
    size = [string sizeWithFont:font constrainedToSize:CGSizeMake(CGFLOAT_MAX, height) lineBreakMode:NSLineBreakByWordWrapping];
#endif
    return size.width;
}
+ (CGFloat)psk_heightOfNormalString:(NSString*)string maxWidth:(CGFloat)width withFont:(UIFont*)font lineSpace:(CGFloat)lineSpace {
    CGSize size;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;
    size = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                             attributes:@{NSFontAttributeName : font, NSParagraphStyleAttributeName : paragraphStyle}
                                context:nil].size;
    return size.height;
}
+ (BOOL)psk_isContainsEmoji:(NSString *)string {
    __block BOOL isEomji = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     isEomji = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 isEomji = YES;
             }
         } else {
             if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                 isEomji = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 isEomji = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 isEomji = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 isEomji = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                 isEomji = YES;
             }
         }
     }];
    return isEomji;
}
@end



//==============================================================================
//
//  针对NSString扩展——显示html文本
//
//==============================================================================
@implementation NSString (Html)
+ (void)psk_layoutHtmlString:(NSString *)htmlString onView:(UIView *)view {
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding]
                                                                   options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}
                                                        documentAttributes:nil
                                                                     error:nil];
    if ([view respondsToSelector:@selector(setAttributedText:)]) {
        [view performSelector:@selector(setAttributedText:) withObject:attrStr];
    }
}
+ (void)psk_fillMutableAttributedString:(NSMutableAttributedString *)attributedString byRegular:(NSRegularExpression *)regular attributes:(NSDictionary *)attributes {
    RETURN_WHEN_OBJECT_IS_EMPTY(attributedString)
    RETURN_WHEN_OBJECT_IS_EMPTY(attributedString.string)
    RETURN_WHEN_OBJECT_IS_EMPTY(regular)
    
    NSRange stringRange = NSMakeRange(0, [attributedString.string length]);
    [regular enumerateMatchesInString:attributedString.string
                              options:0
                                range:stringRange
                           usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                               //0. 获取到匹配的范围
                               NSRange matchRange = [result range];
                               //1. 设置通用的attribute
                               if (attributes) {
                                   [attributedString addAttributes:attributes range:matchRange];
                               }
                               //2. 分别设置匹配项目的attribute
                               if ([result resultType] == NSTextCheckingTypeLink) {
                                   NSURL *url = [result URL];
                                   [attributedString addAttribute:NSLinkAttributeName value:url range:matchRange];
                               }
                               else if ([result resultType] == NSTextCheckingTypePhoneNumber) {
                                   NSString *phoneNumber = [result phoneNumber];
                                   [attributedString addAttribute:NSLinkAttributeName value:phoneNumber range:matchRange];
                               }
                               else {
                                   //其它特殊内容
                               }
                           }];
    
}
@end



//==============================================================================
//
//  各种证件号码(身份证、警官证、军官证)合法性判断
//
//==============================================================================
@implementation NSString (IdentityNumber)
+ (BOOL)psk_verifyIDCardNumber:(NSString *)value {
    RETURN_NO_WHEN_OBJECT_IS_EMPTY(value);
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([value length] != 18) {
        return NO;
    }
    NSString *mmdd = @"(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8])))";
    NSString *leapMmdd = @"0229";
    NSString *year = @"(19|20)[0-9]{2}";
    NSString *leapYear = @"(19|20)(0[48]|[2468][048]|[13579][26])";
    NSString *yearMmdd = [NSString stringWithFormat:@"%@%@", year, mmdd];
    NSString *leapyearMmdd = [NSString stringWithFormat:@"%@%@", leapYear, leapMmdd];
    NSString *yyyyMmdd = [NSString stringWithFormat:@"((%@)|(%@)|(%@))", yearMmdd, leapyearMmdd, @"20000229"];
    NSString *area = @"(1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|82|[7-9]1)[0-9]{4}";
    NSString *regex = [NSString stringWithFormat:@"%@%@%@", area, yyyyMmdd  , @"[0-9]{3}[0-9Xx]"];
    
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ( ! [regexTest evaluateWithObject:value]) {
        return NO;
    }
    int summary = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7
    + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9
    + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10
    + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5
    + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8
    + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4
    + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2
    + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6
    + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
    NSInteger remainder = summary % 11;
    NSString *checkBit = @"";
    NSString *checkString = @"10X98765432";
    checkBit = [checkString substringWithRange:NSMakeRange(remainder,1)];// 判断校验位
    return [checkBit isEqualToString:[[value substringWithRange:NSMakeRange(17,1)] uppercaseString]];
}
+ (BOOL)psk_verifyCardNumberWithSoldier:(NSString *)value {
    RETURN_NO_WHEN_OBJECT_IS_EMPTY(value);
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *s1 = @"^\\d*$";
    NSString *s2 = @"^.{1,}字第\\d{4,}$";
    if ([NSString psk_isMatchRegex:s1 withString:value]) {
        return [NSString psk_isMatchRegex:@"^\\d{4,20}$" withString:value];
    }
    else if ([NSString psk_lengthUsingChineseCharacterCountByTwo:value] >= 10
             && [NSString psk_lengthUsingChineseCharacterCountByTwo:value] <= 20) {
        return [NSString psk_isMatchRegex:s2 withString:value];
    }
    return NO;
}
+ (NSUInteger)psk_lengthUsingChineseCharacterCountByTwo:(NSString *)string{
    NSUInteger count = 0;
    for (NSUInteger i = 0; i< string.length; ++i) {
        if ([string characterAtIndex:i] < 256) {
            count++;
        } else {
            count += 2;
        }
    }
    return count;
}
+ (NSString *)psk_getBirthdayByIDCardNumber:(NSString *)IDCardNumber {
    IDCardNumber = [IDCardNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([IDCardNumber length] != 18) {
        return nil;
    }
    NSString *birthady = [NSString stringWithFormat:@"%@年%@月%@日",
                          [IDCardNumber substringWithRange:NSMakeRange(6,4)],
                          [IDCardNumber substringWithRange:NSMakeRange(10,2)],
                          [IDCardNumber substringWithRange:NSMakeRange(12,2)]];
    return birthady;
}
+ (NSInteger)psk_getGenderByIDCardNumber:(NSString *)IDCardNumber {
    IDCardNumber = [IDCardNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSInteger defaultValue = 0;
    if ([IDCardNumber length] != 18) {
        return defaultValue;
    }
    NSInteger number = [[IDCardNumber substringWithRange:NSMakeRange(16,1)] integerValue];
    if (number % 2 == 0) {  //偶数为女
        return 0;
    } else {
        return 1;
    }
}
@end