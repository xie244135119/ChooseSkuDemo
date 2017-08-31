//
//  AMDButton.m
//  AppMicroDistribution
//
//  Created by SunSet on 15-5-20.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import "AMDButton.h"
#import "SSGlobalVar.h"
#import <Masonry/Masonry.h>


// 未读的图形
@interface UnreadImageView : UIImageView
@end

@interface AMDButton()
{
    // 背景色相关
    UIColor *_selectBackgroundColor;        //选中的背景背景色
    UIColor *_normalBackgroundColor;        //正常时候的背景颜色
    UIColor *_higlhtedBackgroundColor;      //点击时候的背景颜色
    UIColor *_disabledBackgroundColor;      //不可用时候的背景色
    BOOL _supportMaskView;                  //选中的时候支持模板视图
    
    // 字体颜色
    UIColor *_normalTitleColor;              //正常时候的字体颜色
    UIColor *_selectTitleColor;             //选中时候的字体颜色
    UIColor *_higlhtedTitleColor;           //点击时候的背景颜色
    UIColor *_disabledTitleColor;           //不可用时候的背景色
    BOOL _highlightedReduceAlpha;           //高亮状态下降低titlelable alpha值
    
    // 设置图片
    UIImage *_normalImage;                  //正常的图片
    UIImage *_selectImage;                  //选中的图片
    UIImage *_higlhtedImage;                //高亮的图片
    UIImage *_disabledImage;                //不可用的图片
    
    // 字体文字
    NSString *_normalTitle;                 //正常时候的文字
    NSString *_higlhtedTitle;               //高亮时候的文字
    NSString *_selectTitle;                 //选中时候的文字
    NSString *_disabledTitle;                //不可用时候的文字
    
    // 描边颜色相关
    UIColor *_normalBorderColor;            //正常的时候显示的描边颜色
    UIColor *_higlhtedBorderColor;            //正常的时候显示的描边颜色
    UIColor *_disabledBorderColor;            //正常的时候显示的描边颜色
    UIColor *_selectBorderColor;            //正常的时候显示的描边颜色
    
    NSInteger _currentUnreadCount;          //当前未读数量
    __weak UILabel *_unreadLb;              //未读数量的文本框
    __weak UnreadImageView *_unreadImageView;        //未读的显示视图
    
    BOOL _autoLayout;                       //自动布局
}
@property(nonatomic, weak) UIView *maskHighlightView;              //默认选中的时候作为的蒙版视图
@end



@implementation AMDButton

- (void)dealloc
{
    _higlhtedBackgroundColor = nil;
    _selectBackgroundColor = nil;
    _normalBackgroundColor = nil;
    _disabledTitleColor = nil;
    //    self.selectTitleColor = nil;
    //    self.normalTitleColor = nil;
//    self.normalImageName = nil;
//    self.selectImageName = nil;
    _normalTitleColor = nil;
    _selectTitleColor = nil;
    _higlhtedTitleColor = nil;
    
    _normalImage = nil;
    _selectImage = nil;
    _higlhtedImage = nil;
    
    _normalTitle = nil;
    _selectTitle = nil;
    _disabledTitle = nil;
    _higlhtedTitle = nil;
    
    _normalBorderColor = nil;
    _selectBorderColor = nil;
    _disabledBorderColor = nil;
    _higlhtedBorderColor = nil;
    
    self.maskHighlightView = nil;
}

// 原始frame方式
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        if (_autoLayout) {
            [self initContentView2];
        }
        else {
            [self initContentView];
        }
    }
    return self;
}

