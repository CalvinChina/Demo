//
//  NSDate+Util.m
//  CalvinUtils
//
//  Created by pisen on 16/2/4.
//  Copyright © 2016年 Calvin. All rights reserved.
//

#import "NSDate+Util.h"
#import "NSDateFormatter+Singleton.h"

@implementation NSDate (Util)

// NSDate转NSString
+ (NSString *)stringFromDate:(NSDate *)date {
    return [[NSDateFormatter sharedInstance] stringFromDate:date];
}

// NSString转NSDate
+ (instancetype)dateFromString:(NSString *)string {
    return [[NSDateFormatter sharedInstance] dateFromString:string];
}

- (NSString *)weekdayString {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:
                                    NSCalendarUnitYear |
                                    NSCalendarUnitMonth |
                                    NSCalendarUnitDay |
                                    NSCalendarUnitWeekday fromDate:self];
    switch (components.weekday) {
        case 1: return @"星期天";
        case 2: return @"星期一";
        case 3: return @"星期二";
        case 4: return @"星期三";
        case 5: return @"星期四";
        case 6: return @"星期五";
        case 7: return @"星期六";
        default: return @"";
    }
}



@end
