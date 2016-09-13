//
//  UITextField+Util.m
//  CalvinUtils
//
//  Created by pisen on 16/2/4.
//  Copyright © 2016年 Calvin. All rights reserved.
//

#import "UITextField+Util.h"

@implementation UITextField (Util)

+ (instancetype)textFieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder  borderStyle:(UITextBorderStyle)borderStyle keyboardType:(UIKeyboardType)keyboardType returnKeyType:(UIReturnKeyType)returnKeyType textColor:(UIColor*)textColor fontSize:(CGFloat)fontSize clearButtonMode:(UITextFieldViewMode)clearButtonMode sec:(BOOL)sec {
    UITextField * textField = [[UITextField alloc]initWithFrame:frame];
    textField.placeholder = placeholder;
    textField.borderStyle = borderStyle;
    textField.keyboardType = keyboardType;
    textField.returnKeyType = returnKeyType;
    textField.textColor = textColor;
    textField.font = [UIFont systemFontOfSize:fontSize];
    textField.clearButtonMode = clearButtonMode;
    textField.secureTextEntry = sec;
    
    return textField;
}

@end
