//
//  NSDate+PisenKit.h
//  PisenKit
//
//  Created by 杨胜超 on 16/6/30.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#ifndef CURRENT_DATE
    #define CURRENT_DATE    [NSDate date]
#endif

//定义日期格式字符串
static NSString * const kDateFormat1     = @"yyyy-MM-dd HH:mm:ss";
static NSString * const kDateFormat2     = @"yyyy.MM.dd HH:mm";
static NSString * const kDateFormat3     = @"yyyy-MM-dd";
static NSString * const kDateFormat4     = @"yyyy.MM.dd";
static NSString * const kDateFormat5     = @"yyyy年M月d日";
static NSString * const kDateFormat6     = @"yyyy-MM-dd HH:mm";
static NSString * const kDateFormat7     = @"yyyy年M月d日 HH:mm";
static NSString * const kDateFormat8     = @"M月d日";
static NSString * const kDateFormat9     = @"yyyy年M月";
static NSString * const kDateFormat10    = @"yyyy-MM-dd ccc HH:mm";  //2015-12-24 周四 11:32
static NSString * const kDateFormat11    = @"yyyy-MM-dd cccc HH:mm"; //2015-12-24 星期四 11:32
static NSString * const kDateFormat12    = @"yyyy年M月d日 HH:mm:ss";
static NSString * const kDateFormat13    = @"HH:mm";
static NSString * const kDateFormat14    = @"MM月dd日 HH:mm";
static NSString * const kDateFormat15    = @"M月d日 HH:mm";
static NSString * const kDateFormat16    = @"MM-dd";
static NSString * const kDateFormat17    = @"M-d";


//==============================================================================
//
//  常用方法
//
//==============================================================================
@interface NSDate (PisenKit)

#pragma mark - Decomposing dates
@property (readonly) NSInteger psk_hour;
@property (readonly) NSInteger psk_minute;
@property (readonly) NSInteger psk_seconds;
@property (readonly) NSInteger psk_day;
@property (readonly) NSInteger psk_month;
@property (readonly) NSInteger psk_weekday;
@property (readonly) NSInteger psk_weekOfYear;
@property (readonly) NSInteger psk_nthWeekday; // e.g. 2nd Tuesday of the month == 2
@property (readonly) NSInteger psk_year;

#pragma mark - Relative dates from the current date
+ (NSDate *)psk_dateNow;
+ (NSDate *)psk_dateTomorrow;
+ (NSDate *)psk_dateYesterday;
+ (NSDate *)psk_dateAfterTomorrow;
+ (NSDate *)psk_dateBeforeYesterday;
+ (NSDate *)psk_dateFromNowAfterDays:(NSInteger)days;
+ (NSDate *)psk_dateFromNowBeforeDays:(NSInteger)days;
+ (NSDate *)psk_dateFromNowAfterHours:(NSInteger)hours;
+ (NSDate *)psk_dateFromNowBeforeHours:(NSInteger)hours;
+ (NSDate *)psk_dateFromNowAfterMinutes:(NSInteger)minutes;
+ (NSDate *)psk_dateFromNowBeforeMinutes:(NSInteger)minutes;

#pragma mark - Convert with format
+ (NSDate *)psk_dateFromTimeStamp:(NSString *)timeStamp;
+ (NSDate *)psk_dateFromTimeInterval:(NSTimeInterval)timeInterval;
+ (NSDate *)psk_dateFromString:(NSString *)string withFormat:(NSString *)format;
/** 日期字符串转换 */
+ (NSString *)psk_stringFromTimeStamp:(NSString *)timeStamp withFormat:(NSString *)format;
+ (NSString *)psk_convertDateString:(NSString *)dataString fromFormat:(NSString *)fromFormat toFormat:(NSString *)toFormat;
/** 将data对象格式化成字符串 */
- (NSString *)psk_stringWithFormat:(NSString *)format;

#pragma mark - Comparing dates
- (BOOL)psk_isEqualToDateIgnoringTime:(NSDate *)date;
- (BOOL)psk_isToday;
- (BOOL)psk_isTomorrow;
- (BOOL)psk_isYesterday;
- (BOOL)psk_isAfterTomorrow;
- (BOOL)psk_isBeforeYesterday;
- (BOOL)psk_isSameWeekAsDate:(NSDate *)date;
- (BOOL)psk_isThisWeek;
- (BOOL)psk_isNextWeek;
- (BOOL)psk_isLastWeek;
- (BOOL)psk_isSameYearAsDate:(NSDate *)date;
- (BOOL)psk_isThisYear;
- (BOOL)psk_isNextYear;
- (BOOL)psk_isLastYear;
- (BOOL)psk_isEarlierThanDate:(NSDate *)date;
- (BOOL)psk_isLaterThanDate:(NSDate *)date;

