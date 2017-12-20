//
//  NSDate+SZKit.m
//  SZKitDemo
//
//  Created by StenpZ on 2017/12/20.
//  Copyright © 2017年 StenpZ. All rights reserved.
//

#import "NSDate+SZKit.h"

#define D_MINUTE    60
#define D_HOUR      3600
#define D_DAY       86400
#define D_WEEK      604800
#define D_YEAR      31556926

#define CURRENT_CALENDAR [NSCalendar currentCalendar]
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
#define DATE_COMPONENTS (NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfYear | NSCalendarUnitWeekOfMonth | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal)
#else
#define DATE_COMPONENTS (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)
#endif

@implementation NSDate (SZKit)


#pragma mark - # 基本时间参数
- (NSUInteger)year {
    NSCalendar *calendar = [NSCalendar currentCalendar];
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitYear) fromDate:self];
#else
    NSDateComponents *dayComponents = [calendar components:(NSYearCalendarUnit) fromDate:self];
#endif
    return [dayComponents year];
}

- (NSUInteger)month {
    NSCalendar *calendar = [NSCalendar currentCalendar];
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitMonth) fromDate:self];
#else
    NSDateComponents *dayComponents = [calendar components:(NSMonthCalendarUnit) fromDate:self];
#endif
    return [dayComponents month];
}

- (NSUInteger)day {
    NSCalendar *calendar = [NSCalendar currentCalendar];
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitDay) fromDate:self];
#else
    NSDateComponents *dayComponents = [calendar components:(NSDayCalendarUnit) fromDate:self];
#endif
    return [dayComponents day];
}


- (NSUInteger)hour {
    NSCalendar *calendar = [NSCalendar currentCalendar];
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitHour) fromDate:self];
#else
    NSDateComponents *dayComponents = [calendar components:(NSHourCalendarUnit) fromDate:self];
#endif
    return [dayComponents hour];
}

- (NSUInteger)minute {
    NSCalendar *calendar = [NSCalendar currentCalendar];
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitMinute) fromDate:self];
#else
    NSDateComponents *dayComponents = [calendar components:(NSMinuteCalendarUnit) fromDate:self];
#endif
    return [dayComponents minute];
}

- (NSUInteger)second {
    NSCalendar *calendar = [NSCalendar currentCalendar];
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitSecond) fromDate:self];
#else
    NSDateComponents *dayComponents = [calendar components:(NSSecondCalendarUnit) fromDate:self];
#endif
    return [dayComponents second];
}

- (NSUInteger)weekday
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday) fromDate:self];
    NSInteger weekday = [comps weekday] - 1;
    weekday = weekday == 0 ? 7 : weekday;
    return weekday;
}

- (NSUInteger)dayInMonth
{
    switch (self.month) {
        case 1: case 3: case 5: case 7: case 8: case 10: case 12:
            return 31;
        case 2:
            return self.isLeapYear ? 29 : 28;
    }
    return 30;
}

- (BOOL)isLeapYear {
    if ((self.year % 4  == 0 && self.year % 100 != 0) || self.year % 400 == 0) {
        return YES;
    }
    return NO;
}

#pragma mark - # 日期格式化
/// YYYY年MM月dd日
- (NSString *)formatYMD
{
    return [NSString stringWithFormat:@"%lu年%02lu月%02lu日", (unsigned long)self.year, (unsigned long)self.month, (unsigned long)self.day];
}

/// 自定义分隔符
- (NSString *)formatYMDWithSeparate:(NSString *)separate
{
    return [NSString stringWithFormat:@"%lu%@%02lu%@%02lu", (unsigned long)self.year, separate, (unsigned long)self.month, separate, (unsigned long)self.day];
}

/// MM月dd日
- (NSString *)formatMD
{
    return [NSString stringWithFormat:@"%02lu月%02lu日", (unsigned long)self.month, (unsigned long)self.day];
}

/// 自定义分隔符
- (NSString *)formatMDWithSeparate:(NSString *)separate
{
    return [NSString stringWithFormat:@"%02lu%@%02lu", (unsigned long)self.month, separate, (unsigned long)self.day];
}

/// HH:MM:SS
- (NSString *)formatHMS
{
    return [NSString stringWithFormat:@"%02lu:%02lu:%02lu", (unsigned long)self.hour, (unsigned long)self.minute, (unsigned long)self.second];
}

