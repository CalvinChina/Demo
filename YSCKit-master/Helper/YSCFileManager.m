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
+ (NSString *)DirectoryPathOfDocuments {
    return [self _SearchPathByDirectory:NSDocumentDirectory];
}
+ (NSString *)DirectoryPathOfLibrary {
    return [self _SearchPathByDirectory:NSLibraryDirectory];
}
+ (NSString *)DirectoryPathOfLibraryCaches {
    return [self _SearchPathByDirectory:NSCachesDirectory];
}
+ (NSString *)DirectoryPathOfLibraryPreferences {
    return [[self DirectoryPathOfLibrary] stringByAppendingPathComponent:@"Preferences"];
}
+ (NSString *)_SearchPathByDirectory:(NSSearchPathDirectory)directory {
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
@implementation YSCFileManager (Operate)
+ (BOOL)FileExistsAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}
+ (NSString *)EnsureDirectory:(NSString *)directoryPath {
    BOOL isDirectory;
    if ((![[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:&isDirectory]) || (!isDirectory)) {
        [self _EnsureParentDirectory:directoryPath];
        [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    return directoryPath;
}
+ (BOOL)CopyFileFromPath:(NSString *)sourceFilePath toPath:(NSString *)targetFilePath {
    BOOL isSucces = NO;
    if (NO == [[NSFileManager defaultManager] fileExistsAtPath:sourceFilePath]) {
        NSLog(@"The source file is not exists!sourceFilePath=%@", sourceFilePath);
        return NO;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:targetFilePath]) {
        isSucces = [self DeleteFileOrDirectory:targetFilePath]; //if not delete it, error will happen!
    }
    return [[NSFileManager defaultManager] copyItemAtPath:sourceFilePath toPath:targetFilePath error:NULL];
}
+ (BOOL)DeleteFileOrDirectory:(NSString *)deletePath {
    if (NO == [self FileExistsAtPath:deletePath]) {
        NSLog(@"The path has been deleted! deletePath=%@", deletePath);
        return YES;
    }
    return [[NSFileManager defaultManager] removeItemAtPath:deletePath error:NULL];
}
+ (NSArray *)AllPathsInDirectoryPath:(NSString *)directoryPath {
    return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:NULL];
}
+ (NSArray *)AttributesOfAllFilesInDirectoryPath:(NSString *)directoryPath {
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
+ (BOOL)ClearDirectoryPath:(NSString *)directoryPath {
    if ([self DeleteFileOrDirectory:directoryPath]) {
        [self EnsureDirectory:directoryPath];
        return YES;
    }
    else {
        return NO;
    }
}
+ (NSString *)_EnsureParentDirectory:(NSString *)filepath {
    NSString *parentDirectory = [filepath stringByDeletingLastPathComponent];
    BOOL isDirectory;
    if ((![[NSFileManager defaultManager] fileExistsAtPath:parentDirectory isDirectory:&isDirectory]) || (!isDirectory)) {
        [[NSFileManager defaultManager] createDirectoryAtPath:parentDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    return filepath;
}
@end