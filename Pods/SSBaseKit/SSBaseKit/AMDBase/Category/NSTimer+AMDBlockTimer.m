//
//  NSTimer+AMDBlockTimer.m
//  AppMicroDistribution
//
//  Created by SunSet on 16/7/11.
//  Copyright © 2016年 SunSet. All rights reserved.
//

#import "NSTimer+AMDBlockTimer.h"


@implementation NSTimer (AMDBlockTimer)


+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti block:(void (^)())block repeats:(BOOL)yesOrNo
{
    return [self scheduledTimerWithTimeInterval:ti target:self selector:@selector(amd_BlockSel:) userInfo:[block copy] repeats:yesOrNo];
}

+ (void)amd_BlockSel:(NSTimer *)timer
{
    void (^block)(void) = timer.userInfo;
    if (block) {
        block();
    }
}



@end










