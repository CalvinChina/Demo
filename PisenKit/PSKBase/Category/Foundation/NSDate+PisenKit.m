//
//  NSDate+PisenKit.m
//  PisenKit
//
//  Created by 杨胜超 on 16/6/30.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import "NSDate+PisenKit.h"

#define PSK_STD_MINUTE    60
#define PSK_STD_HOUR      (60 * PSK_STD_MINUTE)
#define PSK_STD_DAY       (24 * PSK_STD_HOUR)
#define PSK_STD_WEEK      (7  * PSK_STD_DAY)

#if IOS8_OR_LATER
    #define PSK_CalendarUnitYear        NSCalendarUnitYear
#else
    #define PSK_CalendarUnitYear        NSYearCalendarUnit
#endif
#if IOS8_OR_LATER
    #define PSK_CalendarUnitMonth       NSCalendarUnitMonth
#else
    #define PSK_CalendarUnitMonth       NSMonthCalendarUnit
#endif
#if IOS8_OR_LATER
    #define PSK_CalendarUnitDay         NSCalendarUnitDay
#else
    #define PSK_CalendarUnitDay         NSDayCalendarUnit
#endif
#if IOS8_OR_LATER
    #define PSK_CalendarUnitHour        NSCalendarUnitHour
#else
    #define PSK_CalendarUnitHour        NSHourCalendarUnit
#endif
#if IOS8_OR_LATER
    #define PSK_CalendarUnitMinute      NSCalendarUnitMinute
#else
    #define PSK_CalendarUnitMinute      NSMinuteCalendarUnit
#endif
#if IOS8_OR_LATER
    #define PSK_CalendarUnitSecond      NSCalendarUnitSecond
#else
    #define PSK_CalendarUnitSecond      NSSecondCalendarUnit
#endif
#if IOS8_OR_LATER
    #define PSK_CalendarUnitWeekday     NSCalendarUnitWeekday
#else
    #define PSK_CalendarUnitWeekday     NSWeekdayCalendarUnit
#endif
#if IOS8_OR_LATER
    #define PSK_CalendarUnitWeekOfYear  NSCalendarUnitWeekOfYear
#else
    #define PSK_CalendarUnitWeekOfYear  NSWeekOfYearCalendarUnit
#endif

#define CALENDAR_UNITS      (PSK_CalendarUnitYear | PSK_CalendarUnitMonth | PSK_CalendarUnitDay | PSK_CalendarUnitHour | PSK_CalendarUnitMinute | PSK_CalendarUnitSecond | PSK_CalendarUnitWeekday | PSK_CalendarUnitWeekOfYear)
#define DATE_COMPONENTS     [[NSCalendar currentCalendar] components:CALENDAR_UNITS fromDate:self]


//==============================================================================
//
//  常用方法
//
//==============================================================================
@implementation NSDate (PisenKit)
- (NSInteger)psk_hour {
    return [DATE_COMPONENTS hour];
}
- (NSInteger)psk_minute {
    return [DATE_COMPONENTS minute];
}
- (NSInteger)psk_seconds {
    return [DATE_COMPONENTS second];
}
- (NSInteger)psk_day {
    return [DATE_COMPONENTS day];
}
- (NSInteger)psk_month {
    return [DATE_COMPONENTS month];
}
- (NSInteger)psk_weekday {
    return [DATE_COMPONENTS weekday];
}
- (NSInteger)psk_weekOfYear {
    return [DATE_COMPONENTS weekOfYear];
}
- (NSInteger)psk_nthWeekday {
    return [DATE_COMPONENTS weekdayOrdinal];
}
- (NSInteger)psk_year {
    return [DATE_COMPONENTS year];
}

