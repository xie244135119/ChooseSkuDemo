//
//  AMDTabbarItem.h
//  AppMicroDistribution
//
//  Created by SunSet on 15-5-21.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMDTabbarItem : UIControl


// 显示的标题
//@property(nonatomic,copy) NSString *title;
@property(nonatomic,readonly,weak) UILabel *itemTitleLabel;

// 显示的图片
//@property(nonatomic,strong,readonly) UIImage *itemImage;
@property(nonatomic,strong) UIImage *itemSelectImage;
@property(nonatomic,readonly,weak) UIImageView *itemImageView;

// 支持选中动画
@property(nonatomic) BOOL supportAnimation;
// 有消息提示 默认不展示
//@property(nonatomic) BOOL hasNewRemind;
// 设置提醒数量  0不显示 -2 显示红点 其余正常显示
@property(nonatomic, assign) NSInteger remindNumber;

// 根据不同的状态设置不同的图片
- (void)setImage:(UIImage *)image controlState:(UIControlState)state;

// 根据不同的状态设置不同
- (void)setTitleColor:(UIColor *)titleColor controlState:(UIControlState)state;

// 显示消息数量
//- (void)showMessageCount:(NSInteger)count;




#pragma mark - 支持消息数量功能
//- (void)supportMessageCountObserver;

@end









