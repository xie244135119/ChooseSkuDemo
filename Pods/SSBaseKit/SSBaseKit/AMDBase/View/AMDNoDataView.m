//
//  AMDNoDataView.m
//  AppMicroDistribution
//
//  Created by SunSet on 15-7-2.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import "AMDNoDataView.h"
#import "AMDButton.h"
#import "SSGlobalVar.h"
#import <Masonry/Masonry.h>
//#import "AMDTool.h"
//#import "ATAColorConfig.h"

@interface AMDNoDataView()
{
    BOOL _autoLayout;               //自动布局
    __weak AMDButton *_showBt;      //显示的文字<当前变量后期将取消>
}
@end

@implementation AMDNoDataView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = SSColorWithRGB(246, 246, 246, 1);
        if (_autoLayout) {
            [self initContentView_AutoLayout];
        }
        else {
            [self initContentView];
        }
    }
    return self;
}

- (id)init
{
    _autoLayout = YES;
    if (self = [super init]) {
        //
    }
    return self;
}

//视图加载
- (void)initContentView
{
    //无数据的时候显示 视图
    CGFloat width = self.frame.size.width;
//    CGFloat height = self.frame.size.height;
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake((width-120)/2, 45+15, 120, 120)];
    [self addSubview:imgView];
    _nodataImageView = imgView;
    
    //文本内容展示
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, width, 40)];
    textLabel.font = SSFontWithName(@"", 13);
    textLabel.textColor = SSColorWithRGB(153, 153, 153, 1);
    textLabel.numberOfLines = 2;
    textLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:textLabel];
    _titleLabel = textLabel;
    
    //按钮显示
    AMDButton *bt = [self comonButtonWithFrame:CGRectMake(75, 270, width-150, 40) title:@"去选货"];
    bt.hidden = YES;
    [self addSubview:bt];
    _showBt = bt;
    _operationBt = bt;
}

//视图加载
- (void)initContentView_AutoLayout
{
    //无数据的时候显示 视图
//    CGFloat width = self.frame.size.width;
    //    CGFloat height = self.frame.size.height;
    UIImageView *imgView = [[UIImageView alloc]init];
    [self addSubview:imgView];
    _nodataImageView = imgView;
    __weak typeof(self) weakself = self;
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@150);
        make.top.equalTo(@45);
        make.centerX.equalTo(weakself.mas_centerX);
//        make.centerY.equalTo(weakself.mas_centerY).with.offset(-10);
    }];
    
    //文本内容展示
//    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 220, width, 40)];
    UILabel *textLabel = [[UILabel alloc]init];
    textLabel.font = SSFontWithName(@"", 13);
    textLabel.textColor = SSColorWithRGB(153, 153, 153, 1);
    textLabel.numberOfLines = 2;
    textLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:textLabel];
    _titleLabel = textLabel;
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(imgView.mas_bottom).with.offset(25);
        make.height.equalTo(@40);
    }];
    
    //按钮显示
    AMDButton *bt = [self comonButtonWithFrame:CGRectZero title:@"去选货"];
    bt.hidden = YES;
    [self addSubview:bt];//(75, 270, width-150, 40)
    _showBt = bt;
    [bt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@75);
        make.top.equalTo(@270);
        make.right.equalTo(@-75);
        make.height.equalTo(@40);
    }];
}