#pragma mark Relative Dates
+ (NSDate *)psk_dateNow {
    return CURRENT_DATE;
}
+ (NSDate *)psk_dateTomorrow {
    return [NSDate psk_dateFromNowAfterDays:1];
}
+ (NSDate *)psk_dateYesterday {
    return [NSDate psk_dateFromNowBeforeDays:1];
}
+ (NSDate *)psk_dateAfterTomorrow {
    return [NSDate psk_dateFromNowAfterDays:2];
}
+ (NSDate *)psk_dateBeforeYesterday {
    return [NSDate psk_dateFromNowBeforeDays:2];
}
+ (NSDate *)psk_dateFromNowAfterDays:(NSInteger)days {
    return [self _psk_dateWithSecondReference:CURRENT_DATE second:PSK_STD_DAY * days];
}
+ (NSDate *)psk_dateFromNowBeforeDays:(NSInteger)days {
    return [self _psk_dateWithSecondReference:CURRENT_DATE second:-PSK_STD_DAY * days];
}
+ (NSDate *)psk_dateFromNowAfterHours:(NSInteger)hours {
    return [self _psk_dateWithSecondReference:CURRENT_DATE second:PSK_STD_HOUR * hours];
}
+ (NSDate *)psk_dateFromNowBeforeHours:(NSInteger)hours {
    return [self _psk_dateWithSecondReference:CURRENT_DATE second:-PSK_STD_HOUR * hours];
}
+ (NSDate *)psk_dateFromNowAfterMinutes:(NSInteger)minutes {
    return [self _psk_dateWithSecondReference:CURRENT_DATE second:PSK_STD_MINUTE * minutes];
}
+ (NSDate *)psk_dateFromNowBeforeMinutes:(NSInteger)minutes {
    return [self _psk_dateWithSecondReference:CURRENT_DATE second:-PSK_STD_MINUTE * minutes];
}

#pragma mark - Convert with format
+ (NSDate *)psk_dateFromTimeStamp:(NSString *)timeStamp {
    return [self psk_dateFromTimeInterval:[timeStamp longLongValue]];
}
+ (NSDate *)psk_dateFromTimeInterval:(NSTimeInterval)timeInterval {
    if (timeInterval > 1000000000.0f * 1000.0f) {//判断单位是秒还是毫秒
        timeInterval = timeInterval / 1000.0f;
    }
    return [NSDate dateWithTimeIntervalSince1970:timeInterval];
}
+ (NSDate *)psk_dateFromString:(NSString *)string withFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter dateFromString:string];
}
+ (NSString *)psk_stringFromTimeStamp:(NSString *)timeStamp withFormat:(NSString *)format {
    return [[self psk_dateFromTimeStamp:timeStamp] psk_stringWithFormat:format];
}
+ (NSString *)psk_convertDateString:(NSString *)dataString fromFormat:(NSString *)fromFormat toFormat:(NSString *)toFormat {
    NSDate *date = [NSDate psk_dateFromString:dataString withFormat:fromFormat];
    return [date psk_stringWithFormat:toFormat];
}
- (NSString *)psk_stringWithFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:self];
}

#pragma mark Comparing Dates
- (BOOL)psk_isEqualToDateIgnoringTime:(NSDate *)date {
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:CALENDAR_UNITS fromDate:self];
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:CALENDAR_UNITS fromDate:date];
    return (([components1 year] == [components2 year]) &&
            ([components1 month] == [components2 month]) &&
            ([components1 day] == [components2 day]));
}
- (BOOL)psk_isToday {
    return [self psk_isEqualToDateIgnoringTime:CURRENT_DATE];
}
- (BOOL)psk_isTomorrow {
    return [self psk_isEqualToDateIgnoringTime:[NSDate psk_dateTomorrow]];
}
- (BOOL)psk_isYesterday {
    return [self psk_isEqualToDateIgnoringTime:[NSDate psk_dateYesterday]];
}
- (BOOL)psk_isAfterTomorrow {
    return [self psk_isEqualToDateIgnoringTime:[NSDate psk_dateAfterTomorrow]];
}
- (BOOL)psk_isBeforeYesterday {
    return [self psk_isEqualToDateIgnoringTime:[NSDate psk_dateBeforeYesterday]];
}
- (BOOL)psk_isSameWeekAsDate:(NSDate *)date {
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:CALENDAR_UNITS fromDate:self];
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:CALENDAR_UNITS fromDate:date];
    if ([components1 weekOfYear] != [components2 weekOfYear]) {
        return NO;
    }
    return (fabs([self timeIntervalSinceDate:date]) < PSK_STD_WEEK);
}
- (BOOL)psk_isThisWeek {
    return [self psk_isSameWeekAsDate:CURRENT_DATE];
}
- (BOOL)psk_isNextWeek {
    NSDate *newDate = [NSDate _psk_dateWithSecondReference:self second:PSK_STD_WEEK];
    return [self psk_isSameWeekAsDate:newDate];
}
- (BOOL)psk_isLastWeek {
    NSDate *newDate = [NSDate _psk_dateWithSecondReference:self second:-PSK_STD_WEEK];
    return [self psk_isSameWeekAsDate:newDate];
}
- (BOOL)psk_isSameYearAsDate:(NSDate *)date {
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:PSK_CalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:PSK_CalendarUnitYear fromDate:date];
    return ([components1 year] == [components2 year]);
}
- (BOOL)psk_isThisYear {
    return [self psk_isSameYearAsDate:CURRENT_DATE];
}
- (BOOL)psk_isNextYear {
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:PSK_CalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:PSK_CalendarUnitYear fromDate:CURRENT_DATE];
    
    return ([components1 year] == ([components2 year] + 1));
}
- (BOOL)psk_isLastYear {
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:PSK_CalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:PSK_CalendarUnitYear fromDate:CURRENT_DATE];
    
    return ([components1 year] == ([components2 year] - 1));
}
- (BOOL)psk_isEarlierThanDate:(NSDate *)date {
    return ([self earlierDate:date] == self);
}
- (BOOL)psk_isLaterThanDate:(NSDate *)date {
    return ([self laterDate:date] == self);
}

