//
//  AMDTabbarItem.m
//  AppMicroDistribution
//
//  Created by SunSet on 15-5-21.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import "AMDTabbarItem.h"
#import "SSGlobalVar.h"
#import <Masonry/Masonry.h>
//#import "AMDIMService.h"

@interface AMDTabbarItem()
{
    UIImage *_normalImage;                  //正常情况下的图片
    UIImage *_selectImage;                  //选中情况下的图片
    UIImage *_highlightedImage;             //高亮情况下的图片
    
    UIColor *_normalTitleColor;              //正常情况下的字体颜色
    UIColor *_selectTitleColor;              //选中情况下的字体颜色
    UIColor *_highlightedTitleColor;         //高亮情况下的字体颜色
    
    BOOL _implementAnimated;                //是否已经实现动画
    __weak UILabel *_hongxinView;            //红心视图
    
    BOOL _autoLayout;                       //自动布局
}
@end

@implementation AMDTabbarItem

- (void)dealloc
{
    
    _normalImage = nil;
    _selectImage = nil;
    _highlightedImage = nil;
    self.itemSelectImage = nil;
    
    _normalTitleColor = nil;
    _selectTitleColor = nil;
    _highlightedTitleColor = nil;
}

- (id)init
{
    _autoLayout = YES;
    return [super init];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (_autoLayout) {
            [self initContentView_autoLayout];
        }
        else {
            [self initContentView];
        }
    }
    return self;
}


- (void)setImage:(UIImage *)image controlState:(UIControlState)state
{
    switch (state) {
        case UIControlStateNormal:{     //正常
            _normalImage = image;
            _itemImageView.image = image;
        }
            break;
        case UIControlStateHighlighted:{     //高亮
            _highlightedImage = image;
        }
            break;
        case UIControlStateSelected:{       //选中状态
            _selectImage = image;
        }
            break;
        default:
            break;
    }
}

//设置字体颜色
- (void)setTitleColor:(UIColor *)titleColor controlState:(UIControlState)state
{
    switch (state) {
        case UIControlStateNormal:{     //正常
            _normalTitleColor = titleColor;
            _itemTitleLabel.textColor = titleColor;
        }
            break;
        case UIControlStateHighlighted:{     //高亮
            _highlightedTitleColor = titleColor;
        }
            break;
        case UIControlStateSelected:{       //选中状态
            _selectTitleColor = titleColor;
        }
            break;
        default:
            break;
    }
}


#pragma mark - 视图初始化
-(void)initContentView
{
    NSInteger width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    if (_itemTitleLabel == nil) {
        //标题
        UILabel *titleLb = [[UILabel alloc]initWithFrame:CGRectMake(0, height-20+2, width, 15)];
        titleLb.backgroundColor = [UIColor clearColor];
        titleLb.font = SSFontWithName(@"", 10);
        titleLb.textAlignment = NSTextAlignmentCenter;
        _itemTitleLabel = titleLb;
        [self addSubview:titleLb];
    }
    
    if (_itemImageView == nil) {
        //图片
        CGFloat imagew = 30;
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake((width-imagew)/2, 2, imagew, imagew)];
//        imgView.image = _itemImage;
        _itemImageView = imgView;
        [self addSubview:imgView];
    }
    
    // 默认支持提示语
    [self setHasNewRemind:YES];
}


- (void)initContentView_autoLayout
{
    if (_itemTitleLabel == nil) {
        //标题
        UILabel *titleLb = [[UILabel alloc]init];
        titleLb.backgroundColor = [UIColor clearColor];
        titleLb.font = SSFontWithName(@"", 10);
        titleLb.textAlignment = NSTextAlignmentCenter;
        _itemTitleLabel = titleLb;
        [self addSubview:titleLb];
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.bottom.equalTo(@-2);
            make.height.equalTo(@15);
        }];
    }
    
    if (_itemImageView == nil) {
        //图片
        CGFloat imagew = 30;
        UIImageView *imgView = [[UIImageView alloc]init];
        _itemImageView = imgView;
        [self addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@(imagew));
            make.top.equalTo(@2);
            make.centerX.equalTo(self.mas_centerX);
        }];
    }
    
    // 默认支持提示语
    [self setHasNewRemind:YES];
}



