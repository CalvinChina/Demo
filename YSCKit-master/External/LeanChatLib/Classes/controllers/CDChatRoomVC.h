//
//  CDChatRoomController.h
//  LeanChat
//
//  Created by Qihe Bian on 7/28/14.
//  Copyright (c) 2014 LeanCloud. All rights reserved.
//

#import "XHMessageTableViewController.h"
#import "CDChatManager.h"

/**
 *  聊天页面
 */
@interface CDChatRoomVC : XHMessageTableViewController

@property (nonatomic, strong, readonly) AVIMConversation *conv;
@property (nonatomic, strong, readonly) NSMutableArray *msgs;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, assign) BOOL isAppeared;//用于底部工具栏动画控制

- (instancetype)initWithConv:(AVIMConversation *)conv;
//更新用户信息
- (void)updateUserInfo:(ChatUserModel *)chatUser;
//关闭当前会话页面
- (void)closeCurrentViewControllerAnimated:(BOOL)animated block:(YSCBlock)block;
//重置conv
- (void)resetConversation;

#pragma mark - EZGMessageTableViewCell action
- (void)multiMediaMessageDidSelectedOnMessage:(AVIMTypedMessage *)message atIndexPath:(NSIndexPath *)indexPath onMessageTableViewCell:(EZGMessageBaseCell *)messageTableViewCell;
- (void)didDoubleSelectedOnTextMessage:(AVIMTypedMessage *)message atIndexPath:(NSIndexPath *)indexPath;
- (void)didSelectedAvatorOnMessage:(AVIMTypedMessage *)message atIndexPath:(NSIndexPath *)indexPath;
- (void)didRetrySendMessage:(AVIMTypedMessage *)message atIndexPath:(NSIndexPath *)indexPath;

#pragma mark - select share menu item
//点击扩展功能按钮-发送位置
- (void)didClickedShareMenuItemSendLocation;
//点击扩展功能按钮-发送拍摄照片
- (void)didClickedShareMenuItemCamera;
//点击扩展功能按钮-发送图片
- (void)didClickedShareMenuItemSendPhoto;
//根据地理位置信息和地理经纬度开始发送地理位置消息
- (void)didSendGeolocationsMessageWithGeolocaltions:(NSString *)geolocations location:(CLLocation *)location level:(NSInteger)level;
//发送消息
- (void)sendMsg:(AVIMTypedMessage *)msg;
@end
