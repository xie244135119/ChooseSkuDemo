//
//  AMDLabelShowView.m
//  AppMicroDistribution
//
//  Created by SunSet on 15-5-20.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import "AMDLabelShowView.h"
#import "AMDLineView.h"
#import "SSGlobalVar.h"
//#import <Masonry/Masonry.h>
#import <Masonry/Masonry.h>


@interface AMDLabelShowView()
{
    UIColor *_selectBackgroundColor;                //选中的背景背景色
    UIColor *_normalBackgroundColor;                //正常时候的背景颜色
    UIColor *_higlhtedBackgroundColor;              //点击时候的背景颜色
    UIColor *_disabledBackgroundColor;              //不可用时候的背景色
    
    BOOL _autoLayout;               //自动布局
    
    __weak UIImageView *_currentArrowImgview;                //当前右箭头
    __weak AMDLineView *_line;
}
@end

@implementation AMDLabelShowView

- (void)dealloc
{
    _selectBackgroundColor = nil;
    _normalBackgroundColor = nil;
    _higlhtedBackgroundColor = nil;
    _disabledBackgroundColor = nil;
//    NSLog(@" %@ %s ",[self class],__func__);
}


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        if (_autoLayout) {
            [self initContentView];
        }
        else{
            [self initContentView2];
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



- (void)initContentView2
{
        CGFloat h = self.frame.size.height;
    // 名称 左侧展示
        UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, h)];
//    UILabel *titleLable = [[UILabel alloc]init];
    titleLable.backgroundColor = [UIColor clearColor];
    titleLable.font = SSFontWithName(@"", 14);
    titleLable.textColor = SSColorWithRGB(51, 51, 51, 1);
    [self addSubview:titleLable];
    //    titleLable.layer.borderWidth = 1;
    _titleLabel = titleLable;
//    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).with.offset(15);        //据左侧15
//        make.top.bottom.equalTo(self).with.offset(0);   //占满
//        make.width.equalTo(@100);
//        make.height.equalTo(self.mas_height);
//    }];
    
    // 内容 右侧展示
    AMDCopyLabel *contentLable = [[AMDCopyLabel alloc]initWithFrame:CGRectMake(120, 0, self.frame.size.width-120-15, h)];
//    AMDCopyLabel *contentLable = [[AMDCopyLabel alloc]init];
    contentLable.textAlignment = NSTextAlignmentRight;
    contentLable.backgroundColor = [UIColor clearColor];
    contentLable.font = SSFontWithName(@"", 14);
    contentLable.numberOfLines = 0;
    //    contentLable.textColor = SSColorWithRGB(51, 51, 51, 1);
    contentLable.textColor = SSColorWithRGB(119, 119, 119, 1);
        contentLable.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    //    contentLable.layer.borderWidth = 1;
    [self addSubview:contentLable];
    _contentLabel = contentLable;
//    [contentLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(titleLable.mas_right).with.offset(5);         //距离左侧控件5
//        make.right.equalTo(self).with.offset(-15);                      //距离右侧控件左侧15
//        make.top.bottom.equalTo(self).with.offset(0);                   //占满上下层
//        make.height.equalTo(self.mas_height);
//    }];
}

//视图加载
- (void)initContentView
{
//    CGFloat h = self.frame.size.height;
    // 名称 左侧展示
//    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, h)];
    UILabel *titleLable = [[UILabel alloc]init];
    titleLable.backgroundColor = [UIColor clearColor];
    titleLable.font = SSFontWithName(@"", 14);
    titleLable.textColor = SSColorWithRGB(51, 51, 51, 1);
    [self addSubview:titleLable];
    _titleLabel = titleLable;
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(15);        //据左侧15
        make.top.bottom.equalTo(self).with.offset(0);   //占满
        make.width.equalTo(@60);
        make.height.equalTo(self.mas_height);
    }];
    
    // 内容 右侧展示
//    AMDCopyLabel *contentLable = [[AMDCopyLabel alloc]initWithFrame:CGRectMake(120, 0, self.frame.size.width-120-15, h)];
    AMDCopyLabel *contentLable = [[AMDCopyLabel alloc]init];
    contentLable.textAlignment = NSTextAlignmentRight;
    contentLable.backgroundColor = [UIColor clearColor];
    contentLable.font = SSFontWithName(@"", 14);
    contentLable.numberOfLines = 0;
