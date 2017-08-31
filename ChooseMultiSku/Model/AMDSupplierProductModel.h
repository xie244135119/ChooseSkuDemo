//
//  AMDSupplierProductModel.h
//  AppMicroDistribution
//  供应商货品
//  Created by SunSet on 15-6-2.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import <SSBaseLib/SSBaseLib.h>
#import "AMDSupplySkuModel.h"

@protocol AMDSupplyProductOptionModel,AMDSupplyProductTagModel,AMDSupplyPhotoModel;
@class AMDProductBulkModel,AMDSupplySkuModel;


@protocol AMDSupplierProductModel @end

@interface AMDSupplierProductModel : AMDBaseModel

@property (nonatomic) NSInteger has_auth;       ///< 商品授权

@property(nonatomic, copy)NSString *fromtype;//来源类型
@property(nonatomic, copy)NSString *team_name;                          //团队名称
@property(nonatomic, copy) NSString *product_id;                        //商品id
@property(nonatomic, copy) NSString *supplier_id;                       //供应商id
//供应商信息 {@"supplier_title":供应商标题}
@property(nonatomic, strong) NSDictionary *supplier_info;                     //供应商标题
@property(nonatomic, copy) NSString *supplier_title;                    //供应商标题
@property(nonatomic, copy) NSString *title;                             //商品标题
@property(nonatomic, copy) NSString *vip_price;                         //会员价格
@property(nonatomic, copy) NSString *retail_price;                      //零售价格
@property(nonatomic, copy) NSString *price;                             //当前价格
@property(nonatomic, copy) NSString *min_retail_price;                  //最低零售价
@property(nonatomic, copy) NSString *max_retail_price;                  //最高零售价
@property(nonatomic, copy) NSString *img;                               //商品头图
@property(nonatomic, strong) NSNumber *sell_count;                        //销售数量
@property(nonatomic, strong) NSNumber *forward_count;                       //转发数量
@property(nonatomic, strong) NSNumber *quantity;                          //库存数量
@property(nonatomic, strong) NSNumber *quantity_setting;                  //库存设置
@property(nonatomic, strong) NSNumber *has_showcase;                      //是否存在商品页面模板
@property(nonatomic, strong) NSNumber *published;                         //发布状态 1为上架 0为下架
@property(nonatomic, copy) NSString *body_html;                         //商品描述内容
@property(nonatomic, copy) NSString *product_type;                      //商品类型
@property(nonatomic, strong) NSNumber *product_category;                  //商品条目
@property(nonatomic, copy) NSString *brand;                             //商品品牌
@property(nonatomic, copy) NSString *vendor;                            //商品供应商
@property(nonatomic, strong) NSNumber *is_promoted;                       //是否推广
@property(nonatomic, strong) NSNumber *commission;                        //推广佣金
@property(nonatomic, strong) NSNumber *like_total;                        //喜爱投票总数
@property(nonatomic, copy) NSString *yl_body;                           //有量同步精简的商品描述
@property(nonatomic, copy) NSString *yl_desc;                           //有量商品描述
@property(nonatomic, strong) NSNumber *created_at;                           //
@property(nonatomic, strong) NSNumber *updated_at;                           //
@property(nonatomic, strong) NSArray<AMDSupplySkuModel> *sku_arr;                           //库存列表
@property(nonatomic, strong) NSArray<AMDSupplyProductOptionModel> *product_option_arr;                //商品属性列表述
@property(nonatomic, strong) NSArray<AMDSupplyPhotoModel> *photo_arr;                         //商品图片列表
@property(nonatomic, strong) NSArray<AMDSupplyProductTagModel> *tag_arr;                           //商品标签列表
@property (nonatomic, strong) NSArray *tags;  ///< 小店商品分类标签。string类型数组。
@property (nonatomic, strong) NSArray<AMDSupplyProductTagModel> *tp_tag_arr;    ///< 团队商品分类标签。
@property(nonatomic, strong) AMDProductBulkModel *bulk_rule;                         //批发规则
@property(nonatomic, copy) NSString *url;                                   //商品的地址

//用户在后端设置的分享样式
@property(nonatomic, copy) NSString *share_title;                           //分享的标题
@property(nonatomic, copy) NSString *share_desc;                            //分享的描述内容

