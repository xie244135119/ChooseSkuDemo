//
//  AMDSexSetView.m
//  AppMicroDistribution
//
//  Created by SunSet on 15-8-21.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import "AMDSexSetView.h"
#import "SSGlobalVar.h"
#import "AMDButton.h"
#import "AMDLineView.h"
#import "UIView+SSExtension.h"


@interface AMDSexSetView()
{
    __weak UIView *_middleView;                     //中间视图
    
    NSString *_selectSexString;                     //选中的性别字符串
}
@property(nonatomic, weak) AMDButton *selectBt;         //选中的按钮
@end

@implementation AMDSexSetView

- (void)dealloc
{
    _selectSexString = nil;
    self.selectBlock = nil;
//    self.prepareLoadBlock = nil;
}


- (id)init
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    if (self = [super initWithFrame:CGRectMake(0, 0, size.width, size.height)]) {
        [self initContentView];
    }
    return self;
}

// 视图加载
- (void)initContentView
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    self.backgroundColor = SSColorWithRGB(0, 0, 0, 0);
    
    // 中间视图
    UIView *middleView = [[UIView alloc]initWithFrame:CGRectMake(0, size.height, size.width, 170)];
    middleView.backgroundColor = SSColorWithRGB(246, 246, 246, 1);
    [self addSubview:middleView];
    _middleView = middleView;
    
    // 男
    AMDButton *malebt = [[AMDButton alloc]initWithFrame:CGRectMake(0, 0, size.width, 50)];
    malebt.titleLabel.text = @"男";
    malebt.titleLabel.textColor = SSColorWithRGB(51, 51, 51, 1);
    [malebt setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [malebt setBackgroundColor:SSLineColor forState:UIControlStateSelected];
    [middleView addSubview:malebt];
    malebt.tag = 1;
    [malebt addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 女
    AMDButton *womanbt = [[AMDButton alloc]initWithFrame:CGRectMake(0, 50, size.width, 50)];
    womanbt.titleLabel.text = @"女";
    womanbt.titleLabel.textColor = SSColorWithRGB(51, 51, 51, 1);
    [womanbt setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [womanbt setBackgroundColor:SSLineColor forState:UIControlStateSelected];
    [middleView addSubview:womanbt];
    womanbt.tag = 2;
    [womanbt addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //取消按钮
    AMDButton *cancelbt = [[AMDButton alloc]initWithFrame:CGRectMake(0, 120, size.width, 50)];
    cancelbt.titleLabel.text = @"取消";
    cancelbt.titleLabel.textColor = SSColorWithRGB(51, 51, 51, 1);
    [cancelbt setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelbt setBackgroundColor:SSLineColor forState:UIControlStateSelected];
    [middleView addSubview:cancelbt];
    cancelbt.tag = 3;
    [cancelbt addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //线条
    AMDLineView *middleline = [[AMDLineView alloc]initWithFrame:CGRectMake(0, 50, size.width, SSLineHeight) Color:SSLineColor];
    [_middleView addSubview:middleline];
    AMDLineView *topline = [[AMDLineView alloc]initWithFrame:CGRectMake(0, 120, size.width, SSLineHeight) Color:SSLineColor];
    [_middleView addSubview:topline];
}


// 选中某项
- (void)assignSex:(NSString *)sexString
{
    if (sexString.length == 0) {
        return;
    }
    
    NSInteger tag = [sexString hasPrefix:@"男"]?1:2;
    AMDButton *sender = [_middleView viewWithTag:tag];
    self.selectBt = sender;
}


// 显示视图
- (void)show
{
    //添加视图
    id app = [(UIApplication *)[UIApplication sharedApplication] delegate];
    [[app window] addSubview:self];
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:0.25 animations:^{
//        _middleView.frame = CGRectMake(0, APPHeight-_middleView.frame.size.height, APPWidth, _middleView.frame.size.height);
        _middleView.amd_y = size.height-_middleView.frame.size.height;
        weakself.backgroundColor = SSColorWithRGB(0, 0, 0, 0.56);
    }];
}

// 隐藏视图
- (void)hide
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:0.25 animations:^{
//        _middleView.frame = CGRectMake(0, APPHeight, APPWidth, _middleView.frame.size.height);
        _middleView.amd_y = size.height;
        weakself.backgroundColor = SSColorWithRGB(0, 0, 0, 0);
    } completion:^(BOOL finished) {
        [weakself removeFromSuperview];
    }];
}



#pragma mark - 按钮事件
- (void)setSelectBt:(AMDButton *)selectBt
{
    if (_selectBt != selectBt) {
        
        // 去除之前的选中色
        if (_selectBt) {
            _selectBt.selected = NO;
        }
        _selectBt = selectBt;
        _selectBt.selected = YES;
    }
}



#pragma mark - UITouch事件
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if ([touch.view isEqual:_middleView]) {
        return;
    }
    [self hide];
}



#pragma mark - 按钮事件
- (void)clickAction:(AMDButton *)sender
{
    // 设置选中效果
    self.selectBt = sender;
    
    switch (sender.tag) {
        case 1:     //男
        case 2:     //女
        {
            _selectSexString = sender.tag==2 ? @"女":@"男";
            //回调
            if (_selectBlock) {
                _selectBlock(_selectSexString);
            }
        }
            break;
        case 3:     //取消
            [self hide];
            break;
            
        default:
            break;
    }
}


//#pragma mark - 网络请求
// 网络请求
//- (void)invokeRequestWithEditSex:(NSNumber *)sex
//{
//    NSString *urlpath = [AMDPasswortURLPath stringByAppendingFormat:@"/%@",AMDTestPassportID];
//    NSDictionary *params = @{@"data":@{@"gender":sex}};
//    [[AMDRequestService sharedAMDRequestService] requestWithPutURL:urlpath parameters:params type:1 delegate:self animation:YES];
//}


//#pragma mark - AMDRequestServiceDelegate
//- (void)requestFinished:(NSDictionary *)resault type:(NSUInteger)type
//{
//    if (![resault[@"status"] isEqualToString:@"success"]) {
//        return;
//    }
//    
//    switch (type) {
//        case 1:{            //修改店铺信息
////            if ([_delegate respondsToSelector:@selector(sexSetView:object:)]) {
////                [_delegate sexSetView:self object:_selectSexString];
////            }
//            
//            
//            if (_selectBlock) {
//                _selectBlock(_selectSexString);
//            }
//            
//            [self hide];
//        }
//            break;
//            
//        default:
//            break;
//    }
//}



@end


























