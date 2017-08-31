//
//  CustomTextView.h
//  Test自动换行的TextView
//  frame
//  Created by SunSet on 14-1-17.
//  Copyright (c) 2014年 SunSet. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomTextViewDelegate <NSObject>

@optional
/*在当前高度发生变化的时候调用*/
- (void)textViewChangeRect:(CGFloat)height;
/** */
- (void)textViewLength:(__weak UITextView *)length;
- (void)customTextViewDidBeginEditing:(UITextView *)textView;
- (void)customTextViewDidEndEditing:(UITextView *)textView;
- (BOOL)customTextViewSend:(UITextView *)textView;

@end

@interface CustomTextView : UITextView


@property(nonatomic,weak) id<CustomTextViewDelegate> custDelegate;
@property(nonatomic,weak) UILabel *placeHolderLabel;        //文本标签
////请输入要输入的文本框
//@property(nonatomic,copy) NSString *placeHolderText;        //placeholder文本
@property(nonatomic,copy) NSString *customText;             //自定的文本
//当前文本框的高度
@property(nonatomic) CGFloat customTextViewHeight;
//最大文字长度
@property(nonatomic) NSInteger maxTextLength;

//父视图
@property(nonatomic,weak) UIScrollView *parentScrollView;

@end






