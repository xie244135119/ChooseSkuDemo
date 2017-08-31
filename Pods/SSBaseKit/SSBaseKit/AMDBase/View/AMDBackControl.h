//
//  AMDBackControl.h
//  AppMicroDistribution
//
//  Created by SunSet on 16/10/26.
//  Copyright © 2016年 SunSet. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AMDBackControl : UIControl

//@property(nonatomic, copy) NSString *imageNormalName;    //正常的图片名称
//@property(nonatomic, copy) NSString *imageSelectName;    //选中的图片名称
@property(nonatomic, weak) UILabel *mesRemindLabel;      //消息提醒标签
//
//// 支持AutoLayout
//@property(nonatomic, copy) NSString *imageNormalName2;    //正常的图片名称
//@property(nonatomic, copy) NSString *imageSelectName2;    //选中的图片名称


// 线条颜色
@property(nonatomic, strong) UIColor *imgStrokeColor;


// 设置背景色
//- (void)setImage:(UIImage *)image forState:(UIControlState)state;


@end

















