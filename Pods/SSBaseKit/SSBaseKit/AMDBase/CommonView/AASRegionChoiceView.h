//
//  AASRegionChoiceView.h
//  AppAmountStore
//  地理位置选择<设置为视图的intputView即可>
//  Created by SunSet on 14-10-30.
//  Copyright (c) 2014年 SunSet. All rights reserved.
//

#import "AMDBaseView.h"

@protocol AASRegionChoiceDelegate <NSObject>
@optional

/**
 *  @param type    1为确定 2为取消
 *  @param resaultstr 当确定的时候给地理区域 @{@"location":@"拼接的地址",@"location_ids":@"地址区域码码",@"province":@"省份",@"city":@"城市",@"district":@"区"}
 */
- (void)choiceType:(NSInteger)type resault:(id)resaultstr;

@end


// 提供数据源
@protocol AASRegionChoiceDataSource <NSObject>

// 获取数据源
//- (void)getRegionChoiceSourceCompletion:(void (^)(NSDictionary *source))completion;
- (NSDictionary *)regionChoiceSource;
@end





@interface AASRegionChoiceView : AMDBaseView

@property(nonatomic, weak) id<AASRegionChoiceDelegate> delegate;
@property(nonatomic, weak) id<AASRegionChoiceDataSource> dataSource;

// 默认的地理区域选择
// @{@"location":@"拼接的地址",@"location_ids":@"地址区域码码",@"province":@"省份",@"city":@"城市",@"district":@"区"}
- (NSDictionary *)defaultRegionChoice;

// 根据省份 城市 区域获取邮编 滑动到指定的区域
- (void)scrollToWithProvince:(NSString *)province city:(NSString *)city district:(NSString *)district;
// 根据省市区的名称 滑动到指定的区域
- (void)scrollByNameWithProvince:(NSString *)province city:(NSString *)city district:(NSString *)district;

@end








