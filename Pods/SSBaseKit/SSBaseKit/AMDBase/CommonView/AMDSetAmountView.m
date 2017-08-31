//
//  AMDSetAmountView.m
//  AppMicroDistribution
//
//  Created by SunSet on 15-5-26.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import "AMDSetAmountView.h"
#import "SSGlobalVar.h"
#import <Masonry/Masonry.h>

@interface AMDSetAmountView() <UITextFieldDelegate>
{
    BOOL _isAutoLayout;             //自动布局
    
    //  记录父视图滑动之前的偏移量
    CGPoint _beginOffset;            //之前的偏移量<如果父视图为scrollview> 如果为普通视图，则为中心位置
}
@end

@implementation AMDSetAmountView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _maxStoreAmount = -1;
        
        if (_isAutoLayout) {
            [self initContentView_autoLayout];
        }
        else{
            [self initContentView];
        }
    }
    return self;
}

- (id)init
{
    _isAutoLayout = YES;
    return [super init];
}


- (void)initContentView
{
    self.layer.borderWidth = 1;
    self.layer.borderColor = [SSLineColor CGColor];
    self.layer.cornerRadius = 2;
    self.layer.masksToBounds = YES;
    
    CGFloat h = self.frame.size.height;
    CGFloat w = self.frame.size.width;
    
    //减少按钮
    UIButton *reducecountbt = [UIButton buttonWithType:UIButtonTypeCustom];
    [reducecountbt setBackgroundColor:SSColorWithRGB(242, 242, 242, 1)];
    [reducecountbt setBackgroundImage:SSImageFromName(@"store_minus.png") forState:UIControlStateNormal];
    [reducecountbt setBackgroundImage:SSImageFromName(@"store_minus-hover.png") forState:UIControlStateHighlighted];
    [reducecountbt setFrame:CGRectMake(0, 0, h, h)];
    reducecountbt.tag = 1;
    [reducecountbt addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:reducecountbt];
    
    //增加按钮
    UIButton *addcountbt = [UIButton buttonWithType:UIButtonTypeCustom];
    [addcountbt setFrame:CGRectMake(w-h, 0, h, h)];
    [addcountbt setBackgroundColor:SSColorWithRGB(242, 242, 242, 1)];
    [addcountbt setBackgroundImage:SSImageFromName(@"store_add.png") forState:UIControlStateNormal];
    [addcountbt setBackgroundImage:SSImageFromName(@"store_add-hover.png") forState:UIControlStateHighlighted];
    addcountbt.tag = 2;
    [addcountbt addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addcountbt];
    
    //数量显示
    UITextField *countfield = [[UITextField alloc]initWithFrame:CGRectMake(h, 0, w-2*h, h)];
    countfield.textAlignment = NSTextAlignmentCenter;
    countfield.borderStyle = UITextBorderStyleNone;
    countfield.keyboardType = UIKeyboardTypeNumberPad;
    countfield.delegate = self;
//    countfield.layer.borderWidth =1;
    [self addSubview:countfield];
    _amountField = countfield;
    countfield.text = @"1";
}


- (void)initContentView_autoLayout
{
    self.layer.borderWidth = 1;
    self.layer.borderColor = [SSLineColor CGColor];
    self.layer.cornerRadius = 2;
    self.layer.masksToBounds = YES;
    
//    CGFloat h = self.frame.size.height;
//    CGFloat w = self.frame.size.width;
    
    //减少按钮
    UIButton *reducecountbt = [UIButton buttonWithType:UIButtonTypeCustom];
    [reducecountbt setBackgroundImage:SSImageFromName(@"store_minus.png") forState:UIControlStateNormal];
    [reducecountbt setBackgroundImage:SSImageFromName(@"store_minus-hover.png") forState:UIControlStateHighlighted];
    [reducecountbt setBackgroundColor:SSColorWithRGB(242, 242, 242, 1)];
    reducecountbt.tag = 1;
    [reducecountbt addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:reducecountbt];
    [reducecountbt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.mas_height);
        make.left.top.equalTo(@0);
    }];
    
    //增加按钮
    UIButton *addcountbt = [UIButton buttonWithType:UIButtonTypeCustom];
