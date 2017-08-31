//
//  AMDRootNavgationBar.h
//  AppMicroDistribution
//  根导航
//  Created by SunSet on 15-5-20.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMDRootNavgationBar : UIView



/*左侧的views*/
@property(nonatomic,strong) NSArray *leftViews;
/*右侧的views*/
@property(nonatomic,strong) NSArray *rightViews;
/*背景色 */
@property(nonatomic,strong) UIImage *backgroundimage;
/*标题*/
@property(nonatomic,copy) NSString *title;
@property(nonatomic,weak) UILabel *titleLabel;
/*导航栏*/
@property(nonatomic,weak) UINavigationBar *naviationBar;
/* 导航背景色 */
@property(nonatomic,strong) UIColor *naviationBarColor;



@end





