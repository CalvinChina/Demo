//
//  XHMessageTableViewController.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-4-24.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHMessageTableViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "XHVoiceRecordHelper.h"
#import "XHVoiceRecordHUD.h"

@interface XHMessageTableViewController ()
@property (nonatomic, assign) BOOL isUserScrolling;//判断是否用户手指滚动
@property (nonatomic, assign) CGFloat previousTextViewContentHeight;//记录旧的textView contentSize Heigth
@property (nonatomic, assign) CGFloat keyboardViewHeight;//记录键盘的高度，为了适配iPad和iPhone
@property (nonatomic, assign) XHInputViewType textViewInputViewType;

@property (nonatomic, weak, readwrite) XHMessageInputView *messageInputView;
@property (nonatomic, weak, readwrite) XHShareMenuView *shareMenuView;
@property (nonatomic, weak, readwrite) XHEmotionManagerView *emotionManagerView;

@property (nonatomic, strong, readwrite) XHVoiceRecordHUD *voiceRecordHUD;
@property (nonatomic, strong) XHVoiceRecordHelper *voiceRecordHelper;//管理录音工具对象
@end

@implementation XHMessageTableViewController

#pragma mark - DataSource Change
//改变数据源需要的子线程
- (void)exChangeMessageDataSourceQueue:(void (^)())queue {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), queue);
}
//执行块代码在主线程
- (void)exMainQueue:(void (^)())queue {
    dispatch_async(dispatch_get_main_queue(), queue);
}

static CGPoint  delayOffset = {0.0};
// http://stackoverflow.com/a/11602040 Keep UITableView static when inserting rows at the top
- (void)insertOldMessages:(NSArray *)oldMessages completion:(void (^)())completion {
    WEAKSELF
    [self exChangeMessageDataSourceQueue:^{
        delayOffset = weakSelf.messageTableView.contentOffset;
        NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithCapacity:oldMessages.count];
        NSMutableIndexSet *indexSets = [[NSMutableIndexSet alloc] init];
        [oldMessages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
            [indexPaths addObject:indexPath];
            delayOffset.y += [weakSelf calculateCellHeightWithMessage:[oldMessages objectAtIndex:idx] atIndexPath:indexPath];
            [indexSets addIndex:idx];
        }];
        NSMutableArray *messages = [[NSMutableArray alloc] initWithArray:weakSelf.messages];
        [messages insertObjects:oldMessages atIndexes:indexSets];
        [weakSelf exMainQueue:^{
            [UIView setAnimationsEnabled:NO];
            weakSelf.messageTableView.userInteractionEnabled = NO;
            [weakSelf.messageTableView beginUpdates];
            weakSelf.messages = messages;
            [weakSelf.messageTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            [weakSelf.messageTableView endUpdates];
            [UIView setAnimationsEnabled:YES];
            [weakSelf.messageTableView setContentOffset:delayOffset animated:NO];
            weakSelf.messageTableView.userInteractionEnabled = YES;
            if (completion) {
                completion();
            }
        }];
    }];
}

