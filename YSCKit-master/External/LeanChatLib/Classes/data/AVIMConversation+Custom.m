//
//  AVIMConversation+CustomAttributes.m
//  LeanChatLib
//
//  Created by lzw on 15/4/8.
//  Copyright (c) 2015年 avoscloud. All rights reserved.
//

#import "AVIMConversation+Custom.h"
#import "CDChatManager.h"
#import "UIImage+Icon.h"
#import <objc/runtime.h>

static NSString *ObjectTagKeyLastMessage = @"ObjectTagKeyLastMessage";
static NSString *ObjectTagKeyUnreadCount = @"ObjectTagKeyUnreadCount";
static NSString *ObjectTagKeyMentioned = @"ObjectTagKeyMentioned";
static NSString *ObjectTagKeyUpdatedTime = @"ObjectTagKeyUpdatedTime";

@implementation AVIMConversation (Custom)

- (AVIMTypedMessage *)lastMessage {
    return objc_getAssociatedObject(self, &ObjectTagKeyLastMessage);
}

- (void)setLastMessage:(AVIMTypedMessage *)_lastMessage {
    objc_setAssociatedObject(self, &ObjectTagKeyLastMessage, _lastMessage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)unreadCount {
    return [objc_getAssociatedObject(self, @selector(unreadCount)) integerValue];
}

- (void)setUnreadCount:(NSInteger)_unreadCount {
    objc_setAssociatedObject(self, @selector(unreadCount), @(_unreadCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)mentioned {
    return [objc_getAssociatedObject(self, &ObjectTagKeyMentioned) boolValue];
}

- (void)setMentioned:(BOOL)_mentioned {
    objc_setAssociatedObject(self, &ObjectTagKeyMentioned, @(_mentioned), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDate *)updatedTime {
    return objc_getAssociatedObject(self, &ObjectTagKeyUpdatedTime);
}
- (void)setUpdatedTime:(NSDate *)_updatedTime {
    objc_setAssociatedObject(self, &ObjectTagKeyUpdatedTime, _updatedTime, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isOfficialStaff {
    return [self.attributes[kParamIsOfficialStaff] boolValue];
}
- (NSString *)ezgoalType {
    return Trim(self.attributes[kParamEzgoalType]);
}
- (RescueStatusType)ezgoalStatus {
    return [self.attributes[kParamEzgoalStatus] integerValue];
}
- (NSString *)rescueId {
    return Trim(self.attributes[kParamRescueId]);
}
- (NSString *)s4Id {
    return Trim(self.attributes[kParamS4Id]);
}
- (NSString *)otherId {
    NSArray *members = self.members;
    if ([members count] == 2) {
        if ([members[0] isEqualToString:[CDChatManager manager].selfId]) {
            return members[1];
        }
        else {
            return members[0];
        }
    }
    else {
        return @"";
    }
}

@end
