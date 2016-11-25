//
//  NSDate+YSCKit.m
//  YSCKit
//
//  Created by Erica Sadun, http://ericasadun.com
//  iPhone Developer's Cookbook, 3.x and beyond
//  BSD License, Use at your own risk
/*
   #import <humor.h> : Not planning to implement: dateByAskingBoyOut and dateByGettingBabysitter
   ----
   General Thanks: sstreza, Scott Lawrence, Kevin Ballard, NoOneButMe, Avi`, August Joki. Emanuele Vulcano, jcromartiej
 */

#import "NSDate+YSCKit.h"
#import "YSCKitConstant.h"
#import "YSCKitMacro.h"
#define DATE_COMPONENTS (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)
#define CURRENT_CALENDAR [NSCalendar currentCalendar]

@implementation NSDate (YSCKit)


#pragma mark Decomposing Dates

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)nearestHour {
	NSTimeInterval aTimeInterval = [CURRENT_DATE timeIntervalSinceReferenceDate] + D_MINUTE * 30;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	NSDateComponents *components = [CURRENT_CALENDAR components:NSHourCalendarUnit fromDate:newDate];
	return [components hour];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)hour {
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return [components hour];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)minute {
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return [components minute];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)seconds {
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return [components second];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)day {
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return [components day];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)month {
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return [components month];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)week {
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return [components weekOfYear];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)weekday {
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return [components weekday];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)nthWeekday  // e.g. 2nd Tuesday of the month is 2
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return [components weekdayOrdinal];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)year {
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return [components year];
}

#pragma mark Relative Dates

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSDate *)dateWithDaysFromNow:(NSInteger)days {
	NSTimeInterval aTimeInterval = [CURRENT_DATE timeIntervalSinceReferenceDate] + D_DAY * days;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSDate *)dateWithDaysBeforeNow:(NSInteger)days {
	NSTimeInterval aTimeInterval = [CURRENT_DATE timeIntervalSinceReferenceDate] - D_DAY * days;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSDate *)dateNow {
    return CURRENT_DATE;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSDate *)dateTomorrow {
	return [NSDate dateWithDaysFromNow:1];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSDate *)dateYesterday {
	return [NSDate dateWithDaysBeforeNow:1];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSDate *)dateBeforeYesterday {
    return [NSDate dateWithDaysBeforeNow:2];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSDate *)dateWithHoursFromNow:(NSInteger)dHours {
	NSTimeInterval aTimeInterval = [CURRENT_DATE timeIntervalSinceReferenceDate] + D_HOUR * dHours;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSDate *)dateWithHoursBeforeNow:(NSInteger)dHours {
	NSTimeInterval aTimeInterval = [CURRENT_DATE timeIntervalSinceReferenceDate] - D_HOUR * dHours;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSDate *)dateWithMinutesFromNow:(NSInteger)dMinutes {
	NSTimeInterval aTimeInterval = [CURRENT_DATE timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSDate *)dateWithMinutesBeforeNow:(NSInteger)dMinutes {
	NSTimeInterval aTimeInterval = [CURRENT_DATE timeIntervalSinceReferenceDate] - D_MINUTE * dMinutes;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}


#pragma mark convert to date
+ (NSDate *)dateFromTimeStamp:(NSString *)timeStamp {
	return [self dateFromTimeInterval:[timeStamp longLongValue]];
}

+ (NSDate *)dateFromTimeInterval:(NSTimeInterval)timeInterval {
    if (timeInterval > 1000000000.0f * 1000.0f) {//判断单位是秒还是毫秒
        timeInterval = timeInterval / 1000.0f;
    }
	return [NSDate dateWithTimeIntervalSince1970:timeInterval];
}

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:format];
	return [dateFormatter dateFromString:string];
}

