//
//  NSObject+BindValue.h
//  整合框架
//
//  Created by SunSet on 14-3-21.
//  Copyright (c) 2014年 SunSet. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NSObject (SSBindValue)

/*
 * 绑定数据
 * @param1 绑定对象 @param2 绑定值 @param3 绑定键
 */
- (void)bindValue:(id)value forKey:(NSString *)key;
- (void)bindCopyValue:(id)value forKey:(NSString *)key;

/**
 *  绑定数据--弱饮用 不增加引用次数
 *
 *  @param value 绑定值
 *  @param key   绑定的主键
 */
- (void)bindWeakValue:(id)value forKey:(NSString *)key;


/*
 * 取得数据
 * @param1 绑定对象 @param2 绑定键
 */
- (id)getBindValueForKey:(NSString *)key;

/**
 *  移除所有绑定的数据
 */
- (void)removeBindObjects;


/**
 *  获取类的属性列表
 */
- (NSArray *)propertyList;

@end


