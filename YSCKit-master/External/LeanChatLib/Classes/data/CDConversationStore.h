//
//  CDDatabaseManager.h
//  LeanChatLib
//
//  Created by lzw on 15/7/13.
//  Copyright (c) 2015年 lzwjava@LeanCloud QQ: 651142978. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloudIM/AVOSCloudIM.h>

//最近对话的存储类。最近对话将保存在本地数据库中
@interface CDConversationStore : NSObject

+ (CDConversationStore *)store;

//会在 openClient 时调用 跟自己的clientId相关的数据库路径
- (void)setupStoreWithDatabasePath:(NSString *)path;
//重新创建数据库文件
- (void)reSetupDataBase;

//插入一条最近会话
- (void )insertConversation:(AVIMConversation *)conversation;
//判断会话是否存在本地
- (BOOL)isConversationExistsByConvId:(NSString *)convId;
//删除所有会话
- (void)deleteAllConversions;
//删除本地所有会话数据库文件！
- (void)deleteAllConversionFiles;
//删除会话
- (void)deleteConversationByConvId:(NSString *)convId;
//清空某个会话的未读数
- (void)updateUnreadCountToZeroByConvId:(NSString *)convId;
//增加未读数
- (void)increaseUnreadCountByConvId:(NSString *)convId;
//更新 mentioned 值，当接收到消息发现 @了我的时候，设为 YES，进入聊天页面，设为 NO
- (void)updateMentioned:(BOOL)mentioned convId:(NSString *)convId;
//更新会话(列表)，如果没有就新建
- (void)updateConversations:(NSArray *)conversations;
//更新会话列表，如果没有就新建
- (void)updateConversation:(AVIMConversation *)conversation;
//更新最后一条消息记录成功发送的时间
- (void)updateLastMessage:(AVIMTypedMessage *)message byConvId:(NSString *)convId;

//根据传入参数查询对应类型会话的未读数
//nil or empty - 所有会话未读数
//not empty - 指定会话类型的未读数
- (NSInteger)totalUnreadCountByEzgoalTypes:(NSArray *)ezgoalTypes;
- (NSInteger)totalUnreadCountByEzgoalTypes:(NSArray *)ezgoalTypes ezgoalStatus:(NSArray *)ezgoalStatus;
//从本地数据库查找指定会话的未读消息数
- (NSInteger)selectUnreadCountByConvId:(NSString *)convId;

//从本地数据库查找所有的对话
- (NSArray *)selectAllConversations;
- (AVIMConversation *)selectOneConversationByConvId:(NSString *)convId;
//根据rescueId查询会话
- (AVIMConversation *)selectOneConversationByRescueId:(NSString *)rescueId;

//分页获取本地会话列表
- (NSArray *)selectConversationsByPageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;
//分页获取本地特殊类型的会话列表
- (NSArray *)selectConversationsByEzgoalTypes:(NSArray *)ezgoalTypes pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;
//查询本地是否有会话
- (BOOL)isConversationExists;

@end