#pragma mark Adjusting Dates
- (NSDate *)psk_dateAfterDays:(NSInteger)days {
    return [NSDate _psk_dateWithSecondReference:self second:PSK_STD_DAY * days];
}
- (NSDate *)psk_dateBeforeDays:(NSInteger)days {
    return [NSDate _psk_dateWithSecondReference:self second:-PSK_STD_DAY * days];
}
- (NSDate *)psk_dateAfterHours:(NSInteger)hours {
    return [NSDate _psk_dateWithSecondReference:self second:PSK_STD_HOUR * hours];
}
- (NSDate *)psk_dateBeforeHours:(NSInteger)hours {
    return [NSDate _psk_dateWithSecondReference:self second:-PSK_STD_HOUR * hours];
}
- (NSDate *)psk_dateAfterMinutes:(NSInteger)minutes {
    return [NSDate _psk_dateWithSecondReference:self second:PSK_STD_MINUTE * minutes];
}
- (NSDate *)psk_dateBeforeMinutes:(NSInteger)minutes {
    return [NSDate _psk_dateWithSecondReference:self second:-PSK_STD_MINUTE * minutes];
}
- (NSDate *)psk_dateAtStartOfDay {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:CALENDAR_UNITS fromDate:self];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

#pragma mark Retrieving Intervals
- (NSInteger)psk_minutesAfterDate:(NSDate *)date {
    NSTimeInterval ti = [self timeIntervalSinceDate:date];
    return (NSInteger)(ti / PSK_STD_MINUTE);
}
- (NSInteger)psk_minutesBeforeDate:(NSDate *)date {
    NSTimeInterval ti = [date timeIntervalSinceDate:self];
    return (NSInteger)(ti / PSK_STD_MINUTE);
}
- (NSInteger)psk_hoursAfterDate:(NSDate *)date {
    NSTimeInterval ti = [self timeIntervalSinceDate:date];
    return (NSInteger)(ti / PSK_STD_HOUR);
}
- (NSInteger)psk_hoursBeforeDate:(NSDate *)date {
    NSTimeInterval ti = [date timeIntervalSinceDate:self];
    return (NSInteger)(ti / PSK_STD_HOUR);
}
- (NSInteger)psk_daysAfterDate:(NSDate *)date {
    NSTimeInterval ti = [self timeIntervalSinceDate:date];
    return (NSInteger)(ti / PSK_STD_DAY);
}
- (NSInteger)psk_daysBeforeDate:(NSDate *)date {
    NSTimeInterval ti = [date timeIntervalSinceDate:self];
    return (NSInteger)(ti / PSK_STD_DAY);
}

