//
//  AMDNoDataView.h
//  AppMicroDistribution
//  没有数据手显示的视图(高度260)
//  Created by SunSet on 15-7-2.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMDButton.h"


@protocol AMDNoDataViewDelegate;

@interface AMDNoDataView : UIView

// 委托实例
@property(nonatomic, weak) id<AMDNoDataViewDelegate> delegate;
// 无数据类型 注：必须设置
//@property(nonatomic, assign) AMDNoDataViewType nodataType;
// 文本展示
@property(nonatomic, weak) UILabel *titleLabel;
// 图像视图
@property(nonatomic, weak) UIImageView *nodataImageView;
// 显示按钮
@property(nonatomic, weak) AMDButton *operationBt;

@end




@protocol AMDNoDataViewDelegate <NSObject>

@optional
/**
 *  代理方法---只对有回调的按钮处理
 *
 *  @param view  当前实例本身
 *  @param index 按钮 从1开始
 */
- (void)noDataView:(AMDNoDataView *)view senderIndex:(NSInteger)index;

@end












