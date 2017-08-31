//
//  AMDBackControl.m
//  AppMicroDistribution
//
//  Created by SunSet on 16/10/26.
//  Copyright © 2016年 SunSet. All rights reserved.
//

#import "AMDBackControl.h"
#import "SSGlobalVar.h"
#import <Masonry/Masonry.h>

// 对号视图
@interface AMDBackImgView : UIView

// 线条颜色
@property(nonatomic, strong) UIColor *strokeColor;
@end


// 自定义后退按钮
@implementation AMDBackControl
{
//    __weak UIImageView *_imageView;
    __weak AMDBackImgView *_backImgView;            //对号视图
    
//    UIImage *_normalImage;          //正常状态下的图片
//    UIImage *_hightLightImage;      //高亮状态下的图片
}

- (void)dealloc
{
//    self.imageNormalName = nil;
//    self.imageSelectName = nil;
//    self.imageNormalName2 = nil;
//    self.imageSelectName2 = nil;
//    _normalImage = nil;
//    _hightLightImage = nil;
}

- (id)init
{
    if (self = [super init]) {
        [self initContentView2];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initContentView];
    }
    
    return self;
}

- (void)initContentView
{
    // 对号显示视图
    CGSize imgsize = CGSizeMake(12, 20);
    AMDBackImgView *imgView = [[AMDBackImgView alloc]initWithFrame:CGRectMake(10, (self.frame.size.height-imgsize.height)/2, imgsize.width, imgsize.height)];
    imgView.userInteractionEnabled = NO;
    [self addSubview:imgView];
    _backImgView = imgView;
    
    // 消息数量
    UILabel *messagecountlb = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 50, 44)];
    messagecountlb.font = SSFontWithName(@"", 13);
    messagecountlb.textColor = SSColorWithRGB(75, 75, 75, 1);
    [self addSubview:messagecountlb];
    _mesRemindLabel = messagecountlb;
}

- (void)initContentView2
{
    CGSize imgsize = CGSizeMake(12, 20);
    AMDBackImgView *imgView = [[AMDBackImgView alloc]init];
    imgView.userInteractionEnabled = NO;
    [self addSubview:imgView];
    _backImgView = imgView;
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.height.equalTo(@(imgsize.height));
        make.width.equalTo(@(imgsize.width));
        make.centerY.equalTo(self);
    }];
    
    // 消息数量
    UILabel *messagecountlb = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 50, 44)];
    messagecountlb.font = SSFontWithName(@"", 13);
    messagecountlb.textColor = SSColorWithRGB(75, 75, 75, 1);
    [self addSubview:messagecountlb];
    _mesRemindLabel = messagecountlb;
    [messagecountlb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@30);
        make.top.equalTo(@0);
        make.width.equalTo(@50);
        make.height.equalTo(@44);
    }];
    
}


// 高亮状态
- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    UIColor *highlightcolor = [UIColor colorWithWhite:0 alpha:0.3];
    _backImgView.strokeColor = highlighted?highlightcolor:_imgStrokeColor;
}




- (void)setImgStrokeColor:(UIColor *)imgStrokeColor
{
    if (_imgStrokeColor != imgStrokeColor) {
        _imgStrokeColor = imgStrokeColor;
        
        _backImgView.strokeColor = imgStrokeColor;
    }
}


@end



@implementation AMDBackImgView
{
    CALayer *_shapeLayer;       //线条layer
}

- (void)dealloc
{
    self.strokeColor = nil;
}

- (void)drawRect:(CGRect)rect
{
    [_shapeLayer removeFromSuperlayer];
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, width, 0);
    CGPathAddLineToPoint(path, nil, 2, height/2);
    CGPathAddLineToPoint(path, nil, width, height);
    
    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    layer.path = path;
    layer.strokeColor = _strokeColor.CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth = 1.5;
    layer.lineJoin = @"round";
    [self.layer addSublayer:layer];
    _shapeLayer = layer;
}


- (void)setStrokeColor:(UIColor *)strokeColor
{
    if (_strokeColor != strokeColor) {
        _strokeColor = strokeColor;
        
        // 重绘
        [self setNeedsDisplay];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


@end









