//
//  AMDBaseCell.m
//  AppMicroDistribution
//
//  Created by SunSet on 15-5-20.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#define kMAXOffSet _rightSlideView.frame.size.width //最大偏移量
#define kMAXBufferSet 10 //移动的时候缓冲量
#define kMinOffSet 20 //最低偏移量
#define AASCurrentSlideCell @"AASCurrentSlideCell"
//#define AASCurrentSlideState    @"AASCurrentSlideState"         //是否在编辑状态
#define AMDCurrentCenter    self.frame.size.width/2                         //当前屏幕的中心

#import "AMDBaseCell.h"
#import <objc/runtime.h>

@interface UITableView (SSBind)
//
- (void)bindWeakValue:(id)value forKey:(NSString *)key;
- (id)getBindValueForKey:(NSString *)key;
@end



//#import "NSObject+BindValue.h"


// 滑动视图时候的遮挡视图
@interface AMDHitView : UIView
@property(nonatomic,weak) id delegate;      //实现 AASHitViewDelegate 协议
@end
@protocol AMDHitViewDelegate <NSObject>
@optional
- (UIView *)hitView:(AMDHitView *)hitView hitTest:(CGPoint)point withEvent:(UIEvent *)event;
@end


@interface AMDBaseCell()
{
    CGPoint _currentBeginCenter;    //起始时候的中心位置
    __weak AMDHitView *_currentHitView;     //隐藏视图
}
@end

@implementation AMDBaseCell

- (void)dealloc
{
    //    if (_slidePanGestureRecognizer) {
    //        [_contentInfoView removeObserver:self forKeyPath:@"center"];
    //    }
    _currentHitView = nil;
    self.slidePanGestureRecognizer = nil;
    //    NSLog(@" %@ %s",[self class],__FUNCTION__);
}


//- (void)awakeFromNib {
//    // Initialization code
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    if (_rightSlideView) {
        _rightSlideView.hidden = YES;
        _slidePanGestureRecognizer.enabled = !highlighted;
    }
}


#pragma mark - 实例化
- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
       supportSlide:(BOOL)supportSlide
          cellFrame:(CGRect)frame
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = frame;
        [self initRootContentView];
        
        if (supportSlide) [self initRootPanGesture];
    }
    return self;
}

//内部视图
- (void)initRootContentView
{
    UIView *contentInfoView = [[UIView alloc]initWithFrame:self.bounds];
    contentInfoView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:contentInfoView];
    _contentInfoView = contentInfoView;
}

//添加拖动手势和自定义视图
- (void)initRootPanGesture
{
    //滑动手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureRecognizer:)];
    pan.delegate = self;
    [_contentInfoView addGestureRecognizer:pan];
    _slidePanGestureRecognizer = pan;
    
    //右侧滑动视图
    UIView *rightSlideView = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width-40, 0, 40,self.frame.size.height)];
    rightSlideView.hidden = YES;
    _rightSlideView = rightSlideView;
    [self.contentView addSubview:rightSlideView];
    [self.contentView sendSubviewToBack:rightSlideView];
    
    //    [_contentInfoView addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:nil];
}


#pragma mark
#pragma mark - UIPanGestureRecognizer手势相关 滑动操作
// 手势操作
- (void)panGestureRecognizer:(UIPanGestureRecognizer *)pan
{
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{
            [self begin:pan];
        }
            break;
        case UIGestureRecognizerStateChanged:{
            //移动
            [self changed:pan];
        }
            break;
        case UIGestureRecognizerStateEnded:{
            //结束的时候
            [self end:pan];
        }
            break;
        case UIGestureRecognizerStateCancelled:{
            [pan setTranslation:CGPointZero inView:pan.view];
        }
            break;
        case UIGestureRecognizerStateFailed:{
            [pan setTranslation:CGPointZero inView:pan.view];
        }
            break;
        default:
            break;
    }
}

