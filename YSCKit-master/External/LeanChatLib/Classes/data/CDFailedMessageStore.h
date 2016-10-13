//
//  CDFailedMessagesManager.h
//  LeanChatLib
//
//  Created by lzw on 15/7/14.
//  Copyright (c) 2015年 lzwjava@LeanCloud QQ: 651142978. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloudIM/AVOSCloudIM.h>


/**
 *  失败消息的管理类，讨论见 https://github.com/leancloud/leanchat-ios/issues/53
 */
@interface CDFailedMessageStore : NSObject

/**
 *  单例
 *  @return
 */
+ (CDFailedMessageStore *)store;

/**
 *  openClient 时调用
 *  @param path 与 clientId 相关
 */
- (void)setupStoreWithDatabasePath:(NSString *)path;

/**
 *  发送消息失败时调用
 *  @param message 相应的消息
 */
- (void)insertFailedMessage:(AVIMTypedMessage *)message;

/**
 *  重发成功的时候调用
 *  @param recordId 记录的 id
 *  @return
 */
- (BOOL)deleteFailedMessageByRecordId:(NSString *)recordId;

/**
 *  查找失败的消息。进入聊天页面时调用，若聊天服务连通，则把失败的消息重发，否则，加在列表尾部。
 *  @param conversationId 对话的 id
 *  @return 消息数组
 */
- (NSArray *)selectFailedMessagesByConversationId:(NSString *)conversationId;

@end
