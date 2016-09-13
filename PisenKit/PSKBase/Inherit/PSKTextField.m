//
//  PSKTextField.m
//  PisenKit
//
//  Created by 杨胜超 on 16/6/29.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import "PSKTextField.h"
#import "NSString+PisenKit.h"

/** PSKTextField专有delegate */
@interface PSKTextFieldDelegate : NSObject <UITextFieldDelegate> @end
@implementation PSKTextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification
                                                        object:textField
                                                      userInfo:nil];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;//NOTE:主要是为了放开删除按钮
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    PSKTextField *pskTextField = (PSKTextField *)textField;
    if (pskTextField.keyboardDoneBlock) {
        pskTextField.keyboardDoneBlock(pskTextField.textString);
    }
    if(pskTextField.allowsKeyboardDismiss) {
        [textField resignFirstResponder];
    }
    return YES;
}
@end


/** 重新封装UITextField */
@interface PSKTextField ()
@property (nonatomic, copy) NSString *oldString;
@property (nonatomic, strong) PSKTextFieldDelegate *customDelegate;
@end

@implementation PSKTextField
- (void)dealloc {
    self.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    PRINT_DEALLOCING
}

#pragma mark - Init
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
    //设置参数默认值
    self.textType = PSKTextTypeProperty;
    self.minLength = 0;
    self.maxLength = 20;
    self.allowsEmpty = NO;
    self.allowsEmoji = NO;
    self.allowsChinese = NO;
    self.allowsPunctuation = NO;
    self.allowsKeyboardDismiss = YES;
    self.allowsLetter = YES;
    self.allowsNumber = YES;
    self.stringLengthType = YES;
    self.cornerRadius = 8;
    self.textLeftMargin = 10;
    self.textRightMargin = 10;
    self.borderColor = [UIColor colorWithRed:220 / 255.0f green:220 / 255.0f blue:220 / 255.0f alpha:1.0f];
    
    self.borderStyle = UITextBorderStyleNone;
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    if ( ! self.backgroundColor) {
        self.backgroundColor = [UIColor whiteColor];
    }
    self.customDelegate = [PSKTextFieldDelegate new];
    self.delegate = self.customDelegate;
    self.oldString = @"";
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self];
}

#pragma mark - Override
/** xib中修改了某些属性，需要重新设置参数 */
- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.placeholderColor && self.placeholder) {
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder
                                                                     attributes:@{NSForegroundColorAttributeName:self.placeholderColor}];
    }
    [self _resetKeyboardType];
    [self layoutIfNeeded];
}
// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, self.textLeftMargin/2, self.textRightMargin);
}
// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, self.textLeftMargin/2, self.textRightMargin);
}

#pragma mark - Public Methods
- (BOOL)isValid {
    //0. 暂存输入的字符串
    NSString *tempString = [self textString];
    
    //1. 根据property设置来校验
    if (PSKTextTypeProperty == self.textType) {
        //1.0 根据自定义的正则表达式来校验
        if ( ! OBJECT_IS_EMPTY(self.customRegex)) {
            return [NSString psk_isMatchRegex:self.customRegex withString:tempString];
        }
        //1.1 判空
        if (OBJECT_IS_EMPTY(self.text)) {
            return self.allowsEmpty;
        }
        //1.2 最小值判断
        if (self.minLength > 0 && [self textLength] < self.minLength) {
            return NO;
        }
        //1.3 根据property属性校验
        return [self _isValidByProperty];
    }
    //3. 根据内置正则表达式来校验
    else {
        if (PSKTextTypePhone == self.textType) {
            return [NSString psk_isMatchRegex:PSKConfigManagerInstance.regexPhone withString:tempString];
        }
        else if (PSKTextTypeMobilePhone == self.textType) {
            return [NSString psk_isMatchRegex:PSKConfigManagerInstance.regexMobilePhone withString:tempString];
        }
        else if (PSKTextTypeIdentityNum == self.textType) {
            return [NSString psk_verifyIDCardNumber:tempString];// 严格校验身份证号
        }
        else if (PSKTextTypeEmail == self.textType) {
            return [NSString psk_isMatchRegex:PSKConfigManagerInstance.regexEmail withString:tempString];
        }
        else if (PSKTextTypeUrl == self.textType) {
            return [NSString psk_isMatchRegex:PSKConfigManagerInstance.regexWebUrl withString:tempString];
        }
    }
    
    return YES;
}
- (NSString *)textString {
    return [self.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
- (NSInteger)textLength {
    if (self.stringLengthType) {
        return [self textString].length;
    }
    else {
        return [[self textString] psk_stringLength];
    }
}
- (void)setText:(NSString *)text notify:(BOOL)isNotify {
    self.text = text;
    if (isNotify) {
        [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification
                                                            object:self
                                                          userInfo:nil];
    }
}

#pragma mark - Setters
- (void)setTextType:(PSKTextType)textType {
    _textType = textType;
    [self _resetKeyboardType];
}
- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = 0.5;
}
- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}
- (void)setTextLeftMargin:(CGFloat)textLeftMargin {
    _textLeftMargin = textLeftMargin;
    [self layoutSubviews];
}
- (void)setTextRightMargin:(CGFloat)textRightMargin {
    _textRightMargin = textRightMargin;
    [self layoutSubviews];
}

