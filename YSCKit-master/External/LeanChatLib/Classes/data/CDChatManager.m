//
//  CDChatManager.m
//  LeanChat
//
//  Created by lzw on 15/1/21.
//  Copyright (c) 2015年 LeanCloud. All rights reserved.
//

#import "CDChatManager.h"
#import "CDEmotionUtils.h"
#import "CDSoundManager.h"
#import "CDConversationStore.h"
#import "CDFailedMessageStore.h"
#import "CDMacros.h"

static CDChatManager *instance;

@interface CDChatManager () <AVIMClientDelegate, AVIMSignatureDataSource>

@end

@implementation CDChatManager

+ (instancetype)manager {
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[CDChatManager alloc] init];
    });
    return instance;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        [AVIMClient setTimeoutIntervalInSeconds:20];
        // 以下选项也即是说 A 不在线时，有人往A发了很多条消息，下次启动时，不再收到具体的离线消息，而是收到离线消息的数目(未读通知)
        [AVIMClient setUserOptions:@{AVIMUserOptionUseUnread:@(NO)}];
    }
    return self;
}
- (NSString *)databasePathWithUserId:(NSString *)userId{
    NSString *libPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [libPath stringByAppendingPathComponent:[NSString stringWithFormat:@"com.leancloud.leanchatlib.%@.sqlite", userId]];
}
//登录IM
- (void)openWithClientId:(NSString *)clientId callback:(AVIMBooleanResultBlock)callback {
    _selfId = clientId;
    NSString *dbPath = [self databasePathWithUserId:_selfId];
    [[CDConversationStore store] setupStoreWithDatabasePath:dbPath];
    [[CDFailedMessageStore store] setupStoreWithDatabasePath:dbPath];
    self.client = [[AVIMClient alloc] initWithClientId:clientId tag:@"Mobile"];
    self.client.delegate = self;
    AVIMClientOpenOption *option = [[AVIMClientOpenOption alloc] init];
    option.force = YES;
    [self.client openWithOption:option callback:^(BOOL succeeded, NSError *error) {
        [self updateConnectStatus];
        if (callback) {
            callback(succeeded, error);
        }
    }];
}
//注销IM
- (void)closeWithCallback:(AVBooleanResultBlock)callback {
    if (_selfId) {
        [self.client closeWithCallback:callback];
    }
}

#pragma mark - conversation
//根据会话id查询(不创建)会话
- (void)fetchConvWithConvid:(NSString *)convid callback:(AVIMConversationResultBlock)callback {
    AVIMConversationQuery *q = [self.client conversationQuery];
    q.cachePolicy = kAVCachePolicyNetworkOnly;
    [q whereKey:@"objectId" equalTo:convid];
    [q findConversationsWithCallback: ^(NSArray *objects, NSError *error) {
        if (error) {
            callback(nil, error);
        }
        else {
            if (objects.count == 0) {
                callback(nil, [CDChatManager errorWithText:[NSString stringWithFormat:@"conversation of %@ not exists", convid]]);
            }
            else {
                [[CDConversationStore store] updateConversation:objects[0]];//将会话保存在本地
                callback(objects[0], error);
            }
        }
    }];
}
//根据成员名称查找或创建一个会话
- (void)fetchConvWithMembers:(NSArray *)members callback:(AVIMConversationResultBlock)callback {
    [self fetchConvWithMembers:members extendAttributes:nil callback:callback];
}
//根据成员名称查找或创建一个会话
- (void)fetchConvWithMembers:(NSArray *)members extendAttributes:(NSDictionary *)attributes callback:(AVIMConversationResultBlock)callback {
    //判断自己是否包括在内
    if ([members containsObject:self.selfId] == NO) {
        [NSException raise:NSInvalidArgumentException format:@"members should contain myself"];
    }
    //判断用户名是否重复
    NSSet *set = [NSSet setWithArray:members];
    if (set.count != members.count) {
        [NSException raise:NSInvalidArgumentException format:@"The array has duplicate value"];
    }
    AVIMConversationQuery *q = [self.client conversationQuery];
    [q whereKey:AVIMAttr(kParamEzgoalType) equalTo:attributes[kParamEzgoalType]];
    if (NO == [EZGManager checkConversationIsNormal:attributes[kParamEzgoalType]]) {//如果是非普通会话，需要过滤s4Id和status
        [q whereKey:AVIMAttr(kParamS4Id) equalTo:attributes[kParamS4Id]];
        [q whereKey:AVIMAttr(kParamEzgoalStatus) equalTo:attributes[kParamEzgoalStatus]];
    }
    [q whereKey:kAVIMKeyMember containsAllObjectsInArray:members];
    [q whereKey:kAVIMKeyMember sizeEqualTo:members.count];
    [q orderByDescending:@"lm"];
    q.cachePolicy = kAVCachePolicyNetworkOnly;
    q.limit = 1;
    [q findConversationsWithCallback: ^(NSArray *objects, NSError *error) {
        if (error) {
            callback(nil, error);
        }
        else {
            if (objects.count > 0) {
                callback(objects[0], nil);
            }
            else {//创建一个新的会话
                NSMutableDictionary *tempAttr = [NSMutableDictionary dictionary];
                if (isNotEmpty(attributes)) {//新增扩展属性
                    [tempAttr addEntriesFromDictionary:attributes];
                }
                [self.client createConversationWithName:nil clientIds:members attributes:tempAttr options:AVIMConversationOptionNone callback:callback];
            }
        }
    }];
}
//根据convId数组查询所有会话
- (void)fetchConvsWithConvids:(NSSet *)convids callback:(AVIMArrayResultBlock)callback {
    if (convids.count > 0) {
        AVIMConversationQuery *q = [self.client conversationQuery];
        [q whereKey:@"objectId" containedIn:[convids allObjects]];
        q.cachePolicy = kAVCachePolicyNetworkOnly;
        q.limit = 1000;  // default limit:10
        [q findConversationsWithCallback:callback];
    } else {
        callback([NSMutableArray array], nil);
    }
}


