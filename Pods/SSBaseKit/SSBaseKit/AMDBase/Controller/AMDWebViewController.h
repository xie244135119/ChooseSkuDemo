//
//  AMDWebViewController.h
//  AppMicroDistribution
//  web控制器<不再允许直接引用>
//  Created by SunSet on 15-6-19.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import "AMDRootViewController.h"


@interface AMDWebViewController : AMDRootViewController

// 不带签名 普通请求方式的地址
//@property(nonatomic, copy) NSString *requestURL;

// 使用平台签名的请求地址
@property(nonatomic, copy) NSString *requestWithSignURL;

// 跳转类型 1:正常压栈(默认) 2：模态显示
@property(nonatomic, strong) NSNumber *showType;


// 以下的方法不允许使用
- (instancetype)initWithTitle:(NSString *)title NS_DEPRECATED_IOS(2_0, 7_0, "此方法不再允许使用 请使用[YLJsBridgeSDK bridgeWithActionType:YLJsBridgeActionTypeLink actionParams:urlstr] 方法调用") ;
- (instancetype)initWithTitle:(NSString *)title titileViewShow:(BOOL)titleViewShow tabBarShow:(BOOL)tabbarshow
NS_DEPRECATED_IOS(2_0, 7_0, "此方法不再允许使用 请使用[YLJsBridgeSDK bridgeWithActionType:YLJsBridgeActionTypeLink actionParams:urlstr] 方法调用");

@end
