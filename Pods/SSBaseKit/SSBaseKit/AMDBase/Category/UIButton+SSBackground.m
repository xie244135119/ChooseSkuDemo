//
//  UIButton+AYEButtonBackground.m
//  AppMicroDistribution
//
//  Created by leo on 16/4/5.
//  Copyright © 2016年 SunSet. All rights reserved.
//

#import "UIButton+SSBackground.h"

@implementation UIButton (SSBackground)

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state {
    UIGraphicsBeginImageContext(CGSizeMake(1, 1));
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color setFill];
    UIRectFill(CGContextGetClipBoundingBox(context));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    [self setBackgroundImage:image forState:state];
    UIGraphicsEndImageContext();
}

@end
