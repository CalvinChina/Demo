//
//  CDChatManager.h
//  LeanChat
//
//  Created by lzw on 15/1/21.
//  Copyright (c) 2015年 LeanCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDUserModel.h"
#import "AVIMConversation+Custom.h"
/**
 *  未读数改变了。通知去服务器同步 installation 的badge
 */
static NSString *const kCDNotificationUnreadsUpdated = @"UnreadsUpdated";

/**
 *  消息到来了，通知聊天页面和最近对话页面刷新
 */
static NSString *const kCDNotificationMessageReceived = @"MessageReceived";

/**
 *  消息到达对方了，通知聊天页面更改消息状态
 */
static NSString *const kCDNotificationMessageDelivered = @"MessageDelivered";

/**
 *  对话的元数据变化了，通知页面刷新
 */
static NSString *const kCDNotificationConversationUpdated = @"ConversationUpdated";

/**
 *  聊天服务器连接状态更改了，通知最近对话和聊天页面是否显示红色警告条
 */
static NSString *const kCDNotificationConnectivityUpdated = @"ConnectStatus";

typedef void (^CDRecentConversationsCallback)(NSArray *conversations, NSInteger totalUnreadCount,  NSError *error);

@protocol CDUserDelegate <NSObject>

@required
/**
 *  同步方法，下面的 cacheUserByIds:block 方法是为了 getUserById: 能同步返回用户信息
 */
- (id <CDUserModel> )getUserById:(NSString *)userId;


/**
 *  对于每条消息，都会调用这个方法来缓存发送者的用户信息，以便 getUserById 直接返回用户信息
 */
- (void)cacheUserByIds:(NSSet *)userIds block:(AVBooleanResultBlock)block;

@end

/**
 *  核心的聊天管理类
 */
@interface CDChatManager : NSObject
/*!
 * AVIMClient 实例
 */
@property (nonatomic, strong) AVIMClient *client;
/**
 *  设置用户信息的 delegate
 */
@property (nonatomic, strong) id <CDUserDelegate> userDelegate;
/**
 *  即 openClient 时的 clientId
 */
@property (nonatomic, strong, readonly) NSString *selfId;
/**
 *  是否和聊天服务器连通
 */
@property (nonatomic, assign, readonly) BOOL connect;
/**
 *  当前正在聊天的 conversationId
 */
@property (nonatomic, strong) NSString *chattingConversationId;

/**
 *  是否使用开发证书去推送，默认为 NO。YES 的话每条消息会带上这个参数，云代码利用 Hook 设置证书
 *  参考 https://github.com/leancloud/leanchat-cloudcode/blob/master/cloud/mchat.js
 */
@property (nonatomic, assign) BOOL useDevPushCerticate;

/**
 *  推送弹框点击时记录的 convid
 */
@property (nonatomic, strong) NSString *remoteNotificationConvid;

/**
 *  获取单例
 */
+ (instancetype)manager;

/**
 *  打开一个聊天终端，登录服务器
 *  @param clientId 可以是任何的字符串。可以是 "123"，也可以是 uuid。应用内需唯一，不推荐 name，因为 name 会改变。固定不变的 id 是最好的。
 *  @param callback 回调。当网络错误或签名错误会发生 error 回调。
 */
- (void)openWithClientId:(NSString *)clientId callback:(AVIMBooleanResultBlock)callback;
/**
 *  关闭一个聊天终端，注销的时候使用
 */
- (void)closeWithCallback:(AVBooleanResultBlock)callback;


#pragma mark - conversation
//根据 conversationId 获取对话
- (void)fetchConvWithConvid:(NSString *)convid callback:(AVIMConversationResultBlock)callback;
//根据成员名称查找或创建一个会话
- (void)fetchConvWithMembers:(NSArray *)members callback:(AVIMConversationResultBlock)callback;
//根据成员名称查找或创建一个会话
- (void)fetchConvWithMembers:(NSArray *)members extendAttributes:(NSDictionary *)attributes callback:(AVIMConversationResultBlock)callback;
//根据convId数组查询所有会话
- (void)fetchConvsWithConvids:(NSSet *)convids callback:(AVIMArrayResultBlock)callback;

/**
 *  统一的发送消息接口
 *  @param message      富文本消息
 *  @param conversation 对话
 *  @param block
 */
- (void)sendMessage:(AVIMTypedMessage*)message conversation:(AVIMConversation *)conversation callback:(AVBooleanResultBlock)block;
/**
 *  在 ApplicationDelegate 中的 application:didRemoteNotification 调用，来记录推送时的 convid，这样点击弹框打开后进入相应的对话
 *  @param userInfo
 *  @return 是否检测到 convid 做了处理
 */
- (BOOL)didReceiveRemoteNotification:(NSDictionary *)userInfo;

/**
 *  根据消息的 id 获取声音文件的路径
 *  @param objectId 消息的 id
 *  @return 文件路径
 */
- (NSString *)getPathByObjectId:(NSString *)objectId;

/*!
 *  根据消息来获取视频文件的路径。
 */
- (NSString *)videoPathOfMessag:(AVIMVideoMessage *)message;

/**
 *  图片消息，临时的压缩图片路径
 *  @return
 */
- (NSString *)tmpPath;

/**
 *  发送失败的消息的临时的 id
 *  @return
 */
- (NSString *)tempMessageId;

+ (NSError *)errorWithText:(NSString *)text;

@end
