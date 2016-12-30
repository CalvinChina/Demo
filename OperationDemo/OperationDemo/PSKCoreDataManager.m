//
//  PSKCoreDataManager.m
//  MicroVideo
//
//  Created by pisen on 16/12/22.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

#import "PSKCoreDataManager.h"
#import <CoreData/CoreData.h>

@interface PSKCoreDataManager ()
{
    //coredata管理对象
    NSManagedObjectModel *managedObject;
    
    //coredata引用上下文
    NSManagedObjectContext *managedObjectContext;
    
    //coredata查找过滤类
    NSPersistentStoreCoordinator *storeCoordinator;
}

@end

@implementation PSKCoreDataManager

+ (PSKCoreDataManager *) sharedInstance{
    static PSKCoreDataManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PSKCoreDataManager alloc]init];
    });
    return manager;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        // 初始化
        [self createCoreData];
    }
    return self;
}

//创建coredata数据库
- (void)createCoreData{
    
    if (managedObject == nil) {
        
        managedObject = [NSManagedObjectModel mergedModelFromBundles:nil];
    }
    
    if (storeCoordinator == nil) {
        
        //得到数据库的路径
        NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        
        //CoreData是建立在SQLite之上的，数据库名称需与Xcdatamodel文件同名
        NSURL *storeUrl = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"DownloadInfoModel.sqlite"]];
        
        NSError *error = nil;
        
        storeCoordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:managedObject];
        
        if (![storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
            
            NSLog(@"Error: %@,%@",error,[error userInfo]);
        }
    }
    
    if (managedObjectContext == nil) {
        
        managedObjectContext = [[NSManagedObjectContext alloc]init];
        
        [managedObjectContext setPersistentStoreCoordinator:storeCoordinator];
    }
}

- (BOOL)batchInsertDatasWithModels:(NSArray*)models{
    if (models == nil){
        return  NO;
    }
    if (models.count == 0){
        return NO;
    }
    for (PSKDownloadModel * model in models) {
        [self _insertDataWithModel:model];
    }
   return  [self _saveToCoreData];
}

- (void)_insertDataWithModel:(PSKDownloadModel *)model{
    // 传入上下文，创建一个Person实体对象
    NSManagedObject *  resumetask = [NSEntityDescription insertNewObjectForEntityForName:@"PSKDownloadModel" inManagedObjectContext:managedObjectContext];
    // 设置Person的简单属性
    [resumetask setValue:model.taskID forKey:@"taskID"];
    [resumetask setValue:model.taskUrl forKey:@"taskUrl"];
    [resumetask setValue:model.tmpName forKey:@"tmpName"];
    [resumetask setValue:@(model.state) forKey:@"state"];
    [resumetask setValue:@(model.fileTotalSize)forKey:@"fileTotalSize"];
    [resumetask setValue:@(model.createTime) forKey:@"createTime"];
    [resumetask setValue:@(model.updateTime) forKey:@"updateTime"];
    [resumetask setValue:@(model.downloadedFileSize) forKey:@"downloadedFileSize"];
}
/**查询**/
- (NSArray *)_seletObjectFromDataModel{
    // 初始化一个查询请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init] ;
    // 设置要查询的实体
    request.entity = [NSEntityDescription entityForName:@"PSKDownloadModel" inManagedObjectContext:managedObjectContext];
    // 设置排序（按照age降序）
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"createTime" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sort];
    //    // 设置条件过滤(搜索name中包含字符串"Itcast-1"的记录，注意：设置条件过滤时，数据库SQL语句中的%要用*来代替，所以%Itcast-1%应该写成*Itcast-1*)
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like %@", @"*Itcast-1*"];
    //    request.predicate = predicate;
    // 执行请求
    NSError *error = nil;
    NSArray *objs = [managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
    }
    return objs;
}

- (NSArray *)queryFromData{
    NSArray * objs =[self _seletObjectFromDataModel];
    if (objs == nil){
        return nil;
    }
    if (objs.count == 0){
        return nil;
    }
    NSMutableArray * returnArray = [NSMutableArray array];
       // 遍历数据
    for (NSManagedObject *obj in objs) {
        PSKDownloadModel * task = [[PSKDownloadModel alloc]init];
        task.taskID = [obj valueForKey:@"taskID"];
        task.taskUrl = [obj valueForKey:@"taskUrl"];
        task.tmpName = [obj valueForKey:@"tmpName"];
        task.createTime = [[obj valueForKey:@"createTime"] doubleValue];
        task.updateTime = [[obj valueForKey:@"updateTime"] doubleValue];
        task.downloadedFileSize = [[obj valueForKey:@"downloadedFileSize"] longLongValue];
        task.fileTotalSize = [[obj valueForKey:@"fileTotalSize"] longLongValue];
        task.state = [[obj valueForKey:@"state"] integerValue];
        [returnArray addObject:task];
    }
    return returnArray;
}

// 遍历获取到对应的数据
- (NSManagedObject*)_getObjectWithDestTask:(PSKDownloadModel *)task{
    NSArray * objs =[self _seletObjectFromDataModel];
    if (objs == nil){
        return nil;
    }
    if (objs.count == 0){
        return nil;
    }
    NSManagedObject * destObj = nil;
    for(NSManagedObject *obj in objs){
        NSString * tempID = [obj valueForKey:@"taskID"];
        if ([task.taskID isEqualToString:tempID]){
            destObj = obj;
            break;
        }
    }
    return destObj;
}

- (BOOL)batchDelete:(NSArray*)tasks{
    if (tasks == nil){
        return NO;
    }
    if (tasks.count == 0){
        return NO;
    }
    for (PSKDownloadModel * task in tasks){
        [self _deleteFromData:task];
    }
    return [self _saveToCoreData];
}

- (void)_deleteFromData:(PSKDownloadModel *)task{
    NSManagedObject * deleteObj = [self _getObjectWithDestTask:task];
    if (deleteObj == nil){
        return;
    }
    // 传入需要删除的实体对象
    [managedObjectContext deleteObject:deleteObj];
}
/**
 保存
 */
- (BOOL)_saveToCoreData{
    NSError *error = nil;
    BOOL isSuccess = [managedObjectContext save:&error];
    if (error) {
        NSLog(@"删除错误%@",error.localizedDescription);
    }
    return isSuccess;
}


- (BOOL)batchUpdateTasks:(NSArray*)tasks State:(PSKDownloadState)state{
    if (tasks == nil){
        return NO;
    }
    if (tasks.count == 0){
        return NO;
    }
    for (PSKDownloadModel * task in tasks){
        [self _updateTask:task State:state];
    }
    return [self _saveToCoreData];
}

- (void)_updateTask:(PSKDownloadModel *)task State:(PSKDownloadState)state{
    NSManagedObject * updateObj = [self _getObjectWithDestTask:task];
    if (updateObj == nil){
        return;
    }
    [updateObj setValue:@(state) forKey:@"state"];
    [updateObj setValue:@(task.downloadedFileSize) forKey:@"downloadedFileSize"];
    [updateObj setValue:@(task.fileTotalSize) forKey:@"fileTotalSize"];
    [updateObj setValue:task.tmpName forKey:@"tmpName"];
}


@end
