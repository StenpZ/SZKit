
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import <Foundation/Foundation.h>

@interface NSDate (SZKit)

#pragma mark - 基本时间参数
@property (nonatomic, assign, readonly) NSUInteger year;
@property (nonatomic, assign, readonly) NSUInteger month;
@property (nonatomic, assign, readonly) NSUInteger day;
@property (nonatomic, assign, readonly) NSUInteger hour;
@property (nonatomic, assign, readonly) NSUInteger minute;
@property (nonatomic, assign, readonly) NSUInteger second;
/// 时期几，整数
@property (nonatomic, assign, readonly) NSUInteger weekday;
/// 当前月份的天数
@property (nonatomic, assign, readonly) NSUInteger dayInMonth;
/// 是不是闰年
@property (nonatomic, assign, readonly) BOOL isLeapYear;


#pragma mark - 日期格式化
/// YYYY年MM月dd日
- (NSString *)formatYMD;
/// 自定义分隔符
- (NSString *)formatYMDWithSeparate:(NSString *)separate;
/// MM月dd日
- (NSString *)formatMD;
/// 自定义分隔符
- (NSString *)formatMDWithSeparate:(NSString *)separate;
/// HH:MM:SS
- (NSString *)formatHMS;
/// HH:MM
- (NSString *)formatHM;
/// 星期几
- (NSString *)formatWeekday;
/// 月份
- (NSString *)formatMonth;

- (NSString *)formatWithFormatter:(NSString *)formatter;


#pragma mark - 日期关系
- (BOOL)isSameDay:(NSDate *)aDate;
@property (nonatomic, assign, readonly) BOOL isToday;
@property (nonatomic, assign, readonly) BOOL isTomorrow;
@property (nonatomic, assign, readonly) BOOL isYesterday;

- (BOOL)isSameWeekAsDate:(NSDate *)aDate;
@property (nonatomic, assign, readonly) BOOL isThisWeek;
@property (nonatomic, assign, readonly) BOOL isNextWeek;
@property (nonatomic, assign, readonly) BOOL isLastWeek;

- (BOOL)isSameMonthAsDate:(NSDate *)aDate;
@property (nonatomic, assign, readonly) BOOL isThisMonth;
@property (nonatomic, assign, readonly) BOOL isNextMonth;
@property (nonatomic, assign, readonly) BOOL isLastMonth;

- (BOOL)isSameYearAsDate:(NSDate *)aDate;
@property (nonatomic, assign, readonly) BOOL isThisYear;
@property (nonatomic, assign, readonly) BOOL isNextYear;
@property (nonatomic, assign, readonly) BOOL isLastYear;

- (BOOL)isEarlierThanDate:(NSDate *)aDate;
- (BOOL)isLaterThanDate:(NSDate *)aDate;
@property (nonatomic, assign, readonly) BOOL isInFuture;
@property (nonatomic, assign, readonly) BOOL isInPast;

@property (nonatomic, assign, readonly) BOOL isTypicallyWorkday;
@property (nonatomic, assign, readonly) BOOL isTypicallyWeekend;

#pragma mark - 间隔日期
+ (NSDate *)dateTomorrow;
+ (NSDate *)dateYesterday;
+ (NSDate *)dateWithDaysFromNow:(NSInteger)days;
+ (NSDate *)dateWithDaysBeforeNow:(NSInteger)days;
+ (NSDate *)dateWithHoursFromNow:(NSInteger)hours;
+ (NSDate *)dateWithHoursBeforeNow:(NSInteger)hours;
+ (NSDate *)dateWithMinutesFromNow:(NSInteger)minutes;
+ (NSDate *)dateWithMinutesBeforeNow:(NSInteger)minutes;

#pragma mark - 日期加减
- (NSDate *)dateByAddingYears:(NSInteger)years;
- (NSDate *)dateBySubtractingYears:(NSInteger)years;
- (NSDate *)dateByAddingMonths:(NSInteger)months;
- (NSDate *)dateBySubtractingMonths:(NSInteger)months;
- (NSDate *)dateByAddingDays:(NSInteger)days;
- (NSDate *)dateBySubtractingDays:(NSInteger)days;
- (NSDate *)dateByAddingHours:(NSInteger)hours;
- (NSDate *)dateBySubtractingHours:(NSInteger)hours;
- (NSDate *)dateByAddingMinutes:(NSInteger)minutes;
- (NSDate *)dateBySubtractingMinutes:(NSInteger)minutes;

#pragma mark - 日期间隔
- (NSInteger)minutesAfterDate:(NSDate *)aDate;
- (NSInteger)minutesBeforeDate:(NSDate *)aDate;
- (NSInteger)hoursAfterDate:(NSDate *)aDate;
- (NSInteger)hoursBeforeDate:(NSDate *)aDate;
- (NSInteger)daysAfterDate:(NSDate *)aDate;
- (NSInteger)daysBeforeDate:(NSDate *)aDate;
- (NSInteger)distanceInDaysToDate:(NSDate *)anotherDate;


@end