#pragma mark - format the date to string
- (NSString *)psk_chineseWeekDay {
    NSString *weekDay = @"";
    NSInteger day = self.psk_weekday;
    if (1 == day) {
        weekDay = @"星期日";
    }
    else if (2 == day) {
        weekDay = @"星期一";
    }
    else if (3 == day) {
        weekDay = @"星期二";
    }
    else if (4 == day) {
        weekDay = @"星期三";
    }
    else if (5 == day) {
        weekDay = @"星期四";
    }
    else if (6 == day) {
        weekDay = @"星期五";
    }
    else {
        weekDay = @"星期六";
    }
    return weekDay;
}
- (NSString *)psk_timeStamp {
    return [NSString stringWithFormat:@"%.0f", [self timeIntervalSince1970]];
}
- (NSString *)psk_chineseMonth {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM"];
    int i_month = 0;
    NSString *theMonth = [dateFormatter stringFromDate:self];
    if ([[theMonth substringToIndex:0] isEqualToString:@"0"]) {
        i_month = [[theMonth substringFromIndex:1] intValue];
    }
    else {
        i_month = [theMonth intValue];
    }
    
    if (i_month == 1) {
        return @"一";
    }
    else if (i_month == 2) {
        return @"二";
    }
    else if (i_month == 3) {
        return @"三";
    }
    else if (i_month == 4) {
        return @"四";
    }
    else if (i_month == 5) {
        return @"五";
    }
    else if (i_month == 6) {
        return @"六";
    }
    else if (i_month == 7) {
        return @"七";
    }
    else if (i_month == 8) {
        return @"八";
    }
    else if (i_month == 9) {
        return @"九";
    }
    else if (i_month == 10) {
        return @"十";
    }
    else if (i_month == 11) {
        return @"十一";
    }
    else if (i_month == 12) {
        return @"十二";
    }
    else {
        return @"";
    }
}
- (NSString *)psk_constellation {
    NSString *retStr = @"";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM"];
    int i_month = 0;
    NSString *theMonth = [dateFormatter stringFromDate:self];
    if ([[theMonth substringToIndex:0] isEqualToString:@"0"]) {
        i_month = [[theMonth substringFromIndex:1] intValue];
    }
    else {
        i_month = [theMonth intValue];
    }
    
    [dateFormatter setDateFormat:@"dd"];
    int i_day = 0;
    NSString *theDay = [dateFormatter stringFromDate:self];
    if ([[theDay substringToIndex:0] isEqualToString:@"0"]) {
        i_day = [[theDay substringFromIndex:1] intValue];
    }
    else {
        i_day = [theDay intValue];
    }
    switch (i_month) {
        case 1:
            if (i_day >= 20 && i_day <= 31) {
                retStr = @"水瓶座";
            }
            if (i_day >= 1 && i_day <= 19) {
                retStr = @"摩羯座";
            }
            break;
            
        case 2:
            if (i_day >= 1 && i_day <= 18) {
                retStr = @"水瓶座";
            }
            if (i_day >= 19 && i_day <= 31) {
                retStr = @"双鱼座";
            }
            break;
            
        case 3:
            if (i_day >= 1 && i_day <= 20) {
                retStr = @"双鱼座";
            }
            if (i_day >= 21 && i_day <= 31) {
                retStr = @"白羊座";
            }
            break;
            
        case 4:
            if (i_day >= 1 && i_day <= 19) {
                retStr = @"白羊座";
            }
            if (i_day >= 20 && i_day <= 31) {
                retStr = @"金牛座";
            }
            break;
            
        case 5:
            if (i_day >= 1 && i_day <= 20) {
                retStr = @"金牛座";
            }
            if (i_day >= 21 && i_day <= 31) {
                retStr = @"双子座";
            }
            break;
            
        case 6:
            if (i_day >= 1 && i_day <= 21) {
                retStr = @"双子座";
            }
            if (i_day >= 22 && i_day <= 31) {
                retStr = @"巨蟹座";
            }
            break;
            
        case 7:
            if (i_day >= 1 && i_day <= 22) {
                retStr = @"巨蟹座";
            }
            if (i_day >= 23 && i_day <= 31) {
                retStr = @"狮子座";
            }
            break;
            
        case 8:
            if (i_day >= 1 && i_day <= 22) {
                retStr = @"狮子座";
            }
            if (i_day >= 23 && i_day <= 31) {
                retStr = @"处女座";
            }
            break;
            
        case 9:
            if (i_day >= 1 && i_day <= 22) {
                retStr = @"处女座";
            }
            if (i_day >= 23 && i_day <= 31) {
                retStr = @"天秤座";
            }
            break;
            
        case 10:
            if (i_day >= 1 && i_day <= 23) {
                retStr = @"天秤座";
            }
            if (i_day >= 24 && i_day <= 31) {
                retStr = @"天蝎座";
            }
            break;
            
        case 11:
            if (i_day >= 1 && i_day <= 21) {
                retStr = @"天蝎座";
            }
            if (i_day >= 22 && i_day <= 31) {
                retStr = @"射手座";
            }
            break;
            
        case 12:
            if (i_day >= 1 && i_day <= 21) {
                retStr = @"射手座";
            }
            if (i_day >= 21 && i_day <= 31) {
                retStr = @"摩羯座";
            }
            break;
    }
    return retStr;
}

