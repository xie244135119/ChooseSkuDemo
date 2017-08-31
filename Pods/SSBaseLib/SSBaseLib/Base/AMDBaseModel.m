//
//  AMDBaseModel.m
//  AppMicroDistribution
//
//  Created by SunSet on 15-5-20.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import "AMDBaseModel.h"
#import "SSJSONModel.h"
#import "SSJSONModelLib.h"

@implementation AMDBaseModel


- (void)dealloc
{
    self.baseOtherinfo = nil;
}


//处理纠错能力  防止系统崩溃
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    [self.baseOtherinfo setObject:value forKey:key];
}

- (NSMutableDictionary *)baseOtherinfo
{
    if (_baseOtherinfo == nil) {
        _baseOtherinfo = [[NSMutableDictionary alloc]init];
    }
    return _baseOtherinfo;
}





@end



