#pragma mark - utils
- (void)sendMessage:(AVIMTypedMessage*)message conversation:(AVIMConversation *)conversation callback:(AVBooleanResultBlock)block {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[@"fromUser"] = USERNAME;
    if (message.attributes == nil) {
        message.attributes = attributes;
    } else {
        [attributes addEntriesFromDictionary:message.attributes];
        message.attributes = attributes;
    }
    [conversation sendMessage:message options:AVIMMessageSendOptionRequestReceipt callback:block];
}


#pragma mark - remote notification
- (BOOL)didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if (userInfo[kParamConvId]) {
        self.remoteNotificationConvid = userInfo[kParamConvId];
        return YES;
    }
    self.remoteNotificationConvid = nil;
    return NO;
}


#pragma mark - AVIMClientDelegate
- (void)imClientPaused:(AVIMClient *)imClient {
    [self updateConnectStatus];
}
- (void)imClientResuming:(AVIMClient *)imClient {
    [self updateConnectStatus];
}
- (void)imClientResumed:(AVIMClient *)imClient {
    [self updateConnectStatus];
}


#pragma mark - status
// 除了 sdk 的上面三个回调调用了，还在 open client 的时候调用了，好统一处理
- (void)updateConnectStatus {
    [[NSNotificationCenter defaultCenter] postNotificationName:kCDNotificationConnectivityUpdated object:@(self.connect)];
}
- (BOOL)connect {
    return self.client.status == AVIMClientStatusOpened;
}

#pragma mark - receive message handle
- (void)receiveMessage:(AVIMTypedMessage *)message conversation:(AVIMConversation *)conversation {
    //>>>>>>>>>B端有新的救援就发送通知，主要解决问题：B端在救援管理主页面时，如果有新的救援到达看不到>>>>>>>>>>>>
    if (NO == [[CDConversationStore store] isConversationExistsByConvId:conversation.conversationId]) {
        if ([EzgoalTypeRescue isEqualToString:conversation.ezgoalType] &&
            RescueStatusTypeUnProcess == conversation.ezgoalStatus &&
            kAVIMMessageMediaTypeLocation == message.mediaType) {
            postN(kNotificationRefreshRescueList);
        }
    }
    //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    
    [[CDConversationStore store] updateConversation:conversation];
    [[CDConversationStore store] updateLastMessage:message byConvId:conversation.conversationId];
    
    if ([self.chattingConversationId isEqualToString:conversation.conversationId] == NO) {
        // 没有在聊天的时候才增加未读数和设置mentioned
        [[CDConversationStore store] increaseUnreadCountByConvId:conversation.conversationId];
        if ([self isMentionedByMessage:message]) {
            [[CDConversationStore store] updateMentioned:YES convId:conversation.conversationId];
        }
    }
    if (self.chattingConversationId == nil) {
        if (conversation.muted == NO) {
            [[CDSoundManager manager] playLoudReceiveSoundIfNeed];
            [[CDSoundManager manager] vibrateIfNeed];
        }
    }
    [conversation markAsReadInBackground];
    //只要接受到消息，就表示之前所有已发送的消息都是已读的>>>
    NSString *received_convid = [NSString stringWithFormat:@"received_%@", Trim(conversation.conversationId)];
    YSCSaveCacheObject(@(message.sendTimestamp), received_convid);
    //在进入聊天对话框的时候就设置为已读<<<<<<<<<<<<<<<<<<
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kCDNotificationMessageReceived object:message];
}