#pragma mark - SET
-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    //选中时候点击的图片
    if (_selectImage) {
        _itemImageView.image = selected?_selectImage:_normalImage;
    }
    
    //选中时候点击的字体颜色
    if (_selectTitleColor) {
        _itemTitleLabel.textColor = selected?_selectTitleColor:_normalTitleColor;
    }
    
    if (_supportAnimation) {
        __weak typeof(self) weakself = self;
        //添加选中动画
        if (selected) {
            //么有添加动画的时候
            if (!_implementAnimated) {
                _implementAnimated = YES;
                [UIView animateWithDuration:0.25 animations:^{
                    //图片放大
                    _itemImageView.frame = CGRectMake((weakself.frame.size.width-40)/2, (49-40)/2, 40, 40);
                    //文字渐渐消失
                    _itemTitleLabel.alpha = 0;
                    _itemTitleLabel.center = CGPointMake(_itemTitleLabel.center.x, _itemTitleLabel.center.y-50);
                    _itemTitleLabel.transform = CGAffineTransformMakeScale(2, 2);
                }completion:^(BOOL finished) {
                    _itemTitleLabel.transform = CGAffineTransformMakeScale(1, 1);
                }];
            }
        }
        else{
            //如果还没开始动画
            if (_implementAnimated) {
                _implementAnimated = NO;
                _itemTitleLabel.transform = CGAffineTransformMakeScale(1, 1);
                
                [UIView animateWithDuration:0.25 animations:^{
                    //图片放大
                    _itemImageView.frame = CGRectMake((weakself.frame.size.width-30)/2, 2, 30, 30);
                    //文字渐渐消失
                    _itemTitleLabel.alpha = 1;
                    _itemTitleLabel.frame = CGRectMake(0, weakself.frame.size.height-20+2, weakself.frame.size.width, 15);
                }completion:^(BOOL finished) {
                }];
            }
        }
    }
    
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    switch (self.state) {
        case UIControlStateHighlighted: //高亮的时候
            //改变选中字体颜色
            if (_highlightedTitleColor) {
                _itemTitleLabel.textColor = _highlightedTitleColor;
            }
            
            //改变图片选中时候
            if (_highlightedImage) {
                _itemImageView.image = _highlightedImage;
            }
            
            break;
        case UIControlStateNormal:
            //正常时候的字体颜色
            if (_normalTitleColor) {
                _itemTitleLabel.textColor = _normalTitleColor;
            }
            
            //正常时候的图片名称
            if (_normalImage) {
                _itemImageView.image = _normalImage;
            }
            
            break;
        case UIControlStateSelected:{
            //选中时候的字体颜色
            if (_selectTitleColor) {
                _itemTitleLabel.textColor = _selectTitleColor;
            }
            
//            if (_selectImage) {
            _itemImageView.image = _selectImage?_selectImage:_normalImage;
//            }
        }
            break;
        default:
            break;
    }
    
}



#pragma mark - SET
- (void)setHasNewRemind:(BOOL)hasNewRemind
{
//    _hasNewRemind = hasNewRemind;
    
    if (hasNewRemind) {
        //未读数量
        UILabel *unreadlb = [[UILabel alloc]initWithFrame:CGRectMake(25+(self.frame.size.width-30)/2, 2, 20, 13)];
        unreadlb.textAlignment = NSTextAlignmentCenter;
        unreadlb.font = SSFontWithName(@"", 10);
        unreadlb.layer.cornerRadius = 7;
        unreadlb.layer.masksToBounds = YES;
        unreadlb.backgroundColor = [UIColor redColor];
        unreadlb.textColor = [UIColor whiteColor];
        unreadlb.hidden = YES;
        [self addSubview:unreadlb];
        _hongxinView = unreadlb;
    }
}

// 显示消息数量
- (void)setRemindNumber:(NSInteger)count
{
    _remindNumber = count;
    
    _hongxinView.hidden = count==0;
    if (count == 0) {
        return;
    }
    
    // 红心提示
    if (count == -2) {
        _hongxinView.text = @"";
        _hongxinView.frame = CGRectMake(50+3, 4, 8, 8);
        _hongxinView.layer.cornerRadius = 4;
        _hongxinView.layer.masksToBounds = YES;
        return;
    }
    
    // 小于0的不显示
    if (count < 0) {
        _hongxinView.hidden = YES;
        return;
    }
    
    _hongxinView.text = [NSString stringWithFormat:@"%li",(long)count];
    if (count < 10) {
        _hongxinView.frame = CGRectMake(25+(self.frame.size.width-30)/2, 2, 14, 14);
        _hongxinView.layer.cornerRadius = 7;
        return;
    }
    
    _hongxinView.frame = CGRectMake(25+(self.frame.size.width-30)/2, 2, 20, 14);
    _hongxinView.layer.cornerRadius = 7;
    if (count > 99) {
        _hongxinView.text = @"99+";
    }
}





@end






















