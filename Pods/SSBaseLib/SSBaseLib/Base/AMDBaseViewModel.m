//
//  AMDBaseViewModel.m
//  AppMicroDistribution
//
//  Created by SunSet on 15-8-10.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import "AMDBaseViewModel.h"

@implementation AMDBaseViewModel


- (void)dealloc
{
    NSLog(@"%@ %@",[self class],NSStringFromSelector(_cmd));
}


- (void)prepareView
{
    // 子类需要重写这个方法
}

- (void)clearView
{
    // 子类需要重写这个方法
}

- (void)prepareViewBySuper
{
    // override
}

- (void)clearViewBySuper
{
    // 子类需要重写这个方法
}

- (void)prepareLoad
{
    //override
}

- (void)prepareUnload
{
    //override
}


@end






