//
//  NSString+YSCKit.m
//  YSCKit
//
//  Created by  YangShengchao on 14-7-2.
//  Copyright (c) 2014年 yangshengchao. All rights reserved.
//

#import "NSString+YSCKit.h"
#import "NSData+YSCKit.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

NSString * const kRegexWebUrl = @"((http|ftp|https)://)(([a-zA-Z0-9\\._-]+\\.[a-zA-Z]{2,6})|([0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}))(:[0-9]{1,4})*(/[a-zA-Z0-9\\&%_\\./-~-]*)?";

////////////////////////////////////////////////////////////////////////////////
//
//  针对NSString扩展
//
////////////////////////////////////////////////////////////////////////////////
@implementation NSString (YSCKit)

#pragma mark - 静态方法

+ (BOOL)isEmptyConsiderWhitespace:(NSString *)string {
    RETURN_YES_WHEN_OBJECT_IS_EMPTY(string)
    return ![[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length];
}
+ (BOOL)isNotEmptyConsiderWhitespace:(NSString *)string {
    return ( ! [self isEmptyConsiderWhitespace:string]);
}


#pragma mark - 字符串合法性判断
+ (BOOL)isContains:(NSString *)subString inString:(NSString *)string {
    RETURN_NO_WHEN_OBJECT_IS_EMPTY(string)
    return [string isContains:subString];
}
- (BOOL)isContains:(NSString *)subString {
    RETURN_NO_WHEN_OBJECT_IS_EMPTY(subString)
	return [self rangeOfString:subString].location != NSNotFound;
}

+ (BOOL)isMatchRegex:(NSString*)pattern withString:(NSString *)string {
    RETURN_NO_WHEN_OBJECT_IS_EMPTY(string)
    return [string isMatchRegex:pattern options:NSRegularExpressionAnchorsMatchLines];
}
+ (BOOL)isMatchRegex:(NSString*)pattern withString:(NSString *)string options:(NSRegularExpressionOptions)options {
    RETURN_NO_WHEN_OBJECT_IS_EMPTY(string)
    return [string isMatchRegex:pattern options:options];
}
- (BOOL)isMatchRegex:(NSString *)pattern options:(NSRegularExpressionOptions)options {
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

+ (BOOL)isWebUrl:(NSString *)string {
    RETURN_NO_WHEN_OBJECT_IS_EMPTY(string)
    return [string isWebUrl];
}
- (BOOL)isWebUrl {
    return [NSString isMatchRegex:kRegexWebUrl withString:self];
}
+ (BOOL)isNotWebUrl:(NSString *)string {
    return ![self isWebUrl:string];
}


#pragma mark - 字符串简单变换
+ (NSString *)trimString:(NSString *)string {
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(string)
    return [string trimString];
}

- (NSString *)trimString {
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
//将json字符串转换成dict
+ (NSObject *)jsonObjectOfString:(NSString *)string {
    RETURN_NIL_WHEN_OBJECT_IS_EMPTY(string)
    return [string jsonObjectOfString];
}
- (NSObject *)jsonObjectOfString {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSObject *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    return json;
}
//将id对象转换成json字符串
+ (NSString *)jsonStringWithObject:(id)object {
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

+ (NSString *)replaceString:(NSString *)string byRegex:(NSString *)pattern to:(NSString *)toString {
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(string)
    return [string replaceByRegex:pattern to:toString options:NSRegularExpressionCaseInsensitive];
}
+ (NSString *)replaceString:(NSString *)string byRegex:(NSString *)pattern to:(NSString *)toString options:(NSRegularExpressionOptions)options {
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(string)
    return [string replaceByRegex:pattern to:toString options:options];
}
- (NSString *)replaceByRegex:(NSString *)pattern to:(NSString *)toString options:(NSRegularExpressionOptions)options{
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
    return [[expression stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, [self length]) withTemplate:toString] trimString];
}
//计算字符串的长度（1个英文字母为1个字节，1个汉字为2个字节）
+ (NSInteger)stringLength:(NSString *)string {
    RETURN_ZERO_WHEN_OBJECT_IS_EMPTY(string)
    return [string stringLength];
}
- (NSInteger)stringLength {
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
//    
//    // Look for spaces, tabs and newlines
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
+ (NSString *)removeLastCharOfString:(NSString *)string {
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(string)
    return [string removeLastChar];
}
- (NSString *)removeLastChar {
    return [self substringToIndex:[self length] - 1];
}
+ (void)removeLastCharOfMutableString:(NSMutableString *)mutableString {
    RETURN_WHEN_OBJECT_IS_EMPTY(mutableString)
    [mutableString deleteCharactersInRange:NSMakeRange([mutableString length] - 1, 1)];
}
//获取末尾N个字符
+ (NSString *)substringFromEnding:(NSString *)string count:(NSInteger)count {
    return [string substringFromEnding:count];
}
- (NSString *)substringFromEnding:(NSInteger)count {
    NSString *str = TRIM_STRING(self);
    return [str substringFromIndex:MAX((int)[str length] - count, 0)];
}

#pragma mark - 汉字转拼音
+ (NSString *)toPinYin:(NSString *)hanzi {
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(hanzi)
    return [hanzi toPinYin];
}
- (NSString *)toPinYin {
    NSMutableString *mutableString = [NSMutableString stringWithString:self];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    mutableString = (NSMutableString *)[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    return [NSString stringWithString:mutableString];
}

#pragma mark - 字符串分解
+ (NSArray *)splitString:(NSString *)string byRegex:(NSString *)pattern {
    if (OBJECT_IS_EMPTY(string)) {
        return @[];
    }
    return [string splitByRegex:pattern options:NSRegularExpressionCaseInsensitive];
}
+ (NSArray *)splitString:(NSString *)string byRegex:(NSString *)pattern options:(NSRegularExpressionOptions)options{
    if (OBJECT_IS_EMPTY(string)) {
        return @[];
    }
    return [string splitByRegex:pattern options:options];
}
- (NSArray *)splitByRegex:(NSString *)pattern {
    return [self splitByRegex:pattern options:NSRegularExpressionCaseInsensitive];
}
- (NSArray *)splitByRegex:(NSString *)pattern options:(NSRegularExpressionOptions)options {
    if (OBJECT_IS_EMPTY(pattern)) {
        return @[];
    }
#define SpecialPlaceholderString @"_&&_"   //特殊占位符
    NSString *newString = [self replaceByRegex:pattern to:SpecialPlaceholderString options:options];
    NSArray *sourceArray = [newString componentsSeparatedByString:SpecialPlaceholderString];
	NSMutableArray *components = [NSMutableArray array];
	for (NSString *component in sourceArray) {
		if (![NSString isEmptyConsiderWhitespace:component]) {
			[components addObject:[component trimString]];
		}
	}
	return components;
}

+ (NSArray *)matchesInString:(NSString *)string byRegex:(NSString *)pattern {
    if (OBJECT_IS_EMPTY(string)) {
        return @[];
    }
    return [string matchesByRegex:pattern options:NSRegularExpressionCaseInsensitive];
}
+ (NSArray *)matchesInString:(NSString *)string byRegex:(NSString *)pattern options:(NSRegularExpressionOptions)options {
    if (OBJECT_IS_EMPTY(string)) {
        return @[];
    }
    return [string matchesByRegex:pattern options:options];
}
- (NSArray *)matchesByRegex:(NSString *)pattern options:(NSRegularExpressionOptions)options {
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






////////////////////////////////////////////////////////////////////////////////
//
//  针对NSString扩展——加密解密
//
////////////////////////////////////////////////////////////////////////////////
@implementation NSString (Security)

#define DEFAULTKEY      @"6yc*2JK?00000000"                     //默认秘钥

#pragma mark - base64加密解密(标准的)
+ (NSString *)Base64Encrypt:(NSString *)string {
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(string)
    return [string Base64EncryptString];
}
- (NSString *)Base64EncryptString {
    return [NSString EncodeBase64Data:[self dataUsingEncoding:NSUTF8StringEncoding]];
}
+ (NSString *)EncodeBase64Data:(NSData *)data {
    NSData *encryptBase64Data = [data base64EncodedDataWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    return [[NSString alloc] initWithData:encryptBase64Data encoding:NSUTF8StringEncoding];
}
+ (NSString *)Base64Decrypt:(NSString *)string {
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(string)
    return [string Base64DecryptString];
}
- (NSString *)Base64DecryptString {
    return [NSString DecodeBase64Data:[self dataUsingEncoding:NSUTF8StringEncoding]];
}
+ (NSString *)DecodeBase64Data:(NSData *)data {
    NSData *decryptData = [[NSData alloc] initWithBase64EncodedData:data options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];
}


#pragma mark - AES加密解密(标准的)
+ (NSString *)AESEncrypt:(NSString *)string {
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(string)
    return [string AESEncryptString];
}
- (NSString *)AESEncryptString {
	return [NSString AESEncrypt:self byKey:DEFAULTKEY];
}
+ (NSString *)AESEncrypt:(NSString *)string byKey:(NSString *)key {
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(string)
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(key)
	NSData *sourceData = [string dataUsingEncoding:NSUTF8StringEncoding];
	NSData *encryptData = [self AESEncryptData:sourceData byKey:key];
    return [NSString EncodeBase64Data:encryptData];
}
//私有方法
+ (NSData *)AESEncryptData:(NSData *)data byKey:(NSString *)key {
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
+ (NSString *)AESDecrypt:(NSString *)string {
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(string)
	return [string AESDecryptString];
}
- (NSString *)AESDecryptString {
    return [NSString AESDecrypt:self byKey:DEFAULTKEY];
}
+ (NSString *)AESDecrypt:(NSString *)string byKey:(NSString *)key {
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(string)
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(key)
    NSData *encryptData = [[NSData alloc] initWithBase64EncodedData:[string dataUsingEncoding:NSUTF8StringEncoding] options:NSDataBase64DecodingIgnoreUnknownCharacters];
	NSData *decryptData = [self AESDecryptData:encryptData byKey:key];
	return [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];
}
//私有方法
+ (NSData *)AESDecryptData:(NSData *)data byKey:(NSString *)key {
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

#pragma mark - AES加密解密(与java调通)
+ (NSString *)AESEncrypt1:(NSString *)string byKey:(NSString *)key {
    CCCryptorStatus status = kCCSuccess;
    NSData* result = [[string dataUsingEncoding:NSUTF8StringEncoding]
                      dataEncryptedUsingAlgorithm:kCCAlgorithmAES128
                      key:key
                      initializationVector:nil   // ECB加密不会用到iv
                      options:(kCCOptionPKCS7Padding|kCCOptionECBMode)
                      error:&status];
    if (status != kCCSuccess) {
        NSLog(@"加密失败:%d", status);
        return nil;
    }
    return [NSString EncodeBase64Data:result];
}
+ (NSString *)AESDecrypt1:(NSString *)string byKey:(NSString *)key {
    CCCryptorStatus status = kCCSuccess;
    NSData *decryptData = [[NSData alloc] initWithBase64EncodedData:[string dataUsingEncoding:NSUTF8StringEncoding]
                                                            options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData* result = [decryptData
                      decryptedDataUsingAlgorithm:kCCAlgorithmAES128
                      key:key
                      initializationVector:nil   // ECB解密不会用到iv
                      options:(kCCOptionPKCS7Padding|kCCOptionECBMode)
                      error:&status];
    if (status != kCCSuccess) {
        NSLog(@"解密失败:%d", status);
        return nil;
    }
    return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
}



#pragma mark - DES加密解密
+ (NSString *)DESEncrypt:(NSString *)string {
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(string)
	return [string DESEncryptString];
}
- (NSString *)DESEncryptString {
    return [NSString DESEncrypt:self byKey:DEFAULTKEY];
}
+ (NSString *)DESEncrypt:(NSString *)string byKey:(NSString *)key {
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(string)
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(key)
	NSData *sourceData = [string dataUsingEncoding:NSUTF8StringEncoding];
	NSData *encryptData = [self DESEncryptData:sourceData byKey:key];
    return [NSString EncodeBase64Data:encryptData];
}
//私有方法
+ (NSData *)DESEncryptData:(NSData *)data byKey:(NSString *)key {
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
+ (NSString *)DESDecrypt:(NSString *)string {
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(string)
	return [string DESDecryptString];
}
- (NSString *)DESDecryptString {
    return [NSString DESDecrypt:self byKey:DEFAULTKEY];
}
+ (NSString *)DESDecrypt:(NSString *)string byKey:(NSString *)key {
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(string)
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(key)
	NSData *encryptData = [[NSData alloc] initWithBase64EncodedData:[string dataUsingEncoding:NSUTF8StringEncoding] options:NSDataBase64DecodingIgnoreUnknownCharacters];
	NSData *decryptData = [self DESDecryptData:encryptData byKey:key];
    return [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];
}
//私有方法
+ (NSData *)DESDecryptData:(NSData *)data byKey:(NSString *)key {
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

#pragma mark - RSA加密解密
//TODO:需要调用openssl标准函数实现



#pragma mark - MD5加密(标准的)
+ (NSString *)MD5Encrypt:(NSString *)string {
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(string)
    return [string MD5EncryptString];
}
- (NSString*)MD5EncryptString {
    NSData *sourceData = [self dataUsingEncoding:NSUTF8StringEncoding];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5([sourceData bytes], (unsigned int)[sourceData length], result);
    
	return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
	        result[0], result[1], result[2], result[3],
	        result[4], result[5], result[6], result[7],
	        result[8], result[9], result[10], result[11],
	        result[12], result[13], result[14], result[15]
            ];
}

#pragma mark - SHA1HASH加密
+ (NSString *)Sha1Hash:(NSString *)string {
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(string)
    return [string Sha1HashString];
}
- (NSString *)Sha1HashString {
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

#pragma mark UTF8编码解码
+ (NSString *)UTF8Encoded:(NSString *)string {
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(string)
    return [string UTF8EncodedString];
}
- (NSString *)UTF8EncodedString {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                 (CFStringRef)self,
                                                                                 NULL,
                                                                                 CFSTR("!*'();@&=+$,?%#[]"),
                                                                                 kCFStringEncodingUTF8));
}
+ (NSString *)UTF8Decoded:(NSString *)string {
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(string)
    return [string UTF8DecodedString];
}
- (NSString *)UTF8DecodedString {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                                 (CFStringRef)self,
                                                                                                 CFSTR(""),
                                                                                                 kCFStringEncodingUTF8));
}

#pragma mark - URL编码解码=UTF8
+ (NSString *)URLEncode:(NSString *)string {
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(string)
    return [string URLEncodeString];
}
- (NSString *)URLEncodeString {
    
    return  [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

//    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
//                                                                                 (CFStringRef)self,
//                                                                                 NULL,
//                                                                                 CFSTR("/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"),
//                                                                                 kCFStringEncodingUTF8));
}
+ (NSString *)URLDecode:(NSString *)string {
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(string)
    return [string URLDecodeString];
}
- (NSString *)URLDecodeString {
    return [self UTF8DecodedString];
}
#pragma mark - bin2hex
+ (NSString *)hexFromString:(NSString *)string {
    NSUInteger len = [string length];
    unichar *chars = malloc(len * sizeof(unichar));
    [string getCharacters:chars];
    NSMutableString *hexString = [[NSMutableString alloc] init];
    for(NSUInteger i = 0; i < len; i++ ) {
        [hexString appendString:[NSString stringWithFormat:@"%x", chars[i]]];
    }
    free(chars);
    return hexString;
}
+ (NSString *)stringFromHex:(NSString *)hexString {
    return hexString;//TODO:
}


#pragma mark - 私有方法
/**
 *  将NSData数组转换成十六进制字符串
 *
 */
+ (NSString *)dataBytesToHexString:(NSData *)data {
	NSMutableString *stringBuffer = [NSMutableString stringWithCapacity:([data length] * 2)];
	const unsigned char *dataBuffer = [data bytes];
	int i;
	for (i = 0; i <= [data length]; ++i) {
		[stringBuffer appendFormat:@"%02lX", (unsigned long)dataBuffer[i]];
	}
	return [stringBuffer copy];
}

/**
 *  将十六进制字符串转化成NSData数组
 *
 */
+ (NSData *)hexStringToDataBytes:(NSString *)string {
	NSMutableData *data = [NSMutableData data];
	int idx;
	for (idx = 0; idx + 2 < string.length; idx += 2) {
		NSString *hexStr = [string substringWithRange:NSMakeRange(idx, 2)];
		NSScanner *scanner = [NSScanner scannerWithString:hexStr];
		unsigned int intValue;
		[scanner scanHexInt:&intValue];
		[data appendBytes:&intValue length:1];
	}
	return data;
}

@end





////////////////////////////////////////////////////////////////////////////////
//
//  针对NSString扩展——动态大小
//
////////////////////////////////////////////////////////////////////////////////
@implementation NSString (DynamicSize)
+ (CGFloat)HeightOfNormalString:(NSString*)string maxWidth:(CGFloat)width withFont:(UIFont*)font {
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
+ (CGFloat)WidthOfNormalString:(NSString*)string maxHeight:(CGFloat)height withFont:(UIFont*)font {
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
+ (CGFloat)HeightOfNormalString:(NSString*)string maxWidth:(CGFloat)width withFont:(UIFont*)font lineSpace:(CGFloat)lineSpace {
    CGSize size;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;
    size = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                             attributes:@{NSFontAttributeName : font, NSParagraphStyleAttributeName : paragraphStyle}
                                context:nil].size;
    return size.height;
}
//判断是否包含表情符号(有问题)
+ (BOOL)isContainsEmoji:(NSString *)string {
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



////////////////////////////////////////////////////////////////////////////////
//
//  针对NSString扩展——显示html文本
//
////////////////////////////////////////////////////////////////////////////////
@implementation NSString (Html)
// UIView(UILabel/UITextField/UITextView)上显示HTML
//只能显示HTML内容，但不能点击链接
+ (void)layoutHtmlString:(NSString *)htmlString onView:(UIView *)view {
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding]
                                                                   options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}
                                                        documentAttributes:nil
                                                                     error:nil];
    if ([view respondsToSelector:@selector(setAttributedText:)]) {
        [view performSelector:@selector(setAttributedText:) withObject:attrStr];
    }
}
+ (void)fillMutableAttributedString:(NSMutableAttributedString *)attributedString byRegular:(NSRegularExpression *)regular attributes:(NSDictionary *)attributes {
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



@implementation NSString(IdentityNumber)

//验证身份证
//必须满足以下规则
//1. 长度必须是18位，前17位必须是数字，第十八位可以是数字或X
//2. 前两位必须是以下情形中的一种：11,12,13,14,15,21,22,23,31,32,33,34,35,36,37,41,42,43,44,45,46,50,51,52,53,54,61,62,63,64,65,71,81,82,91
//3. 第7到第14位出生年月日。第7到第10位为出生年份；11到12位表示月份，范围为01-12；13到14位为合法的日期
//4. 第17位表示性别，双数表示女，单数表示男
//5. 第18位为前17位的校验位
//算法如下：
//（1）校验和 = (n1 + n11) * 7 + (n2 + n12) * 9 + (n3 + n13) * 10 + (n4 + n14) * 5 + (n5 + n15) * 8 + (n6 + n16) * 4 + (n7 + n17) * 2 + n8 + n9 * 6 + n10 * 3，其中n数值，表示第几位的数字
//（2）余数 ＝ 校验和 % 11
//（3）如果余数为0，校验位应为1，余数为1到10校验位应为字符串“0X98765432”(不包括分号)的第余数位的值（比如余数等于3，校验位应为9）
//6. 出生年份的前两位必须是19或20
+ (BOOL)verifyIDCardNumber:(NSString *)value {
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

//验证军官证或警官证
//必须是下面两种格式中的一种
//格式一：4到20位数字
//格式二：大于或等于10位并且小于等于20位（中文按两位），并满足以下规则
//1）必须有“字第”两字
//2）“字第”前面有至少一个字符
//3）“字第”后是4位以上数字
+ (BOOL)verifyCardNumberWithSoldier:(NSString *)value {
    RETURN_NO_WHEN_OBJECT_IS_EMPTY(value);
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *s1 = @"^\\d*$";
    NSString *s2 = @"^.{1,}字第\\d{4,}$";
    if ([NSString isMatchRegex:s1 withString:value]) {
        return [NSString isMatchRegex:@"^\\d{4,20}$" withString:value];
    }
    else if ([NSString lengthUsingChineseCharacterCountByTwo:value] >= 10
             && [NSString lengthUsingChineseCharacterCountByTwo:value] <= 20) {
        return [NSString isMatchRegex:s2 withString:value];
    }
    return NO;
}

+ (NSUInteger)lengthUsingChineseCharacterCountByTwo:(NSString *)string{
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

//得到身份证的生日****这个方法中不做身份证校验，请确保传入的是正确身份证
+ (NSString *)getIDCardBirthday:(NSString *)card {
    card = [card stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([card length] != 18) {
        return nil;
    }
    NSString *birthady = [NSString stringWithFormat:@"%@年%@月%@日",
                          [card substringWithRange:NSMakeRange(6,4)],
                          [card substringWithRange:NSMakeRange(10,2)],
                          [card substringWithRange:NSMakeRange(12,2)]];
    return birthady;
}

//得到身份证的性别（1男0女）****这个方法中不做身份证校验，请确保传入的是正确身份证
+ (NSInteger)getIDCardSex:(NSString *)card {
    card = [card stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSInteger defaultValue = 0;
    if ([card length] != 18) {
        return defaultValue;
    }
    NSInteger number = [[card substringWithRange:NSMakeRange(16,1)] integerValue];
    if (number % 2 == 0) {  //偶数为女
        return 0;
    } else {
        return 1;
    }
}

@end


