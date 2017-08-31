//
//  AMDKeyboradView.m
//  AppMicroDistribution
//
//  Created by SunSet on 15-5-20.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import "AMDKeyboradView.h"
#import "AMDButton.h"
#import "AMDLineView.h"
#import "SSGlobalVar.h"

@interface AMDKeyboradView()
{
    __weak AMDButton *_dianBt;       //点
}

@end


@implementation AMDKeyboradView

- (id)init
{
    if (self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 216+40)]) {
        [self initView];
    }
    return self;
}


//视图加载
- (void)initView
{
    self.backgroundColor = [UIColor whiteColor];
    
    // 完成按钮
    CGFloat barheight = 40;
    UIToolbar *bar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, barheight)];
    [self addSubview:bar];
    UIButton *finishbt = [UIButton buttonWithType:UIButtonTypeCustom];
    [finishbt setTitle:@"完成" forState:UIControlStateNormal];
    finishbt.titleLabel.font = SSFontWithName(@"", 14);
    [finishbt setFrame:CGRectMake(self.frame.size.width-35-10, 0, 35, barheight)];
    [finishbt setTitleColor:SSColorWithRGB(255, 82, 54, 1) forState:UIControlStateNormal];
    [finishbt addTarget:self action:@selector(clickFinishAction:) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:finishbt];
    
    CGFloat btw = self.frame.size.width/3.0;
    CGFloat bth = 216.0/4.0;
    for (NSInteger i = 0; i < 12; i++) {
        AMDButton *bt = [[AMDButton alloc]initWithFrame:CGRectMake(btw*(i%3), barheight+bth*(i/3), btw, bth)];
        NSString *imagename = [[NSString alloc]initWithFormat:@"%li.png",(long)i+1];
        NSString *strResourcesBundle = SSGetFilePath(@"SSKeyBoard.bundle");
        UIImage *image = [[UIImage alloc]initWithContentsOfFile:[strResourcesBundle stringByAppendingPathComponent:imagename]];
        bt.imageView.image = image;
        [bt setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [bt setBackgroundColor:SSLineColor forState:UIControlStateHighlighted];
        [bt addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bt];
        bt.tag = i+1;
        
        switch (i) {
            case 10: // 0
            {
                UIImage *image0 = [[UIImage alloc]initWithContentsOfFile:[strResourcesBundle stringByAppendingPathComponent:@"0.png"]];
                bt.imageView.image = image0;
            }
                break;
            case 11: //删除
            {
                UIImage *delimg = [[UIImage alloc]initWithContentsOfFile:[strResourcesBundle stringByAppendingPathComponent:@"c.png"]];
                bt.imageView.image = delimg;
            }
                break;
            case 9:
            {
                bt.userInteractionEnabled = NO;
            }
                break;
            default:
                break;
        }
        bt.imageView.frame = CGRectMake(0, 0, 45, 45);
        bt.imageView.center = CGPointMake(btw/2, bth/2);
    }
    
    //线条
    for (NSInteger i =0; i<4; i++) {
        //横线
        AMDLineView *line = [[AMDLineView alloc]initWithFrame:CGRectMake(0, barheight+bth*i, self.frame.size.width, SSLineHeight) Color:SSColorWithRGB(212, 219, 226, 1)];
        [self addSubview:line];
        //竖线
        if (i==1||i==2) {
            AMDLineView *shuline = [[AMDLineView alloc]initWithFrame:CGRectMake(btw*i, barheight, SSLineHeight, 216) Color:SSColorWithRGB(212, 219, 226, 1)];
            [self addSubview:shuline];
        }
    }
}

//
- (UIImage *)imageFromImageName:(NSString *)name
{
    NSString *path = SSGetFilePathFromBundle(@"SSKeyBoard.bundle", name);
    UIImage *img = [[UIImage alloc]initWithContentsOfFile:path];
    return img;
}



#pragma mark - 按钮事件
// 完成事件
- (void)clickFinishAction:(UIButton *)sender
{
    [_parentField resignFirstResponder];
}




#pragma mark - 按钮事件
- (void)clickAction:(AMDButton *)sender
{
    NSString *text = nil;
    switch (sender.tag) {
        case 10:{//点
            text = @".";
            //            _dianBt = sender;
        }
            break;
        case 11://0
            text = @"0";
            break;
        case 12:
            text = @"";
            break;
        default:
            text = [[NSString alloc]initWithFormat:@"%li",(long)sender.tag];
            break;
    }
    [self keyBoard:self text:text];
    
    //检查是否含有小数点
    [self checkDecimalPoint];
}

- (void)keyBoard:(AMDKeyboradView *)keyboard text:(NSString *)text
{
    NSMutableString *pricestr = [_parentField.text mutableCopy];
    if (text.length == 0) {//删除按钮
        if (pricestr.length > 0) {
            [pricestr deleteCharactersInRange:NSMakeRange(pricestr.length-1, 1)];
        }
    }
    else{
        [pricestr appendString:text];
    }
    _parentField.text = pricestr;
}



#pragma mark - API
- (BOOL)checkDecimalPoint
{
    //如果已经有点 直接不可用
    BOOL ishasdian = [_parentField.text rangeOfString:@"."].length >0;
    _dianBt.imageView.alpha = ishasdian ?0.5:1;
    _dianBt.userInteractionEnabled = !ishasdian;
    return ishasdian;
}



#pragma mark - SET方法
- (void)setKeyboardType:(AMDKeyboardType)keyboardType
{
    if (_keyboardType != keyboardType) {
        _keyboardType = keyboardType;
        
        //设置小数点
        AMDButton *bt = (AMDButton *)[self viewWithTag:10];
        if (_keyboardType == AMDKeyboardTypePrice) {
            bt.userInteractionEnabled = YES;
            NSString *strResourcesBundle = SSGetFilePath(@"SSKeyBoard.bundle");
            UIImage *image0 = [[UIImage alloc]initWithContentsOfFile:[strResourcesBundle stringByAppendingPathComponent:@"dian.png"]];
            bt.imageView.image = image0;
            _dianBt = bt;
        }
        else{
            bt.userInteractionEnabled = NO;
        }
    }
}

@end



