//
//  common.m
//  路由器webDav版
//
//  Created by PDZ-YF3B-P10001 on 14-3-10.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "common.h"
#import <CommonCrypto/CommonDigest.h>
#import <AssetsLibrary/AssetsLibrary.h>
#include <sys/stat.h>
#import <sys/sysctl.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <sys/xattr.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <ImageIO/ImageIO.h>

#import "GTMBase64.h"

#import "NSData+Base64.h"

#import <CommonCrypto/CommonCryptor.h>

static NSDateFormatter * _formatter = nil;


@implementation common

+ (NSString *)encodeUseBase64:(NSString *)text{
    
    NSData* data = [text dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString * result = [data base64EncodedString];
    
    return result;
}


+ (NSString *)decodeUseBase64:(NSString *)text{
    
    NSData * data =  [NSData dataFromBase64String:text];
    
    return  [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
}


+ (NSString*) encryptUseDES:(NSString *)plainText key:(NSString *)key
{
    
    NSString *ciphertext = nil;
    
    const char *textBytes = [plainText UTF8String];
    
    NSUInteger dataLength = [plainText length];
    
    unsigned char buffer[1024];
    
    memset(buffer, 0, sizeof(char));
    
    Byte iv[] = {0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF};
    
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          iv,
                                          textBytes,
                                          dataLength,
                                          buffer,
                                          1024,
                                          &numBytesEncrypted);
    
    if(cryptStatus == kCCSuccess)
    {
        NSData *data = [GTMBase64 encodeBytes: buffer length: (NSUInteger)numBytesEncrypted];
        
        //        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        
        ciphertext = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    return ciphertext;
}



+ (NSDictionary *)getAttrDic:(NSString *)filePath {
    
    NSFileManager *manager=[NSFileManager defaultManager];
    
    NSDictionary*dic =[manager attributesOfItemAtPath:filePath error:nil];
    
    return dic;
}

+ (BOOL)deleteLocalFile:(NSString *)localName {
    
    BOOL state = NO;
    
    NSFileManager*localManager=[NSFileManager defaultManager];
    
    if ([localManager fileExistsAtPath:localName]) {
        
        NSLog(@"delete localpath is %@",localName);
        
        state = [localManager removeItemAtPath:localName error:nil];
    }
    
    return state;
}

+ (BOOL)moveLocalFile:(NSString *)srcPath toPath:(NSString *)dstPath {
    
    BOOL state = NO;
    
    NSFileManager*localManager=[NSFileManager defaultManager];
    
    if (![localManager fileExistsAtPath:dstPath]) {
        
        state = [localManager moveItemAtPath:srcPath toPath:dstPath error:nil];
    }
    
    return state;
}

+ (BOOL)copyLocalFile:(NSString *)srcPath toPath:(NSString *)dstPath {
    
    BOOL state = NO;
    
    NSFileManager*localManager=[NSFileManager defaultManager];
    
    if (srcPath&&dstPath) {
        
        state = [localManager copyItemAtPath:srcPath toPath:dstPath error:nil];
    }

    return state;
}

+ (BOOL)IsValidFileName:(NSString *)fileName {
    
    if (fileName == nil || fileName.length == 0) {
        
        return NO;
        
    }
    
    NSString *fileNameNew = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@""];
    fileNameNew = [fileNameNew stringByReplacingOccurrencesOfString:@">" withString:@""];
    fileNameNew = [fileNameNew stringByReplacingOccurrencesOfString:@"<" withString:@""];
    fileNameNew = [fileNameNew stringByReplacingOccurrencesOfString:@"." withString:@""];
    fileNameNew = [fileNameNew stringByReplacingOccurrencesOfString:@"?" withString:@""];
    fileNameNew = [fileNameNew stringByReplacingOccurrencesOfString:@"|" withString:@""];
    fileNameNew = [fileNameNew stringByReplacingOccurrencesOfString:@":" withString:@""];

    if ([fileNameNew isEqualToString:fileName]) {
        
        return YES;
    }
    
    return NO;
}


+ (CGFloat)getIos4OffsetY {
    
    CGRect apprect = [[UIScreen mainScreen] bounds];
    
    return apprect.size.height - 480;
}

+ (UIImage *)decodedImageWithImage:(UIImage *)image size:(CGSize)tranSize
{
    if (image.images)
    {
        // Do not decode animated images
        return image;
    }
    
    CGImageRef imageRef = image.CGImage;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
    CGRect imageRect = (CGRect){.origin = CGPointZero, .size = tranSize};
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    int infoMask = (bitmapInfo & kCGBitmapAlphaInfoMask);
    BOOL anyNonAlpha = (infoMask == kCGImageAlphaNone ||
                        infoMask == kCGImageAlphaNoneSkipFirst ||
                        infoMask == kCGImageAlphaNoneSkipLast);
    
   
    if (infoMask == kCGImageAlphaNone && CGColorSpaceGetNumberOfComponents(colorSpace) > 1)
    {
        // Unset the old alpha info.
        bitmapInfo &= ~kCGBitmapAlphaInfoMask;
        
        // Set noneSkipFirst.
        bitmapInfo |= kCGImageAlphaNoneSkipFirst;
    }
    // Some PNGs tell us they have alpha but only 3 components. Odd.
    else if (!anyNonAlpha && CGColorSpaceGetNumberOfComponents(colorSpace) == 3)
    {
        // Unset the old alpha info.
        bitmapInfo &= ~kCGBitmapAlphaInfoMask;
        bitmapInfo |= kCGImageAlphaPremultipliedFirst;
    }
    
    // It calculates the bytes-per-row based on the bitsPerComponent and width arguments.
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 imageSize.width,
                                                 imageSize.height,
                                                 CGImageGetBitsPerComponent(imageRef),
                                                 0,
                                                 colorSpace,
                                                 bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    
    if (!context) return image;
	
    CGContextDrawImage(context, imageRect, imageRef);
    CGImageRef decompressedImageRef = CGBitmapContextCreateImage(context);
	
    CGContextRelease(context);
	
    UIImage *decompressedImage = [UIImage imageWithCGImage:decompressedImageRef scale:image.scale orientation:image.imageOrientation];
    
    CGImageRelease(decompressedImageRef);
    
    return decompressedImage;
}

+ (UIImage *) changeImageOrientation:(UIImage *)image
{
    UIImageOrientation imageOrientation=image.imageOrientation;
    
    if(imageOrientation!=UIImageOrientationUp)
    {
        // 原始图片可以根据照相时的角度来显示，但UIImage无法判定，于是出现获取的图片会向左转９０度的现象。
        // 以下为调整图片角度的部分
        UIGraphicsBeginImageContext(image.size);
        [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        // 调整图片角度完毕
    }
    return image;
}


+(UIImage*) MyCreateThumbnailImageFromData:(NSData*)data size:(NSInteger)imageSize
{
    CGImageRef        myThumbnailImage = NULL;
    CGImageSourceRef  myImageSource;
    CFDictionaryRef   myOptions = NULL;
    CFStringRef       myKeys[3];
    CFTypeRef         myValues[3];
    CFNumberRef       thumbnailSize;
    
    // Create an image source from NSData; no options.
    myImageSource = CGImageSourceCreateWithData((CFDataRef)data,
                                                NULL);
    // Make sure the image source exists before continuing.
    if (myImageSource == NULL){
        fprintf(stderr, "Image source is NULL.");
        return  nil;
    }
    
    // Package the integer as a  CFNumber object. Using CFTypes allows you
    // to more easily create the options dictionary later.
    thumbnailSize = CFNumberCreate(NULL, kCFNumberIntType, &imageSize);
    
    // Set up the thumbnail options.
    myKeys[0] = kCGImageSourceCreateThumbnailWithTransform;
    myValues[0] = (CFTypeRef)kCFBooleanTrue;
    
    myValues[1] = (CFTypeRef)kCFBooleanTrue;
    myKeys[2] = kCGImageSourceThumbnailMaxPixelSize;
    myValues[2] = (CFTypeRef)thumbnailSize;
    
    if (imageSize > 1000) {
        
        myKeys[1] = kCGImageSourceCreateThumbnailFromImageAlways;
        
        myOptions = CFDictionaryCreate(NULL, (const void **) myKeys,
                                       (const void **) myValues, 3,
                                       &kCFTypeDictionaryKeyCallBacks,
                                       & kCFTypeDictionaryValueCallBacks);
    }
    else {
        
        myKeys[1] = kCGImageSourceCreateThumbnailFromImageIfAbsent;
        
        myOptions = CFDictionaryCreate(NULL, (const void **) myKeys,
                                       (const void **) myValues, 2,
                                       &kCFTypeDictionaryKeyCallBacks,
                                       & kCFTypeDictionaryValueCallBacks);
    }
    
    
//    myOptions = CFDictionaryCreate(NULL, (const void **) myKeys,
//                                   (const void **) myValues, 2,
//                                   &kCFTypeDictionaryKeyCallBacks,
//                                   & kCFTypeDictionaryValueCallBacks);
//    
//    NSDictionary *options = [[NSDictionary alloc] initWithObjectsAndKeys:
//                             [NSNumber numberWithBool:YES], (NSString *)kCGImageSourceCreateThumbnailFromImageIfAbsent,
//                    
//                             [NSNumber numberWithLong:imageSize], (NSString *)kCGImageSourceThumbnailMaxPixelSize,
//                             [NSNumber numberWithBool:YES], (NSString *)kCGImageSourceThumbnailMaxPixelSize,//new image size 800*600
//                             nil];
    
    // Create the thumbnail image using the specified options.
    myThumbnailImage = CGImageSourceCreateThumbnailAtIndex(myImageSource,
                                                           0,
                                                           (CFDictionaryRef)myOptions);
    // Release the options dictionary and the image source
    // when you no longer need them.
    CFRelease(thumbnailSize);
    CFRelease(myOptions);
    CFRelease(myImageSource);
    
    // Make sure the thumbnail image exists before continuing.
    if (myThumbnailImage == NULL){
        fprintf(stderr, "Thumbnail image not created from image source.");
        return nil;
    }
    
    UIImage *pic = [UIImage imageWithCGImage:myThumbnailImage];
    
    CFRelease(myThumbnailImage);

    return pic;
}

+ (BOOL) isInputTextNull:(NSString*)text {
    
    NSString *temp = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if ([temp length] == 0) {
        
        return YES;
    }
    
    return NO;
}

+ (BOOL)checkResourceIsReachable:(NSString *)url {
    
    if ([url length] > 0) {
        
        NSURL *urlDes = [NSURL URLWithString:url];
        
        BOOL fileExist = YES;
        
        NSError *err = nil;
        
        fileExist = [urlDes checkResourceIsReachableAndReturnError:&err];
        
        return fileExist;
    }
    
    return NO;
}

//按时间排列格式转换
//dateString:时间字符
//return:时间对象
+ (NSDate *)dateFromString:(NSString *)dateString {
    
    NSString *tempData = dateString;
    
    if ([tempData length] > [@"yyyy-MM-dd HH:mm:ss" length]) {
        
        tempData = [tempData substringToIndex:[@"yyyy-MM-dd HH:mm:ss" length]];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *destDate= [dateFormatter dateFromString:tempData];
    
    return destDate;
}

//按时间排列格式转换毫秒级
//dateString:时间字符
//return:时间对象
+ (NSDate *)dateFromStringSSS:(NSString *)dateString {
    
    NSString *tempData = dateString;
    
    if ([tempData length] > [@"yyyy-MM-dd HH:mm:ss:SSS" length]) {
        
        tempData = [tempData substringToIndex:[@"yyyy-MM-dd HH:mm:ss:SSS" length]];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss:SSS"];
    
    NSDate *destDate= [dateFormatter dateFromString:tempData];
    
    return destDate;
}

//按时间排列格式转换
//dateString:时间字符
//return:时间对象
+ (NSString *)stringFromDate:(NSDate *)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    
    NSString *dateString= [dateFormatter stringFromDate:date];
    
    return dateString;
}

/**
 *  显示提示框
 *
 *  @param alertView 弹出框view
 *  @param showStr   需要显示的文字
 *  @param backView  需要弹出框显示的view
 */
+ (void)showCustomAlertView:(UIView *)alertView withString:(NSString *)showStr inBackView:(UIView *)backView
{
    CGSize size = [showStr sizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:CGSizeMake(MAXFLOAT, 0.0) lineBreakMode:NSLineBreakByWordWrapping];

    alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width + 20, 50)];
    alertView.center = CGPointMake(ScreenWidth/2, ScreenHeight - 175/2);
    alertView.backgroundColor = [self rgbColor:"000000" alpha:0.85];
    alertView.layer.cornerRadius = 4.0;
    UILabel *customLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width + 20, 50)];
    customLabel.text = showStr;
    customLabel.textAlignment = NSTextAlignmentCenter;
    customLabel.font = [UIFont systemFontOfSize:15];
    customLabel.textColor = [UIColor whiteColor];
    [alertView addSubview:customLabel];
    [[UIApplication sharedApplication].keyWindow addSubview:alertView];
    
    [self performSelector:@selector(hideAlertView:) withObject:alertView afterDelay:2.0];
}

