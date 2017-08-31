//
//  AMDMultipleTypeView.m
//  AppMicroDistribution
//
//  Created by SunSet on 15-5-21.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import "AMDMultipleTypeView.h"
#import "SSGlobalVar.h"
#import "AMDLineView.h"
#import "UIView+SSExtension.h"
#import <Masonry/Masonry.h>



@interface AMDMultipleTypeView()
{
    __weak UIView * _shadowView;                //底部阴影视图
    
    NSInteger _totalTitlesCount;                //公共的标签数量
    BOOL _isAutoLayout;                         //当前属于自动布局(内部协调处理)
}

@end


@implementation AMDMultipleTypeView

- (void)dealloc
{
    self.titleFont = nil;
    self.textNormalColor = nil;
}


- (id)initWithFrame:(CGRect)frame titles:(NSArray *)titles
{
    if (self = [super initWithFrame:frame]) {
        if (titles.count > 0) {
            _multitles = titles;
            [self initViewWithTitles:titles];
        }
    }
    return self;
}

//加载视图
- (void)initViewWithTitles:(NSArray *)titles
{
    self.backgroundColor = [UIColor whiteColor];
    _totalTitlesCount = titles.count;
    
    //按钮
    CGFloat w = self.frame.size.width/titles.count;
    for (NSInteger i =0 ;i<titles.count; i++) {
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        [bt setFrame:CGRectMake(w*i, 0, w, self.frame.size.height)];
        [bt setTitle:titles[i] forState:UIControlStateNormal];
        [bt setTitleColor:SSColorWithRGB(119, 119, 119, 1) forState:UIControlStateNormal];
        bt.titleLabel.font = SSFontWithName(@"", 14);
        bt.tag = i+1;
        [bt addTarget:self action:@selector(choiceActionButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bt];
        
        if (i == 0) {
            _currentClickIndex = 1;
            [bt setSelected:YES];
        }
    }
    //阴影
    self.layer.shadowOpacity = 0.08;
    self.layer.shadowOffset = CGSizeMake(0, 3);
    
    //底部条
    UIView *shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-2, w, 2)];
//    shadowView.backgroundColor = btn_dark_color;
    [self addSubview:shadowView];
    _shadowView = shadowView;
}


#pragma mark - SET
- (void)setTitleFont:(UIFont *)titleFont
{
    if (_titleFont != titleFont) {
        _titleFont = titleFont;
        
        //设置字体大小
        for (UIView *sender in self.subviews) {
            if ([sender isKindOfClass:[UIButton class]]) {
                UIButton *v = (UIButton *)sender;
                v.titleLabel.font = _titleFont;
            }
        }
    }
}

- (void)setTextNormalColor:(UIColor *)textNormalColor
{
    if (_textNormalColor != textNormalColor) {
        _textNormalColor = textNormalColor;
        
        //设置字体大小
        for (UIView *sender in self.subviews) {
            if ([sender isKindOfClass:[UIButton class]]) {
                UIButton *v = (UIButton *)sender;
                [v setTitleColor:textNormalColor forState:UIControlStateNormal];
            }
        }
    }
}

- (void)setTextSelectColor:(UIColor *)textSelectColor
{
    if (_textSelectColor != textSelectColor) {
        _textSelectColor = textSelectColor;
        
        //设置字体大小
        for (UIView *sender in self.subviews) {
            if ([sender isKindOfClass:[UIButton class]]) {
                UIButton *v = (UIButton *)sender;
                [v setTitleColor:textSelectColor forState:UIControlStateSelected];
            }
        }
        
        // 设置选中线条颜色
        _shadowView.backgroundColor = textSelectColor;
    }
}



- (void)setMaxShadowWidth:(CGFloat)maxShadowWidth
{
    _maxShadowWidth = maxShadowWidth;
    
    if (_currentClickIndex > 0) {
        UIButton *sender = [self viewWithTag:_currentClickIndex];
        _shadowView.amd_width = MIN(_shadowView.amd_width, maxShadowWidth);
        _shadowView.center = CGPointMake(sender.center.x, _shadowView.center.y);
    }
}


- (void)setShadowColor:(UIColor *)shadowColor
{
    if (_shadowColor != shadowColor) {
        _shadowColor = shadowColor;
        
        _shadowView.backgroundColor = shadowColor;
    }
}


- (void)setSupportSeparatorLine:(BOOL)supportSeparatorLine
{
    if (_supportSeparatorLine != supportSeparatorLine) {
        _supportSeparatorLine = supportSeparatorLine;
        
        CGFloat width = self.frame.size.width/_totalTitlesCount;
        for (NSInteger i=0; i<_totalTitlesCount-1; i++) {
            AMDLineView *line = [[AMDLineView alloc]initWithFrame:CGRectMake(width*(i+1), 15, SSLineHeight, self.frame.size.height-30) Color:SSLineColor];
            [self addSubview:line];
        }
    }
}


#pragma mark

