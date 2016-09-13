//
//  UIColor+PisenKit.m
//  PisenKit
//
//  Created by 杨胜超 on 16/6/30.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import "UIColor+PisenKit.h"

//==============================================================================
//
//  常用方法
//
//==============================================================================
@implementation UIColor (PisenKit)
- (CGColorSpaceModel)psk_colorSpaceModel {
    return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
}
- (BOOL)psk_canProvideRGBComponents {
    switch (self.psk_colorSpaceModel) {
        case kCGColorSpaceModelRGB:
        case kCGColorSpaceModelMonochrome:
            return YES;
        default:
            return NO;
    }
}

- (CGFloat)psk_red {
    NSAssert(self.psk_canProvideRGBComponents, @"Must be an RGB color to use -red");
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    return c[0];
}
- (CGFloat)psk_green {
    NSAssert(self.psk_canProvideRGBComponents, @"Must be an RGB color to use -green");
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    if (self.psk_colorSpaceModel == kCGColorSpaceModelMonochrome) {
        return c[0];
    }
    return c[1];
}
- (CGFloat)psk_blue {
    NSAssert(self.psk_canProvideRGBComponents, @"Must be an RGB color to use -blue");
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    if (self.psk_colorSpaceModel == kCGColorSpaceModelMonochrome) {
        return c[0];
    }
    return c[2];
}
- (CGFloat)psk_alpha {
    return CGColorGetAlpha(self.CGColor);
}
- (CGFloat)psk_white {
    NSAssert(self.psk_colorSpaceModel == kCGColorSpaceModelMonochrome, @"Must be a Monochrome color to use -white");
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    return c[0];
}

/** Color RGB string */
- (NSString *)psk_RGBStringFromColor {
    return [NSString stringWithFormat:@"{%.0f, %.0f, %0.0f}",
            self.psk_red * 255,
            self.psk_green * 255,
            self.psk_blue * 255];
}

/** Color builders */
+ (UIColor *)psk_randomColor {
    return [UIColor colorWithRed:random() / (CGFloat)RAND_MAX
                           green:random() / (CGFloat)RAND_MAX
                            blue:random() / (CGFloat)RAND_MAX
                           alpha:1.0f];
}
+ (UIColor *)psk_colorWithRGBString:(NSString *)stringToConvert {
    NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
    if (![scanner scanString:@"{" intoString:NULL]) return nil;
    const NSUInteger kMaxComponents = 4;
    float c[kMaxComponents];
    NSUInteger i = 0;
    if (![scanner scanFloat:&c[i++]]) return nil;
    while (1) {
        if ([scanner scanString:@"}" intoString:NULL]) {
            break;
        }
        if (i >= kMaxComponents) {
            return nil;
        }
        if ([scanner scanString:@"," intoString:NULL]) {
            if (![scanner scanFloat:&c[i++]]) {
                return nil;
            }
        }
        else {
            return nil;
        }
    }
    if ( ! [scanner isAtEnd]) {
        return nil;
    }
    UIColor *color;
    switch (i) {
        case 2: // monochrome
            color = [UIColor colorWithWhite:c[0] alpha:c[1]];
            break;
        case 3: // RGB
            color = [UIColor colorWithRed:c[0] / 255.0f green:c[1] / 255.0f blue:c[2] / 255.0f alpha:1.0f];
            break;
        default:
            color = nil;
    }
    return color;
}
+ (UIColor *)psk_colorWithHexString:(NSString *)hexStringToConvert {
    NSScanner *scanner = [NSScanner scannerWithString:hexStringToConvert];
    unsigned hexNum;
    if (![scanner scanHexInt:&hexNum]) return nil;
    return [UIColor psk_colorWithRGBHex:hexNum];
}
+ (UIColor *)psk_colorWithRGBHex:(UInt32)hex {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

@end