#pragma mark - 过去了多长时间
+ (NSString *)psk_timePassedByStartTimeStamp:(NSString *)timeStamp {
    if ( ! timeStamp || ! [timeStamp isKindOfClass:[NSString class]] || ! [timeStamp longLongValue]) {
        return @"";
    }
    NSDate *startDate= [NSDate psk_dateFromTimeStamp:timeStamp];
    return [self psk_timePassedByStartDate:startDate];
}
+ (NSString *)psk_timePassedByStartDate:(NSDate *)startDate {
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(startDate);
    NSDate *endDate = CURRENT_DATE;
    //异常时间处理
    if ([startDate psk_isLaterThanDate:endDate]) {
        return [startDate psk_stringWithFormat:kDateFormat1];
    }
    NSDateComponents *dateComponents = [NSDate psk_componentsFromDate1:startDate toDate:endDate];
    //如果>=365d
    if (dateComponents.day >= 365) {
        return [startDate psk_stringWithFormat:kDateFormat5];
    }
    //如果>=30d && <365d
    if (dateComponents.day >= 30 && dateComponents.day < 365) {
        return [startDate psk_stringWithFormat:@"M月d日"];
    }
    //如果>=1d  && <30d
    if (dateComponents.day >= 1 && dateComponents.day < 30) {
        return [NSString stringWithFormat:@"%ld天前", (long)dateComponents.day];
    }
    //如果>=1h  && <24h
    if (dateComponents.hour >= 1 && dateComponents.hour < 24) {
        return [NSString stringWithFormat:@"%ld小时前", (long)dateComponents.hour];
    }
    //如果>=1m  && <60m
    if (dateComponents.minute >= 1 && dateComponents.minute < 60) {
        return [NSString stringWithFormat:@"%ld分钟前", (long)dateComponents.minute];
    }
    return @"刚刚";//1分钟以内
}
+ (NSString *)psk_timePassedByStartDate1:(NSDate *)startDate {
    if ([startDate psk_isThisYear]) {
        if ([startDate psk_isToday]) {
            return [NSString stringWithFormat:@"今天 %@", [startDate psk_stringWithFormat:kDateFormat13]];
        }
        else if ([startDate psk_isYesterday]) {
            return [NSString stringWithFormat:@"昨天 %@", [startDate psk_stringWithFormat:kDateFormat13]];
        }
        else if ([startDate psk_isBeforeYesterday]) {
            return [NSString stringWithFormat:@"前天 %@", [startDate psk_stringWithFormat:kDateFormat13]];
        }
        else {
            return [startDate psk_stringWithFormat:kDateFormat15];
        }
    }
    else {
        return [startDate psk_stringWithFormat:kDateFormat7];
    }
}
+ (NSString *)psk_timePassedByStartDate2:(NSDate *)startDate {
    NSDateComponents *dateComponents = [NSDate psk_componentsFromDate:startDate toDate:CURRENT_DATE];
    if (dateComponents.day > 0) {
        return [NSString stringWithFormat:@"%ld天 %02ld:%02ld:%02ld", (long)dateComponents.day,
                (long)dateComponents.hour, (long)dateComponents.minute, (long)dateComponents.second];
    }
    else if (dateComponents.hour > 0) {
        return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",
                (long)dateComponents.hour, (long)dateComponents.minute, (long)dateComponents.second];
    }
    else {
        return [NSString stringWithFormat:@"%02ld:%02ld", (long)dateComponents.minute, (long)dateComponents.second];
    }
}


