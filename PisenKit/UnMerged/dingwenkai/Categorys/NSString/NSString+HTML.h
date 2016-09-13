//
//  NSString+HTML.h
//  CalvinUtils
//
//  Created by pisen on 16/2/4.
//  Copyright © 2016年 Calvin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HTML)

#pragma mark - 静态方法
// 将富文本转换成HTML
+ (NSString *)converRichTextToHTML:(NSAttributedString *)attributedString;



#pragma mark - 实例方法
// 转换成HTML的符号
- (NSString *)escapeHTML;

// 去掉HTML的符号
- (NSString *)deleteHTMLTag;

@end
