//
//  AMDLabelSwitchView.h
//  AppMicroDistribution
//  左侧label 右侧Switch
//  Created by SunSet on 16/12/1.
//  Copyright © 2016年 SunSet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMDLabelSwitchView : UIView


/**
 左侧标题
 */
@property(nonatomic, weak) UILabel *titleLb;

/**
 操作开关
 */
@property(nonatomic, weak) UISwitch *operSwitch;


/**
 配置线条

 @param top    顶部线条
 @param bottom 底部线条
 */
- (void)configLineTop:(BOOL)top
           bottomLine:(BOOL)bottom;



@end










