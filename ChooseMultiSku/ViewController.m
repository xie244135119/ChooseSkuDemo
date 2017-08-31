//
//  ViewController.m
//  ChooseMultiSku
//
//  Created by SunSet on 2017/8/30.
//  Copyright © 2017年 SunSet. All rights reserved.
//

#import "ViewController.h"
#import "AMDChooseSkuView.h"
#import <SSBaseKit/SSBaseKit.h>
#import <AMDNetworkService/NSApi.h>


@interface ViewController ()<AMDChooseSkuDelegate>
{
    __weak AMDLabelShowView *_showSelectModelView;      //显示选中的Model View
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - 测试 
// 视图加载
- (void)test
{
    //
    [NSApi registerHostUrl:[NSURL URLWithString:@"http://api.sandbox.wdwd.com"]];
    [NSApi registerUserAgent:@{@"wdwd_wfx_enterprise":@"2.0",@"enterprise":@"bainiang"}];
    
    NSHttpRequest *request = [[NSHttpRequest alloc]init];
    request.requestParams = @{@"supplier_id":@"MHEA"};
    request.urlPath = @"/supplier/product/1KDAD";
    __weak typeof(self) weakself = self;
    request.completion = ^(id responseObject, NSError *error) {
        if ([responseObject[@"status"] isEqualToString:@"success"]) {
            AMDSupplierProductModel *productModel = [[AMDSupplierProductModel alloc]initWithDictionary:responseObject[@"data"][@"product"] error:nil];
         
            [weakself initContentViewWithModel:productModel];
        }
    };
    
    [[NSApi shareInstance] sendReq:request];
}



// 加载默认视图
- (void)initContentViewWithModel:(AMDSupplierProductModel *)model
{
    // 视图加载
    AMDChooseSkuView *skuView = [[AMDChooseSkuView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 300)];
    skuView.delegate = self;
    [self.view addSubview:skuView];
    // 设置数据源
    [skuView assignProductModel:model];
    
    // 设置显示视图
    AMDLabelShowView *showView = [[AMDLabelShowView alloc]initWithFrame:CGRectMake(0, 340, self.view.frame.size.width, 45)];
    showView.titleLabel.text = @"选中规格";
    showView.layer.borderWidth = 1;
    [self.view addSubview:showView];
    _showSelectModelView = showView;
    
}



#pragma mark - AMDChooseSkuDelegate
//
- (void)skuView:(AMDChooseSkuView *)skuView
      selectSku:(AMDSupplySkuModel *)skuModel
{
    _showSelectModelView.contentLabel.text = [skuModel skuString2];
    NSLog(@" 选中的Model：%@ ", skuModel);
}


@end






