//
//  YSCTextView.h
//  YSCKit
//
//  Created by yangshengchao on 15/7/3.
//  Copyright (c) 2015年 Builder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSCTextView : UITextView
//控制内容
@property (nonatomic, assign) IBInspectable NSInteger maxLength;        //default 400, -1 means no limit
@property (nonatomic, strong) IBInspectable NSString *customRegex;      //default nil
@property (nonatomic, assign) IBInspectable BOOL showsRemainingCount;   //defualt NO 是否显示剩余字符数
@property (nonatomic, assign) IBInspectable BOOL allowsEmpty;           //default NO
@property (nonatomic, assign) IBInspectable BOOL allowsEmoji;           //default NO 所有的emoji
@property (nonatomic, assign) IBInspectable BOOL allowsSimpleEmoji;     //default NO 常用的emoji
@property (nonatomic, assign) IBInspectable BOOL allowsChinese;         //default YES
@property (nonatomic, assign) IBInspectable BOOL allowsPunctuation;     //default YES 标点符号(全)
@property (nonatomic, assign) IBInspectable BOOL allowsKeyboardDone;    //default YES 是否响应键盘的done按钮
@property (nonatomic, assign) IBInspectable BOOL allowsLetter;          //default YES
@property (nonatomic, assign) IBInspectable BOOL allowsNumber;          //default YES
@property (nonatomic, assign) IBInspectable BOOL stringLengthType;      //YES-string.length NO-char length default YES

//控制UI样式
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;       //圆角弧度
@property (nonatomic, strong) IBInspectable UIColor *borderColor;       //边框颜色
@property (nonatomic, strong) IBInspectable NSString *placeholderString;//
@property (nonatomic, strong) IBInspectable UIColor *placeholderColor;  //
@property (nonatomic, strong) IBInspectable UIColor *remainingTextColor;//

//外面可以监听这个属性的变化
@property (nonatomic, assign) NSInteger remainingCount;     //剩余字符数

- (BOOL)isValid;            //检测输入内容是否有效
- (NSString *)textString;   //返回去掉首位空格后的字符串
- (NSInteger)textLength;    //返回去掉首位空格后的字符串的长度
- (void)filterText:(NSString *)text;//TODO:输入text的时候过滤非法内容

@end
