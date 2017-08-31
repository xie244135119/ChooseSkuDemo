//
//  AMDLineView.m
//  AppMicroDistribution
//
//  Created by SunSet on 15-5-20.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import "AMDLineView.h"

@implementation AMDLineView


-(void)dealloc
{
    self.lineColor = nil;
}

-(id)initWithFrame:(CGRect)frame Color:(UIColor *)color
{
    if (self = [super initWithFrame:frame]) {
        _lineColor = color;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(ref, NO);      //关闭锯齿  默认情况下，锯齿显示，所以线条宽度为2.0
    CGContextSetLineWidth(ref, 1);
    CGContextSetStrokeColorWithColor(ref, [_lineColor CGColor]);
    CGContextMoveToPoint(ref,0, 0);
    CGContextAddLineToPoint(ref, rect.size.width, rect.size.height);
    CGContextStrokePath(ref);
}


@end











