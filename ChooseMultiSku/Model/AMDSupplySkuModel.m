//
//  AMDSupplySkuModel.m
//  AppMicroDistribution
//
//  Created by SunSet on 16-4-11.
//  Copyright (c) 2016年 SunSet. All rights reserved.
//

#import "AMDSupplySkuModel.h"

@implementation AMDSupplySkuModel

- (void)dealloc
{
    self.sku_id = nil;
    self.supplier_id = nil;
    self.taobao_sku_id = nil;
    self.product_id = nil;
    self.price = nil;
    self.min_add_price = nil;
    self.max_add_price = nil;
    self.weight = nil;
    self.compare_at_price = nil;
    self.option1 = nil;
    self.option2 = nil;
    self.option3 = nil;
    self.option4 = nil;
    self.sku_code = nil;
    self.requires_shipping = nil;
    self.quantity = nil;
    self.quantity_setting = nil;
    self.inventory_management = nil;
    self.inventory_policy = nil;
    self.created_at = nil;
    self.updated_at = nil;
    self.position = nil;
    self.last_sync_time = nil;
    self.last_sync_code = nil;
    self.min_retail_price = nil;
    self.max_retail_price = nil;
    self.grams = nil;
    
    self.takeOrderCount = nil;
    self.takeOrderPrice = nil;
    
    self.team_id = nil;
    
    self.sku = nil;
    self.bsku_id = nil;
}

- (NSString *)allOptionValue
{
    NSMutableArray *muarry = [[NSMutableArray alloc]init];
    if (_option1.length > 0) {
        [muarry addObject:[@"option1:" stringByAppendingString:_option1]];
    }
    if (_option2.length > 0) {
        [muarry addObject:[@"option2:" stringByAppendingString:_option2]];
    }
    if (_option3.length > 0) {
        [muarry addObject:[@"option3:" stringByAppendingString:_option3]];
    }
    if (_option4.length > 0) {
        [muarry addObject:[@"option4:" stringByAppendingString:_option4]];
    }
    
    return [[muarry sortedArrayUsingSelector:@selector(compare:)] componentsJoinedByString:@";"];
}

- (NSString *)skuString
{
    NSString *skuString = [NSString stringWithFormat:@"%@%@%@%@",_option1,_option2,_option3,_option4];
    if (skuString.length == 0) {
        skuString = @"默认";
    }
    return skuString;
}

- (NSString *)skuString2
{
    NSString *skuString = [[NSString alloc]initWithFormat:@"%@ %@ %@ %@",self.option1,self.option2,self.option3,self.option4];
    skuString = [skuString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (skuString.length == 0) {
        return @"默认";
    }
    return skuString;
}

- (NSNumber *)quantity
{
    if (_quantity_setting.integerValue == 0) {
        return @999999;
    }
    return _quantity;
}

- (NSNumber *)takeOrderCount
{
    if (_takeOrderCount == nil) {
        return @1;
    }
    return _takeOrderCount;
}

- (NSString *)sku_id
{
    if (_sku_id == nil) {
        return @"";
    }
    return _sku_id;
}

- (NSString *)team_id
{
    return _team_id?_team_id:@"";
}

- (NSString *)takeOrderPrice
{
    return _takeOrderPrice?_takeOrderPrice:self.vip_price;
}

- (NSString *)minSalePrice
{
    NSString *minprice = self.min_retail_price.doubleValue<self.vip_price.doubleValue?self.vip_price:self.min_retail_price;
    return minprice;
}

- (NSString *)skuVipPrice
{
    if (_takeOrderBulkVipPrice.intValue != 0) {
        //批发价格高于会员价格的时候 取会员价格
        if (_takeOrderBulkVipPrice.doubleValue > _vip_price.doubleValue) {
            return _vip_price;
        }
        return [[NSString alloc]initWithFormat:@"%.2f",_takeOrderBulkVipPrice.doubleValue];
    }
    return _vip_price;
}


@end










