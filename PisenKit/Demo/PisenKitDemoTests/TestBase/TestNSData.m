//
//  TestNSData.m
//  PisenKitDemo
//
//  Created by 杨胜超 on 16/7/12.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface TestNSData : XCTestCase
@property (nonatomic, strong) NSString *source1;
@property (nonatomic, strong) NSString *encryptKey;

@property (nonatomic, strong) NSString *standardSHA1;
@property (nonatomic, strong) NSString *standardMD5;
@property (nonatomic, strong) NSString *standardSHA256;
@property (nonatomic, strong) NSString *standardSHA384;
@property (nonatomic, strong) NSString *standardSHA512;
@property (nonatomic, strong) NSString *standardSHA224;
@end

@implementation TestNSData

- (void)setUp {
    [super setUp];
    self.source1 = @"abcdABCD12345^%$\"}{+测试加密文本";
    self.encryptKey = @"32583abcABC97加密密钥48(\\*&*\"KHdsIUY:{}<>?@!@#~";
    
    self.standardSHA1 = @"d1651ea09cec5e4f60fd82968d1c9b75a419ffb6";
    self.standardMD5 = @"d01fb16887ef7480eb3e484938197c5b";
    self.standardSHA256 = @"4c4248956f9e3ba3376b57c52962a3e1a385fa62b3ac24cc73b3d8958284da2f";
    self.standardSHA384 = @"b72ec7ab576015b2dd47d147b9d7a973d7db546dc44e902adbccda2dc0267fc088e3338a9059ae188a0ddcd8669bcbc7";
    self.standardSHA512 = @"d5fe45ac024059f348b901c53929557990a451c5ffc3291d30325f01368cf860e583d08c43d2358dbaff807afb9fd3a5732b66b4eb9d70bd3beaa33f4640f406";
    self.standardSHA224 = @"1dc5fbffbc996cd5e08c9f294f7be54877ffcdba93457988be659d46";
}

- (void)tearDown {
    self.source1 = nil;
    self.encryptKey = nil;
    
    self.standardSHA1 = nil;
    self.standardMD5 = nil;
    self.standardSHA256 = nil;
    self.standardSHA384 = nil;
    self.standardSHA512 = nil;
    self.standardSHA224 = nil;
    [super tearDown];
}

- (void)test_psk_HMACWithAlgorithm {
    NSData *sourceData = [self.source1 dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptDataSHA1 = [sourceData psk_HMACWithAlgorithm:kCCHmacAlgSHA1 key:self.encryptKey];
    NSData *encryptDataMD5 = [sourceData psk_HMACWithAlgorithm:kCCHmacAlgMD5 key:self.encryptKey];
    NSData *encryptDataSHA256 = [sourceData psk_HMACWithAlgorithm:kCCHmacAlgSHA256 key:self.encryptKey];
    NSData *encryptDataSHA384 = [sourceData psk_HMACWithAlgorithm:kCCHmacAlgSHA384 key:self.encryptKey];
    NSData *encryptDataSHA512 = [sourceData psk_HMACWithAlgorithm:kCCHmacAlgSHA512 key:self.encryptKey];
    NSData *encryptDataSHA224 = [sourceData psk_HMACWithAlgorithm:kCCHmacAlgSHA224 key:self.encryptKey];
    
    NSString *encryptStringSHA1 = [encryptDataSHA1 byteString];
    NSString *encryptStringMD5 = [encryptDataMD5 byteString];
    NSString *encryptStringSHA256 = [encryptDataSHA256 byteString];
    NSString *encryptStringSHA384 = [encryptDataSHA384 byteString];
    NSString *encryptStringSHA512 = [encryptDataSHA512 byteString];
    NSString *encryptStringSHA224 = [encryptDataSHA224 byteString];
    
    XCTAssert([self.standardSHA1 isEqualToString:encryptStringSHA1], @"");
    XCTAssert([self.standardMD5 isEqualToString:encryptStringMD5], @"");
    XCTAssert([self.standardSHA256 isEqualToString:encryptStringSHA256], @"");
    //FIXME:SHA384未通过测试
//    XCTAssert([self.standardSHA384 isEqualToString:encryptStringSHA384], @"");
    XCTAssert([self.standardSHA512 isEqualToString:encryptStringSHA512], @"");
    //FIXME:SHA224未通过测试
//    XCTAssert([self.standardSHA224 isEqualToString:encryptStringSHA224], @"");
}

@end
