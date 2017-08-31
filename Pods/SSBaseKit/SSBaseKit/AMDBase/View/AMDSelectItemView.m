//
//  AMDSelectItemView.m
//  SSBaseKit
//
//  Created by SunSet on 2017/8/2.
//  Copyright © 2017年 SunSet. All rights reserved.
//

#import "AMDSelectItemView.h"

@implementation AMDSelectItemView

- (void)dealloc
{
    self.strokeColor = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}



- (void)drawRect:(CGRect)rect
{
//    [super drawRect:rect];
    
    CGPoint startpoint = CGPointMake(5, self.frame.size.height/2);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, startpoint.x, startpoint.y);
    CGPathAddLineToPoint(path, nil, startpoint.x+4.5,startpoint.y+5.5);
    CGPathAddLineToPoint(path, nil, startpoint.x+4.5+9.5, startpoint.y+5.5-10.5);
    
    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    layer.path = path;
    layer.strokeColor = _strokeColor.CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth = 1.5;
    layer.lineJoin = @"round";
    [self.layer addSublayer:layer];
}




@end