/// HH:MM
- (NSString *)formatHM
{
    return [NSString stringWithFormat:@"%02lu:%02lu", (unsigned long)self.hour, (unsigned long)self.minute];
}

/// 星期几
- (NSString *)formatWeekday
{
    switch([self weekday]) {
        case 1:
            return NSLocalizedString(@"星期一", nil);
        case 2:
            return NSLocalizedString(@"星期二", nil);
        case 3:
            return NSLocalizedString(@"星期三", nil);
        case 4:
            return NSLocalizedString(@"星期四", nil);
        case 5:
            return NSLocalizedString(@"星期五", nil);
        case 6:
            return NSLocalizedString(@"星期六", nil);
        case 7:
            return NSLocalizedString(@"星期天", nil);
        default:
            break;
    }
    return @"";
}

/// 月份
- (NSString *)formatMonth {
    switch(self.month) {
        case 1:
            return NSLocalizedString(@"一月", nil);
        case 2:
            return NSLocalizedString(@"二月", nil);
        case 3:
            return NSLocalizedString(@"三月", nil);
        case 4:
            return NSLocalizedString(@"四月", nil);
        case 5:
            return NSLocalizedString(@"五月", nil);
        case 6:
            return NSLocalizedString(@"六月", nil);
        case 7:
            return NSLocalizedString(@"七月", nil);
        case 8:
            return NSLocalizedString(@"八月", nil);
        case 9:
            return NSLocalizedString(@"九月", nil);
        case 10:
            return NSLocalizedString(@"十月", nil);
        case 11:
            return NSLocalizedString(@"十一月", nil);
        case 12:
            return NSLocalizedString(@"十二月", nil);
        default:
            break;
    }
    return @"";
}

- (NSString *)formatWithFormatter:(NSString *)formatter {
    NSDateFormatter *format = [NSDateFormatter new];
    format.dateFormat = formatter;
    return [format stringFromDate:self];
}


#pragma mark - # 日期关系
- (BOOL)isSameDay: (NSDate *) date
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:date];
    return ((components1.year == components2.year) &&
            (components1.month == components2.month) &&
            (components1.day == components2.day));
}
- (BOOL)isToday
{
    return [self isSameDay:[NSDate date]];
}
- (BOOL)isTomorrow
{
    return [self isSameDay:[NSDate dateTomorrow]];
}
- (BOOL)isYesterday
{
    return [self isSameDay:[NSDate dateYesterday]];
}

- (BOOL)isSameWeekAsDate: (NSDate *) date
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:date];
    if (components1.weekOfYear != components2.weekOfYear)
        return NO;
    return (fabs([self timeIntervalSinceDate:date]) < D_WEEK);
}
- (BOOL)isThisWeek
{
    return [self isSameWeekAsDate:[NSDate date]];
}
- (BOOL)isNextWeek
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_WEEK;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self isSameWeekAsDate:newDate];
}
- (BOOL)isLastWeek
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_WEEK;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self isSameWeekAsDate:newDate];
}

- (BOOL)isSameMonthAsDate: (NSDate *) date
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:date];
#else
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:date];
#endif
    return ((components1.month == components2.month) && (components1.year == components2.year));
}
- (BOOL)isThisMonth
{
    return [self isSameMonthAsDate:[NSDate date]];
}
- (BOOL)isLastMonth
{
    return [self isSameMonthAsDate:[[NSDate date] dateBySubtractingMonths:1]];
}
- (BOOL)isNextMonth
{
    return [self isSameMonthAsDate:[[NSDate date] dateByAddingMonths:1]];
}

- (BOOL)isSameYearAsDate: (NSDate *) date
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:date];
#else
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:date];
#endif
    return (components1.year == components2.year);
}
- (BOOL)isThisYear
{
    return [self isSameYearAsDate:[NSDate date]];
}
- (BOOL)isNextYear
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:[NSDate date]];
#else
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:[NSDate date]];
#endif
    return (components1.year == (components2.year + 1));
}
- (BOOL)isLastYear
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:[NSDate date]];
#else
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:[NSDate date]];
#endif
    return (components1.year == (components2.year - 1));
}

