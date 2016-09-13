//
//  PSKTextField.h
//  PisenKit
//
//  Created by 杨胜超 on 16/6/29.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PSKTextType) {
    //特殊内容
    PSKTextTypePhone            = 10,   //电话号码(包括座机、手机号)
    PSKTextTypeMobilePhone      = 11,   //手机号
    PSKTextTypeIdentityNum      = 12,   //身份证号码
    PSKTextTypeEmail            = 13,   //email地址
    PSKTextTypeUrl              = 14,   //超链接
    PSKTextTypeDecimal          = 15,   //带小数点的数字
    
    //自定义
    PSKTextTypeProperty         = 99,   //完全根据property的设置来校验
};

@interface PSKTextField : UITextField

@property (nonatomic, assign) PSKTextType textType;                     //default PSKTextTypeProperty
//控制内容
@property (nonatomic, assign) IBInspectable NSInteger minLength;        //default 0 means no limit
@property (nonatomic, assign) IBInspectable NSInteger maxLength;        //default 20, -1 means no limit
@property (nonatomic, strong) IBInspectable NSString *customRegex;      //default nil
@property (nonatomic, strong) IBInspectable NSString *chineseRegex;     //default nil 汉字正则表达式
@property (nonatomic, strong) IBInspectable NSString *punctuationRegex; //default nil 标点符号正则表达式
@property (nonatomic, strong) IBInspectable NSString *emojiRegex;       //default nil emoji正则表达式
@property (nonatomic, assign) IBInspectable BOOL allowsEmpty;           //default NO
@property (nonatomic, assign) IBInspectable BOOL allowsEmoji;           //default NO 所有的emoji
@property (nonatomic, assign) IBInspectable BOOL allowsChinese;         //default NO
@property (nonatomic, assign) IBInspectable BOOL allowsPunctuation;     //default NO 标点符号(全)
@property (nonatomic, assign) IBInspectable BOOL allowsKeyboardDismiss; //default YES 点击done 键盘是否隐藏
@property (nonatomic, assign) IBInspectable BOOL allowsLetter;          //default YES
@property (nonatomic, assign) IBInspectable BOOL allowsNumber;          //default YES
@property (nonatomic, assign) IBInspectable BOOL stringLengthType;      //YES-string.length NO-char length default YES
//控制UI样式
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;       //圆角弧度
@property (nonatomic, strong) IBInspectable UIColor *borderColor;       //边框颜色
@property (nonatomic, strong) IBInspectable UIColor *placeholderColor;  //默认字体颜色
@property (nonatomic, assign) IBInspectable CGFloat textLeftMargin;
@property (nonatomic, assign) IBInspectable CGFloat textRightMargin;

//blocks
@property (nonatomic, copy) void (^changedBlock)(NSObject *object);
@property (nonatomic, copy) void (^keyboardDoneBlock)(NSObject *object);

/** 最终检测输入内容是否有效 */
- (BOOL)isValid;
/** 返回去掉首位空格后的字符串 */
- (NSString *)textString;
/** 返回去掉首位空格后的字符串的长度 */
- (NSInteger)textLength;
/** 处理self.text的变化是否需要触发通知 */
- (void)setText:(NSString *)text notify:(BOOL)isNotify;
@end