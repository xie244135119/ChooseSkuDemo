//
//  AMDDateTool.h
//  AppMicroDistribution
//  日期处理
//  Created by SunSet on 15-5-19.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSDateTool : NSObject


// 1999-01-01
+ (NSString *) toShortString:(NSDate *)date;
+ (NSDate *) toShortDate:(NSString *)datestr;

//1999-01-01 01:01:01
+ (NSString *)toLongString:(NSDate *)date;
+ (NSDate *)toLongDate:(NSString *)datestr;

//时间戳转化
//1999-01-01
+ (NSString *)toStringFromTimeStamp:(NSNumber *)number;
+ (NSString *)toStringFromTimeStamp:(NSNumber *)number formateString:(NSString *)formatString;

//获取当前成分
+ (NSDateComponents *)toDateComponentsFromTimeStamp:(NSNumber *)number;
+ (NSDateComponents *)toDateComponentsFromDate:(NSDate *)date;

//
+ (NSNumber *)toStampStringFromDate:(NSDate *)date;
+ (NSNumber *)toStampStringFromDatestr:(NSString *)datestr;

// 最原始的方式
+ (NSString *)fromDate:(NSDate *)date formateString:(NSString *)formatString;
+ (NSDate *)fromString:(NSString *)datestr formateString:(NSString *)formatString;


@end