// 支持Autolayout
- (id)init
{
    _autoLayout = YES;
    if (self = [super init]) {
        //
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    switch (self.state) {
        case UIControlStateHighlighted: //高亮的时候
            //选中时候的背景颜色
            if (_higlhtedBackgroundColor || _supportMaskView) {
                if (_supportMaskView) {
                    self.maskHighlightView.hidden = NO;
                }
                
                if (_higlhtedBackgroundColor) {
                    self.backgroundColor = _higlhtedBackgroundColor;
                }
            }
            //改变选中字体颜色
            if (_higlhtedTitleColor || _highlightedReduceAlpha) {
                if (_highlightedReduceAlpha) {
                    _titleLabel.alpha = 0.7;
                }
                else {
                    _titleLabel.textColor = _higlhtedTitleColor;
                }
            }
            
            if (_higlhtedImage) {
                _imageView.image = _higlhtedImage;
            }
            
            if (_higlhtedTitle) {
                _titleLabel.text = _higlhtedTitle;
            }
            
            if (_higlhtedBorderColor) {
                self.layer.borderColor = [_higlhtedBorderColor CGColor];
                self.layer.borderWidth = 0.5;
            }
            
            break;
        case UIControlStateNormal:
            _titleLabel.alpha = 1;
             self.maskHighlightView.hidden = YES;
            self.backgroundColor = _normalBackgroundColor?_normalBackgroundColor:[UIColor clearColor];
            if (_normalTitleColor) {
                _titleLabel.textColor = _normalTitleColor;
            }
            
            if (_normalImage) {
                _imageView.image = _normalImage;
            }
            
            if (_normalTitle) {
                _titleLabel.text = _normalTitle;
            }
            
            if (_normalBorderColor) {
                self.layer.borderColor = [_normalBorderColor CGColor];
            }
            
            break;
        case UIControlStateSelected:{
            if (_selectBackgroundColor) {
                self.backgroundColor = _selectBackgroundColor;
            }
            if (_selectTitleColor) {
                _titleLabel.textColor = _selectTitleColor;
            }
            
            if (_selectImage) {
                _imageView.image = _selectImage;
            }
            
            if (_selectTitle) {
                _titleLabel.text = _selectTitle;
            }
            
            if (_selectBorderColor) {
                self.layer.borderColor = [_selectBorderColor CGColor];
            }
        }
            break;
        case UIControlStateDisabled:
            if (_disabledBackgroundColor) {
                self.backgroundColor = _disabledBackgroundColor;
            }
            
            if (_disabledTitle) {
                _titleLabel.text = _disabledTitle;
            }
            
            if (_disabledImage) {
                _imageView.image = _disabledImage;
            }
            
            if (_disabledBorderColor) {
                self.layer.borderColor = [_disabledBorderColor CGColor];
            }
            break;
        default:
            break;
    }
}


- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    //改变背景色
    if (_selectBackgroundColor) {
        self.backgroundColor = selected?_selectBackgroundColor:_normalBackgroundColor;
    }
    
    if (_selectTitle) {
        _titleLabel.text = selected?_selectTitle:_normalTitle;
    }
    
    //改变选中字体颜色
    if (_selectTitleColor) {
        _titleLabel.textColor = selected?_selectTitleColor:_normalTitleColor;
    }
    if (_selectImage) {
        _imageView.image = selected?_selectImage:_normalImage;
    }
    if (_selectBorderColor) {
        self.layer.borderColor = !selected?[_normalBorderColor CGColor]:[_selectBorderColor CGColor];
    }
}

//视图加载
- (void)initContentView
{
    //图像
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:self.bounds];
    [self addSubview:imgView];
    _imageView = imgView;
    
    //文字描述
    UILabel *titleLb = [[UILabel alloc]initWithFrame:self.bounds];
//    UILabel *titleLb = [[UILabel alloc]init];
    titleLb.backgroundColor = [UIColor clearColor];
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.font = SSFontWithName(@"", 14);
//    titleLb.textColor = SSColorWithRGB(153, 153, 153, 1);
    titleLb.textColor = [UIColor whiteColor];
    [self addSubview:titleLb];
    _titleLabel = titleLb;
}

//视图加载
- (void)initContentView2
{
    //图像
//    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIImageView *imgView = [[UIImageView alloc]init];
    [self addSubview:imgView];
    _imageView = imgView;
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    
    //文字描述
    //    UILabel *titleLb = [[UILabel alloc]initWithFrame:self.bounds];
    UILabel *titleLb = [[UILabel alloc]init];
    titleLb.backgroundColor = [UIColor clearColor];
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.font = SSFontWithName(@"", 14);
    //    titleLb.textColor = SSColorWithRGB(153, 153, 153, 1);
    titleLb.textColor = [UIColor whiteColor];
    [self addSubview:titleLb];
    _titleLabel = titleLb;
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}


#pragma mark - SET

//设置文字
- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    switch (state) {
        case UIControlStateNormal:{
            _normalTitle = title;
            self.titleLabel.text = title;
        }
            break;
        case UIControlStateHighlighted:
            _higlhtedTitle = title;
            break;
        case UIControlStateSelected:
            _selectTitle = title;
            break;
        case UIControlStateDisabled:
            _disabledTitle = title;
            break;
        default:
            break;
    }
}

