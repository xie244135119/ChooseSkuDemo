//
//  CustomTableView.h
//  TradeApp
//
//  Created by SunSet on 14-5-23.
//  Copyright (c) 2014年 SunSet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SSBaseKit/CustomTableViewDelegate.h>


/** 创建的TableView类型 */
typedef NS_ENUM(NSUInteger, CustomTableViewType) {
    kCustomTableViewTypeGeneral,        //普通的tableView，没有分组功能,数据为NSArray类型
    kCustomTableViewTypeGeneralPlain,   //普通的tableView，没有分组功能,数据为NSDictionary类型
    kCustomTableViewTypeGroup,          //Group样式,没有标题,单纯的Section,数据为NSArry类型
    kCustomTableViewTypeGroupPlain,     //Group样式的tableView，数据为NSDictionary类型
    
    //    kCustomTableViewTypeRefresh,        //带下拉刷新功能的tableView
    //    kCustomTableViewTypeRefrshSlide,    //带下拉刷新功能的tableView,同时支持滑动操作--右侧编辑视图
    kCustomTableViewTypeIndex,            //表格带索引的tableView,数据为NSDictionary类型
    kCustomTableViewTypeWeChatRefresh,    //类似微信的下拉刷新类型
};


@interface CustomTableView : UIView
{
    @protected
    id _sourceData;
    __weak id<CustomTableViewDelegate> _delegate;
    __weak UITableView * _tableView;
}

@property(nonatomic,weak) id<CustomTableViewDelegate> delegate;     //委托对象
@property(nonatomic,strong) id sourceData;                          //数据源
@property(nonatomic,weak,readonly) UITableView * tableView;


//带下拉刷新功能
@property(nonatomic) BOOL refresh;
@property(nonatomic) BOOL loadMore;                 //仅供支持加载更多<Temp property>
@property(nonatomic) BOOL reachedTheEnd;            //到达最后 默认是NO
@property(nonatomic) BOOL reachedTheTop;            //到达顶部--类似微信的下拉加载更多功能使用



#pragma mark - Mj刷新样式
//开始刷新加载
- (void)startRefresh;

//停止刷新
- (void)headerEndRefreshing;
- (void)footerEndRefreshing;


#pragma mark - 微信刷新样式---从本地获取数据



#pragma mark - 实例化
/*
 * 类簇模式
 * 用户构建不同类型的tableView 
 */
+(instancetype)tableViewWithFrame:(CGRect)frame Type:(CustomTableViewType)type;
-(instancetype)initWithFrame:(CGRect)frame Type:(CustomTableViewType)type;

// 自动布局支持
- (instancetype)initWithType:(CustomTableViewType)type;



// 清空tableView的下方空白
-(void)clearTableViewBottom:(UITableView *)tableView;





@end

