@property(nonatomic, strong) NSNumber *allSkuTakeOrderCount;                   //所有的sku 下单总数量

#pragma mark - 团队
@property(nonatomic, copy) NSString *team_id;               //团队ID




// 销售最小价格
- (NSString *)minSalePrice;

// 能赚价格
- (NSString *)canMakeMoneyStr;

// 多规格下面最小的规格
- (NSString *)minVipPrice;

//商品分享标题
- (NSString *)shareTitle;

//商品分享描述
- (NSString *)shareDesc;

// 多规格下面的批发价
- (double )multiSkusCaigouPrice;


#pragma mark - 额外使用的字段
@property(nonatomic, strong) AMDSupplySkuModel *takeOrderSkuModel;          //下单的商品型号

@end



//商品规格
@protocol AMDSupplyProductOptionModel @end
@interface AMDSupplyProductOptionModel : AMDBaseModel

@property(nonatomic, strong) NSNumber *id;                                  //id
@property(nonatomic, strong) NSNumber *product_id;                          //商品id
@property(nonatomic, copy) NSString *code;                                  //选项码
@property(nonatomic, copy) NSString *name;                                  //选项名称
@property(nonatomic, strong) NSNumber *position;                            //选项在选项列表中的位置

// 规格字段 (option1,option2,option3,option4)
- (NSString *)optionKey;

@end


//商品标签
@protocol AMDSupplyProductTagModel @end
@interface AMDSupplyProductTagModel : AMDBaseModel

@property(nonatomic, copy) NSString *tag_id;                                //商品标签id
@property(nonatomic, copy) NSString *supplier_id;                           //供应商id
@property(nonatomic, copy) NSString *product_id;                            //商品id
@property(nonatomic, copy) NSString *name;                                  //标签名称
@property (nonatomic, strong) NSNumber *bp_count;

@end


//供应商商品图片
@protocol AMDSupplyPhotoModel @end
@interface AMDSupplyPhotoModel : AMDBaseModel

@property(nonatomic, strong) NSNumber *photo_id;                              //商品图片id
@property(nonatomic, copy) NSString *product_id;                              //商品id
@property(nonatomic, copy) NSString *url;                                     //图片地址
@property(nonatomic, strong) NSNumber *width;                                 //宽度
@property(nonatomic, strong) NSNumber *height;                                    //高度
@property(nonatomic, strong) NSNumber *position;                                  //图片位置
@property(nonatomic, copy) NSString *mark;                                      //图片标记
@property(nonatomic, strong) NSNumber *created_at;                              //创建时间
@property(nonatomic, strong) NSNumber *updated_at;                              //修改时间

@end


//折扣表
@protocol AMDProductRuleModel;
@protocol AMDProductBulkModel @end
@interface AMDProductBulkModel : AMDBaseModel

@property(nonatomic, copy) NSString *bulk_type;                 //full_number(满件优惠), full_amount(满金额优惠)
@property(nonatomic, copy) NSString *price_type;                //discount(折扣),price(固定价)
@property(nonatomic, strong) NSArray<AMDProductRuleModel> *rule_arr;                    //采购规则列表

//按照从小到大排序好的规则
@property(nonatomic, strong) NSArray *sortedRules;

@end


@protocol AMDProductRuleModel @end
@interface AMDProductRuleModel : AMDBaseModel

@property(nonatomic, strong) NSNumber *num;                     //bulk_type为full_number时使用该字段
@property(nonatomic, copy) NSString *amount;                     //bulk_type为full_amount时使用该字段
@property(nonatomic, copy) NSString *value;                     //price_type为discount时为优惠折扣，price_type为price时为固定金额

@end



//供应商等级
@interface AMDSupplyLevelModel : AMDBaseModel

@property(nonatomic, copy) NSString *level_id;                          //等级id
@property(nonatomic, copy) NSString *supplier_id;                       //供应商id
@property(nonatomic, copy) NSString *name;                              //供应商名称
@property(nonatomic, strong) NSNumber *level;                           //供应商等级
@property(nonatomic, copy) NSString *discount;                          //折扣
@property(nonatomic, strong) NSString *created_at;                      //
@property(nonatomic, strong) NSString *updated_at;                      //

@end