//弹出框定时消失
+ (void)hideAlertView:(id)param
{
    UIView *alertView = param;
    alertView.hidden = YES;
}

/**
 *  RGB颜色值转换
 *
 *  @param color 输入的16进制颜色值
 *
 *  @return 返回ios标准颜色值
 */
+ (UIColor *)rgbColor:(char*)color alpha:(float)value
{
    int Red = 0, Green = 0, Blue = 0;
    sscanf(color, "%2x%2x%2x", &Red, &Green, &Blue);
    return [UIColor colorWithRed:Red/255.0 green:Green/255.0 blue:Blue/255.0 alpha:value];
}

//判断是否是企业证书证书app
//return:yes是企业证书，no个人证书
+ (BOOL)isEnterpriseApp {
    
    //记得出版本的时候 不能直接return
    //return YES;
    
    NSDictionary *dic  =  [[NSBundle mainBundle] infoDictionary];
    
    NSString *appId  =  [dic objectForKey:@"CFBundleIdentifier"];
    
    if ([appId isEqualToString:@"com.pisen.qianjituan"]){
        
        return YES;
    }
    else if ([appId isEqualToString:@"com.pisen.qianjituanpisen"]) {
        
        return NO;
    }
    
    return NO;
}

//md5转码
//input:原始地址
//return:md5字符
+ (NSString *) md5HexDigest:(NSString*)input {
    
    const char *original_str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}