#pragma mark Comparing Dates

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isEqualToDateIgnoringTime:(NSDate *)aDate {
	NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
	return (([components1 year] == [components2 year]) &&
	        ([components1 month] == [components2 month]) &&
	        ([components1 day] == [components2 day]));
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isToday {
	return [self isEqualToDateIgnoringTime:CURRENT_DATE];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isTomorrow {
	return [self isEqualToDateIgnoringTime:[NSDate dateTomorrow]];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isYesterday {
	return [self isEqualToDateIgnoringTime:[NSDate dateYesterday]];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isBeforeYesterday {
    return [self isEqualToDateIgnoringTime:[NSDate dateBeforeYesterday]];
}

// This hard codes the assumption that a week is 7 days
///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isSameWeekAsDate:(NSDate *)aDate {
	NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];

	// Must be same week. 12/31 and 1/1 will both be week "1" if they are in the same week
	if ([components1 weekOfYear] != [components2 weekOfYear]) return NO;

	// Must have a time interval under 1 week. Thanks @aclark
	return (fabs([self timeIntervalSinceDate:aDate]) < D_WEEK);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isThisWeek {
	return [self isSameWeekAsDate:CURRENT_DATE];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isNextWeek {
	NSTimeInterval aTimeInterval = [CURRENT_DATE timeIntervalSinceReferenceDate] + D_WEEK;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return [self isSameWeekAsDate:newDate];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isLastWeek {
	NSTimeInterval aTimeInterval = [CURRENT_DATE timeIntervalSinceReferenceDate] - D_WEEK;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return [self isSameWeekAsDate:newDate];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isSameYearAsDate:(NSDate *)aDate {
	NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:aDate];
	return ([components1 year] == [components2 year]);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isThisYear {
    return [self isSameYearAsDate:CURRENT_DATE];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isNextYear {
	NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:CURRENT_DATE];

	return ([components1 year] == ([components2 year] + 1));
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isLastYear {
	NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:CURRENT_DATE];

	return ([components1 year] == ([components2 year] - 1));
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isEarlierThanDate:(NSDate *)aDate {
	return ([self earlierDate:aDate] == self);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isLaterThanDate:(NSDate *)aDate {
	return ([self laterDate:aDate] == self);
}

#pragma mark Adjusting Dates

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSDate *)dateByAddingDays:(NSInteger)dDays {
	NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_DAY * dDays;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSDate *)dateBySubtractingDays:(NSInteger)dDays {
	return [self dateByAddingDays:(dDays * -1)];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSDate *)dateByAddingHours:(NSInteger)dHours {
	NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_HOUR * dHours;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSDate *)dateBySubtractingHours:(NSInteger)dHours {
	return [self dateByAddingHours:(dHours * -1)];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSDate *)dateByAddingMinutes:(NSInteger)dMinutes {
	NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSDate *)dateBySubtractingMinutes:(NSInteger)dMinutes {
	return [self dateByAddingMinutes:(dMinutes * -1)];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSDate *)dateAtStartOfDay {
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	[components setHour:0];
	[components setMinute:0];
	[components setSecond:0];
	return [CURRENT_CALENDAR dateFromComponents:components];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSDateComponents *)componentsWithOffsetFromDate:(NSDate *)aDate {
	NSDateComponents *dTime = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate toDate:self options:0];
	return dTime;
}

#pragma mark Retrieving Intervals

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)minutesAfterDate:(NSDate *)aDate {
	NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
	return (NSInteger)(ti / D_MINUTE);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)minutesBeforeDate:(NSDate *)aDate {
	NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
	return (NSInteger)(ti / D_MINUTE);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)hoursAfterDate:(NSDate *)aDate {
	NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
	return (NSInteger)(ti / D_HOUR);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)hoursBeforeDate:(NSDate *)aDate {
	NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
	return (NSInteger)(ti / D_HOUR);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)daysAfterDate:(NSDate *)aDate {
	NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
	return (NSInteger)(ti / D_DAY);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)daysBeforeDate:(NSDate *)aDate {
	NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
	return (NSInteger)(ti / D_DAY);
}


#pragma mark - format the date to string
- (NSString *)chineseWeekDay {
    NSString *weekDay = @"星期一";
    NSInteger day = self.weekday;
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
///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)timeStamp {
    return [NSString stringWithFormat:@"%.0f", [self timeIntervalSince1970]];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)stringWithFormat:(NSString *)format {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:format];
	return [dateFormatter stringFromDate:self];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)chineseMonth {
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

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)constellation {
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
	/*
	   摩羯座 12月22日------1月19日
	   水瓶座 1月20日-------2月18日
	   双鱼座 2月19日-------3月20日
	   白羊座 3月21日-------4月19日
	   金牛座 4月20日-------5月20日
	   双子座 5月21日-------6月21日
	   巨蟹座 6月22日-------7月22日
	   狮子座 7月23日-------8月22日
	   处女座 8月23日-------9月22日
	   天秤座 9月23日------10月23日
	   天蝎座 10月24日-----11月21日
	   射手座 11月22日-----12月21日
	 */
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

+ (NSString *)StringFromTimeStamp:(NSString *)timeStamp withFormat:(NSString *)format {
    return [[self dateFromTimeStamp:timeStamp] stringWithFormat:format];
}

+ (NSString *)ConvertDateString:(NSString *)dataString fromFormat:(NSString *)fromFormat toFormat:(NSString *)toFormat {
    NSDate *date = [NSDate dateFromString:dataString withFormat:fromFormat];
    return [date stringWithFormat:toFormat];
}

//计算两个时间点之间的距离（方法一）
//优势：可以自定义components
+ (NSDateComponents *)ComponentsBetweenStartDate:(NSDate *)startDate withEndDate:(NSDate *)endDate {
    return [self ComponentsBetweenStartDate:startDate
                                withEndDate:endDate
                             withComponents:NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond];
}
+ (NSDateComponents *)ComponentsBetweenStartDate:(NSDate *)startDate withEndDate:(NSDate *)endDate withComponents:(NSCalendarUnit)unitFlags {
    if ([startDate isLaterThanDate:endDate]) {
        return nil;
    }
    return [[NSCalendar currentCalendar] components:unitFlags fromDate:startDate toDate:endDate options:0];
}

//计算两个时间点之间的距离（方法二）
//缺陷：最多只能计算到天数
+ (NSDateComponents *)ComponentsBetweenStartDate1:(NSDate *)startDate withEndDate:(NSDate *)endDate {
    if ([startDate isLaterThanDate:endDate]) {
        return nil;
    }
    return [self ComponentsRemainInterval:[endDate timeIntervalSinceDate:startDate]];
}
+ (NSDateComponents *)ComponentsRemainInterval:(NSTimeInterval)remainInterval {
    NSCalendarUnit unitFlags = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
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
    NSInteger day = (NSInteger)(remainInterval / D_DAY);
    NSInteger hour = (NSInteger)(remainInterval / D_HOUR) - 24 * day;
    NSInteger minute = (NSInteger)(remainInterval / D_MINUTE) - 60 * hour - 24 * 60 * day;
    NSInteger second = (NSInteger)remainInterval - 60 * minute - 60 * 60 * hour - 24 * 60 * 60 * day;
    
    //--------------------设置components START----------------------------------------
    
    //设置day
    if (NSDayCalendarUnit == (NSDayCalendarUnit & unitFlags)) {
        [components setDay:day];
    }
    else {
        [components setDay:0];
    }
    //设置hour
    if (NSHourCalendarUnit == (NSHourCalendarUnit & unitFlags)) {
        NSInteger tempHour = hour;
        if (NSDayCalendarUnit != (NSDayCalendarUnit & unitFlags)) {
            tempHour += 24 * day;
        }
        [components setHour:tempHour];
    }
    else {
        [components setHour:0];
    }
    //设置minute
    if (NSMinuteCalendarUnit == (NSMinuteCalendarUnit & unitFlags)) {
        NSInteger tempMinute = minute;
        if (NSHourCalendarUnit != (NSHourCalendarUnit & unitFlags)) {
            tempMinute += 60 * hour;
            if (NSDayCalendarUnit != (NSDayCalendarUnit & unitFlags)) {//只有当hour不存在，才有判断day的必要，下面类似
                tempMinute += 24 * 60 * day;
            }
        }
        [components setMinute:tempMinute];
    }
    else {
        [components setMinute:0];
    }
    //设置second
    if (NSSecondCalendarUnit == (NSSecondCalendarUnit & unitFlags)) {
        NSInteger tempSecond = second;
        if (NSMinuteCalendarUnit != (NSMinuteCalendarUnit & unitFlags)) {
            tempSecond += 60 * minute;
            if (NSHourCalendarUnit != (NSHourCalendarUnit & unitFlags)) {
                tempSecond += 60 * 60 * hour;
                if (NSDayCalendarUnit != (NSDayCalendarUnit & unitFlags)) {
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


#pragma mark - 过去了多长时间
/**
 *  1. 如果>=0s  && <60s  返回   '刚刚'
 *  2. 如果>=1m  && <60m  返回   'x分钟前'
 *  3. 如果>=1h  && <24h  返回   'x小时之前'
 *  4. 如果>=1d  && <30d  返回   'x天之前'
 *  5. 如果>=30d && <365d 返回   'M月d日'
 *  6. 如果>=365d         返回   'yyyy年M月d日'
 */
+ (NSString *)TimePassedByStartDate:(NSDate *)startDate {
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(startDate);
    return [self TimePassedByStartTimeStamp:startDate.timeStamp];
}
+ (NSString *)TimePassedByStartTimeStamp:(NSString *)timeStamp {
    NSDate *startDate= [NSDate dateFromTimeStamp:timeStamp];
    NSDate *endDate = CURRENT_DATE;
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(startDate);
    //异常时间处理
    if ([startDate isLaterThanDate:endDate]) {
        return [startDate stringWithFormat:kDateFormat1];
    }
    NSDateComponents *dateComponents = [NSDate ComponentsBetweenStartDate1:startDate withEndDate:endDate];
    //如果>=365d
    if (dateComponents.day >= 365) {
        return [startDate stringWithFormat:kDateFormat5];
    }
    //如果>=30d && <365d
    if (dateComponents.day >= 30 && dateComponents.day < 365) {
        return [startDate stringWithFormat:@"M月d日"];
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
/**
 * 1. 如果不是今年   返回 yyyy年M月d日 HH:mm
 * 2. 如果是今天     返回 今天 HH:mm
 * 3. 如果是昨天     返回 昨天 HH:mm
 * 4. 如果是前天     返回 前天 HH:mm
 * 5. 如果是前天以前  返回 M月d日 HH:mm
 **/
+ (NSString *)TimePassedByStartDate1:(NSDate *)startDate {
    if ([startDate isThisYear]) {
        if ([startDate isToday]) {
            return [NSString stringWithFormat:@"今天 %@", [startDate stringWithFormat:kDateFormat13]];
        }
        else if ([startDate isYesterday]) {
            return [NSString stringWithFormat:@"昨天 %@", [startDate stringWithFormat:kDateFormat13]];
        }
        else if ([startDate isBeforeYesterday]) {
            return [NSString stringWithFormat:@"前天 %@", [startDate stringWithFormat:kDateFormat13]];
        }
        else {
            return [startDate stringWithFormat:kDateFormat15];
        }
    }
    else {
        return [startDate stringWithFormat:kDateFormat7];
    }
}

/**
 * 返回 xx天 xx:xx:xx 计时器
 **/
+ (NSString *)TimePassedByStartDate2:(NSDate *)startDate {
    NSDateComponents *dateComponents = [NSDate ComponentsBetweenStartDate:startDate withEndDate:CURRENT_DATE];
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
/**
 * 返回 xx天xx小时xx分钟
 **/
+ (NSString *)TimePassedByStartDate3:(NSDate *)startDate {
    return [self TimePassedByStartDate3:startDate flag:NO];
}
+ (NSString *)TimePassedByStartDate3:(NSDate *)startDate flag:(BOOL)flag {
    NSDate *endDate = CURRENT_DATE;
    //异常时间处理
    if ([startDate isLaterThanDate:endDate]) {
        return @"开始时间有误";
    }
    
    NSDateComponents *dateComponents = [NSDate ComponentsBetweenStartDate1:startDate withEndDate:endDate];
    //如果>=365d
    if (dateComponents.day >= 365) {
        return @"超过1年";
    }
    else {
        NSMutableString *timePassed = [NSMutableString string];
        if (dateComponents.day > 0) {
            [timePassed appendFormat:@"%ld天", dateComponents.day];
            if (flag && dateComponents.hour > 0) {
                [timePassed appendFormat:@"%ld小时", dateComponents.hour];
            }
            return timePassed;
        }
        if (dateComponents.hour > 0) {
            [timePassed appendFormat:@"%ld小时", dateComponents.hour];
            if (flag && dateComponents.minute > 0) {
                [timePassed appendFormat:@"%ld分钟", dateComponents.minute];
            }
            return timePassed;
        }
        if (dateComponents.minute > 0) {
            [timePassed appendFormat:@"%ld分钟", dateComponents.minute];
            return timePassed;
        }
        return @"少于1分钟";
    }
}

#pragma mark - 还剩多长时间
+ (NSString *)TimeRemainByEndDate:(NSDate *)endDate {
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(endDate);
    return [self TimeRemainByEndTimeStamp:endDate.timeStamp];
}
+ (NSString *)TimeRemainByEndTimeStamp:(NSString *)timeStamp {
    NSDate *startDate = CURRENT_DATE;
    NSDate *endDate = [NSDate dateFromTimeStamp:timeStamp];
    RETURN_EMPTY_WHEN_OBJECT_IS_EMPTY(endDate);
    //异常时间处理
    if ([startDate isLaterThanDate:endDate]) {
        return @"过时";
    }
    NSDateComponents *dateComponents = [NSDate ComponentsBetweenStartDate:startDate withEndDate:endDate withComponents:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond];
    if (dateComponents.year >= 1) {
        return [NSString stringWithFormat:@"还剩%ld年", (long)dateComponents.year];
    }
    if (dateComponents.month >= 1) {
        return [NSString stringWithFormat:@"还剩%ld个月", (long)dateComponents.month];
    }
    if (dateComponents.day >= 1) {
        return [NSString stringWithFormat:@"还剩%ld天", (long)dateComponents.day];
    }
    if (dateComponents.hour >= 1) {
        return [NSString stringWithFormat:@"还剩%ld小时", (long)dateComponents.hour];
    }
    if (dateComponents.minute >= 1) {
        return [NSString stringWithFormat:@"还剩%ld分钟", (long)dateComponents.minute];
    }
    if (dateComponents.second >= 1) {
        return [NSString stringWithFormat:@"还剩%ld秒", (long)dateComponents.second];
    }
    return @"过时";
}
@end
