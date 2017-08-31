//
//  NSHttpRequest.m
//  AMDNetworkService
//
//  Created by SunSet on 2017/7/25.
//  Copyright © 2017年 SunSet. All rights reserved.
//

#import "NSHttpRequest.h"
#import "NSLoadingView.h"

@interface NSHttpRequest()
{
//    NSHttpConfiguration *_configuration;        //配置项
    __weak NSLoadingView *_loadingView;        //加载视图
}
@end

@implementation NSHttpRequest
@synthesize configuration = _configuration;


- (void)dealloc
{
    self.requestParams = nil;
    self.urlPath = nil;
    self.completion = nil;
    _configuration = nil;
}


- (id)initWithConfiguration:(NSHttpConfiguration *)configuration
{
    if (self = [super init]) {
        _configuration = configuration;
    }
    return self;
}



#pragma mark - 
// 请求开始 api 不能处理
- (void)start
{
    if (_configuration.animated) {
        UIView *_view = _configuration.animateView;
        if (_configuration.animateView == nil) {
            _view = [UIApplication sharedApplication].keyWindow;
        }
        
        // 动画效果
        NSLoadingView *backView = [[NSLoadingView alloc]initWithFrame:CGRectMake(_view.frame.size.width/2-(100/2), _view.frame.size.height/2-70, 100, 100)];
        [_view addSubview:backView];
        [_view bringSubviewToFront:backView];
        [backView startAnimate];
        _loadingView = backView;
    }
}


- (void)end
{
    if (_configuration.animated) {
        // 移除父视图
        [_loadingView stopAnimate];
        [_loadingView removeFromSuperview];
    }
}




#pragma mark - private api

- (NSRequestType)type
{
    return (_type == 0)?NSRequestGET:_type;
}

@end



@implementation NSHttpConfiguration

- (void)dealloc
{
    self.animateView = nil;
}

@end