#pragma mark - Propertys
- (NSMutableArray *)messages {
    if (!_messages) {
        _messages = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _messages;
}
- (XHShareMenuView *)shareMenuView {
    if (!_shareMenuView) {
        XHShareMenuView *shareMenuView = [[XHShareMenuView alloc] initWithFrame:CGRectMake(0,
                                                                                           CGRectGetHeight(self.view.bounds),
                                                                                           CGRectGetWidth(self.view.bounds),
                                                                                           /*self.keyboardViewHeight*/
                                                                                           120)];
        shareMenuView.delegate = self;
        shareMenuView.backgroundColor = [UIColor colorWithWhite:0.961 alpha:1.000];
        shareMenuView.alpha = 0.0;
        [self.view addSubview:shareMenuView];
        _shareMenuView = shareMenuView;
    }
    [self.view bringSubviewToFront:_shareMenuView];
    return _shareMenuView;
}
- (XHEmotionManagerView *)emotionManagerView {
    if (!_emotionManagerView) {
        XHEmotionManagerView *emotionManagerView = [[XHEmotionManagerView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), self.keyboardViewHeight)];
        emotionManagerView.delegate = self;
        emotionManagerView.dataSource = self;
        emotionManagerView.backgroundColor = [UIColor colorWithWhite:0.961 alpha:1.000];
        emotionManagerView.alpha = 0.0;
        [self.view addSubview:emotionManagerView];
        _emotionManagerView = emotionManagerView;
    }
    [self.view bringSubviewToFront:_emotionManagerView];
    return _emotionManagerView;
}
- (XHVoiceRecordHUD *)voiceRecordHUD {
    if (!_voiceRecordHUD) {
        _voiceRecordHUD = [[XHVoiceRecordHUD alloc] initWithFrame:CGRectMake(0, 0, 140, 140)];
    }
    return _voiceRecordHUD;
}
- (XHVoiceRecordHelper *)voiceRecordHelper {
    if (!_voiceRecordHelper) {
        WEAKSELF
        _voiceRecordHelper = [[XHVoiceRecordHelper alloc] init];
        _voiceRecordHelper.maxTimeStopRecorderCompletion = ^{
            DLog(@"已经达到最大限制时间了，进入下一步的提示");
            [weakSelf finishRecorded];
        };
        _voiceRecordHelper.peakPowerForChannel = ^(float peakPowerForChannel) {
            weakSelf.voiceRecordHUD.peakPower = peakPowerForChannel;
        };
        _voiceRecordHelper.maxRecordTime = kVoiceRecorderTotalTime;
        _voiceRecordHelper.minRecordTime = kVoiceRecorderMinTime;
    }
    return _voiceRecordHelper;
}

#pragma mark - Messages View Controller
- (void)finishSendMessageWithBubbleMessageType:(XHBubbleMessageMediaType)mediaType {
    switch (mediaType) {
        case XHBubbleMessageMediaTypeText: {
            [self.messageInputView.inputTextView setText:nil];
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
                self.messageInputView.inputTextView.enablesReturnKeyAutomatically = NO;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.messageInputView.inputTextView.enablesReturnKeyAutomatically = YES;
                    [self.messageInputView.inputTextView reloadInputViews];
                });
            }
            break;
        }
        case XHBubbleMessageMediaTypePhoto: {
            break;
        }
        case XHBubbleMessageMediaTypeVideo: {
            break;
        }
        case XHBubbleMessageMediaTypeVoice: {
            break;
        }
        case XHBubbleMessageMediaTypeEmotion: {
            break;
        }
        case XHBubbleMessageMediaTypeLocalPosition: {
            break;
        }
        default:
            break;
    }
}
- (void)scrollToBottomAnimated:(BOOL)animated {
	if (![self shouldAllowScroll])
        return;
	
    NSInteger rows = [self.messageTableView numberOfRowsInSection:0];
    
    if (rows > 0) {
        [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:animated];
    }
}
- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath
			  atScrollPosition:(UITableViewScrollPosition)position
					  animated:(BOOL)animated {
	if (![self shouldAllowScroll])
        return;
	
	[self.messageTableView scrollToRowAtIndexPath:indexPath
						  atScrollPosition:position
								  animated:animated];
}

#pragma mark - Previte Method
- (BOOL)shouldAllowScroll {
    if (self.isUserScrolling) {
        return NO;
    }
    
    return YES;
}

