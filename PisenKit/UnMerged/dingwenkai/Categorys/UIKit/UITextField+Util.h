//
//  UITextField+Util.h
//  CalvinUtils
//
//  Created by pisen on 16/2/4.
//  Copyright © 2016年 Calvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Util)

+ (instancetype)textFieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder  borderStyle:(UITextBorderStyle)borderStyle keyboardType:(UIKeyboardType)keyboardType returnKeyType:(UIReturnKeyType)returnKeyType textColor:(UIColor*)textColor fontSize:(CGFloat)fontSize clearButtonMode:(UITextFieldViewMode)clearButtonMode sec:(BOOL)sec;

@end
