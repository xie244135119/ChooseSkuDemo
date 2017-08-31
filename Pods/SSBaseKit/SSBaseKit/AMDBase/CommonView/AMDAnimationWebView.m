//
//  AMDAnimationWebView.m
//  AppMicroDistribution
//
//  Created by SunSet on 15-5-21.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import "AMDAnimationWebView.h"
#import "AMDWebViewProgress.h"
#import "SSGlobalVar.h"
#import "AMDMJRefresh.h"
#import <Masonry/Masonry.h>



@interface AMDAnimationWebView() <AMDWebViewDelegate,WKNavigationDelegate,WKUIDelegate,UIWebViewDelegate>

@property(nonatomic,strong) AYEWebViewProgress *webViewProgress;
@end

@implementation AMDAnimationWebView

- (void)dealloc
{
    [_wkWebView.configuration.userContentController removeAllUserScripts];
    [_webViewProgress exit];
    _wkWebView = nil;
    self.webViewProgress = nil;
    self.reloadAction_WK = nil;
    self.finishLoadAction_UI = nil;
    self.finishLoadAction_WK = nil;
//    NSLog(@" AMDAnimationWebView  deallc");
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        if ([UIDevice currentDevice].systemVersion.doubleValue >= 8.0) {
            [self initWkWebView];
        }
        else {
            [self initUIWebView];
        }
    }
    return self;
}

//加载动画
- (void)loadWebViewAnimate
{
    UIProgressView *progroess = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    progroess.progressTintColor = SSColorWithRGB(30, 206, 109, 1);
    progroess.trackTintColor = [UIColor clearColor];
    progroess.transform = CGAffineTransformMakeScale(1.0f,2.0f);
    _progressView = progroess;
    [self addSubview:progroess];
    [self bringSubviewToFront:progroess];
    [progroess mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@2);
    }];
}

//设置网址
- (void)initSetUrlView
{
    UIView *v = [[UIView alloc]initWithFrame:self.bounds];
    v.backgroundColor = SSColorWithRGB(246, 246, 246, 1);
    UIWebView *webView = (UIWebView *)(_wkWebView!=nil?_wkWebView:_uiWebView);
    [webView insertSubview:v belowSubview:webView.scrollView];
    
    //设置网址
    UILabel *urllabel = [[UILabel alloc]init];
    urllabel.backgroundColor = [UIColor clearColor];
    urllabel.textColor = SSColorWithRGB(194, 194, 194, 1);
    urllabel.textAlignment = NSTextAlignmentCenter;
    urllabel.font = SSFontWithName(@"", 12);
    [v addSubview:urllabel];
    _websiteLabel = urllabel;
    [urllabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(@10);
        make.height.equalTo(@20);
    }];
}


#pragma mark - SET
- (void)setSupportRefresh:(BOOL)supportRefresh
{
    if (_supportRefresh != supportRefresh) {
        _supportRefresh = supportRefresh;
        
        _websiteLabel.hidden = supportRefresh;
        //支持刷新
        if (supportRefresh) {
            [_uiWebView.scrollView addHeaderWithTarget:self action:@selector(webViewRefresh:)];
            [_wkWebView.scrollView addHeaderWithTarget:self action:@selector(webViewRefresh:)];
        }
        else{
            [_uiWebView.scrollView removeHeader];
            [_wkWebView.scrollView removeHeader];
        }
    }
}

//
- (void)setRequestWithSignURL:(NSString *)requestWithSignURL
{
    if (_requestWithSignURL != requestWithSignURL) {
        _requestWithSignURL = requestWithSignURL;
    }
    
    // 签名方式
    if (requestWithSignURL) {
        NSString *urlstr = requestWithSignURL;
        NSURL *url = [[NSURL alloc]initWithString:urlstr];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
        [_uiWebView loadRequest:request];
        [_wkWebView loadRequest:request];
        
        NSString *host = [[NSURL URLWithString:requestWithSignURL] host];
        if ([host rangeOfString:@"wdwd.com"].length == 0) {
            // 将host 转化为 IP请求
            _websiteLabel.text = [NSString stringWithFormat:@"由%@提供",host];
        }
    }
}

