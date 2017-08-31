//
//  AMDButton.h
//  AppMicroDistribution
//  自定义按钮
//  Created by SunSet on 15-5-20.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMDButton : UIControl



@property(nonatomic, readonly) UIImageView *imageView;   //文本名称
@property(nonatomic, weak) UILabel *titleLabel;      //文字label


// 根据不同状态配置不同的颜色
- (void)setTitleColor:(UIColor *)titlecolor forState:(UIControlState)state;
// 根据按钮不同状态配置背景色 背景色为nil的时候 默认开始蒙版选中
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;
//根据不同的状态配置不同的图片
- (void)setImage:(UIImage *)image forState:(UIControlState)state;
// 支持Image2 AutoLayout
- (void)setImage2:(UIImage *)image forState:(UIControlState)state;

//设置文字
- (void)setTitle:(NSString *)title forState:(UIControlState)state;
// 根据不同状态设置描边颜色
- (void)setBorderColor:(UIColor *)color forState:(UIControlState)state;


#pragma mark - 支持右上角数字
// 支持提示数字(自动布局下的右上角数字支持)
- (void)supportRemindNumber;
// 设置或获取未读数量
- (void)setUnreadCount:(NSInteger)unreadcount;
- (NSInteger)unreadCount;




#pragma mark - 加载网络图片
- (void)setImageWithUrl:(NSURL *)url
            placeHolder:(UIImage *)placeHolder;
- (void)setImageWithUrl:(NSURL *)url
            placeHolder:(UIImage *)placeHolder
             completion:(void (^)(UIImage *, NSError *))completion;


- (void)setImageWithPath:(NSString *)path
             placeHolder:(UIImage *)placeHolder;
- (void)setImageWithPath:(NSURL *)url
             placeHolder:(UIImage *)placeHolder
              completion:(void (^)(UIImage *, NSError *))completion;


// 设置背景图片
- (void)setBackgroundImageWithUrl:(NSURL *)url
                      placeHolder:(UIImage *)placeHolder
                         forState:(UIControlState)state;
- (void)setBackgroundImageWithUrl:(NSURL *)url
                      placeHolder:(UIImage *)placeHolder
                         forState:(UIControlState)state
                       completion:(void (^)(UIImage *, NSError *))completion;

@end
















