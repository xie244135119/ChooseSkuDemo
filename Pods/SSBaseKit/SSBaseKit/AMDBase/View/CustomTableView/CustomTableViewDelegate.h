//
//  CustomTableViewDelegate.h
//  TradeApp
//
//  Created by SunSet on 14-5-23.
//  Copyright (c) 2014年 SunSet. All rights reserved.
//

#import <Foundation/Foundation.h>
//@class PullingRefreshTableView;


@protocol CustomTableViewDelegate <NSObject,UIScrollViewDelegate>

@required
-(UITableViewCell *)tableView:(UITableView *)tableView CellAtIndexPath:(NSIndexPath *)indexPath;


@optional
// 特殊情况需要的时候---定制
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
// 需要特殊定制的时候
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;

// 选中某一行执行的操作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

// 开始滑动的时候
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

// 展示最后一个cell展示的
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

// 高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

// 头部视图和尾部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;

// 下拉刷新的操作
- (void)pullingTableViewDidStartRefreshing:(UITableView *)tableView;
- (void)pullingTableViewDidStartLoading:(UITableView *)tableView;


// 采用CollectionViewCell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;



@end
