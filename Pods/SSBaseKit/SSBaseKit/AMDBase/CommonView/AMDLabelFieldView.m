//
//  AMDLabelFieldView.m
//  AppMicroDistribution
//
//  Created by SunSet on 15-5-20.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import "AMDLabelFieldView.h"
#import "SSGlobalVar.h"

@interface AMDLabelFieldView()

@end

@implementation AMDLabelFieldView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViewWithTitle:nil];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title
{
    if (self = [super initWithFrame:frame]) {
        [self initViewWithTitle:title];
    }
    return self;
}

//视图加载
- (void)initViewWithTitle:(NSString *)title
{
    self.backgroundColor = [UIColor whiteColor];
    
    CGFloat h = self.frame.size.height;
    CGFloat w = self.frame.size.width;
    // 标题
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 140, h)];
    titleLable.backgroundColor = [UIColor clearColor];
    titleLable.text = title;
    titleLable.font = SSFontWithName(@"", 14);
    titleLable.textColor = SSColorWithRGB(51, 51, 51, 1);
    [self addSubview:titleLable];
    _titleLabel = titleLable;
    
    // 显示框
    AMDTextField *field = [[AMDTextField alloc]initWithFrame:CGRectMake(100, (h-30)/2, w-(100)-10, 30)];
    titleLable.text = title;
    field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    field.delegate = self;
    field.clearButtonMode = UITextFieldViewModeWhileEditing;
    [field setValue:SSColorWithRGB(119, 119, 119, 1) forKeyPath:@"_placeholderLabel.textColor"];
    field.borderStyle = UITextBorderStyleNone;
    if ([field respondsToSelector:@selector(setReturnKeyType:)]) {
        field.returnKeyType = UIReturnKeyDone;
    }
    field.font = SSFontWithName(@"", 14);
    [self addSubview:field];
    _textField = field;
    
}

- (void)setRightArrowShow:(BOOL)rightArrowShow
{
    if (_rightArrowShow != rightArrowShow) {
        _rightArrowShow = rightArrowShow;
        
        if (rightArrowShow) {
            _textField.center = CGPointMake(_textField.center.x-24, _textField.center.y);
            UIImage *arrowiamge = SSImageFromName(@"arrow-right.png");
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-24-10, (self.frame.size.height-24)/2, 24, 24)];
            imgView.image = arrowiamge;
            [self addSubview:imgView];
        }
    }
}


#pragma mark - UITextFieldDelegate
//控制当键盘显示的时候
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (_parentScrollView == nil) {
        return;
    }
    
    CGRect frame = [_parentScrollView.superview convertRect:textField.frame fromView:textField.superview];
    CGFloat distance = (frame.size.height+frame.origin.y+256+30)-_parentScrollView.frame.size.height;
    // > 0 说明当前输入框被遮住
    if (distance > 0) {
        CGPoint oldpoint = _parentScrollView.contentOffset;
        oldpoint.y += distance;
        [_parentScrollView setContentOffset:oldpoint animated:YES];
    }
}

//
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField sendActionsForControlEvents:UIControlEventValueChanged];
}

@end





