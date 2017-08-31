//
//  AMDAnimationWebView.h
//  AppMicroDistribution
//  带动画的webView
//  Created by SunSet on 15-5-21.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <SSBaseKit/AMDWebViewDelegate.h>
#import <SSBaseKit/AMDBaseView.h>


@interface AMDAnimationWebView : AMDBaseView


@property(nonatomic, copy) NSString *requestWithSignURL;
@property(nonatomic, weak) UILabel *websiteLabel;                       //网址标签
@property(nonatomic, weak) UIProgressView *progressView;                //加载的进度条

/* 自定义的扩展的userAgent  */
@property(nonatomic, copy) NSString *extraUserAgent;


/**
 是否可以预加载
 * aUrlRequest url请求的request
 * continueLoad 是否允许继续执行加载
 * return 是否可以预加载
 */
@property(nonatomic, copy) BOOL (^shouldStartLoad)(WKWebView *webView,NSURLRequest *aUrlRequest, BOOL *continueLoad);

// 在当前webView中所有的a链接跳转新页面 默认NO
//@property(nonatomic) BOOL linkNewPageFunction;
// webView的代理
@property(nonatomic, weak) id<AMDWebViewDelegate> delegate;
// 加载到的控制器
@property(nonatomic, weak) UIViewController *controller;


@property(nonatomic, strong, readonly) WKWebView *wkWebView;                      //webView

/**
  WKWebView页面加载完成之后的事件
 */
@property(nonatomic, copy) void (^finishLoadAction_WK)(WKWebView *webView) NS_AVAILABLE_IOS(8_0);

/**
 WKWebView刷新后的事件
 */
@property(nonatomic, copy) void (^reloadAction_WK)(WKWebView *webView);




@property(nonatomic, strong, readonly) UIWebView *uiWebView;                      //webView
/**
 UIWebView页面加载完成之后的事件
 */
@property(nonatomic, copy) void (^finishLoadAction_UI)(UIWebView *webView);

/**
 UIWebView刷新后的事件
 */
@property(nonatomic, copy) void (^reloadAction_UI)(UIWebView *webView) NS_AVAILABLE_IOS(8_0);


#pragma mark - 是否支持刷新
@property(nonatomic) BOOL supportRefresh;




@end








