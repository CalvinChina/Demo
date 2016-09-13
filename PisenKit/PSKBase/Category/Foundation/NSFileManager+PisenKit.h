//
//  NSFileManager+PisenKit.h
//  PisenKit
//
//  Created by 杨胜超 on 16/7/4.
//  Copyright © 2016年 Pisen. All rights reserved.
//


//==============================================================================
//
//  常用方法
//
//==============================================================================
@interface NSFileManager (PisenKit)
/**
 *  判断文件或目录是否存在
 */
+ (BOOL)psk_fileExistsAtPath:(NSString *)path;
/**
 *  确保filepath目录存在
 *  如果不存在就(递归)创建
 */
+ (BOOL)psk_ensureDirectory:(NSString *)directoryPath;
/**
 *  文件拷贝
 *  只能拷贝文件，不能拷贝目录！
 */
+ (BOOL)psk_copyFileFromPath:(NSString *)sourceFilePath toPath:(NSString *)targetFilePath;
/**
 *  删除文件/夹
 *  如果是目录就删除整个目录包括其下的文件和文件夹；如果是文件就直接删除
 */
+ (BOOL)psk_deleteFileOrDirectory:(NSString *)deletePath;
/**
 *  获取目录下所有文件和目录的路径
 */
+ (NSArray *)psk_allPathsInDirectoryPath:(NSString *)directoryPath;
/**
 *  获取目录下所有文件的属性
 *  @[@{@"fileName":@"config.plist", @"fileSize":@"1234Byte"}]
 */
+ (NSArray *)psk_attributesOfAllFilesInDirectoryPath:(NSString *)directoryPath;
/**
 *  清空目录下所有文件和目录
 *  但保持当前目录的存在
 */
+ (BOOL)psk_clearDirectoryPath:(NSString *)directoryPath;
@end
