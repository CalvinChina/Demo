//
//  DWKFileManager.m
//  DWKKit
//
//  Created by pisen on 16/10/17.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

#import "DWKFileManager.h"

//--------------------------------------
//  常用沙盒路径
//--------------------------------------
@implementation DWKFileManager

+ (NSString *)directoryPathOfDocuments{
    return [self _searchPathByDirectory:NSDocumentDirectory];
}
+ (NSString *)directoryPathOfLibrary {
    return [self _searchPathByDirectory:NSLibraryDirectory];
}
+ (NSString *)directoryPathOfLibraryCaches {
    return [self _searchPathByDirectory:NSCachesDirectory];
}
// NSUserDefault
+ (NSString *)directoryPathOfLibraryPreferences{
    return [[self directoryPathOfLibrary] stringByAppendingPathComponent:@"Preferences"];
}
+ (NSString *)_searchPathByDirectory:(NSSearchPathDirectory)directory{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES);
    if (paths.count > 0) {
        return paths[0];
    }else{
        return @"";
    }
}

@end

@implementation DWKFileManager (Operation)

+ (BOOL)fileExistsAtPath:(NSString *)path{
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}
// 确保filepath目录存在，如果不存在就(递归)创建
+ (NSString *)ensureDirectory:(NSString *)directoryPath{
    BOOL isDirectory;
    if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory: & isDirectory] || (! isDirectory)) {
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

+ (NSString *)_ensureParentDirectory:(NSString *)filePath{
    NSString * parentDirectory = [filePath stringByAppendingString:filePath];
    BOOL isDirectory;
    if ((![[NSFileManager defaultManager] fileExistsAtPath:parentDirectory isDirectory:&isDirectory]) || (!isDirectory)) {
        [[NSFileManager defaultManager] createDirectoryAtPath:parentDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return filePath;
}

@end
