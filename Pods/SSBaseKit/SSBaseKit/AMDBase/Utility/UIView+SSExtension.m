//
//  UIView+AMDExtension.m
//  AppMicroDistribution
//
//  Created by SunSet on 16-4-7.
//  Copyright (c) 2016年 SunSet. All rights reserved.
//

#import "UIView+SSExtension.h"

@implementation UIView (SSExtension)


- (void)setAmd_x:(CGFloat)amd_x
{
    CGRect frame = self.frame;
    frame.origin.x = amd_x;
    self.frame = frame;
}

- (CGFloat)amd_x
{
    return self.frame.origin.x;
}


- (void)setAmd_y:(CGFloat)amd_y
{
    CGRect frame = self.frame;
    frame.origin.y = amd_y;
    self.frame = frame;
}

- (CGFloat)amd_y
{
    return self.frame.origin.y;
}

- (void)setAmd_width:(CGFloat)amd_width
{
    CGRect frame = self.frame;
    frame.size.width = amd_width;
    self.frame = frame;
}

- (CGFloat)amd_width
{
    return self.frame.size.width;
}

- (void)setAmd_height:(CGFloat)amd_height
{
    CGRect frame = self.frame;
    frame.size.height = amd_height;
    self.frame = frame;
}

- (CGFloat)amd_height
{
    return self.frame.size.height;
}

- (void)setAmd_size:(CGSize)amd_size
{
    CGRect frame = self.frame;
    frame.size = amd_size;
    self.frame = frame;
}

- (CGSize)amd_size
{
    return self.frame.size;
}

- (void)setAmd_origin:(CGPoint)amd_origin
{
    CGRect frame = self.frame;
    frame.origin = amd_origin;
    self.frame = frame;
}

- (CGPoint)amd_origin
{
    return self.frame.origin;
}



@end