//
+ (NSString *)md5OfString:(NSString *)beEncryptedStr offsetStr:(NSString *)offsetStr {
    NSString *beMd5Str = [offsetStr stringByAppendingString:beEncryptedStr];
    
    const char *strUtf8 = [beMd5Str UTF8String];
    
    unsigned char encryptResult[CC_MD5_DIGEST_LENGTH];
    CC_MD5(strUtf8, (CC_LONG)strlen(strUtf8), encryptResult);
    
    NSMutableString *resultStr = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; ++i) {
        [resultStr appendFormat:@"%02x", encryptResult[i] ];
    }
    
    return [resultStr lowercaseString];
}
+ (UIDevicePlatform)getDevicePlatform {
    
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    
    char *answer = malloc(size);
    sysctlbyname("hw.machine", answer, &size, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
    
    free(answer);
    
    if ([platform isEqualToString:@"iFPGA"])        return UIDeviceIFPGA;
    
    // iPhone
    if ([platform isEqualToString:@"iPhone1,1"])    return UIDevice1GiPhone;
    if ([platform isEqualToString:@"iPhone1,2"])    return UIDevice3GiPhone;
    if ([platform hasPrefix:@"iPhone2"])            return UIDevice3GSiPhone;
    if ([platform hasPrefix:@"iPhone3"])            return UIDevice4iPhone;
    if ([platform hasPrefix:@"iPhone4"])            return UIDevice4SiPhone;
    if ([platform hasPrefix:@"iPhone5"])            return UIDevice5iPhone;
    if ([platform hasPrefix:@"iPhone6"])            return UIDevice5SiPhone;
    if ([platform hasPrefix:@"iPhone7"])            return UIDevice6iPhone;
    
    // iPod
    if ([platform hasPrefix:@"iPod1"])              return UIDevice1GiPod;
    if ([platform hasPrefix:@"iPod2"])              return UIDevice2GiPod;
    if ([platform hasPrefix:@"iPod3"])              return UIDevice3GiPod;
    if ([platform hasPrefix:@"iPod4"])              return UIDevice4GiPod;
    
    // iPad
    if ([platform hasPrefix:@"iPad1"])              return UIDevice1GiPad;
    if ([platform hasPrefix:@"iPad2"])              return UIDevice2GiPad;
    if ([platform hasPrefix:@"iPad3"])              return UIDevice3GiPad;
    if ([platform hasPrefix:@"iPad4"])              return UIDevice4GiPad;
    
    // Apple TV
    if ([platform hasPrefix:@"AppleTV2"])           return UIDeviceAppleTV2;
    if ([platform hasPrefix:@"AppleTV3"])           return UIDeviceAppleTV3;
    
    if ([platform hasPrefix:@"iPhone"])             return UIDeviceUnknowniPhone;
    if ([platform hasPrefix:@"iPod"])               return UIDeviceUnknowniPod;
    if ([platform hasPrefix:@"iPad"])               return UIDeviceUnknowniPad;
    if ([platform hasPrefix:@"AppleTV"])            return UIDeviceUnknownAppleTV;
    
    // Simulator thanks Jordan Breeding
    if ([platform hasSuffix:@"86"] || [platform isEqual:@"x86_64"])
    {
        BOOL smallerScreen = [[UIScreen mainScreen] bounds].size.width < 768;
        return smallerScreen ? UIDeviceSimulatoriPhone : UIDeviceSimulatoriPad;
    }
    
    return UIDeviceUnknown;

    
//    NSString *name = [[UIDevice currentDevice] platformString];
//    
//    return name;
}

+ (BOOL) cameraInvalid {
    
    NSString *mediaType = AVMediaTypeVideo;
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    NSLog(@"---cui--authStatus--------%d",authStatus);
   
    if(authStatus ==AVAuthorizationStatusRestricted){
        
        NSLog(@"Restricted");
        
        return YES;
        
    }else if(authStatus == AVAuthorizationStatusDenied){
        
        NSLog(@"Denied");
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请在设备的\"设置-隐私-相机\"中允许访问相机。"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        
        return NO;
    }
    else if(authStatus == AVAuthorizationStatusAuthorized){
        
        return YES;
        
    }else if(authStatus == AVAuthorizationStatusNotDetermined){
       
        return YES;
        
        //这里有的机器 没有相机隐私设置
//        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
//            
//            if(granted){
//                NSLog(@"Granted access to %@", mediaType);
//            }
//            else {
//                NSLog(@"Not granted access to %@", mediaType);
//            }
//            
//        }];
        
    }else {
        
        NSLog(@"Unknown authorization status");
    }
    
    
    return NO;
}

+ (BOOL) photosAlbumInvalid {
    
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    
    if (ALAuthorizationStatusNotDetermined == author) {
        
        return YES;
    }
    else if (ALAuthorizationStatusRestricted == author
             ||ALAuthorizationStatusDenied == author){
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请在设备的\"设置-隐私-相册\"中允许访问相册。"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        
        return NO;
    }
    else if (ALAuthorizationStatusAuthorized == author){
        
        return YES;
    }
    
    return NO;
}

+ (NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}

+ (BOOL) isSupportFileType:(NSString*)extension {
    
    NSString *str = [extension lowercaseString];
    
    if ([str isEqualToString:@"exe"]||[str isEqualToString:@"apk"]
        ||[str isEqualToString:@"rar"]||[str isEqualToString:@"zip"]
        ||[str isEqualToString:@"ipa"]||[str isEqualToString:@"iso"]
        ||[str isEqualToString:@"dmg"]||[str isEqualToString:@"download"]
        ||[str isEqualToString:@"upload"]||[str isEqualToString:@"temp"]
        ||[str isEqualToString:@"dat"]||[str isEqualToString:@"wma"]
        /*||[str isEqualToString:@"flac"]||[str isEqualToString:@"avi"]*/) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"ios不支持此文件类型"
                                                       delegate:nil
                                              cancelButtonTitle:@"关闭"
                                              otherButtonTitles:nil];
        [alert show];
        
        return NO;
    }
    
    return YES;
}

