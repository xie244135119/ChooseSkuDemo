//
//  AMDSegmentedControl.m
//  TestMasonry
//
//  Created by SunSet on 16/6/21.
//  Copyright © 2016年 SunSet. All rights reserved.
//

#import "AMDSegmentedControl.h"
//#import "UIButton+AYEButtonBackground.h"
//#import "ATAColorConfig.h"
#import "SSGlobalVar.h"
#import <Masonry/Masonry.h>
#import "AMDButton.h"


@implementation AMDSegmentedControl

- (void)dealloc
{
//    self.segmentItems = nil;
    self.normalTintColor = nil;
    self.selectTintColor = nil;
}

//
//- (id)initWithFrame:(CGRect)frame
//{
//    if (self = [super initWithFrame:frame]) {
//        //
//    }
//    return self;
//}

- (id)initWithItems:(NSArray *)items
{
    if (self = [super init]) {
        _segmentItems = items;
        [self initAutoLayoutView];
    }
    return self;
}



#pragma mark - 视图
//
- (void)initContentView
{
    
}

// 加载自适应视图
- (void)initAutoLayoutView
{
    self.layer.borderColor = [SSColorWithRGB(119, 119, 119, 1) CGColor];
//    self.layer.borderColor = [seg_border_color CGColor];
    self.layer.borderWidth = 0.5;
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
    
    __weak AMDButton *_lastBt = nil;
    for (NSInteger i = 0; i< _segmentItems.count; i++) {
        NSString *title = _segmentItems[i];
        AMDButton *bt = [[AMDButton alloc]init];
        [bt setTitle:title forState:UIControlStateNormal];
        bt.titleLabel.font = SSFontWithName(@"", 13);
        [self addSubview:bt];
        bt.tag = i+1;
        [bt addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            bt.selected = YES;
        }
        
        // 加载位置
        [bt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(@0);
            if (_lastBt == nil) {
                make.left.equalTo(@0);
            }
            else {
                make.width.equalTo(_lastBt.mas_width);
                make.left.equalTo(_lastBt.mas_right);
                make.left.equalTo(_lastBt.mas_right).with.offset(0);
            }
        }];
        _lastBt = bt;
    }
    
    // 最后一个按钮指向最右侧
    [_lastBt mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@0);
    }];
}


// 按钮事件
- (void)clickAction:(AMDButton *)sender
{
    self.selectedSegmentIndex = sender.tag-1;
    
    // 按钮事件
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}



#pragma mark - SET
- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex
{
//    if (_selectedSegmentIndex != selectedSegmentIndex) {
        // 取消之前的选中状态
        AMDButton *sender = [self viewWithTag:_selectedSegmentIndex+1];
        if ([sender isKindOfClass:[AMDButton class]]) {
            sender.selected = NO;
            sender.userInteractionEnabled = YES;
        }
        
        _selectedSegmentIndex = selectedSegmentIndex;
        AMDButton *currentbt = [self viewWithTag:_selectedSegmentIndex+1];
        currentbt.selected = YES;
        currentbt.userInteractionEnabled = NO;
//    }
}



#pragma mark - 
- (void)setNormalTintColor:(UIColor *)normalTintColor
{
    if (_normalTintColor != normalTintColor) {
        _normalTintColor = normalTintColor;
        
        
        for (AMDButton *sender in self.subviews) {
            if ([sender isKindOfClass:[AMDButton class]]) {
                [sender setTitleColor:normalTintColor forState:UIControlStateNormal];
            }
        }
    }
}


- (void)setSelectTintColor:(UIColor *)selectTintColor
{
    if (_selectTintColor != selectTintColor) {
        _selectTintColor = selectTintColor;
        
        for (AMDButton *sender in self.subviews) {
            if ([sender isKindOfClass:[AMDButton class]]) {
                [sender setTitleColor:selectTintColor forState:UIControlStateSelected];
                [sender setTitleColor:selectTintColor forState:UIControlStateHighlighted];
            }
        }
    }
}

- (void)setNormalBarColor:(UIColor *)normalBarColor
{
    if (_normalBarColor != normalBarColor) {
        _normalBarColor = normalBarColor;
        
        for (AMDButton *sender in self.subviews) {
            if ([sender isKindOfClass:[AMDButton class]]) {
                [sender setBackgroundColor:normalBarColor forState:UIControlStateNormal];
            }
        }
    }
}

- (void)setSelectBarColor:(UIColor *)selectBarColor
{
    if (_selectBarColor != selectBarColor) {
        _selectBarColor = selectBarColor;
        
        for (AMDButton *sender in self.subviews) {
            if ([sender isKindOfClass:[AMDButton class]]) {
                [sender setBackgroundColor:selectBarColor forState:UIControlStateSelected];
                [sender setBackgroundColor:selectBarColor forState:UIControlStateHighlighted];
            }
        }
    }
}



////根据状态不同配置背景色
//- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state
//{
//    switch (state) {
//        case UIControlStateNormal:{
//            _normalBackgroundColor = backgroundColor;
//            self.backgroundColor = backgroundColor;
//        }
//            break;
//        case UIControlStateHighlighted:
//        {
//            if (backgroundColor == nil) {
//                _supportMaskView = YES;
//            }
//            else {
//                _higlhtedBackgroundColor = backgroundColor;
//            }
//        }
//            break;
//        case UIControlStateSelected:
//            _selectBackgroundColor = backgroundColor;
//            break;
//        case UIControlStateDisabled:
//            _disabledBackgroundColor = backgroundColor;
//            break;
//        default:
//            break;
//    }
//    //    self.backgroundColor = _normalBackgroundColor?_normalBackgroundColor:[UIColor clearColor];
//}





@end














