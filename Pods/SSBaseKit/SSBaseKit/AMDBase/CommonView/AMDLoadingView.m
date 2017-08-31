//
//  AMDLoadingView.m
//  Test毛玻璃
//
//  Created by SunSet on 17/3/20.
//  Copyright © 2017年 SunSet. All rights reserved.
//

#import "AMDLoadingView.h"

@interface AMDLoadingView()
{
    __weak CALayer *_lineLayer;            //线条
}
@end

@implementation AMDLoadingView

- (void)dealloc
{
    _lineLayer = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 后背景
        CGPoint center = CGPointMake(frame.size.width/2, frame.size.height/2);
        CALayer *backlayer = [CALayer layer];
        backlayer.bounds = self.bounds;
        backlayer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2].CGColor;
        backlayer.position = center;
        backlayer.cornerRadius = 10;
        backlayer.masksToBounds = YES;
        [self.layer addSublayer:backlayer];
        
        // 加载圆圈视图
        // 圆圈半径
        CGFloat radious = (CGFloat)frame.size.width/3;
        CALayer *linebacklayer = [CALayer layer];
        linebacklayer.bounds = CGRectMake(0, 0, radious*2, radious*2);
        linebacklayer.backgroundColor = [UIColor clearColor].CGColor;
        linebacklayer.position = center;
        [self.layer insertSublayer:linebacklayer above:backlayer];
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radious startAngle:0 endAngle:270*M_PI/180 clockwise:YES];
        CAShapeLayer *linelayer = [CAShapeLayer layer];
        linelayer.path = path.CGPath;
        linelayer.position = CGPointMake(-radious/2, -radious/2);
        linelayer.lineWidth = 2;
        linelayer.strokeColor = [UIColor whiteColor].CGColor;
        linelayer.fillColor = [UIColor clearColor].CGColor;
        [linebacklayer addSublayer:linelayer];
        _lineLayer = linebacklayer;
    }
    return self;
}


// 开始动画
- (void)startAnimate
{
    CABasicAnimation *animate = [CABasicAnimation animation];
    animate.keyPath = @"transform.rotation.z";
    animate.fromValue = @0;
    animate.toValue = @(2*M_PI);
    animate.removedOnCompletion = YES;
    animate.repeatDuration = 0;
    animate.repeatCount = FLT_MAX;    //默认无穷
    animate.duration = 1;     //转一圈需要的时间
    [_lineLayer addAnimation:animate forKey:@"animate"];
}


- (void)stopAnimate
{
    [_lineLayer removeAnimationForKey:@"animate"];
}


@end






