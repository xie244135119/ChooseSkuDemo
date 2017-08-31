//
//  AMDLabelShowView.h
//  AppMicroDistribution
//  frame--左侧为label，右侧为label
//  Created by SunSet on 15-5-20.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SSBaseKit/AMDCopyLabel.h>

@interface AMDLabelShowView : UIControl


@property(nonatomic,weak) UILabel *titleLabel;          //标题
@property(nonatomic,weak) AMDCopyLabel *contentLabel;        //详细内容
@property(nonatomic) BOOL  rightArrowShow;              //右侧箭头是否展示,默认NO

// 线条支持
@property(nonatomic) BOOL supportTopLine;               //支持上线条
@property(nonatomic) BOOL supportBottomLine;            //支持下线条


// 设置背景色
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;


@end
