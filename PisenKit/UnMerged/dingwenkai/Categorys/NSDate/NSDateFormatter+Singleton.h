//
//  NSDateFormatter+Singleton.h
//  CalvinUtils
//
//  Created by pisen on 16/2/4.
//  Copyright © 2016年 Calvin. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSDateFormatter (Singleton)

+ (instancetype)sharedInstance;

@end