- (BOOL)isEarlierThanDate: (NSDate *) date
{
    return ([self compare:date] == NSOrderedAscending);
}
- (BOOL)isLaterThanDate: (NSDate *) date
{
    return ([self compare:date] == NSOrderedDescending);
}
- (BOOL)isInFuture
{
    return ([self isLaterThanDate:[NSDate date]]);
}
- (BOOL)isInPast
{
    return ([self isEarlierThanDate:[NSDate date]]);
}

- (BOOL)isTypicallyWeekend
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSDateComponents *components = [CURRENT_CALENDAR components:NSCalendarUnitWeekday fromDate:self];
#else
    NSDateComponents *components = [CURRENT_CALENDAR components:NSWeekdayCalendarUnit fromDate:self];
#endif
    if ((components.weekday == 1) || (components.weekday == 7))
        return YES;
    return NO;
}
- (BOOL)isTypicallyWorkday
{
    return ![self isTypicallyWeekend];
}

#pragma mark - # 间隔日期
+ (NSDate *)dateTomorrow
{
    return [NSDate dateWithDaysFromNow:1];
}
+ (NSDate *)dateYesterday
{
    return [NSDate dateWithDaysBeforeNow:1];
}

+ (NSDate *)dateWithHoursFromNow:(NSInteger)hours
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_HOUR * hours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}
+ (NSDate *)dateWithHoursBeforeNow:(NSInteger)hours
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_HOUR * hours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *)dateWithMinutesFromNow:(NSInteger)minutes
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * minutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}
+ (NSDate *)dateWithMinutesBeforeNow:(NSInteger)minutes
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_MINUTE * minutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *)dateWithDaysFromNow:(NSInteger)days
{
    return [[NSDate date] dateByAddingDays:days];
}
+ (NSDate *)dateWithDaysBeforeNow:(NSInteger)days
{
    return [[NSDate date] dateBySubtractingDays:days];
}

#pragma mark - # 日期加减
- (NSDate *)dateByAddingYears:(NSInteger)years
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:years];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}
- (NSDate *)dateBySubtractingYears:(NSInteger)years
{
    return [self dateByAddingYears:-years];
}

- (NSDate *)dateByAddingMonths:(NSInteger)months
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:months];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}
- (NSDate *)dateBySubtractingMonths:(NSInteger)months
{
    return [self dateByAddingMonths:-months];
}

- (NSDate *)dateByAddingDays:(NSInteger)days
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_DAY * days;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}
- (NSDate *)dateBySubtractingDays:(NSInteger)days
{
    return [self dateByAddingDays: (days * -1)];
}

- (NSDate *)dateByAddingHours:(NSInteger)hours
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_HOUR * hours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}
- (NSDate *)dateBySubtractingHours:(NSInteger)hours
{
    return [self dateByAddingHours: (hours * -1)];
}

- (NSDate *)dateByAddingMinutes:(NSInteger)minutes
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_MINUTE * minutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}
- (NSDate *)dateBySubtractingMinutes:(NSInteger)minutes
{
    return [self dateByAddingMinutes: (minutes * -1)];
}

#pragma mark - # 日期间隔
- (NSInteger)minutesAfterDate:(NSDate *)date
{
    NSTimeInterval ti = [self timeIntervalSinceDate:date];
    return (NSInteger)(ti / D_MINUTE);
}
- (NSInteger)minutesBeforeDate:(NSDate *)date
{
    NSTimeInterval ti = [date timeIntervalSinceDate:self];
    return (NSInteger)(ti / D_MINUTE);
}

- (NSInteger)hoursAfterDate:(NSDate *)date
{
    NSTimeInterval ti = [self timeIntervalSinceDate:date];
    return (NSInteger)(ti / D_HOUR);
}
- (NSInteger)hoursBeforeDate:(NSDate *)date
{
    NSTimeInterval ti = [date timeIntervalSinceDate:self];
    return (NSInteger)(ti / D_HOUR);
}

- (NSInteger)daysAfterDate:(NSDate *)date
{
    NSTimeInterval ti = [self timeIntervalSinceDate:date];
    return (NSInteger)(ti / D_DAY);
}
- (NSInteger)daysBeforeDate:(NSDate *)date
{
    NSTimeInterval ti = [date timeIntervalSinceDate:self];
    return (NSInteger)(ti / D_DAY);
}

- (NSInteger)distanceInDaysToDate:(NSDate *)anotherDate
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay fromDate:self toDate:anotherDate options:0];
#else
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit fromDate:self toDate:anotherDate options:0];
#endif
    return components.day;
}

@end
