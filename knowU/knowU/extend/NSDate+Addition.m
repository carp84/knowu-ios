//
//  NSDate+Addition.m
//  knowU
//
//  Created by HanJiatong on 15/5/16.
//  Copyright (c) 2015年 HanJiatong. All rights reserved.
//

#import "NSDate+Addition.h"
#define DATE_COMPONENTS (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)
#define CURRENT_CALENDAR [NSCalendar currentCalendar]
#define secondOfDay		(60 * 60 * 24)

@implementation NSDate (Addition)

- (NSString *)convertStringWithFormat:(NSString *)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = format;
    return [dateFormatter stringFromDate:self];
}

+ (BOOL)dateIsTodayWithInterval:(NSTimeInterval)interval{
    return [self dateIsToday:[NSDate dateWithTimeIntervalSince1970:interval]];
}

+ (BOOL)dateIsYesterdayWithInterval:(NSTimeInterval)interval{
    return [self dateIsYesterday:[NSDate dateWithTimeIntervalSince1970:interval]];
}

#pragma mark- 判断是否是今日
+ (BOOL)dateIsToday:(NSDate *)date
{
    return [self isEqualToDateIgnoringTime:date today:[NSDate date]];
}

#pragma mark- 判断是否为昨天
+ (BOOL)dateIsYesterday:(NSDate *)date
{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - secondOfDay;
    return [self isEqualToDateIgnoringTime:date today:[NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval]];
}

+ (BOOL)isEqualToDateIgnoringTime:(NSDate *) aDate today:(NSDate *)today
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:today];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
    return ((components1.year == components2.year) &&
            (components1.month == components2.month) &&
            (components1.day == components2.day));
}

- (NSInteger)weekdayWithDate{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *yearComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:self];
    NSArray *yearArray = [[NSArray alloc] initWithObjects:@7, @1, @2, @3, @4, @5, @6, nil];
    return [[yearArray objectAtIndex:([yearComponents weekday] - 1)] integerValue];
}

/** 是否可以上传数据*/
- (BOOL)isCanUpdate:(NSDate *)date{
    NSTimeInterval oldInterval = [self timeIntervalSince1970];
    NSTimeInterval newInterval = [date timeIntervalSince1970];
    return fabs(oldInterval - newInterval) > 3;
}

@end
