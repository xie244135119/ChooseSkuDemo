//
//  GeneralTableView.h
//  TradeApp
//  一般的表格
//  Created by SunSet on 14-5-23.
//  Copyright (c) 2014年 SunSet. All rights reserved.
//

#import "CustomTableView.h"
/** Plain样式的表格--不带分组标题 */
@interface GeneralTableView : CustomTableView

/*
 * @param1 大小 @param2 TableView风格
 */
-(instancetype)initWithFrame:(CGRect)frame TableViewType:(UITableViewStyle)style;
-(instancetype)initWithTableViewType:(UITableViewStyle)style;


@end


@interface GeneralTableView_Section : GeneralTableView

@end



//--只是单纯的Section，没有标题
@interface  GeneralTableView_SectionNoTitle: GeneralTableView

@end

//--带索引的tableView
@interface GeneralTableView_IndexTitle : GeneralTableView_Section

@end


//--类似微信视图的带下拉刷新效果
@interface GeneralTableView_WeChat : GeneralTableView

@end