//开始的时候
- (void)begin:(UIPanGestureRecognizer *)pan
{
    _currentBeginCenter = pan.view.center;
    //设置hitView
    _currentHitView = [_tableView getBindValueForKey:@"AASHitView"];
    if (_currentHitView ==  nil) {
        AMDHitView *hitView = [[AMDHitView alloc]initWithFrame:_tableView.bounds];
        _currentHitView = hitView;
        //只需要加载一次
        [_tableView bindWeakValue:_currentHitView forKey:@"AASHitView"];
        //
        [_tableView addSubview:_currentHitView];
    }
    //
    _currentHitView.delegate = self;
    //显示右侧编辑视图
    _rightSlideView.hidden = NO;
    //可滑动
    _tableView.scrollEnabled = NO;
    //添加当前选中的cell
    [_tableView bindWeakValue:self forKey:AASCurrentSlideCell];
}

// 滑动过程中
- (void)changed:(UIPanGestureRecognizer *)pan
{
    CGPoint p = [pan translationInView:pan.view.superview];
    
    //超过最大偏移继续向左移 -- 禁止
    if (pan.view.center.x < (AMDCurrentCenter - kMAXOffSet - kMAXBufferSet) && p.x < 0) {
        [pan.view setCenter:CGPointMake((AMDCurrentCenter - kMAXOffSet - kMAXBufferSet), pan.view.center.y)];
        [pan setTranslation:CGPointZero inView:pan.view];
        return ;
    }
    
    if ((pan.view.center.x+p.x) < (AMDCurrentCenter - kMAXOffSet - kMAXBufferSet) && p.x < 0) {
        [pan.view setCenter:CGPointMake((AMDCurrentCenter - kMAXOffSet - kMAXBufferSet), pan.view.center.y)];
        [pan setTranslation:CGPointZero inView:pan.view];
        return;
    }
    
    //超过最大偏移继续向右移 -- 禁止
    if ((pan.view.center.x > (AMDCurrentCenter + kMAXBufferSet) && p.x > 0)) {
        [pan.view setCenter:CGPointMake(AMDCurrentCenter+kMAXBufferSet, pan.view.center.y)];
        [pan setTranslation:CGPointZero inView:pan.view];
        return;
    }
    
    if ((pan.view.center.x+p.x) > (AMDCurrentCenter + kMAXBufferSet) && p.x > 0) {
        [pan.view setCenter:CGPointMake(AMDCurrentCenter+kMAXBufferSet, pan.view.center.y)];
        [pan setTranslation:CGPointZero inView:pan.view];
        return;
    }
    
    //移动
    [pan.view setCenter:CGPointMake(pan.view.center.x+p.x, pan.view.center.y)];
    [pan setTranslation:CGPointZero inView:pan.view];
}

// 结束的时候处理
- (void)end:(UIPanGestureRecognizer *)pan
{
    //滑动方向 - 左侧为yes 右侧为no
    BOOL directionType = pan.view.center.x < _currentBeginCenter.x;
    
    if (directionType) {
        __block CGFloat x = 0;
        //判断是否超过最小偏移量，如果不超过，回到原位，超过的话按不同条件处理
        if (_currentBeginCenter.x-pan.view.center.x >= kMinOffSet) {
            
            //如果是从中心左滑，如果超过最小偏移量，直接滑出至按钮显现处
            //如果是从右侧向左滑，如果超过最小偏移量，直接滑至中心按钮覆盖处
            x = (_currentBeginCenter.x == AMDCurrentCenter)?(AMDCurrentCenter-kMAXOffSet):AMDCurrentCenter;
        }
        else{
            //隐藏菜单视图
            x = _currentBeginCenter.x;
        }
        
        [UIView animateWithDuration:0.25 animations:^{
            pan.view.center = CGPointMake(x , pan.view.center.y);
        }];
        [self hideMenuViewoWithOffSetX:x];
    }
    else{
        //如果右滑的位置超过最小偏移量的时候 直接回到原位
        __block CGFloat x = (pan.view.center.x-_currentBeginCenter.x) > kMinOffSet ? AMDCurrentCenter:_currentBeginCenter.x;
        //偏移
        [self hideMenuViewoWithOffSetX:x];
    }
}

