//
//  YSCTextView.m
//  YSCKit
//
//  Created by yangshengchao on 15/7/3.
//  Copyright (c) 2015年 Builder. All rights reserved.
//

#import "YSCTextView.h"
#import "YSCTextDelegate.h"

@interface YSCTextView () <UITextViewDelegate>
@property (nonatomic, copy) NSString *oldString;
@property (nonatomic, strong) UILabel *placeholderLabel;    //显示占位信息的label
@property (nonatomic, strong) UILabel *remainingLabel;      //显示剩余字符数的label
@end

@implementation YSCTextView

- (void)dealloc {
    self.delegate = nil;
    removeAllObservers(self);
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
    self.allowsEmpty = NO;
    self.allowsEmoji = NO;
    self.allowsSimpleEmoji = NO;
    self.allowsChinese = YES;
    self.allowsPunctuation = YES;
    self.allowsKeyboardDone = YES;
    self.allowsLetter = YES;
    self.allowsNumber = YES;
    self.stringLengthType = YES;
    self.cornerRadius = 8;
    self.borderColor = kDefaultBorderColor;
    
    //创建placeholerLabel
    self.placeholderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.placeholderLabel.numberOfLines = 0;
    [self addSubview:self.placeholderLabel];
    self.placeholderLabel.text = self.placeholderString;
    self.placeholderLabel.font = self.font;
    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.mas_top).offset(13);
        make.width.equalTo(self.mas_width).offset(0);
    }];
    self.placeholderString = @"";
    self.placeholderColor = kDefaultPlaceholderColor;
    
    //创建remainingLabel
    self.remainingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:self.remainingLabel];
    self.remainingCount = self.maxLength;
    self.remainingLabel.font = [UIFont systemFontOfSize:22];
    self.remainingLabel.backgroundColor = [UIColor clearColor];
    self.remainingLabel.textAlignment = NSTextAlignmentRight;
    [self.remainingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //NOTE:很奇怪！这里设置右边距和下边距没有用！所以只能用下面的方法代替
        make.top.equalTo(self.mas_top).offset(self.height - 30);
        make.leading.equalTo(self.mas_leading).offset(self.width - 110);
        make.width.equalTo(@100);
    }];
    self.showsRemainingCount = NO;
    self.remainingTextColor = kDefaultPlaceholderColor;
    self.maxLength = 400;
    
    self.backgroundColor = [UIColor whiteColor];
    self.delegate = [YSCTextDelegate sharedInstance];
    self.oldString = @"";
    addNObserverWithObj(@selector(textViewChanged:), UITextViewTextDidChangeNotification, self);
}
- (void)setMaxLength:(NSInteger)maxLength {
    _maxLength = maxLength;
    self.remainingLabel.text = [NSString stringWithFormat:@"%ld", (long)maxLength];
}
- (void)setRemainingCount:(NSInteger)remainingCount {
    _remainingCount = remainingCount;
    if (remainingCount == self.maxLength) {
        self.remainingLabel.text = [NSString stringWithFormat:@"%ld", (long)self.maxLength];
        self.placeholderLabel.hidden = NO;
    }
    else {
        self.remainingLabel.text = [NSString stringWithFormat:@"%ld", (long)remainingCount];
        self.placeholderLabel.hidden = YES;
    }
}