+ (NSString*)getChangeSysPath:(NSString *)path {
    
    if (path) {
        
        NSString *strOld = path;
        
        //先看是否变化
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *documentPath = [paths lastObject];
        
        NSRange ranDocSys = [strOld rangeOfString:@"Documents"];
        
        if (ranDocSys.length == 0) {
            
            return path;
        }
        
        NSString *endDtr = [strOld substringFromIndex:(ranDocSys.location + ranDocSys.length)];
        
        NSString *strNew = [documentPath stringByAppendingString:endDtr];
        
        return strNew;

    }
    
    return @"";
}

/**
 *  更新提醒提示框
 *
 *  @param alertStr 提示语句
 *  @param backView 将要展示的view
 */
+ (void)updateAlertView:(NSString *)alertStr onView:(UIView *)backView
{
    UIView *alertBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    alertBackView.backgroundColor = [UIColor blackColor];
    alertBackView.alpha = 0.5;
    alertBackView.tag = 1001;
    
    UIView *alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    alertView.backgroundColor = [UIColor whiteColor];
    alertView.alpha = 1.0;
    alertView.layer.cornerRadius = 12.0;
    alertView.tag = 1002;
    
    UILabel *alertLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 0, 0)];
    alertLbl.text = alertStr;
    UIFont *font = [UIFont systemFontOfSize:15];
    alertLbl.font = font;
    alertLbl.textColor = [UIColor blackColor];
    alertLbl.backgroundColor = [UIColor clearColor];
    alertLbl.numberOfLines = 0;
    alertLbl.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = CGSizeMake(250, 2000);
    CGSize labelsize = [alertStr sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    alertLbl.frame = CGRectMake(15, 15, labelsize.width, labelsize.height);
    [alertView addSubview:alertLbl];
    
    alertView.frame = CGRectMake(0, 0, 270, labelsize.height + 100);
    alertView.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
    
    UIButton *chooseBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, labelsize.height+22, 30, 30)];
    [chooseBtn setImage:[UIImage imageNamed:@"ios_updatealert_check"] forState:UIControlStateNormal];
