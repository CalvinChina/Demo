//
//  CDUserModel.h
//  LeanChatLib
//
//  Created by lzw on 15/4/3.
//  Copyright (c) 2015年 avoscloud. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  聊天的 User Model 协议
 */
@protocol CDUserModel <NSObject>

@required

/**
 *  用户的 id，如果你的用户系统是数字，则可转换成字符串 "123"
 *  @return
 */
- (NSString *)userId;

/**
 *  头像的 url，则最近对话页面和聊天页面使用，会结合缓存来用
 *  @return
 */
- (NSString *)avatarUrl;

/**
 *  用户名
 *  @return
 */
- (NSString *)username;

@end
