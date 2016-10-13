//
//  XHMessageStatusView.h
//  LeanChat
//
//  Created by lzw on 14/12/30.
//  Copyright (c) 2014年 LeanCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "XHMessage.h"

@interface XHMessageStatusView : UIView

@property (nonatomic,strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic,strong) UILabel *sentLabel;
@property (nonatomic,strong) UIButton *retryButton;
@property (nonatomic,assign) AVIMMessageStatus status;

@end