//    [addcountbt setFrame:CGRectMake(w-h, 0, h, h)];
    [addcountbt setBackgroundColor:SSColorWithRGB(242, 242, 242, 1)];
    [addcountbt setBackgroundImage:SSImageFromName(@"store_add.png") forState:UIControlStateNormal];
    [addcountbt setBackgroundImage:SSImageFromName(@"store_add-hover.png") forState:UIControlStateHighlighted];
    addcountbt.tag = 2;
    [addcountbt addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addcountbt];
    [addcountbt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.mas_height);
        make.right.top.equalTo(@0);
    }];
    
    //数量显示
    UITextField *countfield = [[UITextField alloc]init];
    countfield.textAlignment = NSTextAlignmentCenter;
    countfield.borderStyle = UITextBorderStyleNone;
    countfield.keyboardType = UIKeyboardTypeNumberPad;
    countfield.delegate = self;
    //    countfield.layer.borderWidth =1;
    [self addSubview:countfield];
    _amountField = countfield;
    countfield.text = @"1";
    [countfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.mas_height);
        make.top.equalTo(@0);
        make.left.equalTo(reducecountbt.mas_right).with.offset(0);
        make.right.equalTo(addcountbt.mas_left).with.offset(0);
    }];
}


- (void)setAmount:(NSInteger)amount
{
    _amount = amount;
    
    // 显示文本
    _amountField.text = [[NSString alloc]initWithFormat:@"%li",(long)amount];
}



#pragma mark - 按钮事件
- (void)clickAction:(UIButton *)sender
{
    switch (sender.tag) {
        case 1:{ //减少
            if (_amountField.text.intValue == _minStoreAmount) {
                return;
            }
            _amountField.text = [NSString stringWithFormat:@"%lli",_amountField.text.longLongValue-1];
            _amount--;
            [self.amountField sendActionsForControlEvents:UIControlEventValueChanged];
        }
            break;
        case 2://增加
            if (_amountField.text.intValue >= _maxStoreAmount && _maxStoreAmount != -1) {
//                [AMDUIFactory makeToken:nil message:@"已到最大库存数量"];
                return;
            }
            _amountField.text = [NSString stringWithFormat:@"%lli",_amountField.text.longLongValue+1];
            _amount++;
            [self.amountField sendActionsForControlEvents:UIControlEventValueChanged];
            break;
        default:
            break;
    }
}



#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([_offSetView respondsToSelector:@selector(contentOffset)]) {
        _beginOffset = [(UIScrollView *)_offSetView contentOffset];
    }
    else {
        _beginOffset = _offSetView.center;
    }
    
    //键盘弹出--设置视图偏移
    [self setOffsetForTextField:textField ParentView:_offSetView];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // 键盘弹出--恢复默认视图偏移
    if ([_offSetView respondsToSelector:@selector(contentOffset)]) {
        // 滚动视图不作任何处理
        [(UIScrollView *)_offSetView setContentOffset:_beginOffset animated:YES];
    }
    else{
        [UIView animateWithDuration:0.25 animations:^{
            _offSetView.center = _beginOffset;
        }];
    }
    
    //超过最大数值的时候
    if (textField.text.doubleValue > _maxStoreAmount && _maxStoreAmount != -1) {
//        [AMDUIFactory makeToken:nil message:@"不能超过最大库存"];
        textField.text = [NSString stringWithFormat:@"%li",(long)_maxStoreAmount];
    }
    
    //不能超过最小数值
    if (textField.text.doubleValue < _minStoreAmount && _minStoreAmount != 0) {
        textField.text = [NSString stringWithFormat:@"%li",(long)_minStoreAmount];
    }
    
    // 当前最新值
    _amount = textField.text.integerValue;
    
    // 文本内容改变--利用消息通知(早先设定)
    [_amountField sendActionsForControlEvents:UIControlEventValueChanged];
}




#pragma mark - private api
// 设置自动偏移量
- (void)setOffsetForTextField:(UIView *)textField ParentView:(UIView *)scrollView
{
    CGRect frame = [scrollView.superview convertRect:textField.frame fromView:textField.superview];
    CGFloat distance = (frame.size.height+frame.origin.y+256+30)-scrollView.frame.size.height;
    // > 0 说明当前输入框被遮住
    if (distance > 0) {
        if ([scrollView respondsToSelector:@selector(contentOffset)]) {
            CGPoint oldpoint = [(UIScrollView *)scrollView contentOffset];
            oldpoint.y += distance;
            [(UIScrollView *)scrollView setContentOffset:oldpoint animated:YES];
        }
        else {
            CGPoint oldcenter = scrollView.center;
            oldcenter.y -= distance;
            
            [UIView animateWithDuration:0.25 animations:^{
                scrollView.center = oldcenter;
            }];
        }
    }
}




@end













