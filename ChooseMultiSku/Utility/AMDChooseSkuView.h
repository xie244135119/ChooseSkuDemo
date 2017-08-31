//
//  AMDChooseSkuView.h
//  AppMicroDistribution
//  选择多Sku的视图<下单需要选择>
//  Created by SunSet on 16/9/18.
//  Copyright © 2016年 SunSet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMDSupplierProductModel.h"
@protocol AMDChooseSkuDelegate;

@interface AMDChooseSkuView : UIView


@property(nonatomic, weak) id<AMDChooseSkuDelegate> delegate;


/**
 需要的商品赋值

 @param productModel 商品Model
 */
- (void)assignProductModel:(AMDSupplierProductModel *)productModel;

/**
 进入页面默认选中某一个skuid

 @param skuID 选中的skuid
 */
- (void)selectProductSkuID:(NSString *)skuID;

/**
 选中的规格

 @return 选中的规格
 */
- (AMDSupplySkuModel *)prepareTakeOrderSkuModel;

@end



@protocol AMDChooseSkuDelegate <NSObject>

@optional
// 选中某一个sku的时候
- (void)skuView:(AMDChooseSkuView *)skuView
      selectSku:(AMDSupplySkuModel *)skuModel;

@end
















