//
//  AYEActionSheetView.h
//  AppMicroDistribution
//
//  Created by leo on 16/4/1.
//  Copyright © 2016年 SunSet. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AYEActionSheetView;
@protocol AYEActionSheetViewDelegate <NSObject>

@optional
- (void)AYEActionSheetView:(AYEActionSheetView *)sheetView DidTapWithTitle:(NSString *)title;

- (void)AYEActionSheetView:(AYEActionSheetView *)sheetView DidTapWithIndex:(NSInteger)index;

- (void)AYEActionSheetView:(AYEActionSheetView *)sheetView willDismissWithIndex:(NSInteger)index;

@end

@interface AYEActionSheetView : UIControl


@property (nonatomic, weak, readonly) id<AYEActionSheetViewDelegate> delegate;



/**
 设置字体格式
 */
@property(nonatomic, strong) UIFont *barFont;



/**
 初始化
 
 @param delegate 代理实例
 @param cancelButtonTitle 取消按钮
 @param destructiveButtonTitle 着重按钮
 @param otherButtonTitles 其他按钮
 @return 当前实例
 */
- (instancetype)initWithdelegate:(id<AYEActionSheetViewDelegate>)delegate
               cancelButtonTitle:(NSString *)cancelButtonTitle
          destructiveButtonTitle:(NSString *)destructiveButtonTitle
               otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

- (instancetype)initWithdelegate:(id<AYEActionSheetViewDelegate>)delegate
               cancelButtonTitle:(NSString *)cancelButtonTitle
          destructiveButtonTitle:(NSString *)destructiveButtonTitle
               otherButtonTitles:(NSString *)otherButtonTitles
                            args:(va_list)argList;

- (void)showInView:(UIView *)view;

@end
