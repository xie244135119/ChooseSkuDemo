//
//  AMDDateTool.m
//  AppMicroDistribution
//
//  Created by SunSet on 15-5-19.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import "SSDateTool.h"

@implementation SSDateTool


+ (NSString *)toShortString:(NSDate *)date
{
    return [self fromDate:date formateString:@"yyyy-MM-dd"];
}

+ (NSDate *)toShortDate:(NSString *)datestr
{
    return [self fromString:datestr formateString:@"yyyy-MM-dd"];
}

+ (NSString *)toLongString:(NSDate *)date
{
    return [self fromDate:date formateString:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSDate *)toLongDate:(NSString *)datestr
{
    return [self fromString:datestr formateString:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSInteger) weekDayFromDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday|NSCalendarUnitWeekdayOrdinal|NSCalendarUnitWeekOfMonth|NSCalendarUnitWeekOfYear fromDate:date];
    return components.day ;
}


+ (NSInteger) weekDayFromString:(NSString *)datestr
{
    NSDate *date = [self toShortDate:datestr];
    return [self weekDayFromDate:date];
}

//时间戳转化
+ (NSString *)toStringFromTimeStamp:(NSNumber *)number
{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:number.doubleValue];
    return [self toLongString:confromTimesp];
}

+ (NSString *)toStringFromTimeStamp:(NSNumber *)number formateString:(NSString *)formatString
{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:number.doubleValue];
    return [self fromDate:confromTimesp formateString:formatString];
}

+ (NSDateComponents *)toDateComponentsFromTimeStamp:(NSNumber *)number
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:number.doubleValue];
    return [self toDateComponentsFromDate:date];
}

+(NSDateComponents *)toDateComponentsFromDate:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute |NSCalendarUnitSecond|NSCalendarUnitWeekday|NSCalendarUnitWeekOfMonth|NSCalendarUnitWeekOfYear|NSCalendarUnitWeekdayOrdinal|NSCalendarUnitQuarter|NSCalendarUnitYearForWeekOfYear;
    NSDateComponents *dd = [calendar components:unitFlags fromDate:date];
    return dd;
}


+ (NSNumber *)toStampStringFromDate:(NSDate *)date
{
    return @([date timeIntervalSince1970]);
}

+ (NSNumber *)toStampStringFromDatestr:(NSString *)datestr
{
    NSDate *date = [self toShortDate:datestr];
    return [self toStampStringFromDate:date];
}


// 将日期根据不同的样式转化为不同的字符串
+ (NSString *)fromDate:(NSDate *)date formateString:(NSString *)formatString
{
    NSDateFormatter *_dateFormater = [self _dateFormatter];
    [_dateFormater setDateFormat:formatString];
    return  [_dateFormater stringFromDate:date];
}

// 将字符串根据不同的样式转化为不同的日期
+ (NSDate *)fromString:(NSString *)datestr formateString:(NSString *)formatString
{
    NSDateFormatter *_dateFormater = [self _dateFormatter];
    [_dateFormater setDateFormat:formatString];
    return  [_dateFormater dateFromString:datestr];
}


#pragma mark - private api
//
+ (NSDateFormatter *)_dateFormatter
{
    // 使用静态变量的原因是因为NSDateFormatter(或NSCalendar）初始化比较慢
    // 设置一个NSDateFormatter和创建一个新的 一样慢
    static NSDateFormatter *_formater = nil;
    if (_formater == nil) {
        _formater = [[NSDateFormatter alloc]init];
    }
    return _formater;
}


@end




