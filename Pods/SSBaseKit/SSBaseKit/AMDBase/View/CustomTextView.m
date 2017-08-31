//
//  CustomTextView.m
//  Test自动换行的TextView
//
//  Created by SunSet on 14-1-17.
//  Copyright (c) 2014年 SunSet. All rights reserved.
//

#import "CustomTextView.h"
#import "SSGlobalVar.h"
#import <Masonry/Masonry.h>

@interface CustomTextView()<UITextViewDelegate>
{
    CGFloat _initHeight;
//    __weak UILabel *_placeHolderLabel;      //普通文本
    BOOL _autoLayout;                           //自动布局
}
@end

@implementation CustomTextView

-(void)dealloc
{
//    self.placeHolderText = nil;
    self.customText = nil;
//    self.placeHolderText = nil;
    NSLog(@"%@ %@ ",[self class],NSStringFromSelector(_cmd));
}

// 改变光标位置
- (CGRect)caretRectForPosition:(UITextPosition *)position {
    CGRect originalRect = [super caretRectForPosition:position];
    originalRect.size.height = 18;
//    CGFloat origny = 5;
    // 原始位置
    originalRect.origin.y = originalRect.origin.y+2;
    return originalRect;
}

- (void)layoutSubviews
{
    [self layoutIfNeeded];
    [super layoutSubviews];
}


- (id)init
{
    _autoLayout = YES;
    if (self = [super init]) {
       //
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.borderColor = [SSColorWithRGB(0, 0, 0, 0.15) CGColor];
        self.layer.borderWidth = 0.3;
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
        self.delegate = self;
        
        // 首行缩进
//        self.textContainer.lineFragmentPadding = 0;
//        self.textContainerInset = UIEdgeInsetsMake(5, 0, 5, 0);
        
        if (_autoLayout) {
            [self initContentView2];
        }
        else {
            [self initContentView];
        }
    }
    return self;
}

- (void)initContentView
{
    UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(6, 6,self.frame.size.width-10, 20)];
    lb.backgroundColor = [UIColor clearColor];
    lb.textColor = SSColorWithRGB(153, 153, 153, 1);
    [self addSubview:lb];
    lb.text = @"请输入内容";
    _placeHolderLabel = lb;
    if (self.frame.size.height <= 40) {
        //如果这个textview高度比较小的话
        lb.frame = CGRectMake(6, 0, self.frame.size.width-20, self.frame.size.height);
    }
    
    _initHeight = _customTextViewHeight = self.frame.size.height;
}

- (void)initContentView2
{
    UILabel *lb = [[UILabel alloc]init];
    lb.backgroundColor = [UIColor clearColor];
    lb.font = SSFontWithName(@"", 14);
    lb.textColor = SSColorWithRGB(153, 153, 153, 1);
    [self addSubview:lb];
    lb.text = @"请输入内容";
    _placeHolderLabel = lb;
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@10);
        make.height.equalTo(@20);
//        make.right.equalTo(@(-30));
        make.width.equalTo(@200);
    }];
    
//    if (self.frame.size.height <= 40) {
//        //如果这个textview高度比较小的话
//        lb.frame = CGRectMake(6, 0, self.frame.size.width-20, self.frame.size.height);
//    }
//    
//    _initHeight = _customTextViewHeight = self.frame.size.height;
}


#pragma mark - Set属性
//-(void)setPlaceHolderText:(NSString *)placeHolderText
//{
//    if (_placeHolderText!=placeHolderText) {
//        _placeHolderText=placeHolderText;
//        
//        _placeHolderLabel.text = placeHolderText;
//        _placeHolderLabel.font = self.font;
//    }
//}

//- (void)setText:(NSString *)text
//{
//    [super setText:text];
//    
//    //  判断按文本内容是否可填写
//    
//}


-(void)setCustomTextViewHeight:(CGFloat)customTextViewHeight
{
    if (_customTextViewHeight!=customTextViewHeight) {
        //使用回调
        if([_custDelegate respondsToSelector:@selector(textViewChangeRect:)]){
            [_custDelegate textViewChangeRect:customTextViewHeight-_customTextViewHeight];
        }
        
        _customTextViewHeight = customTextViewHeight;
    }
}

- (void)setCustomText:(NSString *)customText
{
    if (_customText != customText) {
        _customText = customText;
        
        if (customText.length > 0) {
            self.text = customText;
            _placeHolderLabel.alpha = 0;
        }
    }
}

// 重写光标的大小
//- (CGRect)caretRectForPosition:(UITextPosition *)position
//{
//    CGRect originalRect = [super caretRectForPosition:position];
////    originalRect.origin.y -= 2;
//    originalRect.size.height = self.font.lineHeight + 4;
////    originalRect.size.width = 5;
//    return originalRect;
//}


#pragma mark - UITextViewDelegate

/*显示placehodler*/
- (void)textViewDidChange:(UITextView *)textView
{
    _placeHolderLabel.alpha = textView.text.length > 0?0:1;
    if ([_custDelegate respondsToSelector:@selector(textViewLength:)]) {
        [_custDelegate textViewLength:textView];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    CGRect frame = [_parentScrollView.superview convertRect:textView.frame fromView:textView.superview];
    CGFloat distance = (frame.size.height+frame.origin.y+256+30)-_parentScrollView.frame.size.height;
    // > 0 说明当前输入框被遮住
    if (distance > 0) {
        CGPoint oldpoint = _parentScrollView.contentOffset;
        oldpoint.y += distance;
        [_parentScrollView setContentOffset:oldpoint animated:YES];
    }
    
    if ([_custDelegate respondsToSelector:@selector(customTextViewDidBeginEditing:)]) {
        [_custDelegate customTextViewDidBeginEditing:textView];
    }
}


/*- (void)textViewDidChangeSelection:(UITextView *)textView
{
    return;
    
    CGSize textViewSize = [textView.text sizeWithFont:textView.font constrainedToSize:CGSizeMake(textView.frame.size.width-10, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    CGRect rect=textView.frame;
    rect.size.height=(textViewSize.height+20);
    if (rect.size.height<=_initHeight) {
        rect.size.height=_initHeight;
    }
//    if (textViewSize.height<20) {
//        rect.size.height=textViewSize.height+30;
//    }
//    else{
//        rect.size.height=textViewSize.height+20;
//    }
    
    //除过键盘后最大高度
    float maxHeight=[[UIScreen mainScreen] bounds].size.height-216-60-70-40-20;
    rect.size.height=rect.size.height>maxHeight?maxHeight:rect.size.height;
    self.customTextViewHeight=rect.size.height;
    
    textView.frame=rect;
}
 */


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //点击回车结束操作
    if ([text isEqualToString:@"\n"]) {
//        [textView resignFirstResponder];
        if ([_custDelegate respondsToSelector:@selector(customTextViewSend:)]) {
            return [_custDelegate customTextViewSend:textView];
        }
        return NO;
    }
    //当键盘点击删除的时候
    if ([text isEqualToString:@""]){
        return YES;
    }
    
    if (_maxTextLength != 0) {
        //当键盘超过最大限制的时候
        CGFloat width = _maxTextLength+1 - textView.text.length;
        
        if (textView.text.length > _maxTextLength && range.location >= _maxTextLength) {
            return NO;
        }
        //如果文本框中的长度加上字符串的长度太长不行
        if (width < text.length) {
            return NO;
        }
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([_custDelegate respondsToSelector:@selector(customTextViewDidEndEditing:)]) {
        [_custDelegate customTextViewDidEndEditing:textView];
    }
}



@end





