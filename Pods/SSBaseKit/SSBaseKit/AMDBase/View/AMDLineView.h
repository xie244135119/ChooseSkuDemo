//
//  AMDLineView.h
//  AppMicroDistribution
//  线条
//  Created by SunSet on 15-5-20.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMDLineView : UIView


@property(nonatomic,strong) UIColor *lineColor;//线条颜色

/**
 *  线条实例化
 *
 *  @param frame 大小
 *  @param color 颜色
 *
 *  @return 实例化
 */
-(id)initWithFrame:(CGRect)frame Color:(UIColor *)color;



@end







