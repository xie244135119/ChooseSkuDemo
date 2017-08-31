//
//  AMDCopyLabel.m
//  AppMicroDistribution
//
//  Created by SunSet on 15-5-20.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import "AMDCopyLabel.h"
//#import "AppDelegate.h"

@implementation AMDCopyLabel
{
    UIColor *_orignTextColor;            //原始的文字颜色
}

- (void)dealloc
{
    _orignTextColor = nil;
    self.customCopyStr = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

// 可以响应的方法
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return (action == @selector(menuItemCopy:)) || (action == @selector(menuItemCollect:)) || (action == @selector(menuItemJoin:)) || (action == @selector(menuItemTransmit:));
}

//针对于响应方法的实现
/*-(void)copy:(id)sender
{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.text;
    self.textColor = _orignTextColor;
}*/


//UILabel默认是不接收事件的，我们需要自己添加touch事件
-(void)attachTapHandler
{
    self.userInteractionEnabled = YES;  //用户交互的总开关
//    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
//    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognizer:)];
    //    press
//    [self addGestureRecognizer:press];
}

//绑定事件
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        
    }
    return self;
}

// 支持复制功能
- (void)supportCopyFunction
{
    if (_responderView == nil) {
        self.responderView = self;
    }
    
    self.userInteractionEnabled = YES;
    //通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuControllerWillHide:) name:UIMenuControllerWillHideMenuNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuControllerWillShow:) name:UIMenuControllerWillShowMenuNotification object:nil];
}


#pragma mark - SET
- (void)setResponderView:(UIView *)responderView
{
    if (_responderView != responderView) {
        _responderView = responderView;
        
        UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognizer:)];
        [responderView addGestureRecognizer:press];
    }
}


#pragma mark - 手势页面
/*-(void)handleTap:(UIGestureRecognizer*) recognizer
{
    [self becomeFirstResponder];
    if (_orignTextColor == nil) {
        _orignTextColor = [self.textColor copy];
    }
    //复制选中色
//    self.textColor = SSColorWithRGB(11, 137, 226, 1);
    //    self.backgroundColor = [UIColor lightGrayColor];
    
    //    UIMenuItem *copyLink = [[UIMenuItem alloc] initWithTitle:nil action:@selector(copy:)];
    //默认复制
    [[UIMenuController sharedMenuController] setMenuItems:nil];

    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = self.lineBreakMode;
    style.lineSpacing = 5;
    NSDictionary *att = @{NSFontAttributeName:self.font,NSParagraphStyleAttributeName:style};
    CGRect textrect = [self.text boundingRectWithSize:self.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:att context:nil];
    CGSize size = textrect.size;
    CGRect frame = CGRectMake(self.frame.origin.x+self.frame.size.width-size.width, self.frame.origin.y, size.width, self.frame.size.height);
    [[UIMenuController sharedMenuController] setTargetRect:frame inView:self.superview];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated: YES];
}*/


#pragma mark - 通知页面
//menuitem隐藏
- (void)menuControllerWillHide:(NSNotification *)noti
{
//    self.textColor = _orignTextColor;
    //    self.backgroundColor = [UIColor clearColor];
}

- (void)menuControllerWillShow:(NSNotification *)noti
{
    //    self.textColor = _orignTextColor;
    //    self.backgroundColor = [UIColor clearColor];
}


// 长按复制
- (void)longPressGestureRecognizer:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        
        UIMenuItem * itemPase = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(menuItemCopy:)];
        UIMenuController * menuController = [UIMenuController sharedMenuController];
        [menuController setMenuItems: @[itemPase]];
        // 将当前标签的值转化为屏幕上
        CGPoint location = CGPointMake(_responderView.frame.size.width/2, 0);
        CGRect menuLocation = CGRectMake(location.x, location.y, 0, 0);
        [menuController setTargetRect:menuLocation inView:[recognizer view]];
        menuController.arrowDirection = UIMenuControllerArrowDown;
        [menuController setMenuVisible:YES animated:YES];
    }
}

// 复制
- (void)menuItemCopy:(UIMenuItem *)menuItem
{
    NSLog(@" 复制 ");
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _customCopyStr?_customCopyStr:self.text;
}

// 转发
- (void)menuItemTransmit:(UIMenuItem *)menuitem
{
    NSLog(@" 转发 ");
}

// 收藏
- (void)menuItemCollect:(UIMenuItem *)menuitem
{
    NSLog(@" 收藏 ");
}

// 加入
- (void)menuItemJoin:(UIMenuItem *)menuItem
{
    NSLog(@" 加入 ");
}



#pragma mark - 自适应Api

- (CGSize)calculateSize
{
    return [self calculateSizeWithLineSpace:3];
}

- (CGSize)calculateSizeWithLineSpace:(CGFloat)lineSpace {
    CGFloat lineS = lineSpace;
    CGSize size;
    NSMutableAttributedString *attString = self.attributedText.mutableCopy;
    if (!attString && self.text.length > 0) {
        attString = [[NSMutableAttributedString alloc] initWithString:self.text];
    } else {
        return CGSizeZero;
    }
    if (!(lineS > 0)) {
        lineS = 3;
    }
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineSpacing = lineS;
    [attString addAttribute:NSParagraphStyleAttributeName value:[style copy] range:NSMakeRange(0, attString.string.length)];
    self.attributedText = attString.copy;
    size = [self.attributedText boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    size.height += 5;
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
    return size;
}








@end









