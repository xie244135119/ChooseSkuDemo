//
//  GeneralTableView.m
//  TradeApp
//
//  Created by SunSet on 14-5-23.
//  Copyright (c) 2014年 SunSet. All rights reserved.
//

#import "GeneralTableView.h"
#import <Masonry/Masonry.h>

@interface GeneralTableView ()<UITableViewDataSource,UITableViewDelegate>
@end

@implementation GeneralTableView


- (instancetype)initWithFrame:(CGRect)frame TableViewType:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame]) {
        [self initTableViewWithType:style];
    }
    return self;
}

-(instancetype)initWithTableViewType:(UITableViewStyle)style
{
    if (self = [super init]) {
        [self initTableViewWithType2:style];
    }
    return self;
}


#pragma mark - 初始化View
-(void)initTableViewWithType:(UITableViewStyle)style
{
    UITableView * tab = [[UITableView alloc] initWithFrame:self.bounds style:style];
    tab.dataSource = self;
    tab.backgroundColor = [UIColor clearColor];
    tab.separatorColor = [UIColor clearColor];
    _tableView = tab;
    tab.delegate = self;
    [self addSubview:tab];
    tab.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    [self clearTableViewBottom:tab];
}

-(void)initTableViewWithType2:(UITableViewStyle)style
{
    UITableView * tab = [[UITableView alloc] initWithFrame:CGRectZero style:style];
    tab.dataSource = self;
    tab.backgroundColor = [UIColor clearColor];
    tab.separatorColor = [UIColor clearColor];
    _tableView = tab;
    tab.delegate = self;
    [self addSubview:tab];
    [tab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self clearTableViewBottom:tab];
}


#pragma mark - UITableViewDataSource
//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //特殊情况下需要制定的
    if ([_delegate respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
        return [_delegate tableView:tableView numberOfRowsInSection:section];
    }
    if ([_sourceData isKindOfClass:[NSArray class]]) {
        return [_sourceData count];
    }
    if ([_sourceData isKindOfClass:[NSDictionary class]]) {
        NSArray *keys = [[_sourceData allKeys] sortedArrayUsingSelector:@selector(compare:)];
        id value = [_sourceData objectForKey:keys[section]];
        return [value count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(tableView:CellAtIndexPath:)]) {
        return [_delegate tableView:tableView CellAtIndexPath:indexPath];
    }
    return nil;
}

////支持多选删除
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
//}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
        return [_delegate tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([_delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [_delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)]) {
        [_delegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([_delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        return [_delegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([_delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        return [_delegate scrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([_delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [_delegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if ([_delegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
        [_delegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}



@end


@implementation GeneralTableView_Section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([_delegate respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        return [_delegate numberOfSectionsInTableView:tableView];
    }
    
    //普通的带标题头部的时候
    if ([_sourceData isKindOfClass:[NSDictionary class]]) {
        return [[_sourceData allKeys] count];
    }
    return 1;
}

// 头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([_delegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
        return [_delegate tableView:tableView viewForHeaderInSection:section];
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ([_delegate respondsToSelector:@selector(tableView:viewForFooterInSection:)]) {
        return [_delegate tableView:tableView viewForFooterInSection:section];
    }
    return nil;
}

//
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([_delegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)]) {
        return [_delegate tableView:tableView heightForHeaderInSection:section];
    }
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([_delegate respondsToSelector:@selector(tableView:heightForFooterInSection:)]) {
        return [_delegate tableView:tableView heightForFooterInSection:section];
    }
    return 0.01;
}


@end


@implementation GeneralTableView_SectionNoTitle
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //普通的带标题头部的时候
    if ([_sourceData isKindOfClass:[NSArray class]]) {
        return [_sourceData count];
    }
    return 1;
}

//重写父类单元格数的方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_sourceData isKindOfClass:[NSArray class]]) {
        NSArray *arry = _sourceData[section];
        return arry.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

@end




#pragma mark - 索引视图
@implementation GeneralTableView_IndexTitle

//返回索引的数组
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [[_sourceData allKeys] sortedArrayUsingSelector:@selector(compare:)];
}

@end



#pragma mark
#pragma mark - 微信视图
@interface GeneralTableView_WeChat ()
{
    __weak UIActivityIndicatorView *_currentLoadMoreActivityView;       //滚动视图
}

@property(nonatomic, assign) NSInteger currentRefreshState;     //当前刷新状态
@end

@implementation GeneralTableView_WeChat

- (void)dealloc
{
    [_tableView removeObserver:self forKeyPath:@"contentOffset"];
}

//
- (instancetype)initWithFrame:(CGRect)frame TableViewType:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame TableViewType:style]) {
        // 添加observer
        [_tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

// 下拉加载更多视图
- (void)initLoadMoreView
{
    if (_currentLoadMoreActivityView == nil) {
        UIView *loadView = [[UIView alloc]initWithFrame:CGRectMake(0, -40, self.frame.size.width, 40)];
        [_tableView addSubview:loadView];
        loadView.hidden = YES;
        
        // 下拉刷新视图
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityView.frame = CGRectMake((self.frame.size.width-30)/2, 5, 30, 30);
        [loadView addSubview:activityView];
        _currentLoadMoreActivityView = activityView;
    }
    [_currentLoadMoreActivityView startAnimating];
    _currentLoadMoreActivityView.superview.hidden = NO;
}


#pragma mark - 本地加载需要
#pragma mark - KVO监测偏移量
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)contex
{
    if (self.reachedTheTop) return;
    
    if ([keyPath isEqualToString:@"contentOffset"]) {
        // 偏移量小于5的时候自动加载上一页
        if (_tableView.contentOffset.y < 5 && _tableView.contentOffset.y != 0) {
//            // 开始刷新
            self.currentRefreshState = 1;
        }
    }
}

// 设置刷新状态
- (void)setCurrentRefreshState:(NSInteger)currentRefreshState
{
    if (_currentRefreshState != currentRefreshState) {
        _currentRefreshState = currentRefreshState;
        
        //
        switch (currentRefreshState) {
            case 1:     //开始刷新
            {
                // 正在动画的时候
                if ([_currentLoadMoreActivityView isAnimating]) {
                    return ;
                }
                
                // 设置偏移量
                [_tableView setContentInset:UIEdgeInsetsMake(40, 0, 0, 0)];
                // 加载更多视图
                [self initLoadMoreView];
                // 加载事件
                [self performSelector:@selector(tableViewDidStartRefreshing:) withObject:nil afterDelay:0.25];
            }
                break;
            case 2:     //刷新结束
            {
                [_tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
                
                // 隐藏视图
                [_currentLoadMoreActivityView stopAnimating];
                _currentLoadMoreActivityView.superview.hidden = YES;
                
                self.currentRefreshState = 3;
            }
                break;
            case 3:     //正常状态
            {
//                NSLog(@" 到达正常状态 ");
            }
                break;
            default:
                break;
        }
    }
}


#pragma mark - 下拉刷新和加载更多
// 下拉刷新
- (void)tableViewDidStartRefreshing:(id)collectionView
{
    if ([_delegate respondsToSelector:@selector(pullingTableViewDidStartRefreshing:)]) {
        [_delegate pullingTableViewDidStartRefreshing:_tableView];
    }
    
    // 结束当前动画
    self.currentRefreshState = 2;
}



@end





















