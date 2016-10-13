//
//  AVIMConversation+CustomAttributes.h
//  LeanChatLib
//
//  Created by lzw on 15/4/8.
//  Copyright (c) 2015年 avoscloud. All rights reserved.
//

#import <AVOSCloudIM/AVOSCloudIM.h>

#define CONV_TYPE @"type"

@interface AVIMConversation (Custom)
/**
 *  最后一条消息。通过 SDK 的消息缓存找到的
 */
@property (nonatomic, strong) AVIMTypedMessage *lastMessage;

/**
 *  未读消息数，保存在了数据库。收消息的时候，更新数据库
 */
@property (nonatomic, assign) NSInteger unreadCount;

/**
 *  是否有人提到了你，配合 @ 功能。不能看最后一条消息。
 *  因为可能倒数第二条消息提到了你，所以维护一个标记。
 */
@property (nonatomic, assign) BOOL mentioned;

@property (nonatomic, strong) NSDate *updatedTime;
@property (nonatomic, assign) BOOL isOfficialStaff;
@property (nonatomic, strong) NSString *ezgoalType;
@property (nonatomic, assign) RescueStatusType ezgoalStatus;
@property (nonatomic, strong) NSString *rescueId;
@property (nonatomic, strong) NSString *s4Id;

//单聊对话的对方的 clientId
- (NSString *)otherId;

@end
