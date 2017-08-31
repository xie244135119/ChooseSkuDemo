//
//  NSDNSPod.m
//  AMDNetworkService
//
//  Created by SunSet on 2017/7/25.
//  Copyright © 2017年 SunSet. All rights reserved.
//

#import "NSDNSPod.h"
#import <UIKit/UIKit.h>

// 本地存储的ip地址
NSString *const kAMDServerLastHostIP = @"AMDServerLastHostIP";           //已经请求到的ip地址

@interface NSDNSPod()
{
    NSMutableDictionary *_localRequestHostInfo;          //已经解析的域名详情
    NSMutableArray *_requestedHosts;          //App启动本次解析的详情
}
@end


@implementation NSDNSPod


#pragma mark - 根据请求方式做处理
// 使用ip请求服务器
- (NSString *)hostIPWithUrlStr:(NSString *)urlstr
{
    NSURLComponents *components = [[NSURLComponents alloc]initWithString:urlstr];
    components.host = [self ipFromHost:components.host];
    return components.URL.description;
}



//
- (NSString *)ipFromHost:(NSString *)host
{
    // 初始化
    if (_localRequestHostInfo == nil) {
        // 从本地取出上次存储的ip地址
        NSDictionary *localhostipdict = [[NSUserDefaults standardUserDefaults] objectForKey:kAMDServerLastHostIP];
        _localRequestHostInfo = [[NSMutableDictionary alloc]initWithDictionary:localhostipdict];
    }
    
    // app启动一次更新一下域名内是否已经请求过
    if (_requestedHosts == nil) {
        _requestedHosts = [[NSMutableArray alloc]init];
    }
    
    // 每次启动的时候都解析一遍最新的dns 与本地ip地址比对
    if (![_requestedHosts containsObject:host]) {
        // 避免二次请求
        [_requestedHosts addObject:host];
        // 异步获取ip地址
        __block NSMutableDictionary *_blockHostInfo = _localRequestHostInfo;
        NSString *dnspodurlstr = [[NSString stringWithFormat:@"http://119.29.29.29/d?dn=%@",host] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        // 完成操作
        void (^completion)(NSData *) = ^(NSData *data){
            NSString *currenthostip = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            if (currenthostip.length > 0) {
                
                // 更新本地缓存的ip地址
                if (![_blockHostInfo[host] isEqualToString:currenthostip]) {
                    // 赋值
                    [_blockHostInfo setObject:currenthostip forKey:host];
                    
                    //两者不一致的时候更新本地的ip地址(便于服务器迁移的时候使用)
                    [[NSUserDefaults standardUserDefaults] setObject:_blockHostInfo forKey:kAMDServerLastHostIP];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
        };
        
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:dnspodurlstr]];
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            // 请求成功之后的地址
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (httpResponse.statusCode == 200) {
                completion(data);
            }
        }];
        [task resume];
    }
    
    // 当前的地址
    NSString *currenthostip = _localRequestHostInfo[host];
    return (currenthostip.length == 0)?host:currenthostip;
}





@end