#pragma mark - Life Cycle
- (void)initilzer {
    self.navigationController.navigationBar.translucent = YES;//NOTE:与下面的参数必须配套设置，否则top会有64个像素的偏移量
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.keyboardViewHeight = (kIsiPad ? 264 : 216);
    _allowsPanToDismissKeyboard = NO;
    _allowsSendVoice = YES;
    _allowsSendMultiMedia = YES;
    _allowsSendFace = YES;
    _inputViewStyle = XHMessageInputViewStyleFlat;
    
    // 默认设置用户滚动为NO
    _isUserScrolling = NO;
    
    // 初始化message tableView
    self.messageTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	self.messageTableView.dataSource = self;
	self.messageTableView.delegate = self;
    self.messageTableView.separatorColor = [UIColor clearColor];
    self.messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.messageTableView];
    [self.view sendSubviewToBack:self.messageTableView];
    [self.messageTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
        make.right.equalTo(self.view.mas_right);
    }];
    // 设置整体背景颜色
    self.view.backgroundColor = kDefaultViewColor;
    self.messageTableView.backgroundColor = [UIColor clearColor];
    
    //注册自定义消息cell
    [EZGMessageTextCell registerCellToTableView:self.messageTableView];
    [EZGMessageVoiceCell registerCellToTableView:self.messageTableView];
    [EZGMessageImageCell registerCellToTableView:self.messageTableView];
    [EZGMessageLocationCell registerCellToTableView:self.messageTableView];
    [EZGMessageVideoCell registerCellToTableView:self.messageTableView];
    [EZGMessageSceneCell registerCellToTableView:self.messageTableView];
    [EZGMessageCarCell registerCellToTableView:self.messageTableView];
    [EZGMessageServiceCell registerCellToTableView:self.messageTableView];
    [EZGMessageServiceCancelCell registerCellToTableView:self.messageTableView];
    [EZGMessageServiceCommentCell registerCellToTableView:self.messageTableView];
    
    // 设置Message TableView 的bottom edg
    CGFloat inputViewHeight = 45.0f;
    [self setTableViewInsetsWithBottomValue:inputViewHeight];
    
    // 输入工具条的frame
    CGRect inputFrame = CGRectMake(0.0f,
                                   self.view.frame.size.height - inputViewHeight,
                                   self.view.frame.size.width,
                                   inputViewHeight);
    
    WEAKSELF
    if (self.allowsPanToDismissKeyboard) {
        // 控制输入工具条的位置块
        void (^AnimationForMessageInputViewAtPoint)(CGPoint point) = ^(CGPoint point) {
            CGRect inputViewFrame = weakSelf.messageInputView.frame;
            CGPoint keyboardOrigin = [weakSelf.view convertPoint:point fromView:nil];
            inputViewFrame.origin.y = keyboardOrigin.y - inputViewFrame.size.height;
            weakSelf.messageInputView.frame = inputViewFrame;
        };
        
        self.messageTableView.keyboardDidScrollToPoint = ^(CGPoint point) {
            if (weakSelf.textViewInputViewType == XHInputViewTypeText)
                AnimationForMessageInputViewAtPoint(point);
        };
        
        self.messageTableView.keyboardWillSnapBackToPoint = ^(CGPoint point) {
            if (weakSelf.textViewInputViewType == XHInputViewTypeText)
                AnimationForMessageInputViewAtPoint(point);
        };
        
        self.messageTableView.keyboardWillBeDismissed = ^() {
            CGRect inputViewFrame = weakSelf.messageInputView.frame;
            inputViewFrame.origin.y = weakSelf.view.bounds.size.height - inputViewFrame.size.height;
            weakSelf.messageInputView.frame = inputViewFrame;
        };
    }
    self.messageTableView.keyboardWillChange = ^(CGRect keyboardRect, UIViewAnimationOptions options, double duration, BOOL showKeyborad) {
        if (weakSelf.textViewInputViewType == XHInputViewTypeText) {
            [UIView animateWithDuration:duration
                                  delay:0.0
                                options:options
                             animations:^{
                                 CGFloat keyboardY = [weakSelf.view convertRect:keyboardRect fromView:nil].origin.y;
                                 
                                 CGRect inputViewFrame = weakSelf.messageInputView.frame;
                                 CGFloat inputViewFrameY = keyboardY - inputViewFrame.size.height;
                                 
                                 // for ipad modal form presentations
                                 CGFloat messageViewFrameBottom = weakSelf.view.frame.size.height - inputViewFrame.size.height;
                                 if (inputViewFrameY > messageViewFrameBottom)
                                     inputViewFrameY = messageViewFrameBottom;
                                 
                                 weakSelf.messageInputView.frame = CGRectMake(inputViewFrame.origin.x,
                                                                              inputViewFrameY,
                                                                              inputViewFrame.size.width,
                                                                              inputViewFrame.size.height);
                                 
                                 [weakSelf setTableViewInsetsWithBottomValue:weakSelf.view.frame.size.height
                                  - weakSelf.messageInputView.frame.origin.y];
                                 if (showKeyborad)
                                     [weakSelf scrollToBottomAnimated:NO];
                             }
                             completion:nil];
        }
    };
    self.messageTableView.keyboardDidChange = ^(BOOL didShowed) {
        if ([weakSelf.messageInputView.inputTextView isFirstResponder]) {
            if (didShowed) {
                if (weakSelf.textViewInputViewType == XHInputViewTypeText) {
                    weakSelf.shareMenuView.alpha = 0.0;
                    weakSelf.emotionManagerView.alpha = 0.0;
                }
            }
        }
    };
    self.messageTableView.keyboardDidHide = ^() {
        [weakSelf.messageInputView.inputTextView resignFirstResponder];
    };
    
    // 初始化输入工具条
    XHMessageInputView *inputView = [[XHMessageInputView alloc] initWithFrame:inputFrame];
    inputView.allowsSendFace = self.allowsSendFace;
    inputView.allowsSendVoice = self.allowsSendVoice;
    inputView.allowsSendMultiMedia = self.allowsSendMultiMedia;
    inputView.delegate = self;
    [self.view addSubview:inputView];
    [self.view bringSubviewToFront:inputView];
    _messageInputView = inputView;
    
    // 设置手势滑动，默认添加一个bar的高度值
    self.messageTableView.messageInputBarHeight = CGRectGetHeight(_messageInputView.bounds);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initilzer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishRecordingWhenErrorBehaviors) name:UIApplicationWillResignActiveNotification object:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 设置键盘通知或者手势控制键盘消失
    [self.messageTableView setupPanGestureControlKeyboardHide:self.allowsPanToDismissKeyboard];
    
    // KVO 检查contentSize
    [self.messageInputView.inputTextView addObserver:self
                                          forKeyPath:@"contentSize"
                                             options:NSKeyValueObservingOptionNew
                                             context:nil];
    
    [self.messageInputView.inputTextView setEditable:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self finishRecordingWhenErrorBehaviors];
    if (self.textViewInputViewType != XHInputViewTypeNormal) {
        [self layoutOtherMenuViewHiden:YES];
    }
    
    // remove键盘通知或者手势
    [self.messageTableView disSetupPanGestureControlKeyboardHide:self.allowsPanToDismissKeyboard];
    
    // remove KVO
    [self.messageInputView.inputTextView removeObserver:self forKeyPath:@"contentSize"];
    [self.messageInputView.inputTextView setEditable:NO];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    _messages = nil;
    _messageTableView.delegate = nil;
    _messageTableView.dataSource = nil;
    _messageTableView = nil;
    _messageInputView = nil;
}

