//
//  NSDate+Additions.h
//  Additions
//
//  Created by Erica Sadun, http://ericasadun.com
//  iPhone Developer's Cookbook, 3.x and beyond
//  BSD License, Use at your own risk
//  FORMATED!
//

#define D_MINUTE    60
#define D_HOUR      (60 * D_MINUTE)
#define D_DAY       (24 * D_HOUR)
#define D_WEEK      (7 * D_DAY)
#define D_MONTH     (30 * D_DAY)
#define D_YEAR      31556926

@interface NSDate (Additions)

// Decomposing dates
@property (readonly) NSInteger nearestHour;
@property (readonly) NSInteger hour;
@property (readonly) NSInteger minute;
@property (readonly) NSInteger seconds;
@property (readonly) NSInteger day;
@property (readonly) NSInteger month;
@property (readonly) NSInteger week;
@property (readonly) NSInteger weekday;
@property (readonly) NSInteger nthWeekday; // e.g. 2nd Tuesday of the month == 2
@property (readonly) NSInteger year;

// Relative dates from the current date
+ (NSDate *)dateNow;
+ (NSDate *)dateTomorrow;
+ (NSDate *)dateYesterday;
+ (NSDate *)dateBeforeYesterday;
+ (NSDate *)dateWithDaysFromNow:(NSInteger)days;
+ (NSDate *)dateWithDaysBeforeNow:(NSInteger)days;
+ (NSDate *)dateWithHoursFromNow:(NSInteger)dHours;
+ (NSDate *)dateWithHoursBeforeNow:(NSInteger)dHours;
+ (NSDate *)dateWithMinutesFromNow:(NSInteger)dMinutes;
+ (NSDate *)dateWithMinutesBeforeNow:(NSInteger)dMinutes;

// convert to date
+ (NSDate *)dateFromTimeStamp:(NSString *)timeStamp;
+ (NSDate *)dateFromTimeInterval:(NSTimeInterval)timeInterval;
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;

// Comparing dates
- (BOOL)isEqualToDateIgnoringTime:(NSDate *)aDate;
- (BOOL)isToday;
- (BOOL)isTomorrow;
- (BOOL)isYesterday;
- (BOOL)isBeforeYesterday;
- (BOOL)isSameWeekAsDate:(NSDate *)aDate;
- (BOOL)isThisWeek;
- (BOOL)isNextWeek;
- (BOOL)isLastWeek;
- (BOOL)isSameYearAsDate:(NSDate *)aDate;
- (BOOL)isThisYear;
- (BOOL)isNextYear;
- (BOOL)isLastYear;
- (BOOL)isEarlierThanDate:(NSDate *)aDate;
- (BOOL)isLaterThanDate:(NSDate *)aDate;

// Adjusting dates
- (NSDate *)dateByAddingDays:(NSInteger)dDays;
- (NSDate *)dateBySubtractingDays:(NSInteger)dDays;
- (NSDate *)dateByAddingHours:(NSInteger)dHours;
- (NSDate *)dateBySubtractingHours:(NSInteger)dHours;
- (NSDate *)dateByAddingMinutes:(NSInteger)dMinutes;
- (NSDate *)dateBySubtractingMinutes:(NSInteger)dMinutes;
- (NSDate *)dateAtStartOfDay;

// Retrieving intervals
- (NSInteger)minutesAfterDate:(NSDate *)aDate;
- (NSInteger)minutesBeforeDate:(NSDate *)aDate;
- (NSInteger)hoursAfterDate:(NSDate *)aDate;
- (NSInteger)hoursBeforeDate:(NSDate *)aDate;
- (NSInteger)daysAfterDate:(NSDate *)aDate;
- (NSInteger)daysBeforeDate:(NSDate *)aDate;

// format the date to string
- (NSString *)chineseWeekDay;
- (NSString *)timeStamp;
- (NSString *)stringWithFormat:(NSString *)format;
- (NSString *)chineseMonth; //汉语月份
- (NSString *)constellation;//星座
+ (NSString *)StringFromTimeStamp:(NSString *)timeStamp withFormat:(NSString *)format;
+ (NSString *)ConvertDateString:(NSString *)dataString fromFormat:(NSString *)fromFormat toFormat:(NSString *)toFormat;

//计算两个时间点之间的距离（方法一）
//优势：可以自定义components
+ (NSDateComponents *)ComponentsBetweenStartDate:(NSDate *)startDate withEndDate:(NSDate *)endDate;
+ (NSDateComponents *)ComponentsBetweenStartDate:(NSDate *)startDate withEndDate:(NSDate *)endDate withComponents:(NSCalendarUnit)unitFlags;
//计算两个时间点之间的距离（方法二）
//缺陷：最多只能计算到天数
+ (NSDateComponents *)ComponentsBetweenStartDate1:(NSDate *)startDate withEndDate:(NSDate *)endDate;

//过去了多长时间 TODO:待优化
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
