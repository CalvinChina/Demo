//
//  UIColor+PisenKit.h
//  PisenKit
//
//  Created by 杨胜超 on 16/6/30.
//  Copyright © 2016年 Pisen. All rights reserved.
//


//==============================================================================
//
//  常用方法
//
//==============================================================================
@interface UIColor (PisenKit)
@property (nonatomic, readonly) CGColorSpaceModel psk_colorSpaceModel;
@property (nonatomic, readonly) BOOL psk_canProvideRGBComponents;

@property (nonatomic, readonly) CGFloat psk_red;
@property (nonatomic, readonly) CGFloat psk_green;
@property (nonatomic, readonly) CGFloat psk_blue;
@property (nonatomic, readonly) CGFloat psk_alpha;
@property (nonatomic, readonly) CGFloat psk_white;

/** Color RGB string */
- (NSString *)psk_RGBStringFromColor;

/** Color builders */
+ (UIColor *)psk_randomColor;
/** {178,20,20} */
+ (UIColor *)psk_colorWithRGBString:(NSString *)stringToConvert;
/** FB1238 */
+ (UIColor *)psk_colorWithHexString:(NSString *)hexStringToConvert;
+ (UIColor *)psk_colorWithRGBHex:(UInt32)hex;

@end
