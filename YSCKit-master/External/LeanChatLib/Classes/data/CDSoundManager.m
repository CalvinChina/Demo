//
//  CDSoundManager.m
//  LeanChatLib
//
//  Created by lzw on 15/7/2.
//  Copyright (c) 2015年 lzwjava@LeanCloud QQ: 651142978. All rights reserved.
//

#import "CDSoundManager.h"
#import <AudioToolbox/AudioToolbox.h>

#define STR_BY_SEL(sel) NSStringFromSelector(@selector(sel))

@interface CDSoundManager ()

@property (nonatomic, assign) SystemSoundID loudReceiveSound;
@property (nonatomic, assign) SystemSoundID sendSound;
@property (nonatomic, assign) SystemSoundID receiveSound;

@end

@implementation CDSoundManager

+ (CDSoundManager *)manager {
    static CDSoundManager *soundManager;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        soundManager = [[CDSoundManager alloc] init];
    });
    return soundManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setDefaultSettings];
        self.needPlaySoundWhenChatting =  [[[NSUserDefaults standardUserDefaults] objectForKey:STR_BY_SEL(needPlaySoundWhenChatting)] boolValue];
        self.needPlaySoundWhenNotChatting  = [[[NSUserDefaults standardUserDefaults] objectForKey:STR_BY_SEL(needPlaySoundWhenNotChatting)] boolValue];
        self.needVibrateWhenNotChatting = [[[NSUserDefaults standardUserDefaults] objectForKey:STR_BY_SEL(needVibrateWhenNotChatting)] boolValue];
        
        [self createSoundWithName:@"loudReceive" soundId:&_loudReceiveSound];
        [self createSoundWithName:@"send" soundId:&_sendSound];
        [self createSoundWithName:@"receive" soundId:&_receiveSound];
    }
    return self;
}

- (void)createSoundWithName:(NSString *)name soundId:(SystemSoundID *)soundId {
    NSURL *url = [[NSBundle mainBundle] URLForResource:name withExtension:@"caf"];
    OSStatus errorCode = AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url) , soundId);
    if (errorCode != 0) {
        NSLog(@"create sound failed");
    }
}

- (void)playSendSoundIfNeed {
    if (self.needPlaySoundWhenChatting) {
        AudioServicesPlaySystemSound(_sendSound);
    }
}

- (void)playReceiveSoundIfNeed {
    if (self.needPlaySoundWhenChatting) {
        AudioServicesPlaySystemSound(_receiveSound);
    }
}

- (void)playLoudReceiveSoundIfNeed {
    if (self.needPlaySoundWhenNotChatting) {
         AudioServicesPlaySystemSound(_loudReceiveSound);
    }
}

- (void)vibrateIfNeed {
    if (self.needVibrateWhenNotChatting) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}

#pragma mark - local data

- (void)setNeedPlaySoundWhenChatting:(BOOL)needPlaySoundWhenChatting {
    _needPlaySoundWhenChatting = needPlaySoundWhenChatting;
    [[NSUserDefaults standardUserDefaults] setObject:@(self.needPlaySoundWhenChatting) forKey:STR_BY_SEL(needPlaySoundWhenChatting)];
}

- (void)setNeedPlaySoundWhenNotChatting:(BOOL)needPlaySoundWhenNotChatting {
    _needPlaySoundWhenNotChatting = needPlaySoundWhenNotChatting;
    [[NSUserDefaults standardUserDefaults] setObject:@(self.needPlaySoundWhenNotChatting) forKey:STR_BY_SEL(needPlaySoundWhenNotChatting)];
}

- (void)setNeedVibrateWhenNotChatting:(BOOL)needVibrateWhenNotChatting {
    _needVibrateWhenNotChatting = needVibrateWhenNotChatting;
    [[NSUserDefaults standardUserDefaults] setObject:@(self.needVibrateWhenNotChatting) forKey:STR_BY_SEL(needVibrateWhenNotChatting)];
}


- (void)setDefaultSettings {
    NSString *defaultSettingsFile = [[NSBundle mainBundle] pathForResource:@"defaultSettings" ofType:@"plist"];
    NSDictionary *defaultSettings = [[NSDictionary alloc] initWithContentsOfFile:defaultSettingsFile];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultSettings];
}

@end