//根据状态不同配置背景色
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state
{
    switch (state) {
        case UIControlStateNormal:{
            _normalBackgroundColor = backgroundColor;
            self.backgroundColor = backgroundColor;
        }
            break;
        case UIControlStateHighlighted:
        {
            if (backgroundColor == nil) {
                _supportMaskView = YES;
            }
            else {
                _higlhtedBackgroundColor = backgroundColor;
            }
        }
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
//    self.backgroundColor = _normalBackgroundColor?_normalBackgroundColor:[UIColor clearColor];
}

- (void)setTitleColor:(UIColor *)titlecolor forState:(UIControlState)state
{
    switch (state) {
        case UIControlStateSelected:
            _selectTitleColor = titlecolor;
            break;
        case UIControlStateNormal:
            _normalTitleColor = titlecolor;
            _titleLabel.textColor = titlecolor;
            break;
        case UIControlStateHighlighted:
            if (titlecolor == nil) {
                _highlightedReduceAlpha = YES;
            }
            _higlhtedTitleColor = titlecolor;
            break;
        case UIControlStateDisabled:
            _disabledTitleColor = titlecolor;
            break;
        default:
            break;
    }
    self.titleLabel.textColor = _normalTitleColor?_normalTitleColor:[UIColor blackColor];
}

- (void)setBorderColor:(UIColor *)color forState:(UIControlState)state
{
    switch (state) {
        case UIControlStateNormal:
        {
            _normalBorderColor = color;
            self.layer.borderColor = [color CGColor];
            self.layer.borderWidth = 0.5;
        }
            break;
        case UIControlStateSelected:
            _selectBorderColor = color;
            break;
        case UIControlStateHighlighted:
            _higlhtedBorderColor = color;
            break;
        case UIControlStateDisabled:
            _disabledBorderColor = color;
            break;
        default:
            break;
    }
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    switch (state) {
        case UIControlStateNormal:
            _normalImage = image;
            _imageView.image = image;
            break;
        case UIControlStateSelected:
            _selectImage = image;
            break;
        case UIControlStateHighlighted:
            _higlhtedImage = image;
            break;
        default:
            break;
    }
}

- (void)setImage2:(UIImage *)image forState:(UIControlState)state
{
    switch (state) {
        case UIControlStateNormal:
        {
            _normalImage = image;
            _imageView.image = image;
            
            [_imageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self);
                make.width.equalTo(@(image.size.width));
                make.height.equalTo(@(image.size.height));
            }];
        }
            break;
        case UIControlStateSelected:
            _selectImage = image;
            break;
        case UIControlStateHighlighted:
            _higlhtedImage = image;
            break;
        default:
            break;
    }
}



#pragma mark - 选中色蒙版
- (UIView *)maskHighlightView
{
    if (_maskHighlightView == nil) {
        UIView *v = [[UIView alloc]initWithFrame:self.bounds];
        _maskHighlightView = v;
        v.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        [self addSubview:v];
        v.userInteractionEnabled = NO;
    }
    return _maskHighlightView;
}



#pragma mark - 响应事件a
//取消点击
- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    [self setHighlighted:NO];
}


- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    
    if (_disabledBackgroundColor) {
        self.backgroundColor = enabled?_normalBackgroundColor:_disabledBackgroundColor;
    }
    
    if (_disabledTitleColor) {
        self.titleLabel.textColor = enabled?_normalTitleColor:_disabledTitleColor;
    }
    
    if (_disabledTitle) {
        self.titleLabel.text = enabled?_normalTitle:_disabledTitle;
    }
    
    if (_disabledBorderColor) {
        self.layer.borderColor = enabled?[_normalBorderColor CGColor]:[_disabledBorderColor CGColor];
    }
}


#pragma mark - 支持右上角数字
// 显示
- (void)supportRemindNumber
{
    //未读数量
//    CGFloat width = self.frame.size.width;
//    UIImageView *unreadimgView = [[UIImageView alloc]initWithFrame:CGRectMake(width-14, 4, 14, 14)];
    UnreadImageView *unreadimgView = [[UnreadImageView alloc]init];
    unreadimgView.image = [self imageWithColor:[UIColor redColor]];
//    unreadimgView.hidden = YES;
    unreadimgView.layer.cornerRadius = 7;
    unreadimgView.layer.masksToBounds = YES;
    [self addSubview:unreadimgView];
//    [self bringSubviewToFront:unreadimgView];
    
    _unreadImageView = unreadimgView;
//    unreadimgView.layer.borderWidth = 1;
//    unreadimgView.hidden = YES;
    
//    UILabel *unreadlb = [[UILabel alloc]initWithFrame:unreadimgView.frame];
    UILabel *unreadlb = [[UILabel alloc]init];
    unreadlb.textAlignment = NSTextAlignmentCenter;
    unreadlb.font = SSFontWithName(@"", 10);
    unreadlb.textColor = [UIColor whiteColor];
    unreadlb.hidden = YES;
//    unreadlb.layer.borderWidth = 1;
//    unreadlb.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:unreadlb];
    _unreadLb = unreadlb;
    
    // 自动布局处理
    if (_autoLayout) {
        [unreadlb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_imageView.mas_right).with.offset(-5);
            make.top.equalTo(_imageView.mas_top).with.offset(-5);
            make.width.greaterThanOrEqualTo(@10);
            make.height.greaterThanOrEqualTo(@10);
        }];
        