#pragma mark - Private Methods
/** 当输入框内容改变时(包括：键盘输入、粘贴、高亮提示文本、setText:notify:)触发 */
- (void)_textFieldChanged:(NSNotification *)notification {
    UITextField *textField = (UITextField *)notification.object;
    if (textField != self) {
        return;
    }
    
    UITextRange *selectedRange = [textField markedTextRange];//获取高亮部分
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    if (selectedRange || position) {
        //NOTE: 有高亮选择的字符串，则暂不对文字进行统计和限制
    }
    else {
        NSString *inputMode = [self.textInputMode primaryLanguage];
        if ( ! inputMode) {//ios8 默认emoji键盘会返回nil 这是bug???
            inputMode = [[UITextInputMode currentInputMode] primaryLanguage];
        }
        if ([@"emoji" isEqualToString:inputMode] && ( ! self.allowsEmoji)) {//针对emoji键盘控制是否可以输入
            textField.text = self.oldString;
        }
        else {
            if ([self _isValidByProperty]) {
                self.oldString = self.textString;
            }
            else {
                textField.text = self.oldString;
            }
        }
        if (self.changedBlock) {
            self.changedBlock(textField.text);
        }
    }
}
/** 根据设置的属性实时监测输入的合法性 */
- (BOOL)_isValidByProperty {
    if (self.maxLength > 0 && [self textLength] > self.maxLength) {
        return NO;
    }
    if (OBJECT_IS_EMPTY(self.text)) {
        return YES;//永远可以删除所有输入的内容
    }
    //校验各种属性的设置
    NSString *tempString = self.text;
    NSMutableString *tempRegex = [NSMutableString stringWithString:@"^[ "];
    
    //简单emoji表情判断
    if (self.allowsEmoji && OBJECT_ISNOT_EMPTY(self.emojiRegex)) {
        [tempRegex appendString:self.emojiRegex];
    }
    //标点符号判断
    if (self.allowsPunctuation) {
        if (OBJECT_ISNOT_EMPTY(self.punctuationRegex)) {
            [tempRegex appendString:self.punctuationRegex];
        }
        else {
            //参考链接：http://blog.csdn.net/yuan892173701/article/details/8731490
            [tempRegex appendString:@"/,!<>\\{\\}'~•£€¥\\$%@\\*&#_\\+\\?\\^\\|\\.=\\-\\(\\)\\[\\]\\\\"];//常用特殊符号
            [tempRegex appendString:@"\u3002\uFF1F\uFF01\uFF0C\u3001\uFF1A\uFF1B\u300C-\u300F\u2018\u2019\u201C\u201D\uFF08\uFF09"];
            [tempRegex appendString:@"\u3014\u3015\u3010\u3011\u2014\u2026\u2013\uFF0E\u300A\u300B\u3008\u3009"];
            [tempRegex appendString:@"｝｛·～"];
            
            //NOTE:居然下面的unicode正则表达式不起作用！why?
            //参考链接：http://blog.csdn.net/monitor1394/article/details/7255767
            //            [tempRegex appendString:@"\u3000-\u303F"];//CJK标点符号
            //            [tempRegex appendString:@"\uFE10-\uFE1F"];//中文竖排标点
            //            [tempRegex appendString:@"\uFE30-\uFE4F"];//CJK兼容符号（竖排变体、下划线、顿号）
            //            [tempRegex appendString:@"\uFE50-\uFE6F"];//中文标点
            //            [tempRegex appendString:@"\uFF00-\uFFEF"];//全角ASCII、全角中英文标点、半宽片假名、半宽平假名、半宽韩文字母
        }
    }
    //中文判断
    if (self.allowsChinese) {
        if (OBJECT_ISNOT_EMPTY(self.chineseRegex)) {
            [tempRegex appendString:self.chineseRegex];
        }
        else {
            //参考链接：http://blog.csdn.net/fmddlmyy/article/details/1868313
            [tempRegex appendString:@"\u4E00-\u9FBB"];//CJK统一汉字(20924)常用
            //            [tempRegex appendString:@"\u3400-\u4DB5"];//CJK统一汉字扩充A(6582)
            //            [tempRegex appendString:@"\u20000-\u2A6D6"];//CJK统一汉字扩充B(42711)
            //            [tempRegex appendString:@"\uF900-\uFA2D"];//CJK兼容汉字(302)
            //            [tempRegex appendString:@"\uFA30-\uFA6A"];//CJK兼容汉字(59)
            //            [tempRegex appendString:@"\uFA70-\uFAD9"];//CJK兼容汉字(106)
            //            [tempRegex appendString:@"\u2F800-\u2FA1D"];//CJK兼容汉字补充(542)
        }
    }
    if (self.allowsLetter) {
        [tempRegex appendString:@"a-zA-Z"];
    }
    if (self.allowsNumber) {
        [tempRegex appendString:@"0-9"];
    }
    [tempRegex appendString:@"]+$"];
    return [NSString psk_isMatchRegex:tempRegex withString:tempString];
}
/**
 * 设置弹出键盘类型 ios keyboardtype:
 * 0. Default: 汉字 + 字母 + 数字 + 标点 + emoji
 * 1. ASCII Capable: 字母 + 数字 + 标点(英)
 * 2. Numbers and Punctuation: 数字 + 字母 + 标点(中、英)
 * 3. URL、Email、Twitter、Websearch: 字母 + 数字 + 汉字 + 标点 + emoji
 * 4. Number Pad: 数字
 * 5. Phone Pad: 数字 + * + #
 * 6. Name Phone Pad: 数字 + 字母 + 汉字 + emoji
 * 7. Decimal Pad : 数字 +  .
 */
- (void)_resetKeyboardType {
    self.keyboardType = UIKeyboardTypeASCIICapable;
    if (PSKTextTypePhone == self.textType || PSKTextTypeMobilePhone == self.textType) {
        self.keyboardType = UIKeyboardTypeNumberPad;
    }
    else if (PSKTextTypeIdentityNum == self.textType) {
        self.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    else if (PSKTextTypeDecimal == self.textType) {
        self.keyboardType = UIKeyboardTypeDecimalPad;
    }
    else {
        if (self.allowsNumber) {
            self.keyboardType = UIKeyboardTypeNumberPad;
        }
        if (self.allowsLetter) {
            self.keyboardType = UIKeyboardTypeASCIICapable;
        }
        if (self.allowsPunctuation) {
            self.keyboardType = UIKeyboardTypeASCIICapable;
        }
        if (self.allowsEmoji) {
            self.keyboardType = UIKeyboardAppearanceDefault;
        }
        if (self.allowsChinese) {
            self.keyboardType = UIKeyboardAppearanceDefault;
        }
    }
}

@end
