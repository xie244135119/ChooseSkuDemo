//
//  AMDWebViewProgress.h
//  AppMicroDistribution
//
//  Created by SunSet on 15-5-19.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
//#import "AMDProgressView.h"

typedef void (^AMDWebViewProgressBlock)(float progress);
@protocol AMDWebViewProgressDelegate;

@interface AMDWebViewProgress : NSObject<UIWebViewDelegate>

@property (nonatomic, weak) id<AMDWebViewProgressDelegate>progressDelegate;
@property (nonatomic, weak) id<UIWebViewDelegate>webViewProxyDelegate;
@property (nonatomic, copy) AMDWebViewProgressBlock progressBlock;
@property (nonatomic, readonly) float progress; // 0.0..1.0

- (void)reset;
@end

@protocol AMDWebViewProgressDelegate <NSObject>
@optional
- (void)webViewProgress:(AMDWebViewProgress *)webViewProgress updateProgress:(float)progress;
- (void)webViewDidFinishLoad:(UIWebView *)webView;
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;

@end



@protocol AYEWebViewProgressDelegate;
@interface AYEWebViewProgress : NSObject<UIWebViewDelegate,WKNavigationDelegate>

//#ifdef __IPHONE_8_0
@property (nonatomic, strong) WKWebView *wkWebView NS_AVAILABLE_IOS(8_0);
@property (nonatomic, strong) UIWebView *uiWebView;
//#else
@property (nonatomic, weak) id<UIWebViewDelegate>uiWebViewProxyDelegate;
//#endif

//@property (nonatomic, readonly) float progress; // 0.0..1.0
@property(nonatomic, weak) UIProgressView *progressView;            //进度条
//@property(nonatomic, weak) AMDProgressView *progressView;


// 重置
- (void)reset;

// 退出
- (void)exit;

@end











