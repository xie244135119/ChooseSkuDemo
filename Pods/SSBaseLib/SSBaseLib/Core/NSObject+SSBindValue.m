//
//  NSObject+BindValue.m
//  整合框架
//
//  Created by SunSet on 14-3-21.
//  Copyright (c) 2014年 SunSet. All rights reserved.
//


#import "NSObject+SSBindValue.h"
#import <objc/runtime.h>


@implementation NSObject (BindValue)


- (void)bindValue:(id)value forKey:(NSString *)key
{
//    if (value == nil) return;
    
    objc_setAssociatedObject(self, [key cStringUsingEncoding:30], value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)bindCopyValue:(id)value forKey:(NSString *)key
{
//    if (value == nil) return;
    
    objc_setAssociatedObject(self, [key cStringUsingEncoding:30], value, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)bindWeakValue:(id)value forKey:(NSString *)key
{
//    if (value == nil) return;
    
    objc_setAssociatedObject(self, [key cStringUsingEncoding:30], value, OBJC_ASSOCIATION_ASSIGN);
}

- (id)getBindValueForKey:(NSString *)key
{
    return objc_getAssociatedObject(self, [key cStringUsingEncoding:30]);
}


- (void)removeBindObjects
{
    objc_removeAssociatedObjects(self);
}


- (NSArray *)propertyList
{
    unsigned int properycount = 0;
    NSMutableArray *array = [[NSMutableArray alloc]init];
    objc_property_t *propertys = class_copyPropertyList([self class], &properycount);
    for (int i =0; i<properycount; i++) {
        objc_property_t property = propertys[i];
//        const char *propertyname = property_getName(property);
//        const char *propertyattitudes = property_getAttributes(property);
//         NSLog(@" %s  %s",propertyname,propertyattitudes);
        unsigned int attributecount = 0;
        objc_property_attribute_t *attribute_ts = property_copyAttributeList(property, &attributecount);
        for (int i =0; i<attributecount; i++) {
            objc_property_attribute_t attribute = attribute_ts[i];
            NSString *attributename = [[NSString alloc]initWithUTF8String:attribute.name];
//            NSString *attributevalue = [[NSString alloc]initWithUTF8String:attribute.value];
            if ([attributename isEqualToString:@"T"]) {
//                Class class = NSClassFromString(attributevalue);
//                NSLog(@" %@ ",NSStringFromClass(class));
            }
//            NSLog(@" %@ %@ ",attributename,attributevalue);
        }
    }
    
    return array;
}




@end





