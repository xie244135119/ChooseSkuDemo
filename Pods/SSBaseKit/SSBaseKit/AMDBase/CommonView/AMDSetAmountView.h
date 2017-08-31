//
//  AMDSetAmountView.h
//  AppMicroDistribution
//
//  Created by SunSet on 15-5-26.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import <UIKit/UIKit.h>


// 检测UIControlEventValueChanged 事件
@interface AMDSetAmountView : UIView



// 最大库存数量 默认为-1 表示不限库存
@property(nonatomic) NSInteger maxStoreAmount;
// 最小库存数量 默认为0
@property(nonatomic) NSInteger minStoreAmount;
// 当前显示数量
@property(nonatomic) NSInteger amount;

// 文本框
@property(nonatomic, weak) UITextField *amountField;
// 需要自动偏移的父视图
@property(nonatomic, weak) UIView *offSetView;




@end





