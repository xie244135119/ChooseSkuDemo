//
//  NSApi.m
//  AMDNetworkService
//
//  Created by SunSet on 2017/7/25.
//  Copyright © 2017年 SunSet. All rights reserved.
//

#import "NSApi.h"
#import "AFHTTPSessionManager+NSHttpCategory.h"
#import <AFNetworking/AFNetworking.h>
#import "NSDNSPod.h"
#import "NSPrivateTool.h"
#import <objc/objc.h>


// 固定的请求地址
static NSURL *_hostURL = nil;
// 固定的UserAgent
//static NSDictionary *_userAgentDict = nil;


@interface NSApi()
{
    NSDNSPod *_dnsPod;              //dns解析类
    NSDictionary *_userAgentDict;   //用户
}
// 请求类
@property(nonatomic, strong) AFHTTPSessionManager *httpSessionManager;
@end


@implementation NSApi

- (void)dealloc
{
    _dnsPod = nil;
    self.httpSessionManager = nil;
//    self.prismIOS = nil;
}


+ (instancetype)shareInstance
{
    static NSApi *_api = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _api = [[NSApi alloc]init];
    });
    return _api;
}


#pragma mark - public api
//
- (BOOL)sendReq:(NSHttpRequest*)req
{
    // 加载动画
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [req performSelector:NSSelectorFromString(@"start") withObject:nil];
    
    
    // 处理完成事件
    __weak typeof(self) weakself = self;
    __block void (^completion)(id _Nonnull responseObject, NSError * _Nullable error)
    = ^(id _Nonnull responseObject, NSError * _Nonnull error){
        // prism错误提示语
        NSError *aerror = error;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([responseObject[@"result"] isEqualToString:@"error"]) {
                NSDictionary *error = responseObject[@"error"];
//                NSInteger code = [error[@"code"] integerValue];
//                NSString *errordes = [weakself prismErrorFromCode:code];
                NSString *errordes = error[@"message"];
                aerror = [[NSError alloc]initWithDomain:NSURLErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey:errordes}];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 关闭动画
            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [req performSelector:NSSelectorFromString(@"end") withObject:nil];
            
            if (req.completion) {
                req.completion(responseObject, aerror);
            }
        });
    };
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 请求参数
        NSDictionary *params = [weakself _completeParamsWithReq:req];
        // 请求地址
        NSString *url = [weakself _requestCompleteURLWithReq:req];
        // 发起请求
        [weakself _sendReq:req params:params url:url completion:completion];
    });
    
    
    return YES;
}

// 设置主机地址
+ (void)registerHostUrl:(NSURL *)hosturl
{
    // 固定请求地址
    if (_hostURL != hosturl) {
        _hostURL = hosturl;
    }
}

// 注册
+ (void)registerUserAgent:(NSDictionary *)userAgent
{
    NSApi *api = [NSApi shareInstance];
    api->_userAgentDict = userAgent;
}


#pragma mark - private api
//
- (void)_sendReq:(NSHttpRequest *)req
          params:(NSDictionary *)params
             url:(NSString *)url
      completion:(void (^)(id _Nonnull responseObject, NSError * _Nullable error))completion
{
    switch (req.type) {
        case NSRequestPOST:          //请求方式
        {
            [self.httpSessionManager POST_AMD:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                completion(responseObject, nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error, id _Nonnull responseObject) {
                completion(responseObject, error);
            }];
        }
            break;
        case NSRequestPUT:          //请求方式
        {
            [self.httpSessionManager PUT_AMD:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                completion(responseObject, nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error, id _Nonnull responseObject) {
                completion(responseObject, error);
            }];
        }
            break;
        case NSRequestDelete:          //请求方式
        {
            [self.httpSessionManager DELETE_AMD:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                completion(responseObject, nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error, id _Nonnull responseObject) {
                completion(responseObject, error);
            }];
        }
            break;
        default:        //GEt
        {
            [self.httpSessionManager GET_AMD:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                completion(responseObject, nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error, id _Nonnull responseObject) {
                completion(responseObject, error);
            }];
        }
            break;
    }
}


// 完整的请求参数
- (NSDictionary *)_completeParamsWithReq:(NSHttpRequest *)req
{
    // 常规的参数 + 签名需要携带的参数 + 自定义的参数
    // 签名的参数
    NSDictionary *signparam = req.requestParams;
    return signparam;
}


// 完整的请求地址
- (NSString *)_requestCompleteURLWithReq:(NSHttpRequest *)req
{
    // 域名+/api+urlpath部分 <api不能作为签名>
    NSString *hoststr = req.customHost?req.customHost:_hostURL.description;
    NSString *ipurl = [[self dnsPod] hostIPWithUrlStr:hoststr];
    return [ipurl stringByAppendingFormat:@"%@",req.urlPath];
}


// dns解析类
- (NSDNSPod *)dnsPod
{
    if (_dnsPod == nil) {
        _dnsPod = [[NSDNSPod alloc]init];
    }
    return _dnsPod;
}


// 请求参数
- (AFHTTPSessionManager *)httpSessionManager
{
    if (_httpSessionManager == nil) {
        _httpSessionManager = [AFHTTPSessionManager manager];
        AFSecurityPolicy* policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        // 验证域名
        [policy setValidatesDomainName:NO];
        // 允许无效证书
        [policy setAllowInvalidCertificates:YES];
        _httpSessionManager.securityPolicy = policy;
        
        // 设置超时时间 10s
        _httpSessionManager.requestSerializer.timeoutInterval = 10.f;
        
        // 添加header信息
        NSString *ua = [self userAgent];
        if (ua.length > 0) {
            [_httpSessionManager.requestSerializer setValue:[self userAgent] forHTTPHeaderField:@"User-Agent"];
        }
        
        [_httpSessionManager.requestSerializer setValue:[self _localIP] forHTTPHeaderField:@"X-Forwarded-For"];
    }
    
    //设置 host 主机地址
    if (![_httpSessionManager.requestSerializer valueForHTTPHeaderField:@"Host"]) {
        [_httpSessionManager.requestSerializer setValue:_hostURL.host forHTTPHeaderField:@"Host"];
    }
    
    // 加载
    return _httpSessionManager;
}


//用户代理信息
- (NSString *)userAgent
{
    // 设置默认ua
    NSMutableString *defaultua = [[NSMutableString alloc]initWithString:@""];
    NSDictionary *identifier = _userAgentDict;
    if (identifier.allKeys.count > 0) {
        for (NSString *key in identifier.allKeys) {
            NSString *value = identifier[key];
            [defaultua appendFormat:@"%@/%@;",key,value];
        }
    }
    return defaultua;
}

//获取本机IP--不会变
- (NSString *)_localIP
{
    NSString *_localIP = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
        _localIP = [NSPrivateTool localIP];
//    });
    return _localIP;
}

- (NSURL *)api_hostURL
{
    NSAssert(_hostURL != nil, @"请先调用 registerHostUrl 配置请求url");
    return _hostURL;
}



#pragma mark - private api
// af不支持二级参数 需要内部处理
- (NSDictionary *)_buildParamsWithDict:(NSDictionary *)dict
{
    NSMutableDictionary *params = dict.mutableCopy;
    // 并发处理
    [params enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSDictionary class]] || [obj isKindOfClass:[NSArray class]]) {
            NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:kNilOptions error:nil];
            NSString *jsonstr = [[NSString alloc]initWithData:data encoding:4];
            [params setObject:jsonstr forKey:key];
        }
    }];
    return params;
}





@end










