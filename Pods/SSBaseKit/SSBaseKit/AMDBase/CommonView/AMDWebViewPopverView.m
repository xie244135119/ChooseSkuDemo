//
//  AMDWebViewPopverView.m
//  AppMicroDistribution
//
//  Created by SunSet on 17/1/18.
//  Copyright © 2017年 SunSet. All rights reserved.
//

#import "AMDWebViewPopverView.h"
#import "SSGlobalVar.h"
#import <Masonry/Masonry.h>

@interface AMDWebViewPopverView()
{
    __block UIView *_middleView;            //中间视图
}
@end

@implementation AMDWebViewPopverView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initContentView];
    }
    return self;
}


- (void)initContentView
{
    UIView *middleView = [[UIView alloc]init];
    middleView.layer.borderWidth = 1;
    [self addSubview:middleView];
    _middleView = middleView;
    
    // 提供源
    UILabel *sourcelb = [[UILabel alloc]init];
    sourcelb.textAlignment = NSTextAlignmentCenter;
    sourcelb.font = SSFontWithName(@"", 13);
    sourcelb.text = @"网页由 www.baidu.com 提供";
    [middleView addSubview:sourcelb];
    
    // 弹出视图
    
    
    // 基本功能
    UIScrollView *basescrollView = [[UIScrollView alloc]init];
    basescrollView.showsVerticalScrollIndicator = NO;
    basescrollView.layer.borderWidth = 1;
    [middleView addSubview:basescrollView];
    [basescrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.equalTo(@100);
        make.top.equalTo(@40);
    }];
    
    // 取消按钮
    UIButton *cancelbt = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelbt setTitle:@"取消" forState:UIControlStateNormal];
    cancelbt.titleLabel.font = SSFontWithName(@"", 15);
    [cancelbt setBackgroundColor:SSColorWithRGB(255, 255, 255, 0.9)];
    [middleView addSubview:cancelbt];
    [cancelbt addTarget:self action:@selector(clickCancel:) forControlEvents:UIControlEventTouchUpInside];
    [cancelbt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@40);
    }];
    
}




#pragma mark - 按钮事件
// 取消事件
- (void)clickCancel:(UIButton *)sender
{
    [self hide];
}





#pragma mark - Public API
// 显示
- (void)show
{
    
}

// 隐藏
- (void)hide
{
    
}




@end













