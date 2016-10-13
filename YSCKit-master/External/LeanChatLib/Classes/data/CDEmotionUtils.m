//
//  CDEmotionUtils.m
//  LeanChat
//
//  Created by lzw on 14/11/25.
//  Copyright (c) 2014年 LeanCloud. All rights reserved.
//

#import "CDEmotionUtils.h"
#import "XHEmotionManager.h"
#import "Emoji.h"
#import "NSString+Emojize.h"

#import "CDChatManager.h"

#define CDSupportEmojis \
@[@":smile:", \
@":laughing:", \
@":blush:", \
@":smiley:", \
@":relaxed:", \
@":smirk:", \
@":heart_eyes:", \
@":kissing_heart:", \
@":kissing_closed_eyes:", \
@":flushed:", \
@":relieved:", \
@":satisfied:", \
@":grin:", \
@":wink:", \
@":stuck_out_tongue_winking_eye:", \
@":stuck_out_tongue_closed_eyes:", \
@":grinning:", \
@":kissing:", \
@":kissing_smiling_eyes:", \
@":stuck_out_tongue:", \
@":sleeping:", \
@":worried:", \
@":frowning:", \
@":anguished:", \
@":open_mouth:", \
@":grimacing:", \
@":confused:", \
@":hushed:", \
@":expressionless:", \
@":unamused:", \
@":sweat_smile:", \
@":sweat:", \
@":disappointed_relieved:", \
@":weary:", \
@":pensive:", \
@":disappointed:", \
@":confounded:", \
@":fearful:", \
@":cold_sweat:", \
@":persevere:", \
@":cry:", \
@":sob:", \
@":joy:", \
@":astonished:", \
@":scream:", \
@":tired_face:", \
@":angry:", \
@":rage:", \
@":triumph:", \
@":sleepy:", \
@":yum:", \
@":mask:", \
@":sunglasses:", \
@":dizzy_face:", \
@":neutral_face:", \
@":no_mouth:", \
@":innocent:", \
@":thumbsup:", \
@":thumbsdown:", \
@":clap:", \
@":point_right:", \
@":point_left:" \
];

@implementation CDEmotionUtils

+ (UIImage *)imageFromString:(NSString *)string attributes:(NSDictionary *)attributes size:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [string drawInRect:CGRectMake(0, 0, size.width, size.height) withAttributes:attributes];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (NSArray *)emotionManagers {
    NSDictionary *codeToEmoji = [NSString emojiAliases];
    NSArray *emotionCodes = CDSupportEmojis;
    NSMutableArray *emotionManagers = [NSMutableArray array];
    {
        XHEmotionManager *emotionManager = [[XHEmotionManager alloc] init];
        emotionManager.estimatedPages = 3;
        emotionManager.emotionSize = AUTOLAYOUT_SIZE_WH(60, 60);
        emotionManager.emotionName = @"";//普通
        NSMutableArray *emotions = [NSMutableArray array];
        for (NSInteger j = 0; j < emotionCodes.count; j++) {
            XHEmotion *xhEmotion = [[XHEmotion alloc] init];
            NSString *code = emotionCodes[j];
            CGFloat emojiSize = 30;
            xhEmotion.emotionConverPhoto = [self imageFromString:codeToEmoji[code] attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:25] } size:CGSizeMake(emojiSize, emojiSize)];
            xhEmotion.emotionPath = code;
            [emotions addObject:xhEmotion];
        }
        emotionManager.emotions = emotions;
        [emotionManagers addObject:emotionManager];
    }
    return emotionManagers;
}

+ (XHEmotionManager *)emotionManagerWithSize:(CGFloat)size pages:(NSInteger)pages name:(NSString *)name maxIndex:(NSInteger)maxIndex prefix:(NSString *)prefix {
    XHEmotionManager *emotionManager = [[XHEmotionManager alloc] init];
    emotionManager.emotionSize = CGSizeMake(size, size);
    emotionManager.estimatedPages = pages;
    emotionManager.emotionName = name;
    NSMutableArray *emotions = [NSMutableArray array];
    for (NSInteger j = 0; j <= maxIndex; j ++) {
        XHEmotion *emotion = [[XHEmotion alloc] init];
        NSString *imageName = [self coverPathOfIndex:j prefix:prefix];
        NSString *gifPath = [self gifPathOfIndex:j prefix:prefix];
        emotion.emotionPath = gifPath;
        emotion.emotionConverPhoto = [UIImage imageNamed:imageName];
        [emotions addObject:emotion];
    }
    emotionManager.emotions = emotions;
    return emotionManager;
}

