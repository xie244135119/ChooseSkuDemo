//
//  AMDWebViewDelegate.h
//  AppMicroDistribution
//
//  Created by Fuerte on 16/9/7.
//  Copyright © 2016年 SunSet. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AMDWebViewDelegate <NSObject>

@optional
//#ifdef __IPHONE_8_0

// 8.0以上
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler NS_AVAILABLE_IOS(8_0);
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation NS_AVAILABLE_IOS(8_0);
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error NS_AVAILABLE_IOS(8_0);


//#else

// 7.0-8.0 使用
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
- (void)webViewDidStartLoad:(UIWebView *)webView;
- (void)webViewDidFinishLoad:(UIWebView *)webView;
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error;

//#endif

@end

NS_ASSUME_NONNULL_END