//    chooseBtn.backgroundColor = [UIColor redColor];
    [chooseBtn addTarget:self action:@selector(chooseAppAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *chooseLbl = [[UILabel alloc] initWithFrame:CGRectMake(50, labelsize.height+27, 180, 20)];
    chooseLbl.text = @"下次提醒";
    chooseLbl.textColor = [UIColor colorWithRed:41/255.0 green:143/255.0 blue:233/255.0 alpha:1.0];
    chooseLbl.font = [UIFont systemFontOfSize:14];
    chooseLbl.backgroundColor = [UIColor clearColor];
    [alertView addSubview:chooseBtn];
    [alertView addSubview:chooseLbl];
    
    UIImage *lineImg = [UIImage imageNamed:@"ios_updatealert_h"];
    UIImageView *lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, alertView.frame.size.height - 45, 270, 1)];
    lineImgView.image = lineImg;
    [alertView addSubview:lineImgView];
    
    UIImage *vLineImg = [UIImage imageNamed:@"ios_updatealert_v"];
    UIImageView *vLineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(134.5, alertView.frame.size.height - 45, 1, 44)];
    vLineImgView.image = vLineImg;
    [alertView addSubview:vLineImgView];
    
    UIButton *updateBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, alertView.frame.size.height-44, 134.5, 44)];
    [updateBtn setTitle:@"更新" forState:UIControlStateNormal];
    [updateBtn setTitleColor:[UIColor colorWithRed:41/255.0 green:143/255.0 blue:233/255.0 alpha:1.0] forState:UIControlStateNormal];
    [updateBtn addTarget:self action:@selector(updateAppAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(135.5, alertView.frame.size.height-44, 134.5, 44)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithRed:41/255.0 green:143/255.0 blue:233/255.0 alpha:1.0] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelAppAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [alertView addSubview:updateBtn];
    [alertView addSubview:cancelBtn];

    [backView addSubview:alertBackView];
    [backView addSubview:alertView];
}