//
- (void)setExtraUserAgent:(NSString *)extraUserAgent
{
    if (_extraUserAgent != extraUserAgent) {
        _extraUserAgent = extraUserAgent;
        
        if (_uiWebView) {
            NSMutableString *defaultUserAgent = [[[[UIWebView alloc] init] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"] mutableCopy];
            [defaultUserAgent appendFormat:@" %@",extraUserAgent];
            [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":defaultUserAgent}];
        }
        else if (_wkWebView) {
            [_wkWebView setValue:extraUserAgent forKey:@"applicationNameForUserAgent"];
        }
    }
}



#pragma mark - 刷新功能
- (void)webViewRefresh:(UIScrollView *)tableView
{
    if (_reloadAction_UI) {
        _reloadAction_UI(_uiWebView);
    }
    else if (_reloadAction_WK){
        _reloadAction_WK(_wkWebView);
    }
    else {
        [_uiWebView reload];
        [_wkWebView reload];
    }
}



#pragma mark - 8.0以上使用WKWebView
//#ifdef __IPHONE_8_0
//#ifdef IOS8Later

- (void)initWkWebView
{
    // 设置底部提示视图
    [self initSetUrlView];
    
    // WKWebView
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]init];
    // 基本配置
    // 允许打开Window
    configuration.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    
    // 配置JS函数
//#warning 临时处理
    //    NSString *js = [[NSString alloc]initWithFormat:@"window.webkit.messageHandlers.%@.postMessage()",YLJsBridgeClassName];
//    WKUserScript *script = [[WKUserScript alloc]initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
//    [configuration.userContentController addUserScript:script];
//    __weak YLJsBridgeSDK *weakSDK = self.bridgeSDK;
//    [configuration.userContentController addScriptMessageHandler:weakSDK name:YLJsBridgeClassName];
    
    WKWebView *webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, 10, 10) configuration:configuration];
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    webView.allowsBackForwardNavigationGestures = YES;
    [self addSubview:webView];
    _wkWebView = webView;
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    // 加载进度动画条
    [self loadWebViewAnimate];
    // 设置进度条
    self.webViewProgress.wkWebView = webView;
    
    // 设置自定义用户Agent
//    NSString *extraUserAgent = @"";
//    [self webviewUserAgent:&extraUserAgent];
//    [webView setValue:extraUserAgent forKey:@"applicationNameForUserAgent"];
}



