//
//  PSKTextView.h
//  PisenKit
//
//  Created by pisen on 16/6/23.
//  Copyright (c) 2016 pisen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSKTextView : UITextView
//控制内容
@property (nonatomic, assign) IBInspectable NSInteger maxLength;        //default 400, -1 means no limit
@property (nonatomic, strong) IBInspectable NSString *customRegex;      //default nil
@property (nonatomic, strong) IBInspectable NSString *chinessRegex;     //default nil 汉字正则表达式
@property (nonatomic, strong) IBInspectable NSString *punctuationRegex; //default nil 标点符号正则表达式
@property (nonatomic, strong) IBInspectable NSString *emojiRegex;       //default nil emoji正则表达式
@property (nonatomic, assign) IBInspectable BOOL showsRemainingCount;   //defualt NO 是否显示剩余字符数
@property (nonatomic, assign) IBInspectable BOOL allowsEmpty;           //default NO
@property (nonatomic, assign) IBInspectable BOOL allowsEmoji;           //default NO 所有的emoji
@property (nonatomic, assign) IBInspectable BOOL allowsChinese;         //default YES
@property (nonatomic, assign) IBInspectable BOOL allowsPunctuation;     //default YES 标点符号(全)
@property (nonatomic, assign) IBInspectable BOOL allowsKeyboardDismiss; //default YES 点击done 键盘是否隐藏
@property (nonatomic, assign) IBInspectable BOOL allowsLetter;          //default YES
@property (nonatomic, assign) IBInspectable BOOL allowsNumber;          //default YES
@property (nonatomic, assign) IBInspectable BOOL stringLengthType;      //YES-string.length NO-char length default YES

//控制UI样式
@property (nonatomic, strong) UILabel *placeholderLabel;                //显示占位信息的label
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;       //圆角弧度
@property (nonatomic, strong) IBInspectable UIColor *borderColor;       //边框颜色
@property (nonatomic, strong) IBInspectable NSString *placeholderString;//占位文本内容
@property (nonatomic, strong) IBInspectable UIColor *placeholderColor;  //占位文本颜色

//blocks
@property (nonatomic, copy) void (^changedBlock)(NSObject *object);
@property (nonatomic, copy) void (^keyboardDoneBlock)(NSObject *object);

/** 剩余字符数(外面可以监听这个属性的变化) */
@property (nonatomic, assign) NSInteger remainingCount;

/** 最终检测输入内容是否有效 */
- (BOOL)isValid;
/** 返回去掉首位空格后的字符串 */
- (NSString *)textString;
/** 返回去掉首位空格后的字符串的长度 */
- (NSInteger)textLength;
/** 处理self.text的变化是否需要触发通知 */
- (void)setText:(NSString *)text notify:(BOOL)isNotify;
@end