+ (NSString *)emojiStringFromString:(NSString *)text {
    return [self convertString:text toEmoji:YES];
}

+ (NSString *)plainStringFromEmojiString:(NSString *)emojiText {
    return [self convertString:emojiText toEmoji:NO];
}

+ (NSString *)convertString:(NSString *)text toEmoji:(BOOL)toEmoji {
    NSMutableString *emojiText = [[NSMutableString alloc] initWithString:Trim(text)];
    for (NSString *code in[[NSString emojiAliases] allKeys]) {
        NSString *emoji = [NSString emojiAliases][code];
        if (toEmoji) {
            [emojiText replaceOccurrencesOfString:code withString:emoji options:NSLiteralSearch range:NSMakeRange(0, emojiText.length)];
        }
        else {
            [emojiText replaceOccurrencesOfString:emoji withString:code options:NSLiteralSearch range:NSMakeRange(0, emojiText.length)];
        }
    }
    return emojiText;
}

+ (NSString *)emotionOfIndex:(NSInteger)index prefix:(NSString *)prefix {
    return [NSString stringWithFormat:@"%@_%ld", prefix, index];
}

+ (NSString *)coverPathOfIndex:(NSInteger)index prefix:(NSString *)prefix {
    // 如果是源代码引入的话，可能不需要 emoticons/
    NSString *basicPath = [NSString stringWithFormat:@"%@_%ld_cover", prefix, (long)index];
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:basicPath ofType:@"png"];
    if (bundlePath == nil) {
        return [NSString stringWithFormat:@"emoticons/%@", basicPath];
    } else {
        return basicPath;
    }
}

+ (NSString *)gifPathOfIndex:(NSInteger)index prefix:(NSString *)prefix {
    NSString *basicPath = [NSString stringWithFormat:@"%@_%ld", prefix, (long)index];
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:basicPath ofType:@"gif"];
    if (bundlePath == nil) {
        return [NSString stringWithFormat:@"emoticons/%@", basicPath];
    } else {
        return basicPath;
    }
}

+ (void)findEmotionWithName:(NSString *)name block:(AVFileResultBlock)block {
    AVQuery *query = [AVQuery queryWithClassName:@"Emotion"];
    query.cachePolicy = kAVCachePolicyCacheElseNetwork;
    [query whereKey:@"name" equalTo:name];
    [query findObjectsInBackgroundWithBlock:^(NSArray *emotions, NSError *error) {
        if (error) {
            block(nil, error);
        } else {
            if (emotions.count > 0) {
                block(emotions[0][@"file"], nil);
            } else {
                block(nil, nil);
            }
        }
    }];
}

+ (BOOL)saveEmotionFromResource:(NSString *)resource savedName:(NSString *)name error:(NSError *__autoreleasing *)error{
    __block BOOL result;
    NSString *path = [[NSBundle mainBundle] pathForResource:resource ofType:@"gif"];
    if (path == nil)  {
        *error = [NSError errorWithDomain:@"LeanChatLib" code:1 userInfo:@{NSLocalizedDescriptionKey:@"path is nil"}];
        return NO;
    }
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    [self findEmotionWithName:name block:^(AVFile *file, NSError *_error) {
        if (error) {
            result = NO;
            *error = _error;
            dispatch_semaphore_signal(sema);
        } else {
            if (file == nil) {
                AVFile *file = [AVFile fileWithName:name contentsAtPath:path];
                AVObject *emoticon = [AVObject objectWithClassName:@"Emotion"];
                [emoticon setObject:name forKey:@"name"];
                [emoticon setObject:file forKey:@"file"];
                [emoticon saveInBackgroundWithBlock:^(BOOL succeeded, NSError *theError) {
                    if (theError) {
                        result = NO;
                        *error = theError;
                    } else {
                        result = YES;
                    }
                    dispatch_semaphore_signal(sema);
                }];
            } else {
                result = YES;
                dispatch_semaphore_signal(sema);
            }
        }
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    return result;
}

@end