#pragma mark - RecorderPath Helper Method
- (NSString *)getRecorderPath {
    NSString *recorderPath = nil;
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    recorderPath = [[NSString alloc] initWithFormat:@"%@/Documents/IMRecorderPath", NSHomeDirectory()];
    dateFormatter.dateFormat = @"yyyy-MM-dd-HH-mm-ss";
    recorderPath = [recorderPath stringByAppendingFormat:@"%@-MySound.aac", [dateFormatter stringFromDate:now]];
    return recorderPath;
}

#pragma mark - UITextView Helper Method
//获取某个UITextView对象的content高度
- (CGFloat)getTextViewContentH:(UITextView *)textView {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        return ceilf([textView sizeThatFits:textView.frame.size].height);
    }
    else {
        return textView.contentSize.height;
    }
}

#pragma mark - Layout Message Input View Helper Method
//动态改变TextView的高度
- (void)layoutAndAnimateMessageInputTextView:(UITextView *)textView {
    CGFloat maxHeight = [XHMessageInputView maxHeight];
    CGFloat contentH = [self getTextViewContentH:textView];
    BOOL isShrinking = contentH < self.previousTextViewContentHeight;
    CGFloat changeInHeight = contentH - _previousTextViewContentHeight;
    if (!isShrinking && (self.previousTextViewContentHeight == maxHeight || textView.text.length == 0)) {
        changeInHeight = 0;
    }
    else {
        changeInHeight = MIN(changeInHeight, maxHeight - self.previousTextViewContentHeight);
    }
    
    if (changeInHeight != 0.0f) {
        [UIView animateWithDuration:0.25f
                         animations:^{
                             [self setTableViewInsetsWithBottomValue:self.messageTableView.contentInset.bottom + changeInHeight];
                             
                             [self scrollToBottomAnimated:NO];
                             
                             if (isShrinking) {
                                 if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                                     self.previousTextViewContentHeight = MIN(contentH, maxHeight);
                                 }
                                 // if shrinking the view, animate text view frame BEFORE input view frame
                                 [self.messageInputView adjustTextViewHeightBy:changeInHeight];
                             }
                             
                             CGRect inputViewFrame = self.messageInputView.frame;
                             self.messageInputView.frame = CGRectMake(0.0f,
                                                                      inputViewFrame.origin.y - changeInHeight,
                                                                      inputViewFrame.size.width,
                                                                      inputViewFrame.size.height + changeInHeight);
                             if (!isShrinking) {
                                 if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                                     self.previousTextViewContentHeight = MIN(contentH, maxHeight);
                                 }
                                 // growing the view, animate the text view frame AFTER input view frame
                                 [self.messageInputView adjustTextViewHeightBy:changeInHeight];
                             }
                         }
                         completion:^(BOOL finished) {
                         }];
        
        self.previousTextViewContentHeight = MIN(contentH, maxHeight);
    }
    
    // Once we reached the max height, we have to consider the bottom offset for the text view.
    // To make visible the last line, again we have to set the content offset.
    if (self.previousTextViewContentHeight == maxHeight) {
        double delayInSeconds = 0.01;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime,
                       dispatch_get_main_queue(),
                       ^(void) {
                           CGPoint bottomOffset = CGPointMake(0.0f, contentH - textView.bounds.size.height);
                           [textView setContentOffset:bottomOffset animated:YES];
                       });
    }
}

