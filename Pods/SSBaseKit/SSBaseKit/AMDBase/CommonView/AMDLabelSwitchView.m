//
//  AMDLabelSwitchView.m
//  AppMicroDistribution
//
//  Created by SunSet on 16/12/1.
//  Copyright © 2016年 SunSet. All rights reserved.
//

#import "AMDLabelSwitchView.h"
#import "SSGlobalVar.h"
#import <Masonry/Masonry.h>
#import "AMDLineView.h"

@implementation AMDLabelSwitchView


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    // 鼓励金
    UILabel *gulilb = [[UILabel alloc]init];
    gulilb.font = SSFontWithName(@"", 14);
    gulilb.textColor = SSColorWithRGB(51, 51, 51, 1);
    [self addSubview:gulilb];
    _titleLb = gulilb;
    [gulilb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.bottom.equalTo(@0);
        make.right.equalTo(@(-15-51-10));
    }];
    
    // 鼓励金额的开关
    UISwitch *guliswitch = [[UISwitch alloc]init];
//    guliswitch.onTintColor = AMDNavBarColor;
    [self addSubview:guliswitch];
    _operSwitch = guliswitch;
    [guliswitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-15);
        make.width.equalTo(@51);
        make.height.equalTo(@31);
        make.centerY.equalTo(gulilb.mas_centerY);
    }];
}


- (void)configLineTop:(BOOL)top
           bottomLine:(BOOL)bottom
{
    if (top) {
        AMDLineView *line = [[AMDLineView alloc]init];
        line.lineColor = SSLineColor;
        [self addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(@0);
            make.height.equalTo(@0.5);
        }];
    }
    
    if (bottom) {
        AMDLineView *line = [[AMDLineView alloc]init];
        line.lineColor = SSLineColor;
        [self addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(@0);
            make.height.equalTo(@0.5);
        }];
    }
}



@end





