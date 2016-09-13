//
//  NSString+Util.h
//  CalvinUtils
//
//  Created by pisen on 16/2/4.
//  Copyright © 2016年 Calvin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Util)

// 计算尺寸：根据字符串的内容以及指定的最大宽度和字体大小计算出显示该字符串需要的尺寸
- (CGSize)boundingSizeWithSize:(CGSize)size font:(UIFont *)font;

// 判断电话号码是否正确
- (BOOL)isMobileNumber;

// 判断邮箱是否正确
- (BOOL)isEmail;



@end
