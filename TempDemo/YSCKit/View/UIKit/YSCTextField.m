//
//  YSCTextField.m
//  YSCKit
//
//  Created by yangshengchao on 15/7/3.
//  Copyright (c) 2015年 Builder. All rights reserved.
//

#import "YSCTextField.h"

/** YSCTextField专有delegate */
@interface YSCTextFieldDelegate : NSObject <UITextFieldDelegate> @end
@implementation YSCTextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    POST_NOTIFICATION_WITH_OBJECT(UITextFieldTextDidChangeNotification, textField);
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;//NOTE:主要是为了放开删除按钮
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    YSCTextField *yscTextField = (YSCTextField *)textField;
    if (yscTextField.keyboardDoneBlock) {
        yscTextField.keyboardDoneBlock(yscTextField.textString);
    }
    if(yscTextField.allowsKeyboardDismiss) {
        [textField resignFirstResponder];
    }
    return YES;
}
@end


/** 重新封装UITextField */
@interface YSCTextField ()
@property (nonatomic, copy) NSString *oldString;
@property (nonatomic, strong) YSCTextFieldDelegate *customDelegate;
@end

@implementation YSCTextField

- (void)dealloc {
    self.delegate = nil;
    REMOVE_ALL_OBSERVERS(self);
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

//初始化配置参数
- (void)setup {
    //设置参数默认值
    self.textType = YSCTextTypeProperty;
    self.minLength = 0;
    self.maxLength = 20;
    self.allowsEmpty = NO;
    self.allowsEmoji = NO;
    self.allowsSimpleEmoji = NO;
    self.allowsChinese = NO;
    self.allowsPunctuation = NO;
    self.allowsKeyboardDismiss = YES;
    self.allowsLetter = YES;
    self.allowsNumber = YES;
    self.stringLengthType = YES;
    self.cornerRadius = 8;
    self.textLeftMargin = 10;
    self.textRightMargin = 10;
    self.borderColor = YSCConfigDataInstance.defaultBorderColor;
    
    self.borderStyle = UITextBorderStyleNone;
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    if ( ! self.backgroundColor) {
        self.backgroundColor = [UIColor whiteColor];
    }
    self.customDelegate = [YSCTextFieldDelegate new];
    self.delegate = self.customDelegate;
    self.oldString = @"";
    ADD_OBSERVER_WITH_OBJECT(@selector(textFieldChanged:), UITextFieldTextDidChangeNotification, self);
}
- (void)setText:(NSString *)text notify:(BOOL)isNotify {
    self.text = text;
    if (isNotify) {
        POST_NOTIFICATION_WITH_OBJECT(UITextFieldTextDidChangeNotification, self);
    }
}
- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = AUTOLAYOUT_LENGTH(1);
}
- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    // 方法一：
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName: placeholderColor}];
    // 方法二：
//    [self setValue:placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
}
- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = AUTOLAYOUT_LENGTH(cornerRadius);
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

