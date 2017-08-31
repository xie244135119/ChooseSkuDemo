//
//  AMDSegmentedControl.h
//  TestMasonry
//  Tab控制器
//  Created by SunSet on 16/6/21.
//  Copyright © 2016年 SunSet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMDSegmentedControl : UIControl

// 一组Items
@property(nonatomic, readonly, strong) NSArray *segmentItems;
// 选中的index
@property(nonatomic) NSInteger selectedSegmentIndex;

// 字体相关 选中的颜色和正常的颜色
@property(nonatomic, strong) UIColor *selectTintColor;
@property(nonatomic, strong) UIColor *normalTintColor;

// 背景相关颜色
@property(nonatomic, strong) UIColor *selectBarColor;
@property(nonatomic, strong) UIColor *normalBarColor;


// 一组items 可以是NSString
- (id)initWithItems:(NSArray *)items;


@end