//公用的按钮
- (AMDButton *)comonButtonWithFrame:(CGRect)frame title:(NSString *)title
{
    AMDButton *bt = [[AMDButton alloc]initWithFrame:frame];
    if (_autoLayout) {
        bt = [[AMDButton alloc]init];
    }
    bt.titleLabel.text = title;
    [bt setBackgroundColor:SSColorWithRGB(68,129,235, 1) forState:UIControlStateNormal];
    [bt setBackgroundColor:nil forState:UIControlStateHighlighted];
    [bt setTitleColor:SSColorWithRGB(255, 255, 255, 1) forState:UIControlStateNormal];
    bt.titleLabel.font = SSFontWithName(@"", 15);
    bt.layer.cornerRadius = SSCornerRadius;
    bt.layer.masksToBounds = YES;
    [bt addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    return bt;
}


/*#pragma mark -  SET
- (void)setNodataType:(AMDNoDataViewType)nodataType
{
    if (_nodataType != nodataType) {
        _nodataType = nodataType;
        
//        CGFloat width = self.frame.size.width;
        switch (nodataType) {
            case AMDNoDataViewTypeCapital:          //资金明细
            {
                _nodataImageView.image = imageFromBundleName(@"WithdrawModule.bundle", @"nodata_ Funds@2x.png");
                _titleLabel.text = @"暂无资金记录";
                [AMDTool setLineSpacing:2 label:_titleLabel];
                
            }
                break;
            case AMDNoDataViewTypeOrder:            //订单
            {
                _nodataImageView.image = imageFromBundleName(@"OrderModule.bundle", @"nodata_primitive.png");
                _titleLabel.text = @"暂无订单数据";
                
                //快去赚钱
//                AMDButton *bt = [self comonButtonWithFrame:CGRectMake(75, 270, width-150, 40) title:@"去选货"];
//                bt.tag = 1;
//                [self addSubview:bt];
                _showBt.titleLabel.text = @"去选货";
                _showBt.hidden = NO;
                _showBt.tag = 1;
            }
                break;
            case AMDNoDataViewTypeSearch:           //搜索
            {
                _nodataImageView.image = imageFromBundleName(@"SearchModule.bundle", @"nodata_search@2x.png");
                _titleLabel.text = @"未搜索到相关信息";
            }
                break;
            case AMDNoDataViewTypeDynamic:          //动态
            {
                _nodataImageView.image = imageFromBundleName(@"DynamicMoudle.bundle", @"nodata_dynamic.png");
                _titleLabel.text = @"还没有动态哦~";
                
                //去关注供应商
//                AMDButton *bt = [self comonButtonWithFrame:CGRectMake(75, 270, width-150, 40) title:@"查找供应商"];
//                bt.tag = 1;
//                [self addSubview:bt];
//                _showBt.titleLabel.text = @"查找供应商";
//                _showBt.tag = 1;
//                _showBt.hidden = NO;
            }
                break;
            case AMDNoDataViewTypeCustomer:         //会员
            {
                _nodataImageView.image = imageFromBundleName(@"AMDCustomerModule.bundle", @"nodata_Customer@2x.png"); 
                _titleLabel.text = @"还没有客户信息";
            }
                break;
            case AMDNoDataViewTypeCart:             //购物车
            {
                _nodataImageView.image = imageFromBundleName(@"CartModule.bundle", @"nodata_ShoppingCart.png");
                _titleLabel.text = @"购物车空空如也";
                
                //去选货
//                AMDButton *bt = [self comonButtonWithFrame:CGRectMake(75, 270, width-150, 40) title:@"去选货"];
//                bt.tag = 1;
//                [self addSubview:bt];
                _showBt.titleLabel.text = @"去选货";
                _showBt.tag = 1;
                _showBt.hidden = NO;
            }
                break;
            case AMDNoDataViewTypeGoodsSource:      //货源
            {
                _nodataImageView.image = imageFromBundleName(@"GoodsModule.bundle", @"nodata_goods.png");
                _titleLabel.text = @"暂无商品";
            }
                break;
            case AMDNoDataViewTypeMessage:          //消息
//                _nodataImageView.image = imageFromPath(@"nodata_chat@2x.png");
                _titleLabel.text = @"暂无消息";
                break;
//            case AMDNoDataViewTypeNotification:     //通知
//            {
//                _nodataImageView.image = imageFromPath(@"nodata_commodity@2x.png");
//                _titleLabel.text = @"暂无新通知哦~";
//            }
//                break;
            case AMDNoDataViewTypeSupply:           //供应商
            {
                _nodataImageView.image = imageFromBundleName(@"SupplyModule.bundle", @"nodata_supply.png");
                _titleLabel.text = @"您还未关注供应商哦，赶紧添加供应商吧~";
                
//                AMDButton *bt = [self comonButtonWithFrame:CGRectMake(75, 270, width-150, 40) title:@"查找供应商"];
//                bt.tag = 1;
//                [self addSubview:bt];
                _showBt.titleLabel.text = @"查找供应商";
                _showBt.tag = 1;
                _showBt.hidden = NO;
            }
                break;
            case AMDNoDataViewTypeTransmit:         //转发
            {
                _nodataImageView.image = imageFromBundleName(@"MyModule.bundle", @"nodata_forward.png");
                _titleLabel.text = @"我竟然一次都么有转发过？！";
            }
                break;
            case AMDNoDataViewTypeWithdrawRecord:    //提现记录
            {
                _nodataImageView.image = imageFromBundleName(@"WithdrawModule.bundle", @"nodata_ Funds@2x.png");
                _titleLabel.text = @"暂无提现记录";
                
                //去选货
//                AMDButton *bt = [self comonButtonWithFrame:CGRectMake(75, 270, width-150, 40) title:@"去选货"];
//                bt.tag = 1;
//                [self addSubview:bt];
                _showBt.titleLabel.text = @"去选货";
                _showBt.tag = 1;
                _showBt.hidden = NO;
            }
                break;
            default:
//                _nodataImageView.image = imageFromPath(@"nodata_commodity@2x.png");
//                _titleLabel.text = @"";
                break;
        }
    }
}*/


#pragma mark - 按钮事件
- (void)clickAction:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(noDataView:senderIndex:)]) {
        [_delegate noDataView:self senderIndex:sender.tag];
    }
}


@end