/**
 *  更新事件
 *
 *  @param sender button
 */
+ (void)updateAppAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    UIView *view = btn.superview.superview;
    
    for (UIView *subView in view.subviews)
    {
        if (subView.tag == 1001)
        {
            subView.hidden = YES;
        }
        else if (subView.tag == 1002)
        {
            subView.hidden = YES;
        }
    }
    
    NSString *url = [NUSD objectForKey:@"updateURL"];
    
    if (url != nil)
    {
        if (![url hasPrefix:@"http://"])
        {
            url = [@"http://" stringByAppendingString:url];
        }
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

/**
 *  取消更新事件
 *
 *  @param sender button
 */
+ (void)cancelAppAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    UIView *view = btn.superview.superview;

    for (UIView *subView in view.subviews)
    {
        if (subView.tag == 1001)
        {
            subView.hidden = YES;
        }
        else if (subView.tag == 1002)
        {
            subView.hidden = YES;
        }
    }
}

/**
 *  提醒取消/勾选事件
 *
 *  @param sender button
 */
+ (void)chooseAppAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    NSLog(@"update is %@", [NUSD objectForKey:@"update"]);
    
    if ([[NUSD objectForKey:@"update"] boolValue])
    {
//        [btn setBackgroundColor:[UIColor blueColor]];
        [btn setImage:[UIImage imageNamed:@"ios_updatealert_no"] forState:UIControlStateNormal];
        [NUSD setObject:[NSNumber numberWithBool:NO] forKey:@"update"];
        [NUSD synchronize];
    }
    else
    {
//        [btn setBackgroundColor:[UIColor redColor]];
        [btn setImage:[UIImage imageNamed:@"ios_updatealert_check"] forState:UIControlStateNormal];
        [NUSD setObject:[NSNumber numberWithBool:YES] forKey:@"update"];
        [NUSD synchronize];
    }
}


