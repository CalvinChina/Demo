//
//  CDMessageHelper.m
//  LeanChatLib
//
//  Created by lzw on 15/6/30.
//  Copyright (c) 2015年 lzwjava@LeanCloud QQ: 651142978. All rights reserved.
//

#import "CDMessageHelper.h"
#import "CDChatManager.h"
#import "CDEmotionUtils.h"
#import "AVIMEmotionMessage.h"

@interface CDMessageHelper ()

@property (nonatomic, strong) NSCache *attributedStringCache;

@end

@implementation CDMessageHelper

+ (CDMessageHelper *)helper {
    static dispatch_once_t token;
    static CDMessageHelper *messageHelper;
    dispatch_once(&token, ^{
        messageHelper = [[CDMessageHelper alloc] init];
    });
    return messageHelper;
}

#pragma mark - message

- (NSString *)getMessageTitle:(AVIMTypedMessage *)msg {
    NSString *title;
    switch (msg.mediaType) {
        case kAVIMMessageMediaTypeAudio:
            title = @"[声音]";
            break;
        case kAVIMMessageMediaTypeImage:
            title = @"[图片]";
            break;
        case kAVIMMessageMediaTypeEmotion:
            title = @"[表情]";
            break;
        case kAVIMMessageMediaTypeVideo:
            title = @"[视频]";
        case kAVIMMessageMediaTypeText:
        case kAVIMMessageMediaTypeLocation:
        default:
            title = [CDEmotionUtils emojiStringFromString:msg.text];
            break;
    }
    return title;
}

- (NSAttributedString *)attributedStringWithMessage:(AVIMTypedMessage *)message conversation:(AVIMConversation *)conversation {
    NSString *title = [self getMessageTitle:message];
    if (conversation.muted && conversation.unreadCount > 0) {
        title = [NSString stringWithFormat:@"[%ld条] %@", conversation.unreadCount, title];
    }
    NSString *mentionText = @"[有人@你] ";
    NSString *finalText;
    if (conversation.mentioned) {
        finalText = [NSString stringWithFormat:@"%@%@", mentionText, title];
    }
    else {
        finalText = title;
    }
    if (finalText == nil) {
        finalText = @"";
    }
    if ([self.attributedStringCache objectForKey:finalText]) {
        return [self.attributedStringCache objectForKey:finalText];
    }
    UIFont *font = AUTOLAYOUT_FONT(22);//[UIFont systemFontOfSize:13];
    NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor grayColor], (id)NSFontAttributeName:font};
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:finalText attributes:attributes];
    
    if (conversation.mentioned) {
        NSRange range = [finalText rangeOfString:mentionText];
        [attributedString setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:183/255.0 green:20/255.0 blue:20/255.0 alpha:1], NSFontAttributeName : font} range:range];
    }
    
    [self.attributedStringCache setObject:attributedString forKey:finalText];
    
    return attributedString;
}


@end
