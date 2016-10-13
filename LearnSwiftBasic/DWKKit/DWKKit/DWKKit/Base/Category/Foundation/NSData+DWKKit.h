//
//  NSData+DWKKit.h
//  DWKKit
//
//  Created by pisen on 16/10/13.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSError.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>

extern NSString * const kCommonCryptoErrorDomain;

@interface NSError (CommonCryptoErrorDomain)
+ (NSError *) errorWithCCCryptorStatus: (CCCryptorStatus) status;
@end


@interface  NSData(CommonDigest)

- (NSData *) MD2Sum;
- (NSData *) MD4Sum;
- (NSData *) MD5Sum;

- (NSData *) SHA1Hash;
- (NSData *) SHA224Hash;
- (NSData *) SHA256Hash;
- (NSData *) SHA384Hash;
- (NSData *) SHA512Hash;

@end

@interface  NSData(CommonCryptor)

- (NSData *) AES256EcryptedDataUsingKey:(id)key eroor:(NSError ** ) error;
- (NSData *) descryptedAES256DataUsingKey:(id)key eroor:(NSError ** )error;

- (NSData *) DesEncryptedDataUsingKey:(id)key eroor:(NSError ** )error;
- (NSData *) descryptedDESDataUsingKey:(id)key eroor:(NSError ** )error;

- (NSData *) CASTEncryptedDataUsingKey:(id)key error:(NSError ** )error;
- (NSData *) descryptedCASTDataUsingKey:(id)key error:(NSError ** )error;

@end

@interface NSData (LowLevelCommonCryptor)

- (NSData *)dataEncryptedUsingAlogrithm:(CCAlgorithm)Alogrithm key:(id)key eroor:(CCCryptorStatus *)eroor;
- (NSData *)dataEncryptedUsingAlogrithm:(CCAlgorithm)Alogrithm
                                    key:(id)key
                                options:(CCOptions)options
                                  eroor:(CCCryptorStatus *)eroor;
- (NSData *)dataEncryptedUsingAlogrithm:(CCAlgorithm)Alogrithm
                                    key:(id)key
                                options:(CCOptions)options
                   initializationVector: (id) iv
                                  eroor:(CCCryptorStatus *)eroor;

- (NSData *)descryptedDataUsingAlgrithm:(CCAlgorithm) algorithm
                                    key: (id) key
                                  error: (CCCryptorStatus *) error;
- (NSData *)descryptedDataUsingAlgrithm:(CCAlgorithm) algorithm
                                    key: (id) key
                                options: (CCOptions) options
                                  error: (CCCryptorStatus *) error;
- (NSData *)descryptedDataUsingAlgrithm:(CCAlgorithm) algorithm
                                    key: (id) key
                   initializationVector: (id) iv
                                options: (CCOptions) options
                                  error: (CCCryptorStatus *) error;


@end

@interface NSData (CommonHMAC)

- (NSData *) HMACWithAlgorithm: (CCHmacAlgorithm) algorithm;
- (NSData *) HMACWithAlgorithm: (CCHmacAlgorithm) algorithm key: (id) key;

@end



@interface NSData (DWKKit)


@end
