//
//  XHMessageTableViewController.h
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-4-24.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <UIKit/UIKit.h>

// Model
#import "XHMessage.h"
#import "XHStoreManager.h"
#import "EMCDDeviceManager.h"

// Views
#import "XHMessageInputView.h"
#import "XHShareMenuView.h"
#import "XHEmotionManagerView.h"

// Factory
#import "XHMessageBubbleFactory.h"
#import "XHMessageVideoConverPhotoFactory.h"

// Categorys
#import "UIScrollView+XHkeyboardControl.h"


@interface XHMessageTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,
XHMessageInputViewDelegate, XHShareMenuViewDelegate, XHEmotionManagerViewDelegate, XHEmotionManagerViewDataSource>

@property (nonatomic, strong) NSMutableArray *messages;//消息数组
@property (nonatomic, strong) UITableView *messageTableView;//用于显示消息的TableView
@property (nonatomic, weak, readonly) XHMessageInputView *messageInputView;//用于显示发送消息类型控制的工具条，在底部
@property (nonatomic, weak, readonly) XHShareMenuView *shareMenuView;//替换键盘的位置的第三方功能控件
@property (nonatomic, weak, readonly) XHEmotionManagerView *emotionManagerView;//管理第三方gif表情的控件


#pragma mark - Message View Controller Default stup
//是否允许手势关闭键盘，默认是允许
@property (nonatomic, assign) BOOL allowsPanToDismissKeyboard; // default is YES
//是否允许发送语音
@property (nonatomic, assign) BOOL allowsSendVoice; // default is YES
//是否允许发送多媒体
@property (nonatomic, assign) BOOL allowsSendMultiMedia; // default is YES
//是否支持发送表情
@property (nonatomic, assign) BOOL allowsSendFace; // default is YES
//输入框的样式，默认为扁平化
@property (nonatomic, assign) XHMessageInputViewStyle inputViewStyle;

#pragma mark - DataSource Change
//插入旧消息数据到头部，仿微信的做法
- (void)insertOldMessages:(NSArray *)oldMessages completion:(void (^)())completion;

#pragma mark - Messages view controller
//完成发送消息的函数
- (void)finishSendMessageWithBubbleMessageType:(XHBubbleMessageMediaType)mediaType;
//是否滚动到底部
- (void)scrollToBottomAnimated:(BOOL)animated;
//滚动到哪一行
- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath
			  atScrollPosition:(UITableViewScrollPosition)position
					  animated:(BOOL)animated;
//是否显示时间轴Label的回调方法
- (BOOL)shouldDisplayTimestampForRowAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark - 发送基本消息
//根据文本开始发送文本消息
- (void)didSendMessageWithText:(NSString *)text;
//根据图片开始发送图片消息
- (void)didSendMessageWithPhoto:(UIImage *)photo;
//根据录音路径开始发送语音消息
- (void)didSendMessageWithVoice:(NSString *)voicePath voiceDuration:(NSString*)voiceDuration;
//根据地理位置信息和地理经纬度开始发送地理位置消息
- (void)didSendGeolocationsMessageWithGeolocaltions:(NSString *)geolocations location:(CLLocation *)location;
//发送表情
- (void)didSendEmotionMessageWithEmotion:(NSString *)emotion;
//根据视频的封面和视频的路径开始发送视频消息(未启用)
- (void)didSendMessageWithVideoConverPhoto:(UIImage *)videoConverPhoto videoPath:(NSString *)videoPath;

//根据bottom的数值配置消息列表的内部布局变化
- (void)setTableViewInsetsWithBottomValue:(CGFloat)bottom;
//根据显示或隐藏的需求对所有第三方Menu进行管理
- (void)layoutOtherMenuViewHiden:(BOOL)hide;
@end