#pragma mark - WKNavigationDelegate
// 判断是否允许加载
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    // 先校验URL 是否可以加载
    if (![self canLoadURLRequest:navigationAction.request]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    
    // 预加载Url判断
    if (_shouldStartLoad) {
        BOOL allcontinue = NO;
        BOOL loadresault = _shouldStartLoad(webView,navigationAction.request, &allcontinue);
        if (!allcontinue) {
            // 不允许继续执行，直接中断底部流程
            decisionHandler(loadresault?WKNavigationActionPolicyAllow:WKNavigationActionPolicyCancel);
            return;
        }
    }
    
    
    // 如果来自我们官方的请求
//    NSArray *whiteschemes = @[@"wdwd.com",@"maifou.com",@"mai2.cn",@"mai2.cc"];
//    BOOL platformAuthorize = NO;
//    for (NSString *scheme in whiteschemes) {
//        if ([navigationAction.request.URL.host containsString:scheme]) {
//            platformAuthorize = YES;
//            break;
//        }
//    }
    
//#warning 临时禁掉
    // 平台签名
    /*if (platformAuthorize) {
        // 未签名的情况下进入官方网址默认签名处理
        if (_currentPlatformAuthorize == nil) {
            _currentPlatformAuthorize = [[AASPlatformAuthorize alloc]init];
            _currentPlatformAuthorize.prismAppSecret = [self appSecret];
            _currentPlatformAuthorize.prismAppKey = [self appKey];
            _currentPlatformAuthorize.presentSenderID = AMDTestPassportID;
        }
        
        // 签名不可用的时候--进入重新签名处理
        if (![_currentPlatformAuthorize isAvailableWithSign:[navigationAction.request.allHTTPHeaderFields valueForKey:@"Authorization"]]) {
            BOOL resault = [_currentPlatformAuthorize wkWebView:webView shouldStartLoadWithRequest:navigationAction.request];
            decisionHandler(resault?WKNavigationActionPolicyAllow:WKNavigationActionPolicyCancel);
            return;
        }
    }
    
    // 默认进行oauth登录请求--用于第三方登录
    if ([navigationAction.request.URL.path rangeOfString:@"/oauth/authorize"].length > 0) {
        if (_currentWebOauthAuthorize == nil) {
            _currentWebOauthAuthorize = [[AASWebOauthAuthorize alloc]init];
            _currentWebOauthAuthorize.prismAppSecret = [self appSecret];
            _currentWebOauthAuthorize.presentSenderID = AMDTestShopID;
        }
        BOOL resault = [_currentWebOauthAuthorize wkWebView:webView shouldStartLoadWithRequest:navigationAction.request];
        decisionHandler(resault?WKNavigationActionPolicyAllow:WKNavigationActionPolicyCancel);
        return ;
    }*/
    
    // 当前页面表单提交的话 直接返回
    if (navigationAction.navigationType == UIWebViewNavigationTypeFormSubmitted || navigationAction.navigationType == UIWebViewNavigationTypeFormResubmitted) {
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    
    // 当前页面的话---
    NSString *urlStr = navigationAction.request.URL.description;
    if (_requestWithSignURL) {
        if ([urlStr rangeOfString:_requestWithSignURL].length > 0 ) {
            decisionHandler(WKNavigationActionPolicyAllow);
            return;
        }
    }
    
    // 子类重写这个方式
    if ([_delegate respondsToSelector:@selector(webView:decidePolicyForNavigationAction:decisionHandler:)]) {
        [_delegate webView:webView decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
        return ;
    }
    
    // 开启此功能后 开启新的webView页面
//    if (_linkNewPageFunction && [navigationAction.request.URL.description hasPrefix:@"http"]) {
////#warning 临时禁掉
////        [self.bridgeSDK performSelector:@selector(enterHtmlViewWithString:) withObject:navigationAction.request.URL.description afterDelay:0.1];
//        decisionHandler(WKNavigationActionPolicyCancel);
//        return;
//    }
    decisionHandler(WKNavigationActionPolicyAllow);
}


// 加载成功
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    // 在加载中的时候
    if (webView.isLoading) return;
    
    // 取消下拉刷新
    if (_supportRefresh) {
        [_wkWebView.scrollView headerEndRefreshing];
    }
    
    // 如果有加载完成事件
    if (_finishLoadAction_WK) {
        _finishLoadAction_WK(webView);
    }
    
    // 重写子类的方法
    if ([_delegate respondsToSelector:@selector(webView:didFinishNavigation:)]) {
        [_delegate webView:webView didFinishNavigation:navigation];
    }
}


// 加载出错提示
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    // 结束刷新状态
    if (_supportRefresh) {
        [_wkWebView.scrollView headerEndRefreshing];
    }
    
    // 结束的时候
    [UIView animateWithDuration:0.25 animations:^{
        _progressView.alpha = 0;
        [_progressView setProgress:1 animated:NO];
    } completion:nil];
    
    // 视图重新加载
    if ([_delegate respondsToSelector:@selector(webView:didFailNavigation:withError:)]) {
        [_delegate webView:webView didFailNavigation:navigation withError:error];
    }
}


// 配置
//- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
//{
//    NSLog(@" %@ ",error);
//}



#pragma mark - WKUIDelegate(实现自定义的Alert方法)
// 实现Alert方法
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
//#warning 临时禁掉
//    [[AMDCommonClass sharedAMDCommonClass] showAlertTitle:nil Message:message action:nil cancelBt:@"确定" otherButtonTitles: nil];
    NSLog(@" js: alert %@ ",message);
    completionHandler();
}


// 加载进度条
- (AYEWebViewProgress *)webViewProgress
{
    if (_webViewProgress == nil) {
        _webViewProgress = [[AYEWebViewProgress alloc]init];
//        _webViewProgress.uiWebViewProxyDelegate = (id)self;
        _webViewProgress.progressView = _progressView;
        _webViewProgress.uiWebViewProxyDelegate = self;
    }
    return _webViewProgress;
}


//#else

#pragma mark - 7.0 - 8.0 使用UIWebView
//视图加载
- (void)initUIWebView
{
    //添加进度条动画
    [self loadWebViewAnimate];
    
    // 加载视图
    UIWebView *webView = [[UIWebView alloc]initWithFrame:self.bounds];
    _uiWebView = webView;
    webView.scrollView.backgroundColor = [UIColor clearColor];
    webView.delegate = self.webViewProgress;

    [self insertSubview:webView belowSubview:_progressView];
    
    // 设置User-Agent
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        NSString *userAgent = [self webviewUserAgent:nil];
//        [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":userAgent}];
//    });
    
    // 网址来源
    [self initSetUrlView];
}


