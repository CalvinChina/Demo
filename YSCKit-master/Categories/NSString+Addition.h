//
//  NSString+Addition.h
//  YSCKit
//
//  Created by  YangShengchao on 14-7-2.
//  Copyright (c) 2014年 yangshengchao. All rights reserved.
//  FORMATED!
//

#import <Foundation/Foundation.h>

#define RegexEmail          @"^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$"
#define RegexMobilePhone    @"(^(01|1))\\d{10}$"
#define RegexUserName       @"^[A-Za-z0-9]{6,20}+$"
#define RegexPassword       @"^[a-zA-Z0-9]{6,20}+$"
#define RegexRealName       @"^[a-zA-Z0-9\u4E00-\u9FA5 ]{1,10}+$" //@"^[^\W]$"
#define RegexNickName       @"^[\u4e00-\u9fa5]{4,8}$"
#define RegexSimpleIdentityCard     @"^(\\d{14}|\\d{17})(\\d|[xX])$"//简单身份证合法性判断
#define RegexAllNumbers     @"^[0-9]\\d*$"
#define RegexUrl            @"((http|ftp|https)://)(([a-zA-Z0-9\\._-]+\\.[a-zA-Z]{2,6})|([0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}))(:[0-9]{1,4})*(/[a-zA-Z0-9\\&%_\\./-~-]*)?"
#define RegexSimpleChinese  @"^[\u4E00-\u9FA5]+"  //匹配汉字


/*
 *
 * 注意：本类所有的实例方法都有其对应的静态方法
 * 原因：静态方法有判空处理，实例方法没有，所以使用实例方法有一定的风险，必须自己判空；
 *
 */


///////////////////////////////////////////////////////////////////////////////////////////////////
//
//  针对NSString扩展——常用方法
//
///////////////////////////////////////////////////////////////////////////////////////////////////
@interface NSString (Addition)

/**
 *  除了三个条件(1-是否为nil 2-是否为NSNull 3-长度是否为0)外，还考虑了是否全部是空格的情况
 *  @return YES/NO
 */
+ (BOOL)isEmptyConsiderWhitespace:(NSString *)string;
+ (BOOL)isNotEmptyConsiderWhitespace:(NSString *)string;


#pragma mark - 字符串合法性判断
+ (BOOL)isContains:(NSString *)subString inString:(NSString *)string;
- (BOOL)isContains:(NSString *)subString;
+ (BOOL)isMatchRegexType:(RegexType)regexType withString:(NSString *)string;
- (BOOL)isMatchRegexType:(RegexType)regexType;

+ (BOOL)isMatchRegex:(NSString*)pattern withString:(NSString *)string;
+ (BOOL)isMatchRegex:(NSString*)pattern withString:(NSString *)string options:(NSRegularExpressionOptions)options;
- (BOOL)isMatchRegex:(NSString*)pattern options:(NSRegularExpressionOptions)options;

+ (BOOL)isUrl:(NSString *)string;
- (BOOL)isUrl;
+ (BOOL)isNotUrl:(NSString *)string;

#pragma mark - 字符串比较
/**
 *  比较两个版本号的大小
 *  @return -1:version1小  0:两者相等  1:version1大
 */
+ (VersionCompareResult)compareBetweenVersion:(NSString *)version1 withVersion:(NSString *)version2;
- (VersionCompareResult)compareWithVersion:(NSString *)version2;


#pragma mark - 字符串简单变换
+ (NSString *)trimString:(NSString *)string;
- (NSString *)trimString;
//将json字符串转换成dict
+ (NSObject *)jsonObjectOfString:(NSString *)string;
- (NSObject *)jsonObjectOfString;
//将id对象转换成json字符串
+ (NSString *)jsonStringWithObject:(id)object;
//把符合pattern正则表达式的字符串替换成toString (默认是大小写敏感的)
+ (NSString *)replaceString:(NSString *)string byRegex:(NSString *)pattern to:(NSString *)toString;
+ (NSString *)replaceString:(NSString *)string byRegex:(NSString *)pattern to:(NSString *)toString options:(NSRegularExpressionOptions)options;
- (NSString *)replaceByRegex:(NSString *)pattern to:(NSString *)toString options:(NSRegularExpressionOptions)options;
//计算字符串的长度（1个英文字母为1个字节，1个汉字为2个字节）
+ (NSInteger)StringLength:(NSString *)string;
- (NSInteger)StringLength;
//移除字符串最后一个字符
+ (NSString *)removeLastCharOfString:(NSString *)string;
- (NSString *)removeLastChar;
+ (void)removeLastCharOfMutableString:(NSMutableString *)mutableString;
//获取末尾N个字符
+ (NSString *)substringFromEnding:(NSString *)string count:(NSInteger)count;
- (NSString *)substringFromEnding:(NSInteger)count;

