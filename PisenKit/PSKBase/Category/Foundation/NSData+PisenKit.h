//
//  NSData+PisenKit.h
//  PisenKit
//
//  Created by 杨胜超 on 16/6/30.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>


//==============================================================================
//
//  常用方法
//
//==============================================================================
@interface NSData (PisenKit)
/**
 *  直接输出字节内容
 *
 *  @return
 */
- (NSString *)byteString;
/**
 *  先转换成base64编码后的NSData再构造成NSString
 *
 *  @return
 */
- (NSString *)base64String;
@end

@interface NSData (CommonHMAC)
/**
 *  计算哈希值
 *
 *  @param algorithm 算法枚举值
 *
 *  @return
 */
- (NSData *)psk_HMACWithAlgorithm:(CCHmacAlgorithm)algorithm;
/**
 *  计算哈希值
 *
 *  @param algorithm 算法枚举值
 *  @param key       秘钥(只能是NSString 或 NSData两种类型)
 *
 *  @return
 * =====================================================
 *  @note SHA384和SHA224计算出的结果和在线加密的结果不一样！其它算法都对得上
 *  @website http://tool.oschina.net/encrypt?type=2
 *           http://encode.chahuo.com/
 */
- (NSData *)psk_HMACWithAlgorithm:(CCHmacAlgorithm)algorithm key:(id)key;
@end