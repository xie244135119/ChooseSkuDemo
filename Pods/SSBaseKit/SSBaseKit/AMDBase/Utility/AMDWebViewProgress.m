//
//  AMDWebViewProgress.m
//  AppMicroDistribution
//
//  Created by SunSet on 15-5-19.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import "AMDWebViewProgress.h"

NSString *completeRPCURL = @"webviewprogressproxy:///complete";

static const float initialProgressValue = 0.1;
static const float beforeInteractiveMaxProgressValue = 0.5;
static const float afterInteractiveMaxProgressValue = 0.9;


@implementation AMDWebViewProgress
{
    NSUInteger _loadingCount;
    NSUInteger _maxLoadCount;
    NSURL *_currentURL;
    BOOL _interactive;
}

- (id)init
{
    self = [super init];
    if (self) {
        _maxLoadCount = _loadingCount = 0;
        _interactive = NO;
    }
    return self;
}

- (void)startProgress
{
    if (_progress < initialProgressValue) {
        [self setProgress:initialProgressValue];
    }
}

- (void)incrementProgress
{
    float progress = self.progress;
    float maxProgress = _interactive ? afterInteractiveMaxProgressValue : beforeInteractiveMaxProgressValue;
    float remainPercent = (float)_loadingCount / (float)_maxLoadCount;
    float increment = (maxProgress - progress) * remainPercent;
    progress += increment;
    progress = fmin(progress, maxProgress);
    [self setProgress:progress];
}

- (void)completeProgress
{
    [self setProgress:1.0];
}

- (void)setProgress:(float)progress
{
    // progress should be incremental only
    if (progress > _progress || progress == 0) {
        _progress = progress;
        if ([_progressDelegate respondsToSelector:@selector(webViewProgress:updateProgress:)]) {
            [_progressDelegate webViewProgress:self updateProgress:progress];
        }
        if (_progressBlock) {
            _progressBlock(progress);
        }
    }
}

- (void)reset
{
    _maxLoadCount = _loadingCount = 0;
    _interactive = NO;
    [self setProgress:0.0];
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //    if ([_webViewProxyDelegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
    //        BOOL resault = [_webViewProxyDelegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    //        //如果不允许跳进去页面--直接返回
    //        if (!resault)   return NO;
    //    }
    BOOL ret = YES;
    
    // 加载完成触发的事件
    if ([request.URL.description hasPrefix:@"webviewprogressproxy"]) {
        return YES;
    }
    
    if ([_webViewProxyDelegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        ret = [_webViewProxyDelegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    
    if ([request.URL.absoluteString isEqualToString:completeRPCURL]) {
        [self completeProgress];
        return NO;
    }
    
    BOOL isFragmentJump = NO;
    if (request.URL.fragment) {
        NSString *nonFragmentURL = [request.URL.absoluteString stringByReplacingOccurrencesOfString:[@"#" stringByAppendingString:request.URL.fragment] withString:@""];
        isFragmentJump = [nonFragmentURL isEqualToString:webView.request.URL.absoluteString];
    }
    
    BOOL isTopLevelNavigation = [request.mainDocumentURL isEqual:request.URL];
    
    BOOL isHTTP = [request.URL.scheme isEqualToString:@"http"] || [request.URL.scheme isEqualToString:@"https"];
    if (ret && !isFragmentJump && isHTTP && isTopLevelNavigation && navigationType != UIWebViewNavigationTypeBackForward) {
        _currentURL = request.URL;
        [self reset];
    }
    return ret;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if ([_webViewProxyDelegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [_webViewProxyDelegate webViewDidStartLoad:webView];
    }
    
    _loadingCount++;
    _maxLoadCount = fmax(_maxLoadCount, _loadingCount);
    
    [self startProgress];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if ([_webViewProxyDelegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [_webViewProxyDelegate webViewDidFinishLoad:webView];
    }
    
    if ([_progressDelegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [_progressDelegate webViewDidFinishLoad:webView];
    }
    
    _loadingCount--;
    [self incrementProgress];
    
    NSString *readyState = [webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];
    
    BOOL interactive = [readyState isEqualToString:@"interactive"];
    if (interactive) {
        _interactive = YES;
        NSString *waitForCompleteJS = [NSString stringWithFormat:@"window.addEventListener('load',function() { var iframe = document.createElement('iframe'); iframe.style.display = 'none'; iframe.src = '%@'; document.body.appendChild(iframe);  }, false);", completeRPCURL];
        [webView stringByEvaluatingJavaScriptFromString:waitForCompleteJS];
    }
    
    BOOL isNotRedirect = _currentURL && [_currentURL isEqual:webView.request.mainDocumentURL];
    BOOL complete = [readyState isEqualToString:@"complete"];
    if (complete && isNotRedirect) {
        [self completeProgress];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if ([_webViewProxyDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [_webViewProxyDelegate webView:webView didFailLoadWithError:error];
    }
    
    if ([_progressDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [_progressDelegate webView:webView didFailLoadWithError:error];
    }
    
    _loadingCount--;
    [self incrementProgress];
    
    NSString *readyState = [webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];
    
    BOOL interactive = [readyState isEqualToString:@"interactive"];
    if (interactive) {
        _interactive = YES;
        NSString *waitForCompleteJS = [NSString stringWithFormat:@"window.addEventListener('load',function() { var iframe = document.createElement('iframe'); iframe.style.display = 'none'; iframe.src = '%@'; document.body.appendChild(iframe);  }, false);", completeRPCURL];
        [webView stringByEvaluatingJavaScriptFromString:waitForCompleteJS];
    }
    
    BOOL isNotRedirect = _currentURL && [_currentURL isEqual:webView.request.mainDocumentURL];
    BOOL complete = [readyState isEqualToString:@"complete"];
    if (complete && isNotRedirect) {
        [self completeProgress];
    }
}

#pragma mark -
#pragma mark Method Forwarding
// for future UIWebViewDelegate impl

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature *signature = [super methodSignatureForSelector:selector];
    if(!signature) {
        if([_webViewProxyDelegate respondsToSelector:selector]) {
            return [(NSObject *)_webViewProxyDelegate methodSignatureForSelector:selector];
        }
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation*)invocation
{
    if ([_webViewProxyDelegate respondsToSelector:[invocation selector]]) {
        [invocation invokeWithTarget:_webViewProxyDelegate];
    }
}


@end


// 进度条设计思路
// UIWebView给的should，Did和Finish3个状态来模拟 将要加载的时候进度条走30% 开始加载再走30% Finish的时候再走30% 最后留0.3秒渲染时间 走完10% 走的过程做缓慢走的动画，
@implementation AYEWebViewProgress
{
    NSTimer *_currentTimer;                 //定时器
    CGFloat _currentProgress;               //进度条
}

- (id)init
{
    if (self = [super init]) {
        [self configTimer];
        _currentProgress = 0;
    }
    return self;
}

- (void)dealloc
{
    if ([_wkWebView isKindOfClass:[WKWebView class]]) {
        [_wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    }
    self.wkWebView = nil;
    
    [_currentTimer invalidate];
    _currentTimer = nil;
    
//    NSLog(@" AYEWebViewProgress dealloc ");
}

// 设置进度条
- (void)setProgress:(NSNumber *)progress
{
    if (_currentProgress < progress.floatValue) {
        _currentProgress = [progress floatValue];
    }
    
    // 后续添加的
//    [_progressView setProgress:_currentProgress animated:YES];
//    if (_currentProgress == 1) {
//        [UIView animateWithDuration:.1 animations:^{
//            _progressView.alpha = 0;
//        }];
//    }
    
}


#pragma mark  处理定时器
// 配置定时器
- (void)configTimer
{
    // 这块定时器有点问题
    // 1/60 1帧
    _currentTimer = [NSTimer scheduledTimerWithTimeInterval:0.0167 target:self selector:@selector(progressViewIncrease:) userInfo:nil repeats:YES];
//    _currentTimer = [NSTimer timerWithTimeInterval:0.008 target:self selector:@selector(progressViewIncrease:) userInfo:nil repeats:YES];
//    // 添加到主线程里面
//    [[NSRunLoop mainRunLoop] addTimer:_currentTimer forMode:UITrackingRunLoopMode];
    
    
    // 使用递归代替定时器 执行动画
//    [self updateProgressAnimate];
}


- (void)progressViewIncrease:(NSTimer *)timer
{
    // 如果已完成
    if (_currentProgress == 1) {
        // 定时器失效
        [timer invalidate];
        
        // 0.25s 完成最后的动画
        [UIView animateWithDuration:0.1 animations:^{
            [_progressView setProgress:1 animated:YES];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                _progressView.alpha = 0;
            }];
        }];
        return;
    }
    
    if (_progressView.progress < _currentProgress) {
        // 每次0.01的速度添加
        [_progressView setProgress:(_progressView.progress+=0.01) animated:YES];
//        [_progressView setProgress:(_progressView.progress+=0.08) animated:YES];
    }
}




#pragma mark - 递归执行处理
// 递归执行动画
- (void)updateProgressAnimate
{
    // 更新动画
    [self progressViewIncrease:nil];
    
    // 不再执行递归调用
    if (_currentProgress == 1) {
        return;
    }
    
    [self performSelector:@selector(updateProgressAnimate) withObject:nil afterDelay:0.007];
}




#pragma mark - 开放的API
//
- (void)reset
{
    [self configTimer];
    
    _progressView.alpha = 1;
    
    // 初始化
    [self setProgress:@0];
    _currentProgress = 0;
    [_progressView setProgress:0];
}

- (void)exit
{
    if ([_currentTimer isValid]) {
        [_currentTimer invalidate];
    }
}



#pragma mark - 8.0以上使用最新的WKWebView(以下的方法)
//#ifdef __IPHONE_8_0
- (void)setWkWebView:(WKWebView *)wkWebView
{
    if (_wkWebView != wkWebView) {
        _wkWebView = wkWebView;
        
        if ([_wkWebView isKindOfClass:[wkWebView class]]) {
            // 建立监听
            [self buildObserver];
        }
    }
}


#pragma mark - 最新的WkWebView的进度条处理
// 建立KVO监听progess
- (void)buildObserver
{
    // 初始化配置0.3
    [self setProgress:@0.3];
    
    [_wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

// KVO监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        NSNumber *new = change[@"new"];
//        [self setProgress:new];
//        return;
        if (new.doubleValue > 0) {
            // 开始加载的时候直接到0.93
            [self setProgress:@0.93];
            
            // 如果
            if (new.doubleValue <= 0.97 && new.doubleValue >=0.93) {
                [self setProgress:@0.97];
            }
        
        if (new.doubleValue >= 0.97) {
            [self setProgress:new];
        }        
     }
        
        
        // 小于0.3的时候直接显示0.3
//        if (new.doubleValue > 0 && new.doubleValue <= 0.1) {
//            [self setProgress:@0.93];
//        }
//        else if(new.doubleValue <= 0.9){
//            [self setProgress:@0.97];
//        }
//        else {
//            [self setProgress:new];
//        }
        
        // 重置
        NSNumber *old = change[@"old"];
        if (old.doubleValue == 1) {
            [self reset];
        }
    }
}


#pragma mark - 8.0-使用WKWebview
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
//{
//    [self setProgress:@0.3];
//    
//    if ([_wkWebViewProxyDelegate respondsToSelector:@selector(webView:decidePolicyForNavigationAction:decisionHandler:)]) {
//        [_wkWebViewProxyDelegate webView:webView decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
//    }
//}
//
//- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
//{
//    [self setProgress:@0.93];
//    
//    if ([_wkWebViewProxyDelegate respondsToSelector:@selector(webView:didStartProvisionalNavigation:)]) {
//        [_wkWebViewProxyDelegate webView:webView didStartProvisionalNavigation:navigation];
//    }
//}
//
//- (void)webview


//#else
#pragma mark - 7.0-8.0 使用UIWebView
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // 初始化进度
    [self setProgress:@0.3];
    
    BOOL ret = YES;
    
    if ([_uiWebViewProxyDelegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        ret = [_uiWebViewProxyDelegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    
    // 是否能开启重置
    BOOL isFragmentJump = NO;
    if (request.URL.fragment) {
        NSString *nonFragmentURL = [request.URL.absoluteString stringByReplacingOccurrencesOfString:[@"#" stringByAppendingString:request.URL.fragment] withString:@""];
        isFragmentJump = [nonFragmentURL isEqualToString:webView.request.URL.absoluteString];
    }
    BOOL isTopLevelNavigation = [request.mainDocumentURL isEqual:request.URL];
    
    BOOL isHTTP = [request.URL.scheme isEqualToString:@"http"] || [request.URL.scheme isEqualToString:@"https"];
    if (ret && !isFragmentJump && isHTTP && isTopLevelNavigation && navigationType != UIWebViewNavigationTypeBackForward) {
        //        _currentURL = request.URL;
        // 重置URL
//        [self reset];
    }
    
    
    return ret;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //
    [self setProgress:@0.93];
    
    if ([_uiWebViewProxyDelegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [_uiWebViewProxyDelegate webViewDidStartLoad:webView];
    }
    
    //    [self startProgress];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // 完成0.9
    [self setProgress:@0.97];
    
    // 延迟0.1s之后完成之后的0.1进度
    [self performSelector:@selector(setProgress:) withObject:@1 afterDelay:0.1];
    
    //
    if ([_uiWebViewProxyDelegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [_uiWebViewProxyDelegate webViewDidFinishLoad:webView];
    }
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    // 延迟0.1s之后完成之后的0.1进度直接失败
    [self performSelector:@selector(setProgress:) withObject:@1 afterDelay:0.1];
    
    //
    if ([_uiWebViewProxyDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [_uiWebViewProxyDelegate webView:webView didFailLoadWithError:error];
    }
    
}

//#endif


@end















