//
//  NSDNSPod.h
//  AMDNetworkService
//  dns解析
//  Created by SunSet on 2017/7/25.
//  Copyright © 2017年 SunSet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDNSPod : NSObject



/**
 域名解析

 @param urlstr 一串普通的
 @return url地址
 */
- (NSString *)hostIPWithUrlStr:(NSString *)urlstr;


/**
 域名解析ip

 @param host 地址
 @return 地址
 */
- (NSString *)ipFromHost:(NSString *)host;


@end
