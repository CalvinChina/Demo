//
//  TitleBarView.m
//  YSCKit
//
//  Created by  YangShengchao on 14-2-18.
//  Copyright (c) 2014年  YangShengchao. All rights reserved.
//

#import "YSCTitleBarView.h"

@implementation YSCTitleBarView
- (id)init {
    return [self initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64.0f)];
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _setup];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _setup];
        
    }
    return self;
}
- (void)_setup {
    self.backgroundColor = [UIColor whiteColor];
    
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundImageView.top = 63;
    self.backgroundImageView.height = 0.5;
    self.backgroundImageView.backgroundColor = kDefaultCustomNaviTintColor;
    [self addSubview:self.backgroundImageView];
    
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, STATUSBAR_HEIGHT)];
    statusBarView.backgroundColor = [UIColor whiteColor];
    [self addSubview:statusBarView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 50, 160.0f, 24.0f)];
    self.titleLabel.center = CGPointMake(self.bounds.size.width / 2.0f, STATUSBAR_HEIGHT + (self.bounds.size.height - STATUSBAR_HEIGHT) / 2.0f);
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    
    self.netStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(80.0f, 50.0f, 160.0f, 14.0f)];
    self.netStatusLabel.textColor = [UIColor redColor];
    self.netStatusLabel.text = @"您的网络连接不可用";
    self.netStatusLabel.backgroundColor = [UIColor clearColor];
    self.netStatusLabel.font = [UIFont systemFontOfSize:10.0f];
    self.netStatusLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.netStatusLabel];
    
    [YSCInstance addObserver:self
                  forKeyPath:@"isReachable"
                     options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                     context:NULL];
    self.netStatusLabel.hidden = YSCInstance.isReachable;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"isReachable"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.netStatusLabel.hidden = YSCInstance.isReachable;
        });
    }
}
- (void)dealloc {
    [YSCInstance removeObserver:self forKeyPath:@"isReachable"];
}
@end