// 按钮事件
- (void)choiceActionButton:(UIButton *)sender
{
    if (sender.tag == _currentClickIndex) {
        //防止二次点击
        return;
    }
    
    self.currentClickIndex = sender.tag;
    [sender setSelected:YES];
    
    //动画结束后调用回调事件
    __weak UIView *shadowView = _shadowView;
    [UIView animateWithDuration:0.15 animations:^{
        shadowView.center = CGPointMake(sender.center.x, shadowView.center.y);
    } completion:^(BOOL finished) {
        [_delegate messageChoiceView:self sender:sender];
    }];
}


- (void)setCurrentClickIndex:(NSInteger)currentClickIndex
{
    if (_currentClickIndex != currentClickIndex) {
        //去掉之前按钮的选中色
        UIButton *bt = (UIButton *)[self viewWithTag:_currentClickIndex];
        if ([bt isKindOfClass:[UIButton class]]) {
            [bt setSelected:NO];
        }
        
        _currentClickIndex = currentClickIndex;
    }
}


#pragma mark - 对外开放的API
// 选中某一行
- (void)selectChoiceAtIndex:(NSInteger)index
{
    if (index == 0 || index > _totalTitlesCount) {
        return;
    }
    
    if (_currentClickIndex == index) {
        return;
    }
    
    UIButton *sender = (UIButton *)[self viewWithTag:index];
    
    self.currentClickIndex = sender.tag;
    [sender setSelected:YES];
    
    //动画结束后调用回调事件
    __weak UIView *shadowView = _shadowView;
    if (_isAutoLayout) {
        
        [UIView animateWithDuration:0.25 animations:^{
            [shadowView mas_updateConstraints:^(MASConstraintMaker *make) {
                // 调整左侧距离
                make.left.equalTo(@(sender.frame.origin.x));
            }];
            
            [shadowView.superview layoutIfNeeded];
        }];
    }
    else {
        [UIView animateWithDuration:0.25 animations:^{
            shadowView.center = CGPointMake(sender.center.x, shadowView.center.y);
        }];
    }
    
}

- (UIButton *)buttonWithIndex:(NSInteger)index
{
    UIButton *sender = (UIButton *)[self viewWithTag:index+1];
    return sender;
}

+ (CGFloat)defaultHeight
{
    return 44;
}


#pragma mark
#pragma mark - 支持内部自动布局
- (id)initWithTitles:(NSArray *)titles
{
    if (self = [super init]) {
        _isAutoLayout = YES;
        [self initViewWithTitles2:titles];
    }
    return self;
}

//加载视图
- (void)initViewWithTitles2:(NSArray *)titles
{
    self.backgroundColor = [UIColor whiteColor];
    _totalTitlesCount = titles.count;
    
    //按钮
//    __weak UIView *firstView = nil;
    __weak UIView *lastView = nil;
    for (NSInteger i =0 ;i<titles.count; i++) {
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        [bt setTitle:titles[i] forState:UIControlStateNormal];
        [bt setTitleColor:SSColorWithRGB(119, 119, 119, 1) forState:UIControlStateNormal];
        bt.titleLabel.font = SSFontWithName(@"", 14);
        bt.tag = i+1;
        [bt addTarget:self action:@selector(choiceActionButton2:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bt];
        [bt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self).with.offset(0);
            
            if (lastView) { // 不是第一个
                make.left.equalTo(lastView.mas_right).with.offset(0);
                make.width.equalTo(lastView);
            }
            else {
                make.left.equalTo(self).with.offset(0);
            }
        }];
        
        lastView = bt;
        
        if (i == 0) {
            _currentClickIndex = 1;
            [bt setSelected:YES];
//            firstView = bt;
        }
    }
    
    // 最后一个处理按钮
    [lastView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self).with.offset(0);
        make.right.equalTo(self);
    }];
//    _currentLastView = lastView;
    
    //阴影
    self.layer.shadowOpacity = 0.08;
    self.layer.shadowOffset = CGSizeMake(0, 3);
    
    //底部条
    UIView *shadowView = [[UIView alloc]init];
//    shadowView.backgroundColor = btn_dark_color;
    [self addSubview:shadowView];
    [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
        make.width.equalTo(lastView.mas_width);
        make.height.equalTo(@2);
        make.left.equalTo(@0);
    }];
    _shadowView = shadowView;
}

// AutoLayout下的选中处理
- (void)choiceActionButton2:(UIButton *)sender
{
    if (sender.tag == _currentClickIndex) {
        //防止二次点击
        return;
    }
    
    self.currentClickIndex = sender.tag;
    [sender setSelected:YES];
    

    //动画结束后调用回调事件
    [UIView animateWithDuration:0.15 animations:^{
        // 更新动画
        [_shadowView mas_updateConstraints:^(MASConstraintMaker *make) {
            // 调整左侧距离
            make.left.equalTo(@(sender.frame.origin.x));
        }];
         [_shadowView.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        [_delegate messageChoiceView:self sender:sender];
    }];
}


@end






