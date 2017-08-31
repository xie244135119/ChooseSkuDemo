//
//  AMDProgressView.m
//  AppMicroDistribution
//
//  Created by Fuerte on 16/9/8.
//  Copyright © 2016年 SunSet. All rights reserved.
//

#import "AMDProgressView.h"

@interface AMDProgressView()
{
    CAShapeLayer *_progressLayer;           //
    CAShapeLayer *_targetLayer;             //
}
@end

@implementation AMDProgressView

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        [self initContentView];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    // 背景色
    [[UIColor blueColor] setFill];
    
    // 填充进度中的颜色
    CGFloat progrewwidth = _progress*rect.size.width;
    CGFloat height = MIN(rect.size.height, 5);
    UIBezierPath *progresspath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, progrewwidth, height)];
    // 设置颜色
    [_progressTintColor set];
    [progresspath fill];
    
    // 填充正常时候的颜色
    UIBezierPath *targetpath = [UIBezierPath bezierPathWithRect:CGRectMake(progrewwidth, 0, rect.size.width-progrewwidth, height)];
    // 设置颜色
    [_trackTintColor set];
    [targetpath fill];
}


- (void)initContentView
{
    // 两段
}


- (void)setProgress:(float)progress animated:(BOOL)animated
{
    if (animated) {
        self.progress = progress;
    }
    else {
        [UIView animateWithDuration:0.15 animations:^{
            self.progress = progress;
        }];
    }
    
}


#pragma mark - SET
- (void)setProgressTintColor:(UIColor *)progressTintColor
{
    if (_progressTintColor != progressTintColor) {
        _progressTintColor = progressTintColor;
    }
    
    [self setNeedsDisplay];
}

- (void)setTrackTintColor:(UIColor *)trackTintColor
{
    if (_trackTintColor != trackTintColor) {
        _trackTintColor = trackTintColor;
        
        [self setNeedsDisplay];
    }
}

- (void)setProgress:(float)progress
{
    _progress = progress;
    
    // 重绘
    [self setNeedsDisplay];
}


@end























