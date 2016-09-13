//
//  UILabel+Util.m
//  CalvinUtils
//
//  Created by pisen on 16/2/4.
//  Copyright © 2016年 Calvin. All rights reserved.
//

#import "UILabel+Util.h"

@implementation UILabel (Util)

+ (instancetype)labelWithFrame:(CGRect)frame text:(NSString*)text textColor:(UIColor*)textColor fontSize:(CGFloat)fontSize textAlignment:(NSTextAlignment)textAlignment {
    UILabel * label = [[UILabel alloc]initWithFrame:frame];
    label.text = text;
    label.textColor = textColor;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textAlignment = textAlignment;
    
    return label;
}

// 自适应宽度
+ (instancetype)labelWithAutoWidthOfFrame:(CGRect)frame text:(NSString*)text  textColor:(UIColor*)textColor fontSize:(CGFloat)fontSize textAlignment:(NSTextAlignment)textAlignment {
    UILabel * label = [UILabel labelWithFrame:frame text:text textColor:textColor fontSize:fontSize textAlignment:textAlignment];
    CGSize size = [text boundingRectWithSize:CGSizeMake(frame.size.width, 0) options:1 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    CGRect rect = frame;
    rect.size.width = size.width;
    label.frame = rect;
    
    return label;
}

@end
