//
//  AMDMultipleTypeView.h
//  AppMicroDistribution
//  多类型视图
//  Created by SunSet on 15-5-21.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AMDMultipleTypeView;

@protocol AMDMultipleTypeChoiceDelegate <NSObject>
@required
//sender:点击的响应控件  tag 按位置来 起始位置:1
- (void)messageChoiceView:(AMDMultipleTypeView * __nullable)view sender:(UIButton * __nullable)sender;
@end


@interface AMDMultipleTypeView : UIView
// 少于4个均分 多于4个滚动

// 委托实例
@property(nonatomic, weak, nullable) id<AMDMultipleTypeChoiceDelegate> delegate;
// 数据源--一组标题
@property(nonatomic, strong,readonly,nullable) NSArray *multitles;
// 设置文本字体大小
@property(nonatomic, strong, nullable) UIFont *titleFont;
// 设置正常时候的文本
@property(nonatomic, strong, nullable) UIColor *textNormalColor;
// 选中时候的文本
@property(nonatomic, strong, nullable) UIColor *textSelectColor;
// 底部阴影颜色
@property(nonatomic, strong, nullable) UIColor *shadowColor;
// 最大阴影显示宽度
@property(nonatomic) CGFloat maxShadowWidth;

/** 当前点击的按钮索引 从1开始 */
@property(nonatomic,assign) NSInteger currentClickIndex;


// 是否支持分割线 默认为NO
@property(nonatomic) BOOL supportSeparatorLine;


/**
 *  @param frame  大小
 *  @param titles 所有标签名称
 *  @return Button
 */
- (nullable instancetype)initWithFrame:(CGRect)frame titles:(nonnull NSArray *)titles;
/**
 *  支持AutoLayout
 *   
 */
- (nullable instancetype)initWithTitles:(nonnull NSArray *)titles;


// 选择某个tab 索引从1开始
- (void)selectChoiceAtIndex:(NSInteger)index;
// 根据需要 返回的按钮 index:索引值(1开始)
- (nullable UIButton *)buttonWithIndex:(NSInteger)index;


+ (CGFloat)defaultHeight;


@end