// 隐藏编辑视图--视图恢复至默认位置
- (void)hideMenuViewoWithOffSetX:(CGFloat)x
{
    __weak AMDHitView *hitView = _currentHitView;
    [UIView animateWithDuration:0.25 animations:^{
        _contentInfoView.center = CGPointMake(x, _contentInfoView.center.y);
    } completion:^(BOOL finished) {
        //隐藏编辑视图的时候
        if (x == self.frame.size.width/2) {
            //            _rightSlideView.hidden = YES;
            _tableView.scrollEnabled = YES;
            [hitView removeFromSuperview];
        
            //移除当前选中滑动的cell
            [_tableView bindWeakValue:nil forKey:@"AASHitView"];
            [_tableView bindWeakValue:nil forKey:AASCurrentSlideCell];
//            [_tableView removeBindObjects];
        }
        else{
            //显示编辑视图的时候
            _tableView.scrollEnabled = NO;
        }
    }];
}

- (void)reset
{
    _contentInfoView.center = CGPointMake(self.frame.size.width/2, _contentInfoView.center.y);
    _tableView.scrollEnabled = YES;
    [_currentHitView removeFromSuperview];
    
    //移除当前选中滑动的cell
    [_tableView bindWeakValue:nil forKey:@"AASHitView"];
    [_tableView bindWeakValue:nil forKey:AASCurrentSlideCell];
//    [_tableView removeBindObjects];
}


// 隐藏遮挡视图
- (void)hideHitView
{
    [_currentHitView removeFromSuperview];
    _tableView.scrollEnabled = YES;
    
    [_tableView bindWeakValue:nil forKey:@"AASHitView"];
    [_tableView bindWeakValue:nil forKey:AASCurrentSlideCell];
//    [_tableView removeBindObjects];
}


#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        if (self.isInEditing) {
            return NO;
        }
        
        CGPoint vTranslationPoint = [gestureRecognizer translationInView:self.contentView];
        return fabs(vTranslationPoint.x) > fabs(vTranslationPoint.y);
    }
    return YES;
}


#pragma mark - AASHitViewDelegate
- (UIView *)hitView:(AMDHitView *)hitView hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    //
    CGPoint convertPoint = [hitView convertPoint:point toView:_tableView];
//    UITouch *touch = [[event allTouches] anyObject];
//    CGPoint convertPoint = [hitView convertPoint:point fromView:touch.view];
    AMDBaseCell *cell = [_tableView getBindValueForKey:AASCurrentSlideCell];
    
    //    CGRect cellframe = [_tableView.superview convertRect:cell.frame fromView:_tableView];
    CGRect cellframe = cell.frame;
    BOOL vCloudReceiveTouch = CGRectContainsPoint(cellframe, convertPoint);
    
    //如果不属于当前滑动单元格--直接返回
    if (!vCloudReceiveTouch) {
        [self hideMenuViewoWithOffSetX:self.frame.size.width/2];
        return hitView;
    }
    
    //当前是否处于左侧编辑状态
//    CGRect cellcontentframe = [hitView convertRect:cell.contentInfoView.frame fromView:cell];
    CGRect cellcontentframe = [_tableView convertRect:cell.contentInfoView.frame fromView:cell.contentInfoView.superview];
    
    //当前处于编辑状态--
    if (CGRectContainsPoint(cellcontentframe, convertPoint)) {
        [self hideMenuViewoWithOffSetX:self.frame.size.width/2];
        return hitView;
    }
    
    // 移除删除视图
    return [super hitTest:point withEvent:event];
}

@end

@implementation UITableView (SSBind)

#pragma mark - private api
- (void)bindWeakValue:(id)value forKey:(NSString *)key
{
    //    if (value == nil) return;
    
    objc_setAssociatedObject(self, [key cStringUsingEncoding:30], value, OBJC_ASSOCIATION_ASSIGN);
}

- (id)getBindValueForKey:(NSString *)key
{
    return objc_getAssociatedObject(self, [key cStringUsingEncoding:30]);
}

@end



@implementation AMDHitView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if ([_delegate respondsToSelector:@selector(hitView:hitTest:withEvent:)]) {
        return [_delegate hitView:self hitTest:point withEvent:event];
    }
    return [super hitTest:point withEvent:event];
}

@end







