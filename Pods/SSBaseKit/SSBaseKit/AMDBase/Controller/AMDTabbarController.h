//
//  AMDTabbarController.h
//  AppMicroDistribution
//
//  Created by SunSet on 15-5-21.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SSBaseKit/AMDTabbarItem.h>

@interface AMDTabbarController : UITabBarController

// 自定义tabbar
@property(nonatomic, weak , nullable) UIView *amdTabBar;
// 一组ViewControllers
//@property(nullable, nonatomic, strong) NSArray *amdViewControllers;

/*
 * 实例化
 * @param1 所有的tabbar标题 @param2 正常的图片 @param3选中时候的图片
 */
-(nonnull instancetype)initWithItemsTitles:(NSArray * _Nonnull)titles
                        itemImages:(NSArray * _Nonnull)imgs
                   itemSelctImages:(NSArray * _Nonnull)selectimgs;


/**
 *  选中某一个Tabbar的版块
 *
 *  @param index 索引值
 */
- (void)selectTabbarIndex:(NSInteger)index;

// 显示新消息
//- (void)showNewMessageCount:(NSInteger)count;

/**
 *  设置消息数量 count:消息数量 索引数量:index 0开始
 */
//- (void)setShowMessageCount:(NSInteger)count index:(NSInteger)index;


#pragma mark - 支持消息右上角提示
//- (void)supportMessageRemindWithIndex:(NSInteger)index;

@end



@interface UIViewController (AMDTabBarControllerItem)

// 自定义tabbarItem
@property(null_resettable, nonatomic, strong) AMDTabbarItem *amdTabBarItem;
// TabBarController
@property(nullable, nonatomic, readonly, strong) AMDTabbarController *amdTabBarController;

@end