#pragma mark - 汉字转拼音
+ (NSString *)toPinYin:(NSString *)hanzi;
- (NSString *)toPinYin;

#pragma mark - 字符串分解
//根据分隔符切分字符串为数组 (默认是大小写敏感的)
+ (NSArray *)splitString:(NSString *)string byRegex:(NSString *)pattern;
+ (NSArray *)splitString:(NSString *)string byRegex:(NSString *)pattern options:(NSRegularExpressionOptions)options;
- (NSArray *)splitByRegex:(NSString *)pattern;
- (NSArray *)splitByRegex:(NSString *)pattern options:(NSRegularExpressionOptions)options;
//返回匹配regex的数组 (默认是大小写敏感的)
+ (NSArray *)matchesInString:(NSString *)string byRegex:(NSString *)pattern;
+ (NSArray *)matchesInString:(NSString *)string byRegex:(NSString *)pattern options:(NSRegularExpressionOptions)options;
- (NSArray *)matchesByRegex:(NSString *)pattern options:(NSRegularExpressionOptions)options;

@end


///////////////////////////////////////////////////////////////////////////////////////////////////
//
//  针对NSString扩展——加密解密
//
///////////////////////////////////////////////////////////////////////////////////////////////////
@interface NSString (Security)

#pragma mark - base64加密解密(标准的)
+ (NSString *)Base64Encrypt:(NSString *)string;
- (NSString *)Base64EncryptString;
+ (NSString *)EncodeBase64Data:(NSData *)data;
+ (NSString *)Base64Decrypt:(NSString *)string;
- (NSString *)Base64DecryptString;
+ (NSString *)DecodeBase64Data:(NSData *)data;

#pragma mark - AES加密解密(标准的)
+ (NSString *)AESEncrypt:(NSString *)string;
- (NSString *)AESEncryptString;
+ (NSString *)AESEncrypt:(NSString *)string byKey:(NSString *)key;

+ (NSString *)AESDecrypt:(NSString *)string;
- (NSString *)AESDecryptString;
+ (NSString *)AESDecrypt:(NSString *)string byKey:(NSString *)key;

#pragma mark - AES加密解密(与java调通)
+ (NSString *)AESEncrypt1:(NSString *)string byKey:(NSString *)key;
+ (NSString *)AESDecrypt1:(NSString *)string byKey:(NSString *)key;

#pragma mark - DES加密解密
+ (NSString *)DESEncrypt:(NSString *)string;
- (NSString *)DESEncryptString;
+ (NSString *)DESEncrypt:(NSString *)string byKey:(NSString *)key;

+ (NSString *)DESDecrypt:(NSString *)string;
- (NSString *)DESDecryptString;
+ (NSString *)DESDecrypt:(NSString *)string byKey:(NSString *)key;


#pragma mark - RSA加密解密
//TODO:需要调用openssl标准函数实现

#pragma mark - MD5加密(标准的)
+ (NSString*)MD5Encrypt:(NSString*)string;
- (NSString*)MD5EncryptString;

#pragma mark - SHA1HASH加密
+ (NSString *)Sha1Hash:(NSString *)string;
- (NSString *)Sha1HashString;

#pragma mark - UTF8编码解码
+ (NSString *)UTF8Encoded:(NSString *)string;
- (NSString *)UTF8EncodedString;
+ (NSString *)UTF8Decoded:(NSString *)string;
- (NSString *)UTF8DecodedString;

#pragma mark - URL编码解码
+ (NSString *)URLEncode:(NSString *)string;
- (NSString *)URLEncodeString;
+ (NSString *)URLDecode:(NSString *)string;
- (NSString *)URLDecodeString;

@end