#pragma mark UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // 先校验URL 是否可以加载
    if (![self canLoadURLRequest:request]) {
        return NO;
    }
    
    // 预加载Url判断
    if (_shouldStartLoad) {
        BOOL allcontinue = NO;
        BOOL loadresault = _shouldStartLoad((WKWebView *)webView,request, &allcontinue);
        if (!allcontinue) {
            // 不允许继续执行，直接中断底部流程
            return loadresault;
        }
    }
    
    // 如果来自我们官方的请求
    /*if ([request.URL.host rangeOfString:NonNil(GetDefaults(AMDYLDomain), @"")].length > 0) {
        // 未签名的情况下进入官方网址默认签名处理
        if (_currentPlatformAuthorize == nil) {
            _currentPlatformAuthorize = [[AASPlatformAuthorize alloc]init];
            _currentPlatformAuthorize.prismAppSecret = [self appSecret];
            _currentPlatformAuthorize.prismAppKey = [self appKey];
            _currentPlatformAuthorize.presentSenderID = AMDTestPassportID;
        }
        
        // 签名不可用的时候--进入重新签名处理
        if (![_currentPlatformAuthorize isAvailableWithSign:[request.allHTTPHeaderFields valueForKey:@"Authorization"]]) {
            return [_currentPlatformAuthorize uiWebView:webView shouldStartLoadWithRequest:request];
        }
    }
    
    // 默认进行oauth登录请求--用于第三方登录
    if ([request.URL.path rangeOfString:@"/oauth/authorize"].length > 0) {
        if (_currentWebOauthAuthorize == nil) {
            _currentWebOauthAuthorize = [[AASWebOauthAuthorize alloc]init];
            _currentWebOauthAuthorize.prismAppSecret = [self appSecret];
            _currentWebOauthAuthorize.presentSenderID = AMDTestShopID;
        }
        return [_currentWebOauthAuthorize webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }*/
    
    
    // 当前页面表单提交的话 直接返回
    if (navigationType == UIWebViewNavigationTypeFormSubmitted || navigationType == UIWebViewNavigationTypeFormResubmitted) {
        return YES;
    }
    
    // 如果未当前页面本身判断当前页面地址
    NSString *urlStr = request.URL.description;
    if (_requestWithSignURL) {
        if ([urlStr rangeOfString:_requestWithSignURL].length > 0 ) {
            return YES;
        }
    }
    
    // 子类重写这个方式
    if ([_delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        return [_delegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    
    // 开启此功能后 开启新的webView页面
//    if (_linkNewPageFunction && [request.URL.description hasPrefix:@"http"]) {
//        
////#warning 临时禁掉
////        [self.bridgeSDK performSelector:@selector(enterHtmlViewWithString:) withObject:request.URL.description afterDelay:0.1];
//        return NO ;
//    }
    
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    // 结束刷新状态
    if (_supportRefresh) {
        [_uiWebView.scrollView headerEndRefreshing];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        _progressView.alpha = 0;
        [_progressView setProgress:1 animated:NO];
    } completion:nil];
    
    // 视图重新加载
    if ([_delegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [_delegate webView:webView didFailLoadWithError:error];
    }
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // 在加载中的时候
    if (webView.isLoading) return;
    
    // 取消下拉刷新
    if (_supportRefresh) {
        [_uiWebView.scrollView headerEndRefreshing];
    }
    
    // 建立桥接-<App最低版本号为8.0 所以底部不在做支持>
//#warning 临时禁掉
//    [self.bridgeSDK bridgeForWebView:webView webViewDelegate:self];
    
    // 如果有加载完成事件
    if (_finishLoadAction_UI) {
        _finishLoadAction_UI(webView);
    }
    
    // 重写子类的方法
    if ([_delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [_delegate webViewDidFinishLoad:webView];
    }
}



#pragma mark - 公用处理
// 处理是否可以加载当前请求
- (BOOL)canLoadURLRequest:(NSURLRequest *)aRequest
{
    // 如果当前scheme改变---不是普通的http链接和本地链接 用于加载外链 例如taobao://商品地址
    if (!([aRequest.URL.scheme hasPrefix:@"http"] || [aRequest.URL.scheme hasPrefix:@"file"])) {
        if (![aRequest.URL.scheme isEqualToString:@"about"]) {
            if ([[UIApplication sharedApplication] canOpenURL:aRequest.URL]) {
                [[UIApplication sharedApplication] openURL:aRequest.URL];
                return NO;
            }
        }
    }
    
    // 签名配置
    return YES;
}







@end
