+ (NSString*) getNoExitFileName:(NSString*)tagName path:(NSString*)directory{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *arr = [fileManager contentsOfDirectoryAtPath:directory error:nil];
    
    if ([arr count] == 0) {
        
        return tagName;
    }
    
    NSString *ex = [tagName pathExtension];
    
    NSString *file = [tagName stringByDeletingPathExtension];
    
    NSInteger i = 0;
    
    while (1) {
        
        NSString *fileNew = nil;
        
        if (i == 0) {
            
            fileNew = file;
        }
        else {
            
            fileNew = [file stringByAppendingFormat:@"(%d)", i];
        }
        
        BOOL haveNo = YES;
        
        for (NSInteger i = 0; i < [arr count]; i++) {
            
            NSString *str = arr[i];
            
            NSString *tempName = [str stringByDeletingPathExtension];
            
            if ([tempName isEqualToString:fileNew]) {
                
                haveNo = NO;
                
                break;
            }
        }
        
        if (haveNo) {
            
            return [fileNew stringByAppendingPathExtension:ex];
        }
        
        i++;
    }
}

+ (id) fetchBSSIDInfoMac{
    
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    
    id info = nil;
    for (NSString *ifnam in ifs) {
        
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) {
            break;
        }
    }
    
    return [info objectForKey:@"BSSID"];
}

+(id)fetchSSIDInfoMac
{
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    
    id info = nil;
    for (NSString *ifnam in ifs) {
        
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) {
            break;
        }
    }
    
    return [info objectForKey:@"SSID"];
}

+ (NSString*) stringFromFomate:(NSDate*)date formate:(NSString*)formate
{
    if (nil == _formatter)
    {
        _formatter = [[NSDateFormatter alloc] init];
    }
    [_formatter setDateFormat:formate];
    NSString *str = [_formatter stringFromDate:date];
    return str;
}

+ (NSDate *)dateFromFomate:(NSString *)datestring formate:(NSString*)formate
{
    if (nil == _formatter)
    {
        _formatter = [[NSDateFormatter alloc] init];
        NSLocale *enUS = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [_formatter setLocale:enUS];
    }
    [_formatter setDateFormat:formate];
    return [_formatter dateFromString:datestring];
}

+ (CGRect) getScreenRect {
    
    CGRect a = [UIApplication sharedApplication].statusBarFrame;
    
    CGRect b = [[UIScreen mainScreen] bounds];
    
    if (a.size.height > 20) {
        
        b.size.height -= 20;
    }
    
    return b;
}

+ (void) transformViewByKeyWindows:(UIView*)view tag:(UIView*)toView {
    
    CGFloat sysValue = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if (sysValue < 8.0) {
        
        UIInterfaceOrientation deviceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        
        float angle = (deviceOrientation == UIInterfaceOrientationLandscapeRight)?90:-90;
        
        view.transform = CGAffineTransformMakeRotation(degreesToRadian(angle));
        
        view.frame = CGRectOffset(toView.frame, 0, 0);
    }
}

+ (BOOL)IsPad{
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        return YES;
    }
    else {
        
        return NO;
    }
}

+ (NSString *)sizeString:(NSString *)sizeStr{

    NSString * sString;
    
        
        if ([sizeStr floatValue] >= 1024*1024) {
            
            sString = [NSString stringWithFormat:@"%.2fMB",[sizeStr floatValue]/1024.0/1024.0];
        }
        else {
            
            if ([sizeStr floatValue] >= 1024) {
                
                sString = [NSString stringWithFormat:@"%.1fKB",[sizeStr floatValue]/1024.0];
            }
            else {
                
                sString = [NSString stringWithFormat:@"%d bytes", (int)[sizeStr longLongValue]];
            }
        }

    return sString;
}

+ (long long) fileSizeAtPath:(NSString*) filePath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    
    return 0;
}

/**
 *  获取当前app版本
 *
 *  @return 当前的app版本
 */