///////////////////////////////////////////////////////////////////////////////////////////////////
//
//  针对NSString扩展——带emoji表情的富文本显示
//  Created by Joey on 14-9-17.
//  Copyright (c) 2014年 JoeytatEmojiText. All rights reserved.
///////////////////////////////////////////////////////////////////////////////////////////////////
@interface NSString (EmojiAttributedString)

+ (NSAttributedString *)emojiAttributedString:(NSString *)string withFont:(UIFont *)font;
+ (CGFloat)HeightOfEmojiString:(NSString *)string maxWidth:(CGFloat)width withFont:(UIFont *)font;
+ (CGFloat)WidthOfEmojiString:(NSString *)string maxHeight:(CGFloat)height withFont:(UIFont *)font;
+ (CGFloat)HeightOfNormalString:(NSString*)string maxWidth:(CGFloat)width withFont:(UIFont*)font;
+ (CGFloat)WidthOfNormalString:(NSString*)string maxHeight:(CGFloat)height withFont:(UIFont*)font;
+ (CGFloat)HeightOfNormalString:(NSString*)string maxWidth:(CGFloat)width withFont:(UIFont*)font lineSpace:(CGFloat)lineSpace ;
+ (BOOL)isContainsEmoji:(NSString *)string;

@end


///////////////////////////////////////////////////////////////////////////////////////////////////
//
//  各种证件号码(身份证、警官证、军官证)合法性判断
//  参考：http://blog.sina.com.cn/s/blog_c409c8cf0102vfx7.html
//  说明：
//  在ios项目的开发中可能很多地方都需要用到身份证校验，一般在开发的时候很多人都是直接百度去网上荡相关的正则表达式和校验代码，但是网上疯狂 粘贴复制的校验代码本身也可能并不准确,可能会有风险，比如2013年1月1号起停止使用15位的身份证，网上的身份证校验普遍支持15位的号码。
//  在开发过程中，进行类似处理的时候，还是需要一些甄别的能力的，当然也要考虑自己的项目的实际情况。该文贴出了最近项目中使用到得身份证校验代码，以方便有需要的人“谨慎”获取。
//  规则
//      下面是iOS身份证校验规则，对于第6点就值得商榷，按道理出生年份前两位是20也应该是合理的。如果要校验投保人需要年满18岁，需要另行检查，不应放在身份证校验里面。
//      长度必须是18位，前17位必须是数字，第十八位可以是数字或X（校验时不区分大小写）
//      前两位必须是以下35种情形中的一种： 11,12,13,14,15,21,22,23,31,32,33,34,35,36,37,41,42,43,44,45,46,50,51,52,53,54,61,62,63,64,65,71,81,82,91
//      第7到第14位出生年月日。第7到第10位为出生年份；11到12位表示月份，范围为01～12；13到14位为合法的日期，比如月份是04，范围应是01～30
//      第17位表示性别，必须是0或1，0表示女，1表示男
//      第18位为前17位的校验位 算法如下：
//      总和 = (n1 + n11) * 7 + (n2 + n12) * 9 + (n3 + n13) * 10 + (n4 + n14) * 5 + (n5 + n15) * 8 + (n6 + n16) * 4 + (n7 + n17) * 2 + n8 + n9 * 6 + n10 * 3，其中n1表示1位数字，其它类似
//      用总和除以11，看余数是多少, 余数只可能有0 1 2 3 4 5 6 7 8 9 10这11个数字。其分别对应的最后一位身份证的号码为1 0 X 9 8 7 6 5 4 3 2
//      第7位必须为1，第8位必须为9，即：出生年份的前两位必须是19
//
///////////////////////////////////////////////////////////////////////////////////////////////////
@interface NSString (IdentityNumber)
+ (BOOL)verifyIDCardNumber:(NSString *)value; //验证身份证
+ (BOOL)verifyCardNumberWithSoldier:(NSString *)value;   //验证军官证或警官证
+ (BOOL)verifyIDCardHadAdult:(NSString *)card;  //验证身份证是否成年且小于100岁****这个方法中不做身份证校验，请确保传入的是正确身份证
+ (NSString *)getIDCardBirthday:(NSString *)card;   //得到身份证的生日****这个方法中不做身份证校验，请确保传入的是正确身份证
+ (NSInteger)getIDCardSex:(NSString *)card;   //得到身份证的性别（1男0女）****这个方法中不做身份证校验，请确保传入的是正确身份证
@end

