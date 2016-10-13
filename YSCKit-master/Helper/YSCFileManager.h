//
//  YSCFileManager.h
//  YSCKit
//
//  Created by yangshengchao on 16/1/28.
//  Copyright © 2016年 Builder. All rights reserved.
//


/**
 *  文件/夹常用操作
 *  1. 数据库和账户信息，放在Documents目录
 *  2. 程序长期使用的缓存，放在Library/Caches目录
 *  3. 只在当次程序打开使用的，放在tmp目录
 */

#define kPathOfBundle               [[NSBundle mainBundle] resourcePath]    //APP打包文件运行的目录
#define kPathOfSandBoxHome          NSHomeDirectory()                       //沙盒根目录
//1. 通常保存临时数据，比如要上传的图片；下载的临时文件等;
//2. 当内存吃紧时，被ios系统判断是否需要清空该目录
//3. iTunes不备份该目录
#define kPathOfSandBoxTemp          NSTemporaryDirectory()                  //沙盒目录下的临时目录



//--------------------------------------
//  常用沙盒路径
//--------------------------------------
@interface YSCFileManager : NSObject
/**
 *  /Documents
 *  通常存放应用中建立的文件，如数据库文件，或程序中浏览到的文件数据
 *  itunes备份该目录
 */
+ (NSString *)DirectoryPathOfDocuments;
/**
 *  /Library
 *  itunes备份该目录除了Caches
 */
+ (NSString *)DirectoryPathOfLibrary;
/**
 *  /Library/Caches
 *  通常保存页面缓存数据
 *  退出app不被清除
 *  itunes不备份该目录
 */
+ (NSString *)DirectoryPathOfLibraryCaches;
/**
 *  /Library/Preferences
 *  保存NSUserDefaults（bounldId.plist）
 *  itunes备份该目录
 */
+ (NSString *)DirectoryPathOfLibraryPreferences;
@end


//--------------------------------------
//  文件和目录操作常用方法
//--------------------------------------
@interface YSCFileManager (Operate)
// 判断文件或目录是否存在
// Returns a Boolean value that indicates whether a file or directory exists at a specified path.
+ (BOOL)FileExistsAtPath:(NSString *)path;
// 确保filepath目录存在，如果不存在就(递归)创建
+ (NSString *)EnsureDirectory:(NSString *)directoryPath;
// 文件拷贝，只能拷贝文件，不能拷贝目录！
+ (BOOL)CopyFileFromPath:(NSString *)sourceFilePath toPath:(NSString *)targetFilePath;
// 删除文件/夹，如果是目录就删除整个目录包括其下的文件和文件夹；如果是文件就直接删除
+ (BOOL)DeleteFileOrDirectory:(NSString *)deletePath;
// 获取目录下所有文件和目录的路径
+ (NSArray *)AllPathsInDirectoryPath:(NSString *)directoryPath;
// 获取目录下所有文件的属性（filename + filesize）
+ (NSArray *)AttributesOfAllFilesInDirectoryPath:(NSString *)directoryPath;
// 清空目录下所有文件和目录，但保持当前目录的存在
+ (BOOL)ClearDirectoryPath:(NSString *)directoryPath;
@end
