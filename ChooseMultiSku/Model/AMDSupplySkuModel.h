//
//  AMDSupplySkuModel.h
//  AppMicroDistribution
//
//  Created by SunSet on 16-4-11.
//  Copyright (c) 2016年 SunSet. All rights reserved.
//

#import <SSBaseLib/SSBaseLib.h>

//供应商商品sku
@protocol AMDSupplySkuModel @end
@interface AMDSupplySkuModel : AMDBaseModel

@property(nonatomic, copy) NSString *sku_id;                              //skuid
@property(nonatomic, copy) NSString *supplier_id;                         //供货商id
@property(nonatomic, copy) NSString *taobao_sku_id;                       //淘宝skuid
@property(nonatomic, copy) NSString *product_id;                          //商品id
@property(nonatomic, copy) NSString *price;                               //价格
@property(nonatomic, copy) NSString *min_add_price;                       //最低加价
@property(nonatomic, copy) NSString *max_add_price;                       //最高加价
@property(nonatomic, copy) NSString *retail_price;                        //零售价
@property(nonatomic, copy) NSString *vip_price;                           //vip价格
@property(nonatomic, strong) NSNumber *weight;                              //重量
@property(nonatomic, strong) NSNumber *compare_at_price;                    //市场价
@property(nonatomic, copy) NSString *option1;                               //规格1
@property(nonatomic, copy) NSString *option2;                               //规格2
@property(nonatomic, copy) NSString *option3;                               //规格3
@property(nonatomic, copy) NSString *option4;                               //规格4
@property(nonatomic, copy) NSString *sku_code;                              //规格值
@property(nonatomic, strong) NSNumber *requires_shipping;                   //需要物流
@property(nonatomic, strong) NSNumber *quantity;                            //库存量
@property(nonatomic, strong) NSNumber *quantity_setting;                    //库存设置
@property(nonatomic, copy) NSString *inventory_management;                  //
@property(nonatomic, copy) NSString *inventory_policy;                      //
@property(nonatomic, strong) NSNumber *created_at;                          //
@property(nonatomic, strong) NSNumber *updated_at;                          //
@property(nonatomic, strong) NSNumber *position;                            //在sku列表中的显示位置
@property(nonatomic, strong) NSNumber *last_sync_time;                          //最后从淘宝同步的时间
@property(nonatomic, copy) NSString *last_sync_code;                          //最后从淘宝同步的状态码
@property(nonatomic,  copy) NSString *max_retail_price;                 //建议最高售价
@property(nonatomic, copy) NSString *min_retail_price;                  //建议最低售价
@property (nonatomic, copy) NSString *min_pt_price;         ///< 最低拼团价
@property (nonatomic, copy) NSString *max_pt_price;         ///< 最高拼团价
@property(nonatomic, strong) NSNumber *grams;                               //克数
//@property(nonatomic, strong) AMDProductBulkModel *bulk_rule;                         //批发规则

#pragma mark - 额外使用的字段
@property(nonatomic, strong) NSNumber *takeOrderCount;                      //采购下单数量
@property(nonatomic, copy) NSString *takeOrderPrice;                        //采购下单价格
//当商品所有sku下的总数量达到批发规则的时候使用批量采购价
@property(nonatomic, strong) NSNumber *takeOrderBulkVipPrice;               //当批量采购价


#pragma mark - 临时添加
@property (nonatomic, copy) NSString *earningsPrice;    //我能赚的价格
@property (nonatomic, copy) NSString *inputText;        //我输入的价格

@property (nonatomic, copy) NSString *team_id;          //团队id

@property (nonatomic, copy) NSString *PTPrice;          ///< 拼团拼


#pragma mark V2.2之后需要
@property (nonatomic, strong) AMDSupplySkuModel *sku;           //数据
@property (nonatomic, copy) NSString *bsku_id;                  //分销店铺用到的bsku_id



//销售最小价格
- (NSString *)minSalePrice;

// 总计结算价
//- (CGFloat)caigouJieSuanPrice;

// 采购下单的时候使用批量采购价价格
- (NSString *)skuVipPrice;

// 拼接所有的商品属性字段
- (NSString *)allOptionValue;

// 商品sku值-拼接的sku字符串 "红色L码43号"
- (NSString *)skuString;
// 商品sku值-拼接的sku字符串 "红色 L码 43号"(带风格)
- (NSString *)skuString2;


@end