//NOTE:xib中修改了某些属性，需要重新设置参数
- (void)layoutSubviews {
    [super layoutSubviews];
    self.textType = _textType;
    [self layoutIfNeeded];
}
//当输入框内容改变时触发
//NOTE:彻底解决中文输入高亮超过限制会crash的问题！
- (void)textFieldChanged:(NSNotification *)notification {
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
            if ([self isValidByProperty]) {
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
//只检测配置属性 ok -> err
- (BOOL)isValidByProperty {
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
    if (self.allowsEmoji && self.allowsSimpleEmoji) {
        [tempRegex appendString:YSCEMOJI_SUPPORT_REGEX];
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
        if (OBJECT_ISNOT_EMPTY(self.chinessRegex)) {
            [tempRegex appendString:self.chinessRegex];
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
//    NSLog(@"string=%@,regex=%@", tempString,tempRegex);
    return [self checkString:tempString isMatchRegex:tempRegex];
}
//检测输入内容是否有效 ok <-> err
- (BOOL)isValid {
    //0. 暂存输入的字符串
    NSString *tempString = [self textString];
    
    //1. 根据property设置来校验
    if (YSCTextTypeProperty == self.textType) {
        //1.0 根据自定义的正则表达式来校验
        if ( ! OBJECT_IS_EMPTY(self.customRegex)) {
            return [self checkString:tempString isMatchRegex:self.customRegex];
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
        return [self isValidByProperty];
    }
    //3. 根据内置正则表达式来校验
    else {
        if (YSCTextTypePhone == self.textType) {
            return [self checkString:tempString isMatchRegex:@"^\\d{3,15}$"];
        }
        else if (YSCTextTypeMobilePhone == self.textType) {
            return [self checkString:tempString isMatchRegex:@"^(01|1)\\d{10}$"];
        }
        else if (YSCTextTypeIdentityNum == self.textType) {
            return [NSString verifyIDCardNumber:tempString];//NOTE:严格校验身份证号
        }
        else if (YSCTextTypeEmail == self.textType) {
            return [self checkString:tempString isMatchRegex:@"^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$"];
        }
        else if (YSCTextTypeCarNumber == self.textType) {
            return [self checkString:tempString isMatchRegex:@"^[\u4e00-\u9fa5]{1}[A-Z]{1}[A-Z0-9]{0,5}[0-9]{1,5}[A-Z0-9]{0,5}$"];
        }
        else if (YSCTextTypeUrl == self.textType) {
            return [self checkString:tempString isMatchRegex:@"((http|ftp|https)://)(([a-zA-Z0-9\\._-]+\\.[a-zA-Z]{2,6})|([0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}))(:[0-9]{1,4})*(/[a-zA-Z0-9\\&%_\\./-~-]*)?"];
        }
    }

    return YES;
}

//定义弹出键盘类型
//ios keyboardtype:
//0. Default: 汉字+字母+数字+标点+emoji
//1. ASCII Capable: 字母+数字+标点(英)
//2. Numbers and Punctuation : 数字+字母+标点(中、英)
//3. URL、Email、Twitter、Websearch : 字母+数字+汉字+标点+emoji
//4. Number Pad: 数字
//5. Phone Pad: 数字+*+#
//6. Name Phone Pad ：数字+字母+汉字+emoji
//7. Decimal Pad : 数字 +  .
- (void)setTextType:(YSCTextType)textType {
    _textType = textType;
    self.keyboardType = UIKeyboardTypeASCIICapable;
    if (YSCTextTypePhone == textType || YSCTextTypeMobilePhone == textType) {
        self.keyboardType = UIKeyboardTypeNumberPad;
    }
    else if (YSCTextTypeIdentityNum == textType) {
        self.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    else if (YSCTextTypeDecimal == textType) {
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
        if (self.allowsEmoji || self.allowsSimpleEmoji) {
            self.keyboardType = UIKeyboardAppearanceDefault;
        }
        if (self.allowsChinese) {
            self.keyboardType = UIKeyboardAppearanceDefault;
        }
    }
}
//返回去掉首位空格后的字符串
- (NSString *)textString {
    return [self.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
//返回去掉首位空格后的字符串的长度
- (NSInteger)textLength {
    if (self.stringLengthType) {
        return [self textString].length;
    }
    else {
        return [[self textString] stringLength];
    }
}
//输入text的时候过滤非法内容
- (void)filterText:(NSString *)text {

}
//判断内容是否符合正则表达式
- (BOOL)checkString:(NSString *)string isMatchRegex:(NSString *)regex {
    RETURN_NO_WHEN_OBJECT_IS_EMPTY(string)
    RETURN_NO_WHEN_OBJECT_IS_EMPTY(regex)
    NSError *error = nil;
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:regex
                                                                                options:NSRegularExpressionAnchorsMatchLines
                                                                                  error:&error];
    if (error) {
        return NO;
    }
    return ([expression numberOfMatchesInString:string options:0 range:NSMakeRange(0, [string length])] > 0);
}

#pragma mark - 重写基类方法
// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, AUTOLAYOUT_LENGTH(self.textLeftMargin), AUTOLAYOUT_LENGTH(self.textRightMargin));
}
// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, AUTOLAYOUT_LENGTH(self.textLeftMargin), AUTOLAYOUT_LENGTH(self.textRightMargin));
}

@end
