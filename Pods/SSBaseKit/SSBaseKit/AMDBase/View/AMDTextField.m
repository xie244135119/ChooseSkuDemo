//
//  AMDTextField.m
//  AppMicroDistribution
//
//  Created by SunSet on 15-10-26.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import "AMDTextField.h"

@interface AMDTextField() <UITextFieldDelegate>

@end

@implementation AMDTextField

- (void)dealloc
{
    if (_maxInputChars != 0) {
        [self _removeObserver];
    }
}



- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _supportPaste = YES;
        _supportCut = YES;
    }
    return self;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if(action == @selector(paste:))
    {
        return _supportPaste;
    }
    else if (action == @selector(cut:)){
        return _supportCut;
    }
    return [super canPerformAction:action withSender:sender];
}


#pragma mark - SET
//
- (void)setMaxInputChars:(NSInteger)maxInputChars
{
    if (maxInputChars != 0) {
        _maxInputChars = maxInputChars;
        
        // 添加监听
        [self _addTextOberver];
    }
}



#pragma mark - 添加监听
// 添加文字监听
- (void)_addTextOberver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_textDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    // 防止子类实现调用
//    [self addObserver:self forKeyPath:@"delegate" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
//    self.delegate = self;
}


- (void)_removeObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [self removeObserver:self forKeyPath:@"delegate"];
    
}


//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
//{
//    if ([keyPath isEqualToString:@"delegate"]) {
//        
//    }
//}


#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // 不做限制
    if (_maxInputChars == 0) {
        return YES;
    }
    
    // 删除的时候
    if (string.length == 0) {
        return YES;
    }
    

    // 如果目前文本内容的数量已经达到限制数
    CGFloat originlength = [self byteLengthFromText:textField.text];
    if (originlength >= _maxInputChars) {
        return NO;
    }
    
    // 判断两者之和是否超过限制数
    NSString *text = [textField.text stringByAppendingString:string];
    CGFloat length = [self byteLengthFromText:text];
    // 未达到限制
    if (length <= _maxInputChars) {
        return YES;
    }
    
    // 达到限制 做截断处理
    // 计算空余的字节数量
    NSInteger reduce = _maxInputChars-originlength;
    NSString *reuceText = [string substringToIndex:reduce];
    textField.text = [textField.text stringByAppendingPathComponent:reuceText];
    
    return NO;
}




// 文本改变时候的处理事件 如粘贴的时候
- (void)_textDidChange:(NSNotification *)notification
{
 
    if (_maxInputChars == 0) {
        return;
    }
    
    CGFloat bytelength = [self byteLengthFromText:self.text];
    if (bytelength > _maxInputChars) {
        // 做截断处理
        // 计算超出限制的字节部分
//        CGFloat reducelength = bytelength-_maxInputChars;
        
        // 如果是为0.5的奇数倍 例 1.5 说明全部字节数为整数
        // 如果为0.5的整数倍 例0.5 说明字节中含有英文
        // 1.5 应该去掉 最后的1个中文或最后两者英文
        
        NSString *content = [self subStrWithUtf8Len:_maxInputChars text:self.text];
        self.text = content;
    }
}


#pragma mark - private api
// 字节长度
- (CGFloat)byteLengthFromText:(NSString *)text
{
    if (text.length == 0)   return 0;
    
    CGFloat resault = 0;
    for (int i =0; i<text.length;i++) {
        NSString *sendertext = [text substringWithRange:NSMakeRange(i, 1)];
        resault += ([self isChinese:sendertext])?1:0.5;
    }
    return resault;
    
//    NSInteger bytelength = [text lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
//    // 在UTF8编码中，一个英文字母占用1个字节，一个汉字会占用3个字节
//    // 文字长度
//    CGFloat length = bytelength- (bytelength - text.length) / 2;;
//    // 文字占用字节 英文占用字节
//    length = (length+1)/2;
//    return length;
}


// 截断处理
- (NSString *)subStrWithUtf8Len:(NSInteger)length
                           text:(NSString *)text
{
    CGFloat resault = 0;
    NSMutableString *string = [[NSMutableString alloc]init];
    for (int i =0; i<text.length-1;i++) {
        NSString *sendertext = [text substringWithRange:NSMakeRange(i, 1)];
        resault += ([self isChinese:sendertext])?1:0.5;
        if (resault > length) {
            break;
        }
        
        [string appendString:sendertext];
    }
    return string;
}


// 是否为中文
-(BOOL)isChinese:(NSString *)str
{
    NSInteger count = str.length;
    NSInteger result = 0;
    for(int i=0; i< [str length];i++)
    {
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)//判断输入的是否是中文
        {
            result++;
        }
    }
    if (count == result) {//当字符长度和中文字符长度相等的时候
        return YES;
    }
    return NO;
}









@end











