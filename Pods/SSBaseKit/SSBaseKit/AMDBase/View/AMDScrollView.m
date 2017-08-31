//
//  AMDScrollView.m
//  AppMicroDistribution
//
//  Created by SunSet on 16/9/13.
//  Copyright © 2016年 SunSet. All rights reserved.
//

#import "AMDScrollView.h"

@implementation AMDScrollView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //
        [self handleWindowScrollGesture];
    }
    return self;
}


// 手势支持系统右滑(优先系统右滑动功能)
- (void)handleWindowScrollGesture
{
    [self.gestureRecognizers enumerateObjectsUsingBlock:^(__kindof UIGestureRecognizer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIPanGestureRecognizer class]]) {
            id app = [UIApplication sharedApplication].delegate;
            UINavigationController *navVC  = (UINavigationController *)[[app window] rootViewController];
            [obj requireGestureRecognizerToFail:navVC.interactivePopGestureRecognizer];
        }
    }];
}



@end











