//
//  NSTimer+AMDBlockTimer.h
//  AppMicroDistribution
//
//  Created by SunSet on 16/7/11.
//  Copyright © 2016年 SunSet. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (AMDBlockTimer)


+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti block:(void (^)()) block repeats:(BOOL)yesOrNo;

@end



NS_ASSUME_NONNULL_END