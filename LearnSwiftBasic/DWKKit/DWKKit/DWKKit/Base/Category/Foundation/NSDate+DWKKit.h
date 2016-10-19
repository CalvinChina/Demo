//
//  NSDate+DWKKit.h
//  DWKKit
//
//  Created by pisen on 16/10/13.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

#import <Foundation/Foundation.h>

#define D_MINUTE    60
#define D_HOUR      (60 * D_MINUTE)
#define D_DAY       (24 * D_HUOR)
#define D_WEEK      (7 * D_DAY)
#define D_MONTH     (30 * D_DAY)
#define D_YEAR      31556926

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


@interface NSDate (DWKKit)

@property (readonly) NSInteger nearestHour;
@property (readonly) NSInteger hour;
@property (readonly) NSInteger minute;
@property (readonly) NSInteger seconds;
@property (readonly) NSInteger day;
@property (readonly) NSInteger month;
@property (readonly) NSInteger week;
@property (readonly) NSInteger weekDay;
@property (readonly) NSInteger nthWeekday;
@property (readonly) NSInteger year;

+ (NSDate *)dateNow;
+ (NSDate *)dateTomorrow;
+ (NSDate *)dateYesterday;
+ (NSDate *)dateBeforeYesterday;
+ (NSDate *)dateWithDaysFromNow:(NSInteger)days;
+ (NSDate *)dateWithDaysBeforeNow:(NSInteger)days;
+ (NSDate *)dateWithHoursFromNow:(NSInteger)hours;
+ (NSDate *)dateWithHoursBeforeNow:(NSInteger)hours;
+ (NSDate *)dateWithMinutesFromNow:(NSInteger)minutes;
+ (NSDate *)dateWithMinutesBeforeNow:(NSInteger)minutes;

+ (NSDate *)dateFromTimeStamp:(NSString*)timeStamp;
+ (NSDate *)dateFromTimeInterval:(NSTimeInterval)timeInterval;
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;

// Comparing dates
- (BOOL)isEqualToDateIgnoringTime:(NSDate *)otherDate;
- (BOOL)isToday;
- (BOOL)isTomorow;
- (BOOL)isYesterday;
- (BOOL)isBeforeYesterday;
- (BOOL)isSameWeekAsDate:(NSDate *)adate;
- (BOOL)isThisWeek;
- (BOOL)isNextWeek;
- (BOOL)isLastWeek;
- (BOOL)isSameYearAsDate:(NSDate *)adate;
- (BOOL)isThisYear;
- (BOOL)isNextYear;
- (BOOL)isLastYear;
- (BOOL)isEarlierThanDate:(NSDate *)aDate;
- (BOOL)isLaterThanDate:(NSDate *)aDate;

- (NSDate *)dateByAddingDays:(NSInteger)dDays;
- (NSDate *)dateBySubtractingDays:(NSInteger)dDays;
- (NSDate *)dateByAddingHours:(NSInteger)dHours;
- (NSDate *)dateBySubtractingHours:(NSInteger)dHours;
- (NSDate *)dateByAddingMinutes:(NSInteger)dMinutes;
- (NSDate *)dateBySubtractingMinutes:(NSInteger)minutes;
- (NSDate *)dateAtStartOfDay;

- (NSInteger)minutesAfterDate:(NSDate *)aDate;
- (NSInteger)minutesBeforeDate:(NSDate *)aDate;
- (NSInteger)hoursAfterDate:(NSDate *)aDate;
- (NSInteger)hoursBeforeDate:(NSDate *)aDate;
- (NSInteger)daysAfterDate:(NSDate *)aDate;
- (NSInteger)daysBoforeDate:(NSDate *)aDate;

- (NSString *)chineseWeekDay;
- (NSString *)timeStamp;
- (NSString *)stringWithFormat:(NSString *)format;
- (NSString *)chineseMonth;
- (NSString *)constellation;

+ (NSString *)stingFromTimeStamp:(NSString *)timeStamp withFormat:(NSString *)format;
+ (NSString *)ConvertDateString:(NSString *)dataString fromFormat:(NSString *)fromFormat toFormat:(NSString *)toFormat;
//计算两个时间点之间的距离（方法一）
//优势：可以自定义components
+ (NSDateComponents *) ComponentsBetweenStartDate:(NSDate *)startDate WithEndDate:(NSDate *)endDate;
+ (NSDateComponents *) ComponentsBetweenStartDate:(NSDate *)startDate WithEndDate:(NSDate *)endDate withComponents:(NSCalendarUnit)unitFlags;
//计算两个时间点之间的距离（方法二）
//缺陷：最多只能计算到天数
+ (NSDateComponents *)ComponentsBetweenStartDate1:(NSDate *)startDate withEndDate:(NSDate *)endDate;


//过去了多长时间
+ (NSString *)TimePassedByStartDate:(NSDate *)startDate;
+ (NSString *)TimePassedByStartTimeStamp:(NSString *)timeStamp;
+ (NSString *)TimePassedByStartDate1:(NSDate *)startDate;
+ (NSString *)TimePassedByStartDate2:(NSDate *)startDate;
+ (NSString *)TimePassedByStartDate3:(NSDate *)startDate;
+ (NSString *)TimePassedByStartDate3:(NSDate *)startDate flag:(BOOL)flag;

//还剩多长时间
+ (NSString *)TimeRemainByEndDate:(NSDate *)endDate;
+ (NSString *)TimeRemainByEndTimeStamp:(NSString *)timeStamp;
@end
