//
//  AMDLabelTextView.h
//  AppMicroDistribution
//  左侧label 右侧textView(自动换行)
//  Created by SunSet on 16-5-30.
//  Copyright (c) 2016年 SunSet. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AMDLabelTextView;
@protocol AMDLabelTextViewDelegate <NSObject>

- (void)AMDLabelTextView:(AMDLabelTextView *)view heightDidChange:(CGFloat)height;

@end

@interface AMDLabelTextView : UIView

@property (nonatomic, weak) id<AMDLabelTextViewDelegate> delegate;
@property(nonatomic, strong, readonly) UILabel *titleLabel;          //标题
@property(nonatomic, strong, readonly) UITextView *textView;       //详细内容
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;

//父视图---注：当父视图为滑动视图的时候可用,默认不可用
@property(nonatomic, weak) UIScrollView *parentScrollView;

// 实例化
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title;
@end


















