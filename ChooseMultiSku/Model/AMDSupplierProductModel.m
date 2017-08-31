//
//  AMDSupplierProductModel.m
//  AppMicroDistribution
//
//  Created by SunSet on 15-6-2.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import "AMDSupplierProductModel.h"

@implementation AMDSupplyPhotoModel

- (void)dealloc
{
    self.photo_id = nil;
    self.product_id = nil;
    self.url = nil;
    self.width = nil;
    self.height = nil;
    self.position = nil;
    self.mark = nil;
    self.created_at = nil;
    self.updated_at = nil;
}

- (NSString *)url
{
    return _url?_url:@"";
}

@end


@implementation AMDSupplierProductModel

- (void)dealloc
{
    self.product_id = nil;
    self.supplier_id = nil;
//    self.supplier_name = nil;
    self.supplier_info = nil;
    self.title = nil;
    self.vip_price = nil;
    self.retail_price = nil;
    self.price = nil;
    self.min_retail_price = nil;
    self.max_retail_price = nil;
    self.img = nil;
    self.sell_count = nil;
    self.forward_count = nil;
    self.quantity = nil;
    self.quantity_setting = nil;
    self.has_showcase = nil;
    self.published = nil;
    self.body_html = nil;
    self.product_type = nil;
    self.product_category = nil;
    self.brand = nil;
    self.vendor = nil;
    self.is_promoted = nil;
    self.commission = nil;
    self.like_total = nil;
    self.yl_body = nil;
    self.yl_desc = nil;
    self.created_at = nil;
    self.updated_at = nil;
    self.sku_arr = nil;
    self.product_option_arr = nil;
    self.photo_arr = nil;
    self.tag_arr = nil;
    self.bulk_rule = nil;
//    self.takeOrderSkuModel = nil;
    self.supplier_title = nil;
    self.team_id = nil;
    
    self.share_desc = nil;
    self.share_title = nil;
//    self.msg_tags = nil;
}

- (void)setTp_tag_arr:(NSArray<AMDSupplyProductTagModel> *)tp_tag_arr
{
    if (_tp_tag_arr != tp_tag_arr) {
        _tp_tag_arr = tp_tag_arr;
        NSMutableArray *mArr = [NSMutableArray new];
        for (AMDSupplyProductTagModel *model in tp_tag_arr) {
            [mArr addObject:model.name];
        }
        self.tags = [mArr copy];
    }
}

- (NSString *)team_id
{
    return _team_id.length>0?_team_id:@"";
}

- (NSString *)team_name
{
    // 如果是来自团队的商品
    if ([_fromtype isEqualToString:@"team"]) {
        return _team_name?_team_name:@"";
    }
    return _supplier_title;
}

- (NSString *)img
{
    //取图片数组中的第一张图片
    if (_photo_arr.count > 0) {
        AMDSupplyPhotoModel *modle = _photo_arr[0];
        return modle.url;
    }
    return _img?_img:@"";
}

- (AMDSupplySkuModel *)takeOrderSkuModel
{
    if (_takeOrderSkuModel == nil) {
        _takeOrderSkuModel = _sku_arr[0];
    }
    return _takeOrderSkuModel;
}

- (NSString *)url
{
    return _url?_url:@"";
}


- (NSString *)minSalePrice
{
    NSString *minprice = self.min_retail_price.doubleValue<self.vip_price.doubleValue?self.vip_price:self.min_retail_price;
    return minprice;
}

//能赚的钱
- (NSString *)canMakeMoneyStr
{
    // 去掉 无限逻辑(元元要求)
    CGFloat price = MAX((_retail_price.doubleValue-_vip_price.doubleValue), 0);
    NSString *pricestr = [[NSString alloc]initWithFormat:@"能赚  ¥%.2f",price];
    return pricestr;
}


- (NSString *)minVipPrice
{
//    double vipprice = 0;
    NSArray *vipprices = [[_sku_arr valueForKey:@"vip_price"] sortedArrayUsingSelector:@selector(compare:)];
    
    return vipprices[0];
}

- (NSString *)shareTitle
{
    if (_share_title.length > 0) {
        NSString *str =  [_share_title mutableCopy];
        str = [str stringByReplacingOccurrencesOfString:@"{GOODS}" withString:_title];
        str = [str stringByReplacingOccurrencesOfString:@"{GOODS_URL}" withString:_url];
        return str;
    }
    return @"分享给你一件商品";
}

//商品分享描述
- (NSString *)shareDesc
{
    if (_share_desc.length > 0) {
        NSString *str = [_share_desc mutableCopy];
        str = [str stringByReplacingOccurrencesOfString:@"{GOODS}" withString:_title];
        str = [str stringByReplacingOccurrencesOfString:@"{GOODS_URL}" withString:_url];
        return str;
    }
    return [_title stringByAppendingString:@"代理价不错，去看看吧"];
}

