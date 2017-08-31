//
//  AMDLabelTextView.m
//  AppMicroDistribution
//
//  Created by SunSet on 16-5-30.
//  Copyright (c) 2016年 SunSet. All rights reserved.
//

#import "AMDLabelTextView.h"
#import "SSGlobalVar.h"
//#import "NSObject+BindValue.h"

@interface AMDLabelTextView ()
@property(nonatomic, strong, readwrite) UILabel *titleLabel;
@property(nonatomic, strong, readwrite) UITextView *textView;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic) BOOL once;
@end

@implementation AMDLabelTextView

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"textView.text"];
    [self removeObserver:self forKeyPath:@"textView.contentSize"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViewWithTitle:nil];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title
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
    self.clipsToBounds = YES;
    CGFloat h = self.frame.size.height;
//    CGFloat w = self.frame.size.width;
    // 标题
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 140, h)];
    titleLable.backgroundColor = [UIColor clearColor];
    titleLable.text = title;
    titleLable.font = SSFontWithName(@"", 14);
    titleLable.textColor = SSColorWithRGB(51, 51, 51, 1);
    [self addSubview:titleLable];
    self.titleLabel = titleLable;
    
    // 显示框
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(100, 0, 100, 1)];
    if ([textView respondsToSelector:@selector(setReturnKeyType:)]) {
        textView.returnKeyType = UIReturnKeyDone;
    }
    textView.font = SSFontWithName(@"", 14);
    [self addSubview:textView];
    self.textView = textView;
    
    [self addObserver:self forKeyPath:@"textView.text" options:NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:@"textView.contentSize" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange:) name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:nil];
}

- (void)layoutSubviews
{
    if (self.once) {
        return;
    }
    self.once = YES;
    CGSize size = self.textView.contentSize;
    CGFloat h = self.frame.size.height;
    CGFloat pointSize = self.textView.font.pointSize + 9.5*2;
    CGFloat textViewH = pointSize > size.height ? pointSize : size.height;
    textViewH = textViewH > self.frame.size.height ? self.frame.size.height : textViewH;
    self.textView.frame = CGRectMake(95, (h-textViewH)/2+5/2, CGRectGetWidth(self.frame)-100-10, textViewH);
    [self.textView setContentOffset:CGPointZero animated:YES];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"textView.text"]) {
        if (self.textView.text.length > 0) {
            self.placeholderLabel.hidden = YES;
        } else {
            self.placeholderLabel.hidden = NO;
        }
    } else {
        
        CGSize size = [change[NSKeyValueChangeNewKey] CGSizeValue];
        CGSize oldSize = [change[NSKeyValueChangeOldKey] CGSizeValue];
        if (self.delegate) {
            [self.delegate AMDLabelTextView:self heightDidChange:size.height];
        }
        
        
        
        CGFloat h = self.frame.size.height;
        CGFloat pointSize = self.textView.font.pointSize + 9.5*2;
        CGFloat textViewH = pointSize > size.height ? pointSize : size.height;
        textViewH = textViewH > self.frame.size.height ? self.frame.size.height : textViewH;
        if (!(textViewH > h && !self.delegate)) {
            self.textView.frame = CGRectMake(95, (h-textViewH)/2+5/2, CGRectGetWidth(self.frame)-100-10, textViewH);
            if (size.height > oldSize.height) {
                [self.textView setContentOffset:CGPointZero animated:YES];
            }
        }
    }
}

- (void)textViewDidBeginEditing:(NSNotification *)noti
{
    id obj = [noti object];
    if (obj != self.textView) {
        return;
    }
    if (_parentScrollView == nil) {
        return;
    }
//    [_parentScrollView bindValue:textView forKey:AASFirstResponderViewKey];
    
    CGRect frame = [_parentScrollView.superview convertRect:self.textView.frame fromView:self.textView.superview];
    CGFloat distance = (frame.size.height+frame.origin.y+256+30)-_parentScrollView.frame.size.height;
    // > 0 说明当前输入框被遮住
    if (distance > 0) {
        CGPoint oldpoint = _parentScrollView.contentOffset;
        oldpoint.y += distance;
        [_parentScrollView setContentOffset:oldpoint animated:YES];
    }
}

- (void)textViewDidChange:(NSNotification *)noti
{
    id obj = [noti object];
    if (obj != self.textView) {
        return;
    }
    if (self.textView.text.length > 0) {
        self.placeholderLabel.hidden = YES;
    } else {
        self.placeholderLabel.hidden = NO;
    }
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    if (_placeholder) {
        if (!self.placeholderLabel) {
            self.placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 7, CGRectGetWidth(self.textView.frame), 19)];
            self.placeholderLabel.font = self.textView.font;
            self.placeholderLabel.textColor = SSColorWithRGB(119, 119, 119, 1);
            [self.textView addSubview:self.placeholderLabel];
        }
        self.placeholderLabel.text = placeholder;
    }
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    self.placeholderLabel.textColor = placeholderColor;
}

@end








































