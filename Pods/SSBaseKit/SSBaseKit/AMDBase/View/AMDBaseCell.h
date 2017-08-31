//
//  AMDBaseCell.h
//  AppMicroDistribution
//  父类单元格
//  Created by SunSet on 15-5-20.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMDBaseCell : UITableViewCell



/*
 * 下方的属性只有当可以支持滑动的时候才可用
 *  supportSlide 是否支持cell滑动  默认不支持
 *  当cell支持滑动的时候,视图需要添加到    contentInfoView 上面
 *  rightSlideView 当支持cell滑动的时候,显示的视图
 *  注： tableView 属性必须要设置
 */
@property(nonatomic,weak) UIView *contentInfoView;      //自定义内部视图
@property(nonatomic,weak) UIView *rightSlideView;       //右侧编辑视图
@property(nonatomic,weak) UIPanGestureRecognizer *slidePanGestureRecognizer; //滑动手势
@property(nonatomic,weak) UITableView *tableView;       //绑定的表单
@property(nonatomic) BOOL isInEditing;                  //当前单元格是否处于编辑状态



// 根据需要返回实例方法
// 仅当需要实现滑动效果的时候需要使用的返回实例化
- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
       supportSlide:(BOOL)supportSlide
          cellFrame:(CGRect)frame;

// 恢复cell初始状态
- (void)reset;

// 隐藏遮挡视图
- (void)hideHitView;

@end