#pragma mark - AVIMMessageDelegate
// content : "this is message"
- (void)conversation:(AVIMConversation *)conversation didReceiveCommonMessage:(AVIMMessage *)message {
    // 不做处理，此应用没有用到
    // 可以看做跟 AVIMTypedMessage 两个频道。构造消息和收消息的接口都不一样，互不干扰。
    // 其实一般不用，有特殊的需求时可以考虑优先用 自定义 AVIMTypedMessage 来实现。见 AVIMCustomMessage 类
}
// content : "{\"_lctype\":-1,\"_lctext\":\"sdfdf\"}"  sdk 会解析好
- (void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message {
    if (message.messageId) {
        if (conversation.creator == nil && [[CDConversationStore store] isConversationExistsByConvId:conversation.conversationId] == NO) {
            [conversation fetchWithCallback:^(BOOL succeeded, NSError *error) {
                if (error) {
                    DLog(@"%@", error);
                } else {
                    [self receiveMessage:message conversation:conversation];
                }
            }];
        } else {
            [self receiveMessage:message conversation:conversation];
        }
    }
    else {
        DLog(@"Receive Message , but MessageId is nil");
    }
}
//NOTE:消息已经发送给对方，对方会立即返回这条消息，用于改变本地消息的状态，但是该状态不能保存在服务端，因此接收方有可能接收不到
- (void)conversation:(AVIMConversation *)conversation messageDelivered:(AVIMMessage *)message {
    DLog();
    if (message != nil) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kCDNotificationMessageDelivered object:message];
    }
}
//接收到未读消息数的通知
- (void)conversation:(AVIMConversation *)conversation didReceiveUnread:(NSInteger)unread {
    // 需要开启 AVIMUserOptionUseUnread 选项，见 init
    DLog(@"conversatoin:%@ didReceiveUnread:%@", conversation, @(unread));
    [conversation markAsReadInBackground];
}

#pragma mark - AVIMClientDelegate
- (void)conversation:(AVIMConversation *)conversation membersAdded:(NSArray *)clientIds byClientId:(NSString *)clientId {
    DLog();
}
- (void)conversation:(AVIMConversation *)conversation membersRemoved:(NSArray *)clientIds byClientId:(NSString *)clientId {
    DLog();
}
- (void)conversation:(AVIMConversation *)conversation invitedByClientId:(NSString *)clientId {
    DLog();
}
- (void)conversation:(AVIMConversation *)conversation kickedByClientId:(NSString *)clientId {
    DLog();
}
- (void)client:(AVIMClient *)client didOfflineWithError:(NSError *)error {
    if ([error code]  == 4111) {//单点登录
        NSDictionary *param = @{kParamMessage : @"您的账号已在其它设备上登录", kParamUserId : Trim(client.clientId)};
        postNWithInfo(kNotificationLoginExpired, param);
    }
}

#pragma mark - signature
- (id)convSignWithSelfId:(NSString *)selfId convid:(NSString *)convid targetIds:(NSArray *)targetIds action:(NSString *)action {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:selfId forKey:@"self_id"];
    if (convid) {
        [dict setObject:convid forKey:@"convId"];
    }
    if (targetIds) {
        [dict setObject:targetIds forKey:@"targetIds"];
    }
    if (action) {
        [dict setObject:action forKey:@"action"];
    }
    //这里是从云代码获取签名，也可以从你的服务器获取
    return [AVCloud callFunction:@"conv_sign" withParameters:dict];
}
- (AVIMSignature *)getAVSignatureWithParams:(NSDictionary *)fields peerIds:(NSArray *)peerIds {
    AVIMSignature *avSignature = [[AVIMSignature alloc] init];
    NSNumber *timestampNum = [fields objectForKey:@"timestamp"];
    long timestamp = [timestampNum longValue];
    NSString *nonce = [fields objectForKey:@"nonce"];
    NSString *signature = [fields objectForKey:@"signature"];
    
    [avSignature setTimestamp:timestamp];
    [avSignature setNonce:nonce];
    [avSignature setSignature:signature];
    return avSignature;
}
- (AVIMSignature *)signatureWithClientId:(NSString *)clientId
                          conversationId:(NSString *)conversationId
                                  action:(NSString *)action
                       actionOnClientIds:(NSArray *)clientIds {
    if ([action isEqualToString:@"open"] || [action isEqualToString:@"start"]) {
        action = nil;
    }
    if ([action isEqualToString:@"remove"]) {
        action = @"kick";
    }
    if ([action isEqualToString:@"add"]) {
        action = @"invite";
    }
    NSDictionary *dict = [self convSignWithSelfId:clientId convid:conversationId targetIds:clientIds action:action];
    if (dict != nil) {
        return [self getAVSignatureWithParams:dict peerIds:clientIds];
    }
    else {
        return nil;
    }
}