#pragma mark - Message Calculate Cell Height
//统一计算Cell的高度方法
- (CGFloat)calculateCellHeightWithMessage:(AVIMTypedMessage *)message atIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellHeight = 0;
    BOOL displayTimestamp = [self shouldDisplayTimestampForRowAtIndexPath:indexPath];
    if (kAVIMMessageMediaTypeText == message.mediaType) {
        cellHeight = [EZGMessageTextCell HeightOfCellByMessage:message displaysTimestamp:displayTimestamp];
    }
    else if (kAVIMMessageMediaTypeAudio == message.mediaType) {
        cellHeight = [EZGMessageVoiceCell HeightOfCellByMessage:message displaysTimestamp:displayTimestamp];
    }
    else if (kAVIMMessageMediaTypeImage == message.mediaType) {
        cellHeight = [EZGMessageImageCell HeightOfCellByMessage:message displaysTimestamp:displayTimestamp];
    }
    else if (kAVIMMessageMediaTypeLocation == message.mediaType) {
        cellHeight = [EZGMessageLocationCell HeightOfCellByMessage:message displaysTimestamp:displayTimestamp];
    }
    else if (kAVIMMessageMediaTypeVideo == message.mediaType) {
        cellHeight = [EZGMessageVideoCell HeightOfCellByMessage:message displaysTimestamp:displayTimestamp];
    }
    else if (EZGMessageTypeScene == message.mediaType) {
        cellHeight = [EZGMessageSceneCell HeightOfCellByMessage:message displaysTimestamp:displayTimestamp];
    }
    else if (EZGMessageTypeCar == message.mediaType) {
        cellHeight = [EZGMessageCarCell HeightOfCellByMessage:message displaysTimestamp:displayTimestamp];
    }
    else if (EZGMessageTypeService == message.mediaType) {
        cellHeight = [EZGMessageServiceCell HeightOfCellByMessage:message displaysTimestamp:displayTimestamp];
    }
    else if (EZGMessageTypeServiceCancel == message.mediaType) {
        cellHeight = [EZGMessageServiceCancelCell HeightOfCellByMessage:message displaysTimestamp:displayTimestamp];
    }
    else if (EZGMessageTypeServiceComment == message.mediaType) {
        cellHeight = [EZGMessageServiceCommentCell HeightOfCellByMessage:message displaysTimestamp:displayTimestamp];
    }
    
    return cellHeight;
}
//是否显示时间轴Label的回调方法
- (BOOL)shouldDisplayTimestampForRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - Message Send
//根据文本开始发送文本消息
- (void)didSendMessageWithText:(NSString *)text {
    DLog(@"send text : %@", text);
    
}
//根据图片开始发送图片消息
- (void)didSendMessageWithPhoto:(UIImage *)photo {
    DLog(@"send photo : %@", photo);
    
}
//根据录音路径开始发送语音消息
- (void)didSendMessageWithVoice:(NSString *)voicePath voiceDuration:(NSString*)voiceDuration {
    DLog(@"send voicePath : %@", voicePath);
    
}
//根据地理位置信息和地理经纬度开始发送地理位置消息
- (void)didSendGeolocationsMessageWithGeolocaltions:(NSString *)geolocations location:(CLLocation *)location {
    DLog(@"send geolcations : %@", geolocations);
    
}
//发送表情
- (void)didSendEmotionMessageWithEmotion:(NSString *)emotion {
    DLog(@"send emotion : %@", emotion);
}
//根据视频的封面和视频的路径开始发送视频消息(未启用)
- (void)didSendMessageWithVideoConverPhoto:(UIImage *)videoConverPhoto videoPath:(NSString *)videoPath  {
    DLog(@"send videoPath : %@  videoConverPhoto : %@", videoPath, videoConverPhoto);
    
}


