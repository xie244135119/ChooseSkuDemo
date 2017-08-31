//
//  AMDKeyboradView.h
//  AppMicroDistribution
//
//  Created by SunSet on 15-5-20.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, AMDKeyboardType) {
    AMDKeyboardTypeNumber,      //数字键盘  0-9,
    AMDKeyboardTypePrice,       //价格键盘  0-9, 和.
};



@interface AMDKeyboradView : UIView


@property(nonatomic)  AMDKeyboardType keyboardType; //键盘类型
@property(nonatomic,weak) UITextField *parentField; //父输入框

// 检查是否含有小数点
- (BOOL)checkDecimalPoint;

// 实例化
- (id)init;


@end