//    contentLable.textColor = SSColorWithRGB(51, 51, 51, 1);
    contentLable.textColor = SSColorWithRGB(119, 119, 119, 1);
//    contentLable.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self addSubview:contentLable];
    _contentLabel = contentLable;
    [contentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLable.mas_right).with.offset(5);         //距离左侧控件5
        make.right.equalTo(self).with.offset(-15);                      //距离右侧控件左侧15
        make.top.bottom.equalTo(self).with.offset(0);                   //占满上下层
        make.height.equalTo(self.mas_height);
    }];
}


- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state
{
    switch (state) {
        case UIControlStateNormal:{
            _normalBackgroundColor = backgroundColor;
            self.backgroundColor = backgroundColor;
        }
            break;
        case UIControlStateHighlighted:
            _higlhtedBackgroundColor = backgroundColor;
            break;
        case UIControlStateSelected:
            _selectBackgroundColor = backgroundColor;
            break;
        case UIControlStateDisabled:
            _disabledBackgroundColor = backgroundColor;
            break;
        default:
            break;
    }
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    switch (self.state) {
        case UIControlStateHighlighted: //高亮的时候
            //选中时候的背景颜色
            if (_higlhtedBackgroundColor) {
                self.backgroundColor = _higlhtedBackgroundColor;
            }
            
            //有点击事件
            if (_rightArrowShow) {
                self.backgroundColor = highlighted ?SSLineColor:[UIColor whiteColor];
            }
            
            break;
        case UIControlStateNormal:
            self.backgroundColor = _normalBackgroundColor?_normalBackgroundColor:[UIColor clearColor];
            break;
        case UIControlStateSelected:{
            if (_selectBackgroundColor) {
                self.backgroundColor = _selectBackgroundColor;
            }
        }
            break;
        case UIControlStateDisabled:
            if (_disabledBackgroundColor) {
                self.backgroundColor = _disabledBackgroundColor;
            }
            break;
        default:
            break;
    }
}


#pragma mark - SET方法
- (void)setRightArrowShow:(BOOL)rightArrowShow
{
    if (_rightArrowShow != rightArrowShow) {
        _rightArrowShow = rightArrowShow;
        
        if (rightArrowShow) {
            if (_currentArrowImgview == nil) {
//                NSString *arrowpath = SSImageFromName(@"arrow-right.png");
                UIImage *arrowiamge = SSImageFromName(@"arrow-right.png");
                UIImageView *imgView = [[UIImageView alloc]init];
                imgView.tag = 2;
                imgView.image = arrowiamge;
                [self addSubview:imgView];
                imgView.hidden = YES;
                _currentArrowImgview = imgView;
                [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.height.equalTo(@24);
                    make.right.equalTo(self).with.offset(-10);
                    make.centerY.equalTo(self.mas_centerY);
                }];
            }
        }
        _currentArrowImgview.hidden = !rightArrowShow;
    }

    // 更新内容展示视图布局
    [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_right).with.offset(5);    //距离左侧控件5
        make.right.equalTo(self).with.offset(-15-(rightArrowShow?24:0));                   //距离右侧控件左侧15
        make.top.bottom.equalTo(self).with.offset(0);
    }];
}


#pragma mark - 线条显示
- (void)setSupportTopLine:(BOOL)supportTopLine
{
    _supportTopLine = supportTopLine;
    
    if (supportTopLine) {
        AMDLineView *line = [[AMDLineView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, SSLineHeight) Color:SSLineColor];
        [self addSubview:line];
        
        if (_autoLayout) {
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.equalTo(@0);
                make.height.equalTo(@(SSLineHeight));
            }];
        }
    }
}

- (void)setSupportBottomLine:(BOOL)supportBottomLine
{
    _supportBottomLine = supportBottomLine;
    
    if (_supportBottomLine) {
        AMDLineView *line = [[AMDLineView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-SSLineHeight, self.frame.size.width, SSLineHeight) Color:SSLineColor];
        _line = line;
        [self addSubview:line];
        
        // 自动布局
        if (_autoLayout) {
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(@0);
                make.height.equalTo(@(SSLineHeight));
            }];
        }
        
    }else{
        if (_line != nil) {
            [_line removeFromSuperview];
        }
    }
}


@end