#pragma mark - Other Menu View Frame Helper Mehtod
//根据显示或隐藏的需求对所有第三方Menu进行管理
- (void)layoutOtherMenuViewHiden:(BOOL)hide {
    [self.messageInputView.inputTextView resignFirstResponder];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        __block CGRect inputViewFrame = self.messageInputView.frame;
        __block CGRect otherMenuViewFrame;
        
        void (^InputViewAnimation)(BOOL hide) = ^(BOOL hide) {
            inputViewFrame.origin.y = (hide ? (CGRectGetHeight(self.view.bounds) - CGRectGetHeight(inputViewFrame)) : (CGRectGetMinY(otherMenuViewFrame) - CGRectGetHeight(inputViewFrame)));
            self.messageInputView.frame = inputViewFrame;
        };
        
        void (^EmotionManagerViewAnimation)(BOOL hide) = ^(BOOL hide) {
            otherMenuViewFrame = self.emotionManagerView.frame;
            otherMenuViewFrame.origin.y = (hide ? CGRectGetHeight(self.view.frame) : (CGRectGetHeight(self.view.frame) - CGRectGetHeight(otherMenuViewFrame)));
            self.emotionManagerView.alpha = !hide;
            self.emotionManagerView.frame = otherMenuViewFrame;
        };
        
        void (^ShareMenuViewAnimation)(BOOL hide) = ^(BOOL hide) {
            otherMenuViewFrame = self.shareMenuView.frame;
            otherMenuViewFrame.origin.y = (hide ? CGRectGetHeight(self.view.frame) : (CGRectGetHeight(self.view.frame) - CGRectGetHeight(otherMenuViewFrame)));
            self.shareMenuView.alpha = !hide;
            self.shareMenuView.frame = otherMenuViewFrame;
        };
        
        if (hide) {
            switch (self.textViewInputViewType) {
                case XHInputViewTypeEmotion: {
                    EmotionManagerViewAnimation(hide);
                    break;
                }
                case XHInputViewTypeShareMenu: {
                    ShareMenuViewAnimation(hide);
                    break;
                }
                default:
                    break;
            }
        } else {
            // 这里需要注意block的执行顺序，因为otherMenuViewFrame是公用的对象，所以对于被隐藏的Menu的frame的origin的y会是最大值
            switch (self.textViewInputViewType) {
                case XHInputViewTypeEmotion: {
                    // 1、先隐藏和自己无关的View
                    ShareMenuViewAnimation(!hide);
                    // 2、再显示和自己相关的View
                    EmotionManagerViewAnimation(hide);
                    break;
                }
                case XHInputViewTypeShareMenu: {
                    // 1、先隐藏和自己无关的View
                    EmotionManagerViewAnimation(!hide);
                    // 2、再显示和自己相关的View
                    ShareMenuViewAnimation(hide);
                    break;
                }
                default:
                    break;
            }
        }
        
        InputViewAnimation(hide);
        
        [self setTableViewInsetsWithBottomValue:self.view.frame.size.height - self.messageInputView.frame.origin.y];
        [self scrollToBottomAnimated:NO];
    } completion:^(BOOL finished) {
        if (hide) {
            self.textViewInputViewType = XHInputViewTypeNormal;
        }
    }];
}

