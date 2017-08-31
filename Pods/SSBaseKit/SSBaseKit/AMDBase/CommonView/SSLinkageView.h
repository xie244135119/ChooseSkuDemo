//
//  XQLinkageView.h
//  TestScrollView联动效果
//
//  Created by 谢强 on 14-12-2.
//  Copyright (c) 2014年 SunSet. All rights reserved.
//


#import <UIKit/UIKit.h>
@protocol SSLinkageViewDelegate;

@interface SSLinkageView : UIView

@property(nonatomic, weak) id<SSLinkageViewDelegate> delegate;
@property(nonatomic, readonly) UIScrollView *scrollView;                //滚动视图
@property(nonatomic,strong,readwrite) NSArray *imageNameOrURLs;          //图片名称或请求地址
@property(nonatomic,weak) UIPageControl *currentPageControl;            //当前pagecontrol

- (id)initWithFrame:(CGRect)frame imageNames:(NSArray *)imagenames;

//使定时器无效
- (void)invalidate;




/**
 配置滚动时间 默认为5s

 @param time 默认为5s
 */
+ (void)configLinkageTime:(NSInteger)time;



@end



@protocol SSLinkageViewDelegate <NSObject>

@optional
// 点击事件
- (void)linkPageView:(SSLinkageView *)pageView index:(NSInteger)index;

@end











