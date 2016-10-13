//
//  XHMessageStatusView.m
//  LeanChat
//
//  Created by lzw on 14/12/30.
//  Copyright (c) 2014年 LeanCloud. All rights reserved.
//

#import "XHMessageStatusView.h"

@implementation XHMessageStatusView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self) {
        //正在发送中
        self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.indicatorView.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
        self.indicatorView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        [self addSubview:self.indicatorView];
        
        //已发送标签
        self.sentLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width - AUTOLAYOUT_LENGTH(50), 0,
                                                              AUTOLAYOUT_LENGTH(50), AUTOLAYOUT_LENGTH(30))];
        self.sentLabel.centerY = frame.size.height / 2;
        self.sentLabel.font = [UIFont systemFontOfSize:10];
        self.sentLabel.textAlignment = NSTextAlignmentCenter;
        self.sentLabel.layer.cornerRadius = 3;
        self.sentLabel.layer.masksToBounds = YES;
        self.sentLabel.text = NSLocalizedStringFromTable(@"sent", @"MessageDisplayKitString", @"未读");
        self.sentLabel.backgroundColor = [UIColor colorWithRed:249/255.0 green:140/255.0 blue:140/255.0 alpha:1];
        self.sentLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.sentLabel];
        
        //重新发送
        self.retryButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, AUTOLAYOUT_LENGTH(40), AUTOLAYOUT_LENGTH(40))];
        self.retryButton.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
        [self.retryButton setBackgroundImage:[UIImage imageNamed:@"messageSendFail"] forState:UIControlStateNormal];
        [self addSubview:self.retryButton];
    }
    return self;
}

- (void)setStatus:(AVIMMessageStatus)status {
    _status = status;
    self.indicatorView.hidden = YES;
    self.sentLabel.hidden = YES;
    self.retryButton.hidden = YES;
    if (AVIMMessageStatusNone == status) {
        
    }
    else if (AVIMMessageStatusSending == status) {
        self.indicatorView.hidden = NO;
        [self.indicatorView startAnimating];
    }
    else if (AVIMMessageStatusSent == status) {
        self.sentLabel.hidden = NO;
        [self.indicatorView stopAnimating];
    }
    else if (AVIMMessageStatusDelivered == status) {
        [self.indicatorView stopAnimating];
    }
    else if (AVIMMessageStatusFailed == status) {
        self.retryButton.hidden = NO;
        [self.indicatorView stopAnimating];
    }
}

@end