#pragma mark - Voice Recording Helper Method
- (void)prepareRecordWithCompletion:(XHPrepareRecorderCompletion)completion {
    [self.voiceRecordHelper prepareRecordingWithPath:[self getRecorderPath] prepareRecorderCompletion:completion];
}
- (void)startRecord {
    self.messageTableView.scrollEnabled = NO;
    [self.voiceRecordHUD startRecordingHUDAtView:self.view];
    [self.voiceRecordHelper startRecordingWithStartRecorderCompletion:^{
    }];
}
- (void)finishRecorded {
    WEAKSELF
    [self.voiceRecordHUD stopRecordCompled:^(BOOL fnished) {
        weakSelf.voiceRecordHUD = nil;
        weakSelf.messageInputView.isRecording = NO;
        weakSelf.messageInputView.isCancelled = NO;
        weakSelf.messageTableView.scrollEnabled = YES;
    }];
    [self.voiceRecordHelper stopRecordingWithStopRecorderCompletion:^{
        [weakSelf didSendMessageWithVoice:weakSelf.voiceRecordHelper.recordPath voiceDuration:weakSelf.voiceRecordHelper.recordDuration];
    }];
}
- (void)pauseRecord {
    [self.voiceRecordHUD pauseRecord];
}
- (void)resumeRecord {
    [self.voiceRecordHUD resaueRecord];
}
- (void)cancelRecord {
    WEAKSELF
    [self.voiceRecordHUD cancelRecordCompled:^(BOOL fnished) {
        weakSelf.voiceRecordHUD = nil;
        weakSelf.messageInputView.isRecording = NO;
        weakSelf.messageInputView.isCancelled = YES;
        weakSelf.messageTableView.scrollEnabled = YES;
    }];
    [self.voiceRecordHelper cancelledDeleteWithCompletion:^{
        
    }];
}
//当其它错误操作发生时，停止录音
- (void)finishRecordingWhenErrorBehaviors {
    if (self.messageInputView.isRecording) {
        [self didFinishRecoingVoiceAction];
    }
}

#pragma mark - XHMessageInputView Delegate
- (void)inputTextViewWillBeginEditing:(XHMessageTextView *)messageInputTextView {
    self.textViewInputViewType = XHInputViewTypeText;
}
- (void)inputTextViewDidBeginEditing:(XHMessageTextView *)messageInputTextView {
    if (!self.previousTextViewContentHeight)
		self.previousTextViewContentHeight = [self getTextViewContentH:messageInputTextView];
}
- (void)didChangeSendVoiceAction:(BOOL)changed {
    DLog(@"didChangeSendVoiceAction");
    if (changed) {
        if (self.textViewInputViewType == XHInputViewTypeText)
            return;
        // 在这之前，textViewInputViewType已经不是XHTextViewTextInputType
        [self layoutOtherMenuViewHiden:YES];
    }
}
- (void)didInputAtSign:(XHMessageTextView *)messageInputTextView {
    DLog(@"didInputAtSign");
}
- (void)didSendTextAction:(NSString *)text {
    DLog(@"text : %@", text);
    [self didSendMessageWithText:text];
}
- (void)didSelectedMultipleMediaAction {
    DLog(@"didSelectedMultipleMediaAction");
    self.textViewInputViewType = XHInputViewTypeShareMenu;
    [self layoutOtherMenuViewHiden:NO];
}
- (void)didSendFaceAction:(BOOL)sendFace {
    DLog(@"didSendFaceAction");
    if (sendFace) {
        self.textViewInputViewType = XHInputViewTypeEmotion;
        [self layoutOtherMenuViewHiden:NO];
    } else {
        [self.messageInputView.inputTextView becomeFirstResponder];
    }
}
- (void)prepareRecordingVoiceActionWithCompletion:(BOOL (^)(void))completion {
    DLog(@"prepareRecordingWithCompletion");
    [self prepareRecordWithCompletion:completion];
}
- (void)didStartRecordingVoiceAction {
    DLog(@"didStartRecordingVoice");
    [self startRecord];
}
- (void)didCancelRecordingVoiceAction {
    DLog(@"didCancelRecordingVoice");
    [self cancelRecord];
}
- (void)didFinishRecoingVoiceAction {
    DLog(@"didFinishRecoingVoice");
    if (self.voiceRecordHelper.currentTimeInterval < self.voiceRecordHelper.minRecordTime) {
        [UIView showResultThenHideOnWindow:@"录音时间太短" afterDelay:0.5];
        [self cancelRecord];
    }
    else {
        [self finishRecorded];
    }
}
- (void)didDragOutsideAction {
    DLog(@"didDragOutsideAction");
    [self resumeRecord];
}
- (void)didDragInsideAction {
    DLog(@"didDragInsideAction");
    [self pauseRecord];
}

