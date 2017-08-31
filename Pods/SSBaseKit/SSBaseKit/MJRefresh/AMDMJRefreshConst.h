//
//  AMDMJRefreshConst.h
//  AMDMJRefresh
//
//  Created by mj on 14-1-3.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import <UIKit/UIKit.h>

#ifdef DEBUG
#define MJLog(...) NSLog(__VA_ARGS__)
#else
#define MJLog(...)
#endif

// objc_msgSend
#define msgSend(...) ((void (*)(void *, SEL, UIView *))objc_msgSend)(__VA_ARGS__)


#define MJColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
// 文字颜色
#define AMDMJRefreshLabelTextColor MJColor(150, 150, 150)

extern const CGFloat AMDMJRefreshViewHeight;
extern const CGFloat AMDMJRefreshFastAnimationDuration;
extern const CGFloat AMDMJRefreshSlowAnimationDuration;

//extern const CGFloat AMDMJRefreshViewMargin;       //距离上侧的高度
extern const CGFloat AMDMJRefreshLabelHieght;      //label标签的高度

extern NSString *const AMDMJRefreshBundleName;
#define AMDMJRefreshSrcName(file) [AMDMJRefreshBundleName stringByAppendingPathComponent:file]

extern NSString *const AMDMJRefreshFooterPullToRefresh;
extern NSString *const AMDMJRefreshFooterReleaseToRefresh;
extern NSString *const AMDMJRefreshFooterRefreshing;

extern NSString *const AMDMJRefreshHeaderPullToRefresh;
extern NSString *const AMDMJRefreshHeaderReleaseToRefresh;
extern NSString *const AMDMJRefreshHeaderRefreshing;
extern NSString *const AMDMJRefreshHeaderTimeKey;

extern NSString *const AMDMJRefreshContentOffset;
extern NSString *const AMDMJRefreshContentSize;
