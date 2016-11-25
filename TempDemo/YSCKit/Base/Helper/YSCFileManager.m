//
//  YSCFileManager.m
//  YSCKit
//
//  Created by yangshengchao on 16/1/28.
//  Copyright © 2016年 Builder. All rights reserved.
//

#import "YSCFileManager.h"


//--------------------------------------
//  常用沙盒路径
//--------------------------------------
@implementation YSCFileManager
+ (NSString *)directoryPathOfDocuments {
    return [self _searchPathByDirectory:NSDocumentDirectory];
}
+ (NSString *)directoryPathOfLibrary {
    return [self _searchPathByDirectory:NSLibraryDirectory];
}
+ (NSString *)directoryPathOfLibraryCaches {
    return [self _searchPathByDirectory:NSCachesDirectory];
}
+ (NSString *)directoryPathOfLibraryPreferences {
    return [[self directoryPathOfLibrary] stringByAppendingPathComponent:@"Preferences"];
}
+ (NSString *)_searchPathByDirectory:(NSSearchPathDirectory)directory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES);
    if ([paths count] > 0) {
        return paths[0];
    }
    else {
        return @"";
    }
}
@end


//--------------------------------------
//  文件和目录操作常用方法
//--------------------------------------
@implementation YSCFileManager (Operation)
+ (BOOL)fileExistsAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}
+ (NSString *)ensureDirectory:(NSString *)directoryPath {
    BOOL isDirectory;
    if ((![[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:&isDirectory]) || (!isDirectory)) {
        [self _ensureParentDirectory:directoryPath];
        [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    return directoryPath;
}
+ (BOOL)copyFileFromPath:(NSString *)sourceFilePath toPath:(NSString *)targetFilePath {
    BOOL isSucces = NO;
    if ( ! [[NSFileManager defaultManager] fileExistsAtPath:sourceFilePath]) {
        NSLog(@"The source file is not exists!sourceFilePath=%@", sourceFilePath);
        return NO;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:targetFilePath]) {
        isSucces = [self deleteFileOrDirectory:targetFilePath]; //if not delete it, error will happen!
    }
    return [[NSFileManager defaultManager] copyItemAtPath:sourceFilePath toPath:targetFilePath error:NULL];
}
+ (BOOL)deleteFileOrDirectory:(NSString *)deletePath {
    if ( ! [self fileExistsAtPath:deletePath]) {
        NSLog(@"The path has been deleted! deletePath=%@", deletePath);
        return YES;
    }
    return [[NSFileManager defaultManager] removeItemAtPath:deletePath error:NULL];
}
+ (NSArray *)allPathsInDirectoryPath:(NSString *)directoryPath {
    return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:NULL];
}
+ (NSArray *)attributesOfAllFilesInDirectoryPath:(NSString *)directoryPath {
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
+ (BOOL)clearDirectoryPath:(NSString *)directoryPath {
    if ([self deleteFileOrDirectory:directoryPath]) {
        [self ensureDirectory:directoryPath];
        return YES;
    }
    else {
        return NO;
    }
}
+ (NSString *)_ensureParentDirectory:(NSString *)filepath {
    NSString *parentDirectory = [filepath stringByDeletingLastPathComponent];
    BOOL isDirectory;
    if ((![[NSFileManager defaultManager] fileExistsAtPath:parentDirectory isDirectory:&isDirectory]) || (!isDirectory)) {
        [[NSFileManager defaultManager] createDirectoryAtPath:parentDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    return filepath;
}
@end