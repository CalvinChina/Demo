//
//  CDChatRoomController.m
//  LeanChat
//
//  Created by Qihe Bian on 7/28/14.
//  Copyright (c) 2014 LeanCloud. All rights reserved.
//

#import <CommonCrypto/CommonCrypto.h>
#import "CDChatRoomVC.h"
#import "XHDisplayTextViewController.h"

#import "LZStatusView.h"
#import "CDEmotionUtils.h"
#import "AVIMConversation+Custom.h"
#import "CDSoundManager.h"
#import "CDConversationStore.h"
#import "CDFailedMessageStore.h"
#import "AVIMEmotionMessage.h"
#import "MJRefresh.h"

@interface CDChatRoomVC () <UINavigationControllerDelegate, UIImagePickerControllerDelegate,
ZYQAssetPickerControllerDelegate>
@property (nonatomic, strong, readwrite) AVIMConversation *conv;
@property (atomic, assign) NSInteger currentSelectedIndex;
@property (nonatomic, strong) NSArray *emotionManagers;
@property (nonatomic, strong) LZStatusView *clientStatusView;
@property (nonatomic, assign) int64_t lastSentTimestamp;
@property (nonatomic, strong) NSString *isUserChangedIdentifier;
@end

@implementation CDChatRoomVC

#pragma mark - life cycle
- (instancetype)initWithConv:(AVIMConversation *)conv {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.conv = conv;
    }
    return self;
}
//重置conv
- (void)resetConversation {
    AVIMConversation *conversation = [[CDConversationStore store] selectOneConversationByConvId:self.conv.conversationId];
    if (conversation) {
        self.conv = conversation;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isAppeared = NO;
    YSCInstance.currentViewController = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessage:) name:kCDNotificationMessageReceived object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMessageDelivered:) name:kCDNotificationMessageDelivered object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateStatusView) name:kCDNotificationConnectivityUpdated object:nil];
    
    NSString *received_convid = [NSString stringWithFormat:@"received_%@", Trim(self.conv.conversationId)];
    self.lastSentTimestamp = [YSCGetCacheObject(received_convid) longLongValue];
    [self initBottomMenu];
    [self initEmotionView];
    [self.view addSubview:self.clientStatusView];
    [self updateStatusView];
    
    //配置下拉刷新
    WEAKSELF
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf queryMessages];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.messageTableView.header = header;
    self.currentSelectedIndex = -1;
    [self queryMessages];
    
    //重新设置返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:DefaultNaviBarArrowBackImage
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(closeCurrentViewController)];
    //用户信息
    APPDATA.chatUser = [ChatUserModel GetLocalDataByUserId:self.conv.otherId];//重置当前聊天对象
    if (nil == APPDATA.chatUser) {
        self.title = @"聊天";
    }
    else {
        [self updateUserInfo:APPDATA.chatUser];
    }
    [self refreshUserInfo];
    //监控用户是否被挤下线了
    self.isUserChangedIdentifier = [APPDATA bk_addObserverForKeyPath:@"isUserChanged" task:^(id target) {
        if (ISNOTLOGGED) {
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}
//更新用户头像和昵称等信息
- (void)refreshUserInfo {
    WEAKSELF
    [ChatUserModel RefreshByUserIds:@[Trim(self.conv.otherId)] ezgoalType:self.conv.ezgoalType block:^(NSObject *object, NSString *errorMessage) {
        NSArray *array = (NSArray *)object;
        if (isNotEmpty(object) && [array isKindOfClass:[NSArray class]]) {
            ChatUserModel *chatUser = array[0];
            if (nil == APPDATA.chatUser ||
                NO == [chatUser.phoneNumber isEqualToString:APPDATA.chatUser.phoneNumber] ||
                NO == [chatUser.avatarUrl isEqualToString:APPDATA.chatUser.avatarUrl] ||
                NO == [chatUser.userName isEqualToString:APPDATA.chatUser.userName]) {
                APPDATA.chatUser = [ChatUserModel GetLocalDataByUserId:weakSelf.conv.otherId];//从缓存数据库中查询
                [weakSelf updateUserInfo:APPDATA.chatUser];//刷新本页对方相关信息
                [weakSelf.messageTableView reloadData];//刷新本页列表
                YSCResultBlock block = weakSelf.params[kParamBlock];
                if (block) {
                    block(nil);//刷新cell，更新用户昵称和头像
                }
            }
        }
    }];
}
//更新用户信息
- (void)updateUserInfo:(ChatUserModel *)chatUser {
    self.title = Trim(chatUser.userName);//会话对方的昵称
}
- (void)closeCurrentViewController {
    [self closeCurrentViewControllerAnimated:YES block:nil];
}
//关闭当前会话页面
- (void)closeCurrentViewControllerAnimated:(BOOL)animated block:(YSCBlock)block {
    if (self.messageInputView.isRecording) {
        return ;//正在录音中
    }
    if (self.navigationController) {            //如果有navigationBar
        NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
        if (index > 0) {                        //不是root，就返回上一级
            [self.navigationController popViewControllerAnimated:animated];
            if (block) {
                block();
            }
        }
        else {
            [self.presentingViewController dismissViewControllerAnimated:animated completion:^{
                if (block) {
                    block();
                }
            }];
        }
    }
    else {
        [self.presentingViewController dismissViewControllerAnimated:animated completion:^{
            if (block) {
                block();
            }
        }];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [CDChatManager manager].chattingConversationId = self.conv.conversationId;
}
- (void)viewDidDisappear:(BOOL)animated {
    self.isAppeared = NO;
    [self stopPlayingAudio];
    [CDChatManager manager].chattingConversationId = nil;
    //如果有未读消息，且通过推送栏进入本页面后，继续有新消息到达，退出的时候就需要清空conv的未读消息，
    //因为处于当前页面时不会发送kCDNotificationUnreadsUpdated通知！
    [self updateConversationAsRead];
    [super viewDidDisappear:animated];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.isAppeared = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    YSCResultBlock block = self.params[kParamBlock];
    if (block) {
        block(nil);//刷新cell，更新最后一条聊天记录
    }
    [super viewWillDisappear:animated];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCDNotificationMessageReceived object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCDNotificationMessageDelivered object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCDNotificationConnectivityUpdated object:nil];
    if (self.isUserChangedIdentifier) {
        [APPDATA bk_removeObserversWithIdentifier:self.isUserChangedIdentifier];
    }
}

#pragma mark - ui init
//初始化扩展区域
- (void)initBottomMenu {
    NSMutableArray *shareMenuItems = [NSMutableArray array];
    NSArray *plugIcons = @[@"sharemore_pic", @"sharemore_video", @"sharemore_location"];
    NSArray *plugTitle = @[@"照片", @"拍摄", @"位置"];
    for (NSString *plugIcon in plugIcons) {
        XHShareMenuItem *shareMenuItem = [[XHShareMenuItem alloc] initWithNormalIconImage:[UIImage imageNamed:plugIcon] title:[plugTitle objectAtIndex:[plugIcons indexOfObject:plugIcon]]];
        [shareMenuItems addObject:shareMenuItem];
    }
    self.shareMenuView.shareMenuItems = shareMenuItems;
    [self.shareMenuView reloadData];
}
//初始化表情管理器
- (void)initEmotionView {
    _emotionManagers = [CDEmotionUtils emotionManagers];
    self.emotionManagerView.isShowEmotionStoreButton = YES;
    [self.emotionManagerView reloadData];
}

#pragma mark - connect status view
- (LZStatusView *)clientStatusView {
    if (_clientStatusView == nil) {
        _clientStatusView = [[LZStatusView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, kLZStatusViewHight)];
        _clientStatusView.hidden = YES;
    }
    return _clientStatusView;
}
- (void)updateStatusView {
    self.clientStatusView.hidden = ([CDChatManager manager].client.status == AVIMClientStatusOpened);
}

#pragma mark -  ui config
// 是否显示时间轴Label的回调方法
- (BOOL)shouldDisplayTimestampForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > 0 && indexPath.row < [self.messages count]) {
        AVIMTypedMessage *currentMsg = [self.messages objectAtIndex:indexPath.row];
        AVIMTypedMessage *lastMsg = [self.messages objectAtIndex:indexPath.row - 1];
        return currentMsg.sendTimestamp - lastMsg.sendTimestamp > 60 * 1 * 1000;//NOTE:超过N分钟间隔就显示时间
    }
    else {
        return NO;
    }
}
// 是否支持用户手动滚动
- (BOOL)shouldPreventScrollToBottomWhileUserScrolling {
    return YES;
}

#pragma mark - alert and async utils
- (void)alert:(NSString *)msg block:(void (^)(void))block{
    UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:msg];
    [alertView bk_setCancelButtonWithTitle:@"确定" handler:block];
    [alertView show];
}
- (BOOL)alertError:(NSError *)error {
    if (error) {
        [YSCManager SaveNSError:error];
        if (error.code == 4303 || kAVIMErrorConversationNotFound == error.code) {
            [[CDConversationStore store] deleteConversationByConvId:self.conv.conversationId];//删除本地不存在的会话
            self.conv = nil;
            WEAKSELF
            [self alert:@"会话不存在" block:^{
                [weakSelf bk_performBlock:^(id obj) {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                } afterDelay:kDefaultDuration];
            }];
        }
        else if (kAVIMErrorConnectionLost == error.code) {
            [UIView showResultThenHideOnWindow:@"未能连接聊天服务器"];
            postN(kNotificationConnectToChatServer);
        }
        else if (kAVIMErrorConnectionLost == error.code || kAVIMErrorClientNotOpen == error.code) {
            [UIView showResultThenHideOnWindow:@"会话连接断开"];
        }
        else if (kAVIMErrorMessageTooLong == error.code) {
            [UIView showResultThenHideOnWindow:@"消息太长"];
        }
        else if ([error.domain isEqualToString:NSURLErrorDomain]) {
            [UIView showResultThenHideOnWindow:@"网络连接错误"];
        }
        else {
            NSString *messageDetail = GetNSErrorMsg(error);
            if (isEmpty(messageDetail)) {
                messageDetail = @"会话连接失败";
            }
            [self alert:messageDetail block:nil];
        }
        return YES;
    }
    return NO;
}
- (void)runInMainQueue:(void (^)())queue {
    dispatch_async(dispatch_get_main_queue(), queue);
}
- (void)runInGlobalQueue:(void (^)())queue {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), queue);
}

