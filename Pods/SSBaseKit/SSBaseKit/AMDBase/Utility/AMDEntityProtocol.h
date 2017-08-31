//
//  AMDEntityProtocol.h
//  AppMicroDistribution
//
//  Created by SunSet on 16/12/19.
//  Copyright © 2016年 SunSet. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AMDEntityProtocol <NSObject>



/**
 将entity 转化为相应的实体类

 @return 实例化对象
 */
- (id)model;




@optional
/**
 根据模型类实例化

 @param model 实体类

 @return 实体
 */
+ (id)entityWithModel:(id)model;
- (id)initWithModel:(id)model;




@end