#pragma mark - XHEmotionManagerView Delegate
- (void)didSelecteEmotion:(XHEmotion *)emotion atIndexPath:(NSIndexPath *)indexPath {
    if (emotion.emotionPath) {
        [self didSendEmotionMessageWithEmotion:emotion.emotionPath];
    }
}
- (void)didSelectEmotionStoreButton:(UIButton *)button{
    [self didSendMessageWithText:self.messageInputView.inputTextView.text];
}

#pragma mark - XHEmotionManagerView DataSource
- (NSInteger)numberOfEmotionManagers {
    return 0;
}
- (XHEmotionManager *)emotionManagerForColumn:(NSInteger)column {
    return nil;
}
- (NSArray *)emotionManagersAtManager {
    return nil;
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	self.isUserScrolling = YES;
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if (menu.isMenuVisible) {
        [menu setMenuVisible:NO animated:YES];
    }
    
    if (self.textViewInputViewType != XHInputViewTypeNormal) {
        [self layoutOtherMenuViewHiden:YES];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.isUserScrolling = NO;
}

#pragma mark - Table View Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AVIMTypedMessage *message = self.messages[indexPath.row];
    BOOL displayTimestamp = [self shouldDisplayTimestampForRowAtIndexPath:indexPath];
    
    EZGMessageBaseCell *cell = nil;
    if (kAVIMMessageMediaTypeText == message.mediaType) {
        cell = [EZGMessageTextCell dequeueCellByTableView:tableView];
    }
    else if (kAVIMMessageMediaTypeAudio == message.mediaType) {
        cell = [EZGMessageVoiceCell dequeueCellByTableView:tableView];
    }
    else if (kAVIMMessageMediaTypeImage == message.mediaType) {
        cell = [EZGMessageImageCell dequeueCellByTableView:tableView];
        EZGMessageImageCell *imageCell = (EZGMessageImageCell *)cell;
        imageCell.block = ^{
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];//FIXME:bug?
            //TODO:如何判断当处于bottom就始终scroll to bottom；不处于bottom就只刷新cell？？？
//            [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        };
    }
    else if (kAVIMMessageMediaTypeLocation == message.mediaType) {
        cell = [EZGMessageLocationCell dequeueCellByTableView:tableView];
    }
    else if (kAVIMMessageMediaTypeVideo == message.mediaType) {
        cell = [EZGMessageVideoCell dequeueCellByTableView:tableView];
    }
    else if (EZGMessageTypeScene == message.mediaType) {
        cell = [EZGMessageSceneCell dequeueCellByTableView:tableView];
    }
    else if (EZGMessageTypeCar == message.mediaType) {
        cell = [EZGMessageCarCell dequeueCellByTableView:tableView];
    }
    else if (EZGMessageTypeService == message.mediaType) {
        cell = [EZGMessageServiceCell dequeueCellByTableView:tableView];
    }
    else if (EZGMessageTypeServiceCancel == message.mediaType) {
        cell = [EZGMessageServiceCancelCell dequeueCellByTableView:tableView];
    }
    else if (EZGMessageTypeServiceComment == message.mediaType) {
        cell = [EZGMessageServiceCommentCell dequeueCellByTableView:tableView];
    }
    [cell layoutMessage:message displaysTimestamp:displayTimestamp];
    
    return cell;
}

#pragma mark - Table View Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self calculateCellHeightWithMessage:self.messages[indexPath.row] atIndexPath:indexPath];
}

#pragma mark - Key-value Observing
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (object == self.messageInputView.inputTextView && [keyPath isEqualToString:@"contentSize"]) {
        [self layoutAndAnimateMessageInputTextView:object];
    }
}

#pragma mark - Scroll Message TableView Helper Method
//根据bottom的数值配置消息列表的内部布局变化
- (void)setTableViewInsetsWithBottomValue:(CGFloat)bottom {
    UIEdgeInsets insets = [self tableViewInsetsWithBottomValue:bottom];
    self.messageTableView.contentInset = insets;
    self.messageTableView.scrollIndicatorInsets = insets;
}
//根据底部高度获取UIEdgeInsets常量
- (UIEdgeInsets)tableViewInsetsWithBottomValue:(CGFloat)bottom {
    UIEdgeInsets insets = UIEdgeInsetsZero;
    insets.top = 64;
    insets.bottom = bottom;
    return insets;
}

@end
