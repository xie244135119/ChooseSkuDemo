//
//  AMDBaseViewModel.h
//  AppMicroDistribution
//  ViewModel基类
//  Created by SunSet on 15-8-10.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AMDBaseViewModel : NSObject


// 响应控制器
@property(nonatomic, weak) UIViewController *senderController;
// 需要承载显示的父视图 自需
@property(nonatomic, weak) UIView *superView;

// 视图渲染 (控制器视图)
- (void)prepareView;

/**
 从父视图移除的时候
 */
- (void)clearView;

/**
 *  视图渲染 (默认父视图superView)
 */
- (void)prepareViewBySuper;


/**
 从父视图移除的时候
 */
- (void)clearViewBySuper;


/**
 *  预加载
 */
- (void)prepareLoad;

/*
 *
 */
- (void)prepareUnload;


@end







