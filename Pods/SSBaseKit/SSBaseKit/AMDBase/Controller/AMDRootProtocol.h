//
//  AMDRootProtocol.h
//  AppMicroDistribution
//
//  Created by Fuerte on 16/8/11.
//  Copyright © 2016年 SunSet. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AMDRootProtocol <NSObject>


@optional
/** 重写后退方法(临时使用) */
-(void)ClickBt_Back:(UIControl *)sender;


/* 每个类特定的url串 */
//- (NSString *)


/**
 页面重新加载
 */
- (void)preReload;


@end