#pragma mark - File Utils
- (NSString *)getFilesPath {
    NSString *appPath = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filesPath = [appPath stringByAppendingString:@"/files/"];
    NSFileManager *fileMan = [NSFileManager defaultManager];
    NSError *error;
    BOOL isDir = YES;
    if ([fileMan fileExistsAtPath:filesPath isDirectory:&isDir] == NO) {
        [fileMan createDirectoryAtPath:filesPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            [NSException raise:@"error when create dir" format:@"error"];
        }
    }
    return filesPath;
}
- (NSString *)getPathByObjectId:(NSString *)objectId {
    return [[self getFilesPath] stringByAppendingFormat:@"%@", objectId];
}
- (NSString *)videoPathOfMessag:(AVIMVideoMessage *)message {
    // 视频播放会根据文件扩展名来识别格式
    return [[self getFilesPath] stringByAppendingFormat:@"%@.%@", message.messageId, message.format];
}
- (NSString *)tmpPath {
    return [[self getFilesPath] stringByAppendingFormat:@"tmp"];
}
- (NSString *)tempMessageId {
    NSString *chars = @"abcdefghijklmnopgrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    assert(chars.length == 62);
    int len = (int)chars.length;
    NSMutableString *result = [[NSMutableString alloc] init];
    for (int i = 0; i < 24; i++) {
        int p = arc4random_uniform(len);
        NSRange range = NSMakeRange(p, 1);
        [result appendString:[chars substringWithRange:range]];
    }
    return result;
}
+ (NSError *)errorWithText:(NSString *)text {
    return [NSError errorWithDomain:@"LeanChatLib" code:0 userInfo:@{NSLocalizedDescriptionKey:text}];
}





//-----------------------会话缓存业务逻辑--------------------------------------------
#pragma mark - conv cache
//只是刷新本地已有的会话列表而已
- (void)selectOrRefreshConversationsWithBlock:(AVIMArrayResultBlock)block {
    NSArray *conversations = [[CDConversationStore store] selectAllConversations];//本地的convId是从哪里来的？？？有新消息到达就插入一条conversation记录
    if (isEmpty(conversations)) {
        block(nil, nil);
        return;
    }
    
    if (self.connect) {//如果是联网状态就从网络下载最新的会话列表
        NSMutableSet *convids = [NSMutableSet set];
        for (AVIMConversation *conversation in conversations) {
            [convids addObject:Trim(conversation.conversationId)];
        }
        //刷新会话列表
        [self fetchConvsWithConvids:convids callback:^(NSArray *objects, NSError *error) {
            if (error) {
                block(conversations, error);//刷新会话出错！直接返回缓存数组。这里返回的error没有用！因为conversations肯定不为空！
            } else {
                if ([objects count] > 0) {
                    [[CDConversationStore store] updateConversations:objects];//保存会话列表
                    block([[CDConversationStore store] selectAllConversations], nil);//返回最新的会话列表
                }
                else {
                    block(nil, nil);
                }
            }
        }];
    }
    else {//没有联网就直接返回本地缓存的会话列表
        block(conversations, nil);
    }
}

#pragma mark - mention
//当前消息是否@我
- (BOOL)isMentionedByMessage:(AVIMTypedMessage *)message {
    if (![message isKindOfClass:[AVIMTextMessage class]]) {
        return NO;
    } else {
        NSString *text = ((AVIMTextMessage *)message).text;
        NSString *pattern = [NSString stringWithFormat:@"@%@ ",[AVUser currentUser].username];
        if([text rangeOfString:pattern].length > 0) {
            return YES;
        } else {
           return NO;
        }
    }
}

@end
