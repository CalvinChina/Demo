//
//  UILabel+Util.h
//  CalvinUtils
//
//  Created by pisen on 16/2/4.
//  Copyright © 2016年 Calvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Util)

+ (instancetype)labelWithFrame:(CGRect)frame text:(NSString*)text textColor:(UIColor*)textColor fontSize:(CGFloat)fontSize textAlignment:(NSTextAlignment)textAlignment;

// 自适应宽度
+ (instancetype)labelWithAutoWidthOfFrame:(CGRect)frame text:(NSString*)text  textColor:(UIColor*)textColor fontSize:(CGFloat)fontSize textAlignment:(NSTextAlignment)textAlignment;

@end