- (double)multiSkusCaigouPrice
{
    //如果有批发规则
    if (self.bulk_rule) {
        AMDProductRuleModel *userrule = nil;
        NSInteger _takeOrderCount = self.allSkuTakeOrderCount.integerValue;
        
        NSString *bulk_type = _bulk_rule.bulk_type;
        NSString *price_type = _bulk_rule.price_type;
        
        if ([bulk_type isEqualToString:@"full_number"]) {       //满件优惠
            //计算使用哪一种规则
            NSInteger ruleindex = -1;
            //
            for (NSInteger i = 0;i< _bulk_rule.sortedRules.count-1; i++) {
                AMDProductRuleModel * rule = _bulk_rule.sortedRules[i];
                AMDProductRuleModel * nextrule = _bulk_rule.sortedRules[i+1];
                
                //如果数量处于中间的批发价时候
                if (_takeOrderCount >= rule.num.intValue && _takeOrderCount < nextrule.num.intValue) {
                    ruleindex = i;
                    break;
                }
                
                //如果下单数量超过最大的批发数量的时候
                if (i == _bulk_rule.sortedRules.count-2) {
                    if (_takeOrderCount >= nextrule.num.intValue) {
                        ruleindex = i+1;
                        break;
                    }
                }
            }
            
            //阶梯价规则只有一个设置的时候
            if (_bulk_rule.sortedRules.count == 1) {
                if (_takeOrderCount >= [_bulk_rule.sortedRules[0] num].intValue) {
                    ruleindex = 0;
                }
            }
            
            //获取使用的批发规格
            if (ruleindex != -1) {
                userrule = _bulk_rule.sortedRules[ruleindex];
            }
        }
        else if ([bulk_type isEqualToString:@"full_amount"]){   //满金额优惠
            //计算使用哪一种规则
            NSInteger ruleindex = 0;
            for (NSInteger i = 0;i< _bulk_rule.sortedRules.count; i++) {
                AMDProductRuleModel * rule = _bulk_rule.sortedRules[i];
                //如果下单数量大于采购数量 的时候 -不满足条件
                if (rule.amount.intValue >= _takeOrderCount) {
                    ruleindex = i-1;
                    break;
                }
            }
            
            //获取使用的批发规格
            if (ruleindex != -1) {
                userrule = _bulk_rule.sortedRules[ruleindex];
            }
        }
        
        if (userrule) {
            double value = userrule.value.doubleValue;
            //折扣--目前不支持
            if ([price_type isEqualToString:@"discount"]) {
                return 0;
            }
            //减价
            else if ([price_type isEqualToString:@"price"]){
                return value;
            }
        }
    }
    return 0;
}


//转发数量
- (NSNumber *)forward_count
{
    return _forward_count == nil?@0:_forward_count;
}

- (NSNumber *)allSkuTakeOrderCount
{
    NSInteger totalcount = 0;
    for (AMDSupplySkuModel *skumodel in _sku_arr) {
        totalcount += skumodel.takeOrderCount.intValue;
    }
    return @(totalcount);
}


@end





@implementation AMDSupplyProductOptionModel

- (void)dealloc
{
    self.id = nil;
    self.product_id = nil;
    self.code = nil;
    self.name = nil;
    self.position = nil;
}

- (NSString *)optionKey
{
    NSArray *options = @[@"option1:",@"option2:",@"option3:",@"option4:",@""];
    NSString *option = options[_position.intValue];
    return option;
}

@end


@implementation AMDSupplyProductTagModel

- (void)dealloc
{
    self.tag_id = nil;
    self.supplier_id = nil;
    self.product_id = nil;
    self.name = nil;
}

@end



@implementation AMDProductBulkModel

- (void)dealloc
{
    self.bulk_type = nil;
    self.price_type = nil;
    self.rule_arr = nil;
    self.sortedRules = nil;
}

//按num 升序排列
- (NSArray *)sortedRules
{
    NSArray *rules = [_rule_arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([[obj1 num] intValue] > [[obj2 num] intValue]) {
            return NSOrderedDescending;
        }
        if ([[obj1 num] intValue] == [[obj2 num] intValue]) {
            return NSOrderedSame;
        }
        return NSOrderedAscending;
    }];
    return rules;
}

@end


@implementation AMDProductRuleModel

- (void)dealloc
{
    self.num = nil;
    self.amount = nil;
    self.value = nil;
}

@end



@implementation AMDSupplyLevelModel

- (void)dealloc
{
    self.level = nil;
    self.level_id = nil;
    self.supplier_id = nil;
    self.name = nil;
    self.discount = nil;
    self.created_at = nil;
    self.updated_at = nil;
}

@end







