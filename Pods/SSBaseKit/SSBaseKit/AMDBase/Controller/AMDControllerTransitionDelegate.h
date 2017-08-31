//
//  AMDControllerTransitionDelegate.h
//  AppMicroDistribution
//  页面传值回调
//  Created by SunSet on 15-5-21.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AMDControllerTransitionDelegate <NSObject>


@optional
/**
 *
 *  @param viewController 控制器
 *  @param sender         页面传值
 */
- (void)viewController:(id)viewController object:(id)sender;

@end
