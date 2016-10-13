//
//  NSAttributedString+EmojiAttributedString.m
//  EmojiText
//
//  Created by Joey on 14-9-17.
//  Copyright (c) 2014年 JoeytatEmojiText. All rights reserved.
//

#import "NSAttributedString+EmojiAttributedString.h"

@implementation NSAttributedString (EmojiAttributedString)
- (NSAttributedString *)emojiAttributedString
{
    NSMutableAttributedString *parsedOutput = [[NSMutableAttributedString alloc]initWithAttributedString:self];
    // 1. 获取本地表情 Dictionary
    NSDictionary *emojiPlistDic = [[NSDictionary alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Emoji" ofType:@"plist"]];
    
    // 2. 正则匹配获取 parsedOutput 中符合表情代码的 range，图片代码暂时使用 ![图片名称]
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\!\\[[A-Za-z1-9]*\\]" options:0 error:nil];
    NSArray* matches = [regex matchesInString:[parsedOutput string]
                                      options:NSMatchingWithoutAnchoringBounds
                                        range:NSMakeRange(0, parsedOutput.length)];
    
    // 3. 遍历 parsedOutput 中的属性以获取字体显示高度
    __block CGFloat emojiSize;
    [parsedOutput enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, parsedOutput.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        if(value){
            emojiSize = ((UIFont *)value).lineHeight;
        }
    }];
    
    // 4. 倒序遍历 match 到的 range
    for (NSTextCheckingResult* result in [matches reverseObjectEnumerator]) {
        NSRange matchRange = [result range];
        NSRange captureRange = [result rangeAtIndex:0];
        NSTextAttachment* textAttachment = [NSTextAttachment new];
        // 5. 通过图片代码找到图片
        UIImage *emojiImage = [UIImage imageNamed:emojiPlistDic[[parsedOutput.string substringWithRange:captureRange]]];
        // 6. 将图片 Size 修改为符合字体的大小
        textAttachment.image = [YSCImageManager ResizeImage:emojiImage toSize:CGSizeMake(emojiSize,emojiSize)];
        
        // 7. 将之前 match 到的图片代码替换为含有 Emoji 表情的 NSAttributeString
        NSAttributedString *rep = [NSAttributedString attributedStringWithAttachment:textAttachment];
        [parsedOutput replaceCharactersInRange:matchRange withAttributedString:rep];
    }
    
    return parsedOutput;
}
@end