//        [unreadimgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(unreadlb.mas_left).with.offset(-2);
//            make.top.equalTo(unreadlb.mas_top).with.offset(-2);
//            make.width.height.equalTo(@14);
//        }];
    }
    
}

- (NSInteger)unreadCount
{
    return _currentUnreadCount;
}

- (void)setUnreadCount:(NSInteger)unreadcount
{
    _currentUnreadCount = unreadcount;
    // 使用自动布局处理
    if (_autoLayout) {
        [self _setAutoLayoutUnreadCount:unreadcount];
        return;
    }
    
    // 下方的逐渐废弃
    // 意思是只显示红框 不显示数量
    UIImageView *senderimgView = (UIImageView *)_unreadLb.superview;
//    CGFloat width = self.frame.size.width;
    if (unreadcount == -2) {
        _unreadLb.text = @"";
        senderimgView.hidden = NO;
        senderimgView.frame = CGRectMake(_imageView.frame.origin.x+_imageView.frame.size.width-5, _imageView.frame.origin.y-5, 7, 7);
        senderimgView.layer.cornerRadius = 3.5;
        senderimgView.layer.masksToBounds = YES;
        return;
    }
    
    if (unreadcount <= 0) {
        senderimgView.hidden = YES;
    }
    else {
        senderimgView.hidden = NO;
        senderimgView.frame = CGRectMake(_imageView.frame.origin.x+_imageView.frame.size.width-3, _imageView.frame.origin.y-5, 14, 14);
        senderimgView.layer.cornerRadius = 7;
        senderimgView.layer.masksToBounds = YES;
        _unreadLb.text = [NSString stringWithFormat:@"%li",(long)unreadcount];
        // 超过99条
        if (unreadcount >= 10) {
            senderimgView.frame = CGRectMake(senderimgView.frame.origin.x-3, senderimgView.frame.origin.y, 20, 14);
            // 超过99的话
            if (unreadcount > 99) {
                _unreadLb.text = @"99+";
            }
        }
    }
}

// 自动布局下处理
- (void)_setAutoLayoutUnreadCount:(NSInteger)unreadcount
{
    _unreadImageView.hidden = unreadcount==0;
    _unreadLb.hidden = unreadcount==0;
    
    if (unreadcount == 0) return;
    
    _unreadLb.text = [[NSString alloc]initWithFormat:@"%li",(long)unreadcount];
    if (unreadcount > 99) {
        _unreadLb.text = @"99+";
    }
    // 自适应
    [_unreadLb systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    // 更新外层视图
    [_unreadImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_unreadLb.mas_left).with.offset(-2);
        make.top.equalTo(_unreadLb.mas_top).with.offset(-2);
        make.bottom.equalTo(_unreadLb.mas_bottom).with.offset(2);
        make.right.equalTo(_unreadLb.mas_right).with.offset(2);
    }];
}



#pragma mark - 内部处理
- (UIImage *)imageWithColor:(UIColor *)color
{
    UIGraphicsBeginImageContext(CGSizeMake(1, 1));
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ref, color.CGColor);
    CGContextFillRect(ref, CGRectMake(0, 0, 1, 1));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}




#pragma mark - Pubilc Api
//
- (void)setImageWithUrl:(NSURL *)url
            placeHolder:(UIImage *)placeHolder
{
    // override
}

- (void)setImageWithUrl:(NSURL *)url
            placeHolder:(UIImage *)placeHolder
             completion:(void (^)(UIImage *, NSError *))completion
{
    // override
}


- (void)setImageWithPath:(NSString *)path
             placeHolder:(UIImage *)placeHolder
{
    // override
}

//
- (void)setImageWithPath:(NSURL *)url
             placeHolder:(UIImage *)placeHolder
              completion:(void (^)(UIImage *, NSError *))completion
{
    // override
}


- (void)setBackgroundImageWithUrl:(NSURL *)url
                      placeHolder:(UIImage *)placeHolder
                         forState:(UIControlState)state
{
    // override
}

- (void)setBackgroundImageWithUrl:(NSURL *)url
                      placeHolder:(UIImage *)placeHolder
                         forState:(UIControlState)state
                       completion:(void (^)(UIImage *, NSError *))completion
{
    // override
}




@end





// 临时使用自定义的ImageView 去使用圆角
@implementation UnreadImageView

- (void)layoutSubviews
{
    [super layoutSubviews];
    [super layoutIfNeeded];
    
    self.layer.cornerRadius = self.frame.size.width/2;
}



@end