#pragma mark - conversations store
- (void)updateConversationAsRead {
    if (self.conv) {
        [[CDConversationStore store] updateConversation:self.conv];
        [[CDConversationStore store] updateUnreadCountToZeroByConvId:self.conv.conversationId];
        [[CDConversationStore store] updateMentioned:NO convId:self.conv.conversationId];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kCDNotificationUnreadsUpdated object:nil];
}

#pragma mark - EZGMessageTableViewCell action
//设置cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EZGMessageBaseCell *cell = (EZGMessageBaseCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    AVIMTypedMessage *message = self.messages[indexPath.row];
    WEAKSELF
    [cell.bubbleImageView removeAllGestureRecognizers];
    
    //1. 单击头像
    [cell.avatarImageView removeAllGestureRecognizers];
    [cell.avatarImageView bk_whenTapped:^{
        [weakSelf didSelectedAvatorOnMessage:message atIndexPath:indexPath];
    }];
    
    //2. 单击重发消息
    [cell.statusView.retryButton bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
    [cell.statusView.retryButton bk_addEventHandler:^(id sender) {
        [weakSelf didRetrySendMessage:message atIndexPath:indexPath];
    } forControlEvents:UIControlEventTouchUpInside];
    
    //3. 双击文本消息
    if (kAVIMMessageMediaTypeText == message.mediaType) {
        [cell.bubbleImageView bk_whenDoubleTapped:^{
            [weakSelf didDoubleSelectedOnTextMessage:message atIndexPath:indexPath];
        }];
    }
    
    //4. 单击消息体
    [cell.bubbleImageView bk_whenTapped:^{
        [cell setupNormalMenuController];
        //点击媒体消息
        [weakSelf multiMediaMessageDidSelectedOnMessage:message atIndexPath:indexPath onMessageTableViewCell:cell];
    }];
    //5. 添加长按手势
    [cell addLongPressGesture];
    
    //6. 设置音频cell
    if (kAVIMMessageMediaTypeAudio == message.mediaType) {
        EZGMessageVoiceCell *voiceCell = (EZGMessageVoiceCell *)cell;
        if (self.currentSelectedIndex == indexPath.row) {
            [voiceCell.animationVoiceImageView startAnimating];
        }
        else {
            [voiceCell.animationVoiceImageView stopAnimating];
        }
    }
    return cell;
}
//单击消息体
- (void)multiMediaMessageDidSelectedOnMessage:(AVIMTypedMessage *)message atIndexPath:(NSIndexPath *)indexPath onMessageTableViewCell:(EZGMessageBaseCell *)messageTableViewCell {
    WEAKSELF
    //1. 正在录音过程中不能跳转页面
    if (self.messageInputView.isRecording) {
        return;
    }
    //2. 单击消息体跳转页面
    if (kAVIMMessageMediaTypeAudio == message.mediaType) {//播放声音
        NSInteger oldIndex = self.currentSelectedIndex;
        [self stopPlayingAudio];
        if (indexPath.row != oldIndex) {//停止播放之前的index和当前不同才开始播放
            self.currentSelectedIndex = indexPath.row;
            [[EMCDDeviceManager sharedInstance] enableProximitySensor];
            [[EMCDDeviceManager sharedInstance] asyncPlayingWithPath:message.file.localPath completion:^(NSError *error) {
                [weakSelf stopPlayingAudio];
            }];
            [self.messageTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    else if (kAVIMMessageMediaTypeImage == message.mediaType) {//打开图片浏览器
        //打开图片浏览器
        YSCBaseViewController *photoDetail = (YSCBaseViewController *)[UIResponder createBaseViewController:@"YSCPhotoBrowseViewController"];
        
        //NOTE:遍历当前消息数组里所有的图片
        NSMutableArray *photoArray = [NSMutableArray array];
        NSInteger photoIndex = 0;
        for (AVIMTypedMessage *msg in self.messages) {
            if (kAVIMMessageMediaTypeImage == msg.mediaType) {
                YSCPhotoBrowseCellModel *model = [YSCPhotoBrowseCellModel new];
                if (msg.file.isDataAvailable) {
                    NSData *imageData = [msg.file getData];
                    if (imageData) {
                        model.image = [UIImage imageWithData:imageData];
                    }
                    else {
                        model.imageUrl = Trim(msg.file.url);
                    }
                }
                else if (isNotEmpty(msg.file.localPath)) {
                    model.imageUrl = Trim(msg.file.localPath);
                }
                else if (isNotEmpty(msg.file.url)) {
                    model.imageUrl = Trim(msg.file.url);
                }
                
                [photoArray addObject:model];
                if ([message.messageId isEqualToString:msg.messageId]) {
                    photoIndex = [photoArray count] - 1;
                }
            }
        }
        photoDetail.params = @{kParamImageModels : photoArray, kParamIndex : @(photoIndex)};
        [self.navigationController pushViewController:photoDetail animated:NO];
    }
    else if (kAVIMMessageMediaTypeLocation == message.mediaType) {//查看位置
        YSCBaseViewController *mapViewController = (YSCBaseViewController *)[UIResponder createBaseViewController:@"YSCLocationDisplayViewController"];
        AVIMLocationMessage *locMessage = (AVIMLocationMessage *)message;
        mapViewController.params = @{kParamBackType : @(BackTypeImage),
                                     kParamLatitude : @(locMessage.latitude),
                                     kParamLongitude : @(locMessage.longitude)};
        [self.navigationController pushViewController:mapViewController animated:YES];
    }
    else if (kAVIMMessageMediaTypeVideo == message.mediaType) {
        //TODO:播放视频
    }
}
//双击文本消息
- (void)didDoubleSelectedOnTextMessage:(AVIMTypedMessage *)message atIndexPath:(NSIndexPath *)indexPath {
    XHDisplayTextViewController *displayTextViewController = [[XHDisplayTextViewController alloc] init];
    displayTextViewController.message = message;
    [self.navigationController pushViewController:displayTextViewController animated:YES];
}
//单击头像
- (void)didSelectedAvatorOnMessage:(AVIMTypedMessage *)message atIndexPath:(NSIndexPath *)indexPath {
    DLog(@"indexPath : %@", indexPath);
}
//重发消息
- (void)didRetrySendMessage:(AVIMTypedMessage *)message atIndexPath:(NSIndexPath *)indexPath {
    [self resendMessage:message atIndexPath:indexPath discardIfFailed:false];
}
//停止音频播放
- (void)stopPlayingAudio {
    [[EMCDDeviceManager sharedInstance] stopPlaying];//停止播放
    [[EMCDDeviceManager sharedInstance] disableProximitySensor];//停止接近传感器的检测
    
    if (self.currentSelectedIndex >= 0) {
        //停止cell动画
        EZGMessageVoiceCell *voiceCell = [self.messageTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentSelectedIndex inSection:0]];
        [voiceCell.animationVoiceImageView stopAnimating];
        self.currentSelectedIndex = -1;
    }
}



//================================================
//
//  扩展功能
//
//================================================
#pragma mark - XHShareMenuViewDelegate
//点击扩展区域的功能按钮
- (void)didSelecteShareMenuItem:(XHShareMenuItem *)shareMenuItem atIndex:(NSInteger)index {
    if ([@"照片" isEqualToString:shareMenuItem.title]) {
        [self didClickedShareMenuItemSendPhoto];
    }
    else if ([@"拍摄" isEqualToString:shareMenuItem.title]) {
        [self didClickedShareMenuItemCamera];
    }
    else if ([@"位置" isEqualToString:shareMenuItem.title]) {
        [self didClickedShareMenuItemSendLocation];
    }
}
#pragma mark - select share menu item
//点击扩展功能按钮-发送位置
- (void)didClickedShareMenuItemSendLocation {
    WEAKSELF
    YSCResultBlock block = ^(NSObject *object) {//发送位置信息
        if (object) {
            SearchPoiModel *dataModel = (SearchPoiModel *)object;
            CLLocation *location = [[CLLocation alloc] initWithLatitude:dataModel.poiLocation.latitude longitude:dataModel.poiLocation.longitude];
            NSString *locationAddress = isEmpty(dataModel.poiAddress) ? Trim(dataModel.poiName) : Trim(dataModel.poiAddress);
            [weakSelf didSendGeolocationsMessageWithGeolocaltions:locationAddress location:location level:dataModel.level];
        }
        else {
            [UIView showResultThenHideOnWindow:@"没有选择位置信息"];
        }
    };
    YSCBaseViewController *viewController = (YSCBaseViewController *)[UIResponder createBaseViewController:@"EZGAddressSearchViewController"];
    viewController.params = @{kParamBackType : @(BackTypeImage), kParamBlock : block};
    [self presentViewController:[UIResponder createNavigationControllerWithRootViewController:viewController]
                       animated:YES completion:nil];
}
//点击扩展功能按钮-发送拍摄照片
- (void)didClickedShareMenuItemCamera {
    [UIView PresentCameraPickerOnViewController:self];
}
//点击扩展功能按钮-发送图片
- (void)didClickedShareMenuItemSendPhoto {
    [UIView PresentImagePickerOnViewController:self numberOfSelection:9];
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    WEAKSELF
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *pickedImage = [info objectForKey:UIImagePickerControllerEditedImage];
        if ( ! pickedImage) {
            pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        
        //处理获得的图片对象
        if (pickedImage) {
            [[ALAssetsLibrary new] saveImage:pickedImage toAlbum:@"翼畅行" completion:nil failure:nil];
            [weakSelf didSendMessageWithPhoto:[YSCImageManager ResizeImage:pickedImage]];
        }
        else {
            [UIView showResultThenHideOnWindow:@"未选择图片"];
        }
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - ZYQAssetPickerControllerDelegate
- (void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets {
    for (int i = 0; i<assets.count; i++) {
        ALAsset *asset = assets[i];
        UIImage *pickedImage = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        UIImage *sendImage = [YSCImageManager ResizeImage:pickedImage];
        [self didSendMessageWithPhoto:sendImage];
    }
}
- (void)assetPickerControllerDidCancel:(ZYQAssetPickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}



//================================================
//
//  toolBar相关delegate
//
//================================================
#pragma mark - XHMessageInputView Delegate
//开始录音
- (void)prepareRecordingVoiceActionWithCompletion:(BOOL (^)(void))completion {
    [self stopPlayingAudio];
    [super prepareRecordingVoiceActionWithCompletion:completion];
}

#pragma mark - XHEmotionManagerView DataSource
- (NSInteger)numberOfEmotionManagers {
    return self.emotionManagers.count;
}
- (XHEmotionManager *)emotionManagerForColumn:(NSInteger)column {
    return [self.emotionManagers objectAtIndex:column];
}
- (NSArray *)emotionManagersAtManager {
    return self.emotionManagers;
}



//================================================
//
// 消息收发
//
//================================================
#pragma mark - Message Send
//根据文本开始发送文本消息
- (void)didSendMessageWithText:(NSString *)text {
    if (isEmpty(text)) {
        [UIView showResultThenHideOnWindow:@"消息内容不能为空"];
        return;
    }
    AVIMTextMessage *msg = [AVIMTextMessage messageWithText:[CDEmotionUtils plainStringFromEmojiString:text] attributes:nil];
    [self sendMsg:msg];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeText];
}
//根据图片开始发送图片消息
- (void)didSendMessageWithPhoto:(UIImage *)photo {
    NSData *imageData = UIImageJPEGRepresentation(photo, 0.6);
    AVFile *imageFile = [AVFile fileWithData:imageData];
    AVIMImageMessage *msg = [AVIMImageMessage messageWithText:nil file:imageFile attributes:nil];
    [self sendMsg:msg];
}
//根据录音路径开始发送语音消息
- (void)didSendMessageWithVoice:(NSString *)voicePath voiceDuration:(NSString*)voiceDuration {
    AVIMAudioMessage *msg = [AVIMAudioMessage messageWithText:nil attachedFilePath:voicePath attributes:nil];
    [self sendMsg:msg];
}
//根据地理位置信息和地理经纬度开始发送地理位置消息
- (void)didSendGeolocationsMessageWithGeolocaltions:(NSString *)geolocations location:(CLLocation *)location level:(NSInteger)level {
    if (0 == level) {
        level = 15;
    }
    AVIMLocationMessage *locMsg = [AVIMLocationMessage messageWithText:geolocations
                                                              latitude:location.coordinate.latitude
                                                             longitude:location.coordinate.longitude
                                                            attributes:@{MParamMapLevel : @(level)}];
    [self sendMsg:locMsg];
    
}
//发送表情
- (void)didSendEmotionMessageWithEmotion:(NSString *)emotion {
    if ([emotion hasPrefix:@":"]) {
        // 普通表情
        UITextView *textView = self.messageInputView.inputTextView;
        NSRange range = [textView selectedRange];
        NSMutableString *str = [[NSMutableString alloc] initWithString:textView.text];
        [str deleteCharactersInRange:range];
        [str insertString:emotion atIndex:range.location];
        textView.text = [CDEmotionUtils emojiStringFromString:str];
        textView.selectedRange = NSMakeRange(range.location + emotion.length, 0);
    } else {
        AVIMEmotionMessage *msg = [AVIMEmotionMessage messageWithEmotionPath:emotion];
        [self sendMsg:msg];
    }
}

#pragma mark - send message
- (void)sendMsg:(AVIMTypedMessage *)msg {
    msg.status = AVIMMessageStatusSending;

    //>>>>>设置临时消息必要的属性，先在cell中显示出来>>>>>>>>>>>
    msg.messageId = [[CDChatManager manager] tempMessageId];
    msg.sendTimestamp = YSCInstance.currentTimeInterval * 1000;
    msg.clientId = [CDChatManager manager].selfId;
    msg.conversationId = self.conv.conversationId;
    [self appendMessage:msg];
    NSInteger msgIndex = [self.messages indexOfObject:msg];//先缓存该消息在列表中的位置
    [[CDConversationStore store] updateLastMessage:msg byConvId:self.conv.conversationId];//更新最后一条消息对象
    //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    
    WEAKSELF
    [[CDChatManager manager] sendMessage:msg conversation:self.conv callback:^(BOOL succeeded, NSError *error) {
        if ([weakSelf alertError:error]) {
            [[CDFailedMessageStore store] insertFailedMessage:msg];
            msg.status = AVIMMessageStatusFailed;
        }
        else {
            msg.status = AVIMMessageStatusSent;
        }
        [[CDSoundManager manager] playSendSoundIfNeed];
        //NOTE:刷新当前message所在的cell
        if (msgIndex < [weakSelf.messages count]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:msgIndex inSection:0];
            [weakSelf.messageTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
        [weakSelf scrollToBottomAnimated:YES];
    }];
}
- (void)replaceMesssage:(AVIMTypedMessage *)message atIndexPath:(NSIndexPath *)indexPath {
    self.messages[indexPath.row] = message;
    [self.messageTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)resendMessage:(AVIMTypedMessage *)msg atIndexPath:(NSIndexPath *)indexPath discardIfFailed:(BOOL)discardIfFailed {
    msg.status = AVIMMessageStatusSending;
    [self replaceMesssage:msg atIndexPath:indexPath];
    NSString *recordId = msg.messageId;//NOTE:先缓存该临时消息的id，因为重发成功后messageId是要改变的
    WEAKSELF
    [[CDChatManager manager] sendMessage:msg conversation:self.conv callback:^(BOOL succeeded, NSError *error) {
        if ([weakSelf alertError:error]) {
            if (discardIfFailed) {//判断是否需要删除重发失败的消息
                [[CDFailedMessageStore store] deleteFailedMessageByRecordId:recordId];
            }
            msg.status = AVIMMessageStatusFailed;
        }
        else {//重发成功后删除失败消息
            [[CDFailedMessageStore store] deleteFailedMessageByRecordId:recordId];
            msg.status = AVIMMessageStatusSent;
        }
        //刷新message所在的cell
        [weakSelf replaceMesssage:msg atIndexPath:indexPath];
    }];
}

#pragma mark - receive and delivered
//处理接收消息
- (void)receiveMessage:(NSNotification *)notification {
    AVIMTypedMessage *message = notification.object;
    if ([message.conversationId isEqualToString:self.conv.conversationId]) {
        //关闭'未读'提示标记>>>>>>>>>>>>>>>>>>>>>>>>>
        for (int pos = 0; pos < self.messages.count; pos++) {
            AVIMTypedMessage *msg = self.messages[pos];
            if (AVIMMessageIOTypeOut == msg.ioType &&
                AVIMMessageStatusDelivered != msg.status) {
                msg.status = AVIMMessageStatusDelivered;
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:pos inSection:0];
                [self.messageTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
        //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        
        if (NO == self.conv.muted) {
            [[CDSoundManager manager] playReceiveSoundIfNeed];
        }
        [self appendMessage:message];
    }
}
//处理消息已送达
- (void)onMessageDelivered:(NSNotification *)notification {
    AVIMTypedMessage *message = notification.object;
    if ([message.conversationId isEqualToString:self.conv.conversationId]) {
        int foundIndex = -1;
        for (int pos = 0; pos < self.messages.count; pos++) {
            AVIMTypedMessage *msg = self.messages[pos];
            if ([msg.messageId isEqualToString:message.messageId]) {
                foundIndex = pos;
                msg.status = AVIMMessageStatusDelivered;
                break;
            }
        }
        if (foundIndex >= 0) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:foundIndex inSection:0];
            [self.messageTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self scrollToBottomAnimated:YES];
        }
    }
}

#pragma mark - query messages
//自动分页查询聊天消息
- (void)queryMessages {
    int64_t timestamp = 0;
    NSInteger pageSize = 30;//FIXME:临时解决方案 - 第1页显示的时候强制多获取点服务端的数据
    if (isNotEmpty(self.messages)) {
        AVIMTypedMessage *msg = self.messages[0];
        timestamp = msg.sendTimestamp;
        pageSize = 10;
        if (0 == timestamp) {//NOTEO:万一消息的发送时间为0不能当做第1页处理
            timestamp = YSCInstance.currentTimeInterval * 1000;
        }
    }
    WEAKSELF
    AVIMArrayResultBlock callback = ^(NSArray *msgs, NSError *error) {
        if (isNotEmpty(msgs)) {
            //1. 处理查询回来的原始数据
            NSMutableArray *typedMessages = [NSMutableArray array];
            for (AVIMTypedMessage *message in msgs) {
                if ([message isKindOfClass:[AVIMTypedMessage class]]) {
                    //设置消息是已读的>>>>>>>>>>>>>>>>>>>
                    if (message.sendTimestamp <= weakSelf.lastSentTimestamp &&
                        AVIMMessageIOTypeOut == message.ioType &&
                        AVIMMessageStatusDelivered != message.status) {
                        message.status = AVIMMessageStatusDelivered;
                    }
                    //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                    [typedMessages addObject:message];
                }
            }
            
            //2. 处理发送失败的消息
            if (0 == timestamp) {
                [weakSelf updateConversationAsRead];
                [weakSelf.messages removeAllObjects];
                if (isNotEmpty(typedMessages)) {
                    [weakSelf.messages addObjectsFromArray:typedMessages];
                    //更新最后一条消息对象
                    AVIMTypedMessage *lastMessage = [weakSelf.messages lastObject];
                    if (NO == [lastMessage.messageId isEqualToString:weakSelf.conv.lastMessage.messageId]) {
                        [[CDConversationStore store] updateLastMessage:lastMessage
                                                              byConvId:weakSelf.conv.conversationId];
                    }
                    //显示消息列表
                    NSArray *failedMessages = [[CDFailedMessageStore store] selectFailedMessagesByConversationId:weakSelf.conv.conversationId];
                    [weakSelf.messages addObjectsFromArray:failedMessages];//追加上次发送错误的消息
                    [weakSelf.messageTableView reloadData];
                    [weakSelf scrollToBottomAnimated:NO];
                    if ([CDChatManager manager].connect) {//如果连接上，则重发所有的失败消息
                        for (NSInteger i = typedMessages.count; i < weakSelf.messages.count; i++) {
                            [weakSelf resendMessage:weakSelf.messages[i] atIndexPath:[NSIndexPath indexPathForRow:i inSection:0] discardIfFailed:YES];
                        }
                    }
                }
                [weakSelf.messageTableView.header endRefreshing];
            }
            //3. 处理加载更多消息
            else {
                if (isNotEmpty(typedMessages)) {
                    [weakSelf insertOldMessages:typedMessages completion: ^{
                        [weakSelf.messageTableView.header endRefreshing];
                    }];
                }
                else {
                    [weakSelf.messageTableView.header endRefreshing];
                }
            }
        }
        else {
            [weakSelf alertError:error];
            [weakSelf.messageTableView.header endRefreshing];
        }
    };
    
    //开始查询
    if(timestamp == 0) {
        if ([CDChatManager manager].connect) {//联网情况下只查询服务器端
            [self.conv queryMessagesFromServerWithLimit:pageSize callback:callback];
        }
        else {
            [self.conv queryMessagesWithLimit:pageSize callback:callback];
        }
    }
    else {
        [self.conv queryMessagesBeforeId:nil timestamp:timestamp limit:pageSize callback:callback];
    }
}
//把消息追加到最后
- (void)appendMessage:(AVIMTypedMessage *)message {
    [self.messageTableView beginUpdates];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messages.count inSection:0];
    [self.messages addObject:message];
    [self.messageTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.messageTableView endUpdates];
    [self scrollToBottomAnimated:YES];
}

@end
