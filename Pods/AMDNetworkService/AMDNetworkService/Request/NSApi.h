//
//  NSApi.h
//  AMDNetworkService
//
//  Created by SunSet on 2017/7/25.
//  Copyright © 2017年 SunSet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSHttpRequest.h"

@interface NSApi : NSObject


+ (instancetype)shareInstance;


/**
 发送请求

 @param req 请求
 @return 成功或失败
 */
- (BOOL)sendReq:(NSHttpRequest*)req;






#pragma mark - 类方法仅需注册一次

/**
 类注册自定UserAgent<只需注册一次>
 
 @param userAgent 用户agent
 */
+ (void)registerUserAgent:(NSDictionary *)userAgent;


/**
 注册统一请求前缀<只需注册一次>
 注册之后就可以进行本机ip解析
 如果需要改变地址，请重新注册一次
 
 @param hosturl host地址例如<https://openapi.wdwd.com>
 */
+ (void)registerHostUrl:(NSURL *)hosturl;



@end








