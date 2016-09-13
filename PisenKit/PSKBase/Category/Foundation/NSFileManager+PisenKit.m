//
//  NSFileManager+PisenKit.m
//  PisenKit
//
//  Created by 杨胜超 on 16/7/4.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import "NSFileManager+PisenKit.h"

//==============================================================================
//
//  常用方法
//
//==============================================================================
@implementation NSFileManager (PisenKit)
+ (BOOL)psk_fileExistsAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}
+ (BOOL)psk_ensureDirectory:(NSString *)directoryPath {
    BOOL isDirectory;
    BOOL isSucces = YES;
    if (( ! [[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:&isDirectory]) ||
        ( ! isDirectory)) {
        [self _psk_ensureParentDirectory:directoryPath];
        isSucces = [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    return isSucces;
}
+ (BOOL)psk_copyFileFromPath:(NSString *)sourceFilePath toPath:(NSString *)targetFilePath {
    BOOL isSucces = NO;
    if ( ! [[NSFileManager defaultManager] fileExistsAtPath:sourceFilePath]) {
        return NO;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:targetFilePath]) {
        isSucces = [self psk_deleteFileOrDirectory:targetFilePath]; //if not delete it, error will happen!
    }
    return [[NSFileManager defaultManager] copyItemAtPath:sourceFilePath toPath:targetFilePath error:NULL];
}
+ (BOOL)psk_deleteFileOrDirectory:(NSString *)deletePath {
    if ( ! [self psk_fileExistsAtPath:deletePath]) {
        return YES;
    }
    return [[NSFileManager defaultManager] removeItemAtPath:deletePath error:NULL];
}
+ (NSArray *)psk_allPathsInDirectoryPath:(NSString *)directoryPath {
    return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:NULL];
}
+ (NSArray *)psk_attributesOfAllFilesInDirectoryPath:(NSString *)directoryPath {
    NSArray *filesName = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:NULL];
    NSMutableArray *fileAttributes = [NSMutableArray new];
    for (NSString *fileName in filesName) {
        NSString *filePath = [directoryPath stringByAppendingPathComponent:fileName];
        BOOL isDir;
        BOOL isExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDir];
        if (![fileName.lowercaseString hasSuffix:@"ds_store"] && isExists && !isDir) { //filer directory and index file .DS_Store
            NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:NULL];
            NSString *fileSize = [NSString stringWithFormat:@"%llu", [attributes fileSize]];
            [fileAttributes addObject:@{@"fileName" : fileName, @"fileSize" : fileSize}];
        }
    }
    return fileAttributes;
}
+ (BOOL)psk_clearDirectoryPath:(NSString *)directoryPath {
    if ([self psk_deleteFileOrDirectory:directoryPath]) {
        [self psk_ensureDirectory:directoryPath];
        return YES;
    }
    else {
        return NO;
    }
}
+ (NSString *)_psk_ensureParentDirectory:(NSString *)filepath {
    NSString *parentDirectory = [filepath stringByDeletingLastPathComponent];
    BOOL isDirectory;
    if (( ! [[NSFileManager defaultManager] fileExistsAtPath:parentDirectory isDirectory:&isDirectory]) ||
        ( ! isDirectory)) {
        [[NSFileManager defaultManager] createDirectoryAtPath:parentDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    return filepath;
}
@end
