//
//  CDMessageHelper.h
//  LeanChatLib
//
//  Created by lzw on 15/6/30.
//  Copyright (c) 2015年 lzwjava@LeanCloud QQ: 651142978. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloudIM/AVOSCloudIM.h>
#import "AVIMConversation+Custom.h"

@interface CDMessageHelper : NSObject

/**
 *  单例
 *  @return
 */
+ (CDMessageHelper *)helper;

/**
 *  最近对话里的消息概要。 [有人@ 你] [20 条] 老王：今晚一起吃饭吗？
 *  @param message
 *  @param conversation 对话
 *  @return 修饰文本。红色的 [有人@你]
 */
- (NSAttributedString *)attributedStringWithMessage:(AVIMTypedMessage *)message conversation:(AVIMConversation *)conversation;

@end
