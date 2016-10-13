//
//  YSCTextDelegate.h
//  YSCKit
//
//  Created by yangshengchao on 15/7/23.
//  Copyright (c) 2015年 Builder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSCTextDelegate : NSObject <UITextFieldDelegate, UITextViewDelegate>

+ (instancetype)sharedInstance;

@end