#pragma mark - 计算两个时间点之间的距离
+ (NSDateComponents *)psk_componentsFromDate:(NSDate *)startDate toDate:(NSDate *)endDate {
    return [self psk_componentsFromDate:startDate
                                 toDate:endDate
                         withComponents:PSK_CalendarUnitDay | PSK_CalendarUnitHour | PSK_CalendarUnitMinute | PSK_CalendarUnitSecond];
}
+ (NSDateComponents *)psk_componentsFromDate:(NSDate *)startDate toDate:(NSDate *)endDate withComponents:(NSCalendarUnit)unitFlags {
    if ([startDate psk_isLaterThanDate:endDate]) {
        return nil;
    }
    return [[NSCalendar currentCalendar] components:unitFlags fromDate:startDate toDate:endDate options:0];
}
+ (NSDateComponents *)psk_componentsFromDate1:(NSDate *)startDate toDate:(NSDate *)endDate {
    if ([startDate psk_isLaterThanDate:endDate]) {
        return nil;
    }
    NSTimeInterval remainInterval = [endDate timeIntervalSinceDate:startDate];
    NSCalendarUnit unitFlags = PSK_CalendarUnitDay | PSK_CalendarUnitHour | PSK_CalendarUnitMinute | PSK_CalendarUnitSecond;
    NSDateComponents *components = [NSDateComponents new];
    components.year = 0;
    components.month = 0;
    components.day = 0;
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    
    //方法一：计算间隔时间是根据从零时间点(1970-01-01)开始的NSDate对象(效率最低！)
    //    NSDate *sinceDate = [NSDate dateFromString:@"1970-01-01" withFormat:@"yyyy-MM-dd"];
    //    NSDate *tempDate = [NSDate dateWithTimeInterval:remainTimeInterval sinceDate:sinceDate];//NOTE:dateWithTimeIntervalSince1970会有时差问题
    //    NSInteger day = [tempDate daysAfterDate:sinceDate];//NOTE:这里不能用tempDate.day
    //    NSInteger hour = tempDate.hour;
    //    NSInteger minute = tempDate.minute;
    //    NSInteger second = tempDate.seconds;
    
    //方法二：最直接的方法(效率最高！)
    NSInteger day = (NSInteger)(remainInterval / PSK_STD_DAY);
    NSInteger hour = (NSInteger)(remainInterval / PSK_STD_HOUR) - 24 * day;
    NSInteger minute = (NSInteger)(remainInterval / PSK_STD_MINUTE) - 60 * hour - 24 * 60 * day;
    NSInteger second = (NSInteger)remainInterval - 60 * minute - 60 * 60 * hour - 24 * 60 * 60 * day;
    
    //--------------------设置components START----------------------------------------
    
    //设置day
    if (PSK_CalendarUnitDay == (PSK_CalendarUnitDay & unitFlags)) {
        [components setDay:day];
    }
    else {
        [components setDay:0];
    }
    //设置hour
    if (PSK_CalendarUnitHour == (PSK_CalendarUnitHour & unitFlags)) {
        NSInteger tempHour = hour;
        if (PSK_CalendarUnitDay != (PSK_CalendarUnitDay & unitFlags)) {
            tempHour += 24 * day;
        }
        [components setHour:tempHour];
    }
    else {
        [components setHour:0];
    }
    //设置minute
    if (PSK_CalendarUnitMinute == (PSK_CalendarUnitMinute & unitFlags)) {
        NSInteger tempMinute = minute;
        if (PSK_CalendarUnitHour != (PSK_CalendarUnitHour & unitFlags)) {
            tempMinute += 60 * hour;
            if (PSK_CalendarUnitDay != (PSK_CalendarUnitDay & unitFlags)) {//只有当hour不存在，才有判断day的必要，下面类似
                tempMinute += 24 * 60 * day;
            }
        }
        [components setMinute:tempMinute];
    }
    else {
        [components setMinute:0];
    }
    //设置second
    if (PSK_CalendarUnitSecond == (PSK_CalendarUnitSecond & unitFlags)) {
        NSInteger tempSecond = second;
        if (PSK_CalendarUnitMinute != (PSK_CalendarUnitMinute & unitFlags)) {
            tempSecond += 60 * minute;
            if (PSK_CalendarUnitHour != (PSK_CalendarUnitHour & unitFlags)) {
                tempSecond += 60 * 60 * hour;
                if (PSK_CalendarUnitDay != (PSK_CalendarUnitDay & unitFlags)) {
                    tempSecond += 24 * 60 * 60 * day;
                }
            }
        }
        [components setSecond:tempSecond];
    }
    else {
        [components setSecond:0];
    }
    //--------------------设置components END----------------------------------------
    
    return components;
}

#pragma mark - Private Methods
/**
 * 以date为基准，计算前推或后移seconds秒后的date
 */
+ (NSDate *)_psk_dateWithSecondReference:(NSDate *)date second:(long)seconds {
    NSTimeInterval aTimeInterval = [date timeIntervalSinceReferenceDate] + seconds;
    return [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
}

@end