//当输入框内容改变时触发
//NOTE:彻底解决中文输入高亮超过限制会crash的问题！
- (void)textViewChanged:(NSNotification *)notification {
    UITextView *textView = (UITextView *)notification.object;
    if (textView != self) {
        return;
    }
    
    UITextRange *selectedRange = [textView markedTextRange];//获取高亮部分
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    if (selectedRange || position) {
        //NOTE: 有高亮选择的字符串，则暂不对文字进行统计和限制
        self.placeholderLabel.hidden = YES;
    }
    else {
        NSString *inputMode = [self.textInputMode primaryLanguage];
        if (nil == inputMode) {//ios8 默认emoji键盘会返回nil 这是bug???
            inputMode = [[UITextInputMode currentInputMode] primaryLanguage];
        }
        if ([@"emoji" isEqualToString:inputMode] && NO == self.allowsEmoji) {//针对emoji键盘控制是否可以输入
            textView.text = self.oldString;
        }
        else {
            if ([self isValidByProperty]) {
                self.oldString = self.textString;
            }
            else {
                textView.text = self.oldString;
            }
        }
        self.remainingCount = self.maxLength - [self textLength];
    }
}
//只检测配置属性 ok -> err
- (BOOL)isValidByProperty {
    if (self.maxLength > 0 && [self textLength] > self.maxLength) {
        return NO;
    }
    if (isEmpty(self.text)) {
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
        //参考链接：http://blog.csdn.net/yuan892173701/article/details/8731490
        [tempRegex appendString:@"/,!<>\\{\\}'~•£€¥\\$%@\\*&#_\\+\\?\\^\\|\\.=\\-\\(\\)\\[\\]\\\\"];//常用特殊符号
        [tempRegex appendString:@"\u3002\uFF1F\uFF01\uFF0C\u3001\uFF1A\uFF1B\u300C-\u300F\u2018\u2019\u201C\u201D\uFF08\uFF09"];
        [tempRegex appendString:@"\u3014\u3015\u3010\u3011\u2014\u2026\u2013\uFF0E\u300A\u300B\u3008\u3009"];
        [tempRegex appendString:@"｝｛·～"];
        
        //NOTE:居然下面的unicode正则表达式不起作用！why?
        //参考链接：http://blog.csdn.net/monitor1394/article/details/7255767
        //        [tempRegex appendString:@"\u3000-\u303F"];//CJK标点符号
        //        [tempRegex appendString:@"\uFE10-\uFE1F"];//中文竖排标点
        //        [tempRegex appendString:@"\uFE30-\uFE4F"];//CJK兼容符号（竖排变体、下划线、顿号）
        //        [tempRegex appendString:@"\uFE50-\uFE6F"];//中文标点
        //        [tempRegex appendString:@"\uFF00-\uFFEF"];//全角ASCII、全角中英文标点、半宽片假名、半宽平假名、半宽韩文字母
    }
    //中文判断
    if (self.allowsChinese) {
        //参考链接：http://blog.csdn.net/fmddlmyy/article/details/1868313
        [tempRegex appendString:@"\u4E00-\u9FBB"];//CJK统一汉字(20924)常用
        //        [tempRegex appendString:@"\u3400-\u4DB5"];//CJK统一汉字扩充A(6582)
        //        [tempRegex appendString:@"\u20000-\u2A6D6"];//CJK统一汉字扩充B(42711)
        //        [tempRegex appendString:@"\uF900-\uFA2D"];//CJK兼容汉字(302)
        //        [tempRegex appendString:@"\uFA30-\uFA6A"];//CJK兼容汉字(59)
        //        [tempRegex appendString:@"\uFA70-\uFAD9"];//CJK兼容汉字(106)
        //        [tempRegex appendString:@"\u2F800-\u2FA1D"];//CJK兼容汉字补充(542)
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
    //1.0 根据自定义的正则表达式来校验
    if (NO == isEmpty(self.customRegex)) {
        return [self checkString:tempString isMatchRegex:self.customRegex];
    }
    //1.1 判空
    if (isEmpty(self.text)) {
        return self.allowsEmpty;
    }
    //1.2 根据property属性校验
    return [self isValidByProperty];
}
- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = AUTOLAYOUT_LENGTH(1);
}
- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = AUTOLAYOUT_LENGTH(cornerRadius);
    self.layer.masksToBounds = YES;
}
- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    self.placeholderLabel.textColor = placeholderColor;
}
- (void)setPlaceholderString:(NSString *)placeholderString {
    _placeholderString = placeholderString;
    self.placeholderLabel.text = placeholderString;
}
- (void)setRemainingTextColor:(UIColor *)remainingTextColor {
    _remainingTextColor = remainingTextColor;
    self.remainingLabel.textColor = remainingTextColor;
}
- (void)setShowsRemainingCount:(BOOL)showsRemainingCount {
    _showsRemainingCount = showsRemainingCount;
    self.remainingLabel.hidden = ! showsRemainingCount;
}
//NOTE:xib中修改了某些属性，需要重新设置参数
- (void)layoutSubviews {
    [super layoutSubviews];
    [self resetKeyboardType];
    [self layoutIfNeeded];
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
- (void)resetKeyboardType {
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
        return [[self textString] StringLength];
    }
}
//输入text的时候过滤非法内容
- (void)filterText:(NSString *)text {

}
//判断内容是否符合正则表达式
- (BOOL)checkString:(NSString *)string isMatchRegex:(NSString *)regex {
    if (isEmpty(string)) {
        return NO;
    }
    if (isEmpty(regex)) {
        return NO;
    }
    NSError *error = nil;
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:regex
                                                                                options:NSRegularExpressionAnchorsMatchLines
                                                                                  error:&error];
    if (error) {
        return NO;
    }
    return ([expression numberOfMatchesInString:string options:0 range:NSMakeRange(0, [string length])] > 0);
}

@end