+ (NSString *)getAppVersion {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //   CFShow((__bridge CFTypeRef)(infoDictionary));
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    //    NSString *app_Version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    
    return app_Version;
}

+ (BOOL)isValidateIP:(NSString *)ipStr
{
    NSString *ipRegex = @"^((25[0-5]|2[0-4]\\d|[01]?\\d\\d?)($|(?!\\.$)\\.)){4}$";
    NSPredicate *ipTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ipRegex];
    return [ipTest evaluateWithObject:ipStr];
}

+ (BOOL)isValidatePwd:(NSString *)pwdStr
{
    NSString *pwdRegex = @"^[_0-9a-zA-Z!^&*(@.)$#%-]{8,63}$";
    NSPredicate *pwdTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pwdRegex];
    return [pwdTest evaluateWithObject:pwdStr];
}

+ (void)PlaySound
{
    SystemSoundID sound;
    
    NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@.%@",@"sms-received1",@"caf"];
    
    if (path) {
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&sound);
        
        if (error != kAudioServicesNoError) {
            sound = nil;
        }
    }
    
    AudioServicesPlaySystemSound(sound);
}

+ (UIImage*)getSubImage:(CGRect)rect inputImg:(UIImage *)img
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(img.CGImage, rect);
    
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return smallImage;
}

+ (UIDocumentInteractionController *) setupControllerWithURL:(NSString *)filePath presentInView:(UIView *)view
{
    UIDocumentInteractionController *document = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
    
    [document presentOpenInMenuFromRect:CGRectMake(760, 20, 100, 100) inView:view animated:YES];
    
    return document;
}

+ (void)generateCode:(NSString *)inputText onLabel:(UILabel *)lbl
{
    for (UIView *view in lbl.subviews)
    {
        [view removeFromSuperview];
    }
    
    float red = arc4random() % 100 / 100.0;
    float green = arc4random() % 100 / 100.0;
    float blue = arc4random() % 100 / 100.0;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:0.2];
    [lbl setBackgroundColor:color];
    
    CGSize cSize = [@"S" sizeWithFont:[UIFont systemFontOfSize:14]];
    int width = lbl.frame.size.width / inputText.length - cSize.width;
    int height = lbl.frame.size.height - cSize.height/2;
    
    CGPoint point;
    float pX, pY;
    
    for (int i = 0; i < inputText.length; i++)
    {
        pX = arc4random() % width + lbl.frame.size.width / inputText.length * i - 1;
        pY = arc4random() % height/2;
        point = CGPointMake(pX, pY);
        unichar c = [inputText characterAtIndex:i];
        UILabel *tempLabel = [[UILabel alloc]
                              initWithFrame:CGRectMake(pX, pY,
                                                       lbl.frame.size.width / 4,
                                                       lbl.frame.size.height)];
        tempLabel.backgroundColor = [UIColor clearColor];
        
        float red = arc4random() % 100 / 100.0;
        float green = arc4random() % 100 / 100.0;
        float blue = arc4random() % 100 / 100.0;
        UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
        
        NSString *textC = [NSString stringWithFormat:@"%C", c];
        tempLabel.font = [UIFont fontWithName:@"Georgia" size:14];
        tempLabel.textColor = color;
        tempLabel.text = textC;
        
        [lbl addSubview:tempLabel];
    }
    
    // 干扰线
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    
    for(int i = 0; i < inputText.length; i++)
    {
        red = arc4random() % 100 / 100.0;
        green = arc4random() % 100 / 100.0;
        blue = arc4random() % 100 / 100.0;
        color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
        CGContextSetStrokeColorWithColor(context, [color CGColor]);
        pX = arc4random() % (int)lbl.frame.size.width;
        pY = arc4random() % (int)lbl.frame.size.height;
        CGContextMoveToPoint(context, pX, pY);
        pX = arc4random() % (int)lbl.frame.size.width;
        pY = arc4random() % (int)lbl.frame.size.height;
        CGContextAddLineToPoint(context, pX, pY);
        CGContextStrokePath(context);
    }
}
//获取随机两位字符串
+(NSString *)catchStringByRandom{
    NSArray *originArray=@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",@"z"];
    NSMutableString *backString=[NSMutableString string];
    for (int index=0; index<2; ) {
        NSInteger randomNumber=arc4random()%(originArray.count);
        if (randomNumber<originArray.count) {
            [backString appendString:originArray[randomNumber]];
            index++;
        }
    }
    return backString;
}
@end