#pragma mark - Adjusting dates
- (NSDate *)psk_dateAfterDays:(NSInteger)days;
- (NSDate *)psk_dateBeforeDays:(NSInteger)days;
- (NSDate *)psk_dateAfterHours:(NSInteger)hours;
- (NSDate *)psk_dateBeforeHours:(NSInteger)hours;
- (NSDate *)psk_dateAfterMinutes:(NSInteger)minutes;
- (NSDate *)psk_dateBeforeMinutes:(NSInteger)minutes;
/** 返回当前日期的起始时刻 00:00:00 */
- (NSDate *)psk_dateAtStartOfDay;

#pragma mark - Retrieving intervals
- (NSInteger)psk_minutesAfterDate:(NSDate *)date;
- (NSInteger)psk_minutesBeforeDate:(NSDate *)date;
- (NSInteger)psk_hoursAfterDate:(NSDate *)date;
- (NSInteger)psk_hoursBeforeDate:(NSDate *)date;
- (NSInteger)psk_daysAfterDate:(NSDate *)date;
- (NSInteger)psk_daysBeforeDate:(NSDate *)date;

/** 返回 星期一...星期日 */
- (NSString *)psk_chineseWeekDay;
/** 返回从 1970-01-01 00:00:00 以来的秒数 */
- (NSString *)psk_timeStamp;
/**
 * 汉语月份 
 */
- (NSString *)psk_chineseMonth;
/**
 * 计算星座
 *  摩羯座 12月22日------1月19日
 *  水瓶座 1月20日-------2月18日
 *  双鱼座 2月19日-------3月20日
 *  白羊座 3月21日-------4月19日
 *  金牛座 4月20日-------5月20日
 *  双子座 5月21日-------6月21日
 *  巨蟹座 6月22日-------7月22日
 *  狮子座 7月23日-------8月22日
 *  处女座 8月23日-------9月22日
 *  天秤座 9月23日------10月23日
 *  天蝎座 10月24日-----11月21日
 *  射手座 11月22日-----12月21日
 */
- (NSString *)psk_constellation;

#pragma mark - 过去了多长时间
/**
 *  1. 如果>=0s  && <60s  返回   '刚刚'
 *  2. 如果>=1m  && <60m  返回   'x分钟前'
 *  3. 如果>=1h  && <24h  返回   'x小时前'
 *  4. 如果>=1d  && <30d  返回   'x天前'
 *  5. 如果>=30d && <365d 返回   'M月d日'
 *  6. 如果>=365d         返回   'yyyy年M月d日'
 */
+ (NSString *)psk_timePassedByStartTimeStamp:(NSString *)timeStamp;
+ (NSString *)psk_timePassedByStartDate:(NSDate *)startDate;
/**
 * 1. 如果不是今年   返回 yyyy年M月d日 HH:mm
 * 2. 如果是今天     返回 今天 HH:mm
 * 3. 如果是昨天     返回 昨天 HH:mm
 * 4. 如果是前天     返回 前天 HH:mm
 * 5. 其它          返回 M月d日 HH:mm
 */
+ (NSString *)psk_timePassedByStartDate1:(NSDate *)startDate;
/**
 * 返回 'dd天 HH:mm:ss' 或 'HH:mm:ss' 或 'mm:ss'
 */
+ (NSString *)psk_timePassedByStartDate2:(NSDate *)startDate;

#pragma mark - 计算两个时间点之间的距离
/**
 * 计算两个时间点之间的距离（方法一）
 * 优势：可以自定义components
 */
+ (NSDateComponents *)psk_componentsFromDate:(NSDate *)startDate toDate:(NSDate *)endDate;
+ (NSDateComponents *)psk_componentsFromDate:(NSDate *)startDate toDate:(NSDate *)endDate withComponents:(NSCalendarUnit)unitFlags;
/**
 * 计算两个时间点之间的距离（方法二）
 * 缺陷：只能计算出时间间距的天数、小时数、分钟数、秒数，不能计算出年数和月数
 */
+ (NSDateComponents *)psk_componentsFromDate1:(NSDate *)startDate toDate:(NSDate *)endDate;
@end
