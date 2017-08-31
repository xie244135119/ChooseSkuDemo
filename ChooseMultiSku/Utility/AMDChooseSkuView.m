//
//  AMDChooseSkuView.m
//  AppMicroDistribution
//
//  Created by SunSet on 16/9/18.
//  Copyright © 2016年 SunSet. All rights reserved.
//

#import "AMDChooseSkuView.h"
#import <SSBaseKit/SSBaseKit.h>
#import <SSBaseLib/SSBaseLib.h>
#import <SSBaseKit/SSGlobalVar.h>

static NSString *const KBindSender = @"KBindSender";            //绑定Model
static NSString *const kBindParentView = @"kBindParentView";    //绑定的父视图
static NSString *const kBindSkuOption = @"kBindSkuOption";

@interface AMDChooseSkuView()
{
    __weak UIScrollView *_currentScrollView;                //当前scrollview
    AMDSupplierProductModel *_currentProductModel;          //当前商品信息
    AMDSupplySkuModel *_selectSupplySkuModel;               //选中的SkuModel
    
    NSMutableArray *_currentAllSkuViews;                //所有的skuViews
    NSMutableDictionary *_allSkuCombinateResault;       //所有的sku组合结果
    NSMutableArray *_currentSelectOptions;              //当前选中的规格
    NSMutableArray *_currentSelectSkuViews;             //所有选中的skuView
    NSMutableDictionary *_allSkuOptionValues;           //所有的规格对应的可选的值SkuModel
}
@property(nonatomic, strong) NSArray *allSkuCombineKeys;            //所有的sku组合键
@end

@interface AYEOptionQuantityModel : AMDBaseModel<NSCopying,NSMutableCopying>
@property(nonatomic, copy) NSString *optionValue;           //option字段值
@property(nonatomic, strong) NSNumber *quantity;                            //库存量
@property(nonatomic, strong) NSNumber *quantity_setting;                    //库存设置
@end

@implementation AMDChooseSkuView


- (void)dealloc
{
    _selectSupplySkuModel = nil;
    _currentProductModel = nil;
    _currentAllSkuViews = nil;
    _allSkuCombinateResault = nil;
    _currentSelectOptions = nil;
    _currentSelectSkuViews = nil;
    self.allSkuCombineKeys = nil;
}


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
//        [self initContentView];
    }
    return self;
}

// 初始化内存
- (void)initMembory
{
    _currentAllSkuViews = [[NSMutableArray alloc]init];
    _allSkuCombinateResault = [[NSMutableDictionary alloc]init];
    _currentSelectOptions = [[NSMutableArray alloc]init];
    _currentSelectSkuViews = [[NSMutableArray alloc]init];
}


// 视图加载
- (void)initContentView
{
    self.backgroundColor = [UIColor whiteColor];
    // 规格视图
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self addSubview:scrollView];
    _currentScrollView = scrollView;
    
    CGFloat y = 10;
    for (NSInteger i = 0; i<_currentProductModel.product_option_arr.count; i++) {
        AMDSupplyProductOptionModel *model = _currentProductModel.product_option_arr[i];
        
        //每一组sku 父视图
        UIView *skuView = [[UIView alloc]initWithFrame:CGRectMake(0, y, SScreenWidth, 20)];
        skuView.tag = i+1;
        [scrollView addSubview:skuView];
        [_currentAllSkuViews addObject:skuView];
        [skuView bindValue:model forKey:KBindSender];
        
        //sku名称
        UILabel *namelb = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SScreenWidth, 20)];
        namelb.text = model.name;
        namelb.textColor = SSColorWithRGB(75, 75, 75, 1);
        namelb.font = SSFontWithName(@"", 13);
        [skuView addSubview:namelb];
        
        //规格下面相应的字按钮
        NSArray *values = [self skuNamesFromPostion:model.position.integerValue];
        CGFloat btx = 15;
        CGFloat bty = 30;
        for (NSInteger j =0; j<values.count; j++) {
            NSString *value = values[j];
            value = [value isEqualToString:@""]?@"默认":value;
            
            CGFloat width = [self calculateText:value maxSize:CGSizeMake(FLT_MAX, 20) font:SSFontWithName(@"", 13) lineSpace:0 lineBreakMode:NSLineBreakByWordWrapping].width+10;
            width = MIN(MAX(60, width), SScreenWidth-30);
            
            //规格按钮
            AMDButton *bt = [[AMDButton alloc]initWithFrame:CGRectMake(btx, bty, width, 30)];
            bt.titleLabel.text = value;
            bt.titleLabel.font = SSFontWithName(@"", 13);
            [bt setTitleColor:SSColorWithRGB(75, 75, 75, 1) forState:UIControlStateNormal];
            [bt setTitleColor:SSColorWithRGB(255, 82, 54, 1) forState:UIControlStateSelected];
            [bt setTitleColor:SSColorWithRGB(204, 204, 204, 1) forState:UIControlStateDisabled];
            bt.layer.borderColor = [SSColorWithRGB(192, 192, 192, 1) CGColor];
            bt.layer.borderWidth = 0.5;
            bt.layer.cornerRadius = 3;
            bt.layer.masksToBounds = YES;
            [skuView addSubview:bt];
            [bt addTarget:self action:@selector(clickAction1:) forControlEvents:UIControlEventTouchUpInside];
            [bt bindValue:skuView forKey:kBindParentView];
            
            //单sku的情况下 默认选中第一个
            if (_currentProductModel.sku_arr.count == 1){
                bt.layer.borderColor = [SSColorWithRGB(68,129,235, 1) CGColor];
                bt.selected = YES;
            }
            
            // 修复Y位置
            if (bt.amd_width + bt.amd_x + 15 > SScreenWidth) {
                bty += 40;
                // 修复当前按钮的位置
                bt.amd_x = 15;
                bt.amd_y += 40;
            }
            btx = bt.amd_width+bt.amd_x+10;
            
            // 判断当前按钮下面是否内存可用按钮是否可用(某一个)
            NSString *optionname = [[NSString alloc]initWithFormat:@"%@%@",model.optionKey,value];
            AYEOptionQuantityModel *optionModel = _allSkuCombinateResault[optionname];
            // 没有库存情况下设置按钮不可用
            if (optionModel.quantity_setting.intValue == 1 && optionModel.quantity.intValue == 0) {
                [self setOptionButtonState:0 sender:bt];
            }
        }
        
        bty += 40;
        
        skuView.frame = CGRectMake(skuView.frame.origin.x, skuView.frame.origin.y, skuView.frame.size.width, bty);
        y += bty;
    }
    
    //改变scrollView的偏移
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, MAX(y+20, scrollView.frame.size.height+1));
}



#pragma mark - PrivateAPI
// 根据sku的位置得出所有的规格名称
- (NSArray *)skuNamesFromPostion:(NSInteger)postion
{
    NSArray *options = @[@"option1",@"option2",@"option3",@"option4",@""];
    NSString *option = options[postion];
    NSArray *optionnames = [_currentProductModel.sku_arr valueForKey:option];
    NSSet *set = [[NSSet alloc]initWithArray:optionnames];
    return [set allObjects];
}


//计算文字尺寸---用户去除警告
- (CGSize)calculateText:(NSString *)text
                maxSize:(CGSize)maxsize
                   font:(UIFont *)font
              lineSpace:(CGFloat)linespace
          lineBreakMode:(NSLineBreakMode)linebreakdmode
{
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = linebreakdmode;
    style.lineSpacing = linespace;
    NSDictionary *att = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:style};
    CGRect textrect = [text boundingRectWithSize:maxsize options:NSStringDrawingUsesLineFragmentOrigin attributes:att context:nil];
    CGSize textSize = textrect.size;
    return textSize;
}


#pragma mark -  public API
// 赋值商品信息
- (void)assignProductModel:(AMDSupplierProductModel *)productModel
{
    _currentProductModel = productModel;
    
    // 初始化视图
    [self initMembory];
    [self initSkus];
    [self initContentView];
}

- (void)selectProductSkuID:(NSString *)skuID
{
    NSArray *skuids = [_currentProductModel.sku_arr valueForKey:@"sku_id"];
    if ([skuids containsObject:skuID]) {
        NSInteger index = [skuids indexOfObject:skuID];
        AMDSupplySkuModel *skuModel = _currentProductModel.sku_arr[index];
        
        // 设置选中显示
        for (NSInteger i = 0; i<_currentAllSkuViews.count; i++) {
            UIView *skuView = _currentAllSkuViews[i];
            NSString *optionKey = [[NSString alloc]initWithFormat:@"option%li",i+1];
            NSString *option = [skuModel valueForKey:optionKey];
            
            for (AMDButton *sender in skuView.subviews) {
                if (![sender isKindOfClass:[AMDButton class]])   continue;
                if ([option isEqualToString:sender.titleLabel.text]) {
                    [self clickAction1:sender];
                    break;
                }
            }
        }
    }
}

- (AMDSupplySkuModel *)prepareTakeOrderSkuModel
{
    return _selectSupplySkuModel;
}



#pragma mark - UI处理
// 处理 按钮的三种状态描边颜色
// 当前规格的描边色 0不可用 1正常可用 2被选中
- (void)setOptionButtonState:(NSInteger)state
                        sender:(AMDButton *)senderBt
{
    switch (state) {
        case 0:     //当前规格按钮不可用
            senderBt.enabled = NO;
            senderBt.layer.borderColor = [SSColorWithRGB(204, 204, 204, 1) CGColor];
            break;
        case 1:     //当前规格按钮可用
            senderBt.enabled = YES;
            senderBt.layer.borderColor = [SSColorWithRGB(196, 196, 196, 1) CGColor];
            break;
        case 2:     //当前规格按钮被选中
            senderBt.enabled = YES;
            senderBt.layer.borderColor = [SSColorWithRGB(255, 82, 54, 1) CGColor];
            break;
            
        default:
            break;
    }
}




#pragma mark - 重构使用开辟的新方法
// 按钮事件1---根据新算法
- (void)clickAction1:(AMDButton *)sender
{
    // 如果单规的话---不能取消
    if (_currentProductModel.sku_arr.count == 1) {
        return ;
    }
    
    // 设置按钮选中色问题
    [self setSelectSkuButton:sender];
    
    // 在其他未选择的规格所列出的选择
    for (UIView *senderSkuView in _currentAllSkuViews) {
        
        NSMutableArray *optionscopy = _currentSelectOptions.mutableCopy;
        if ([_currentSelectSkuViews containsObject:senderSkuView])
        { // 在已选的规格中 除去当前点击的某项规格
            AMDSupplyProductOptionModel *optionMoel = [senderSkuView getBindValueForKey:KBindSender];
            AMDButton *selectSkuBt = [senderSkuView getBindValueForKey:kBindSkuOption];
            NSString *optionname = [optionMoel.optionKey stringByAppendingString:selectSkuBt.titleLabel.text];
            [optionscopy removeObject:optionname];
        }
        // 处理按钮可用状态
        [self dealBtEnableWithSkuView:senderSkuView tempSelectOptions:optionscopy];
    }
    
    // 设置相关UI处理
    [self adjustPriceAndQuality];
}

// 处理
- (void)dealBtEnableWithSkuView:(UIView *)skuView
              tempSelectOptions:(NSMutableArray *)tempSelectOptions
{
    AMDSupplyProductOptionModel *optionMoel = [skuView getBindValueForKey:KBindSender];
    AMDButton *selectSkuBt = [skuView getBindValueForKey:kBindSkuOption];
    
    for (AMDButton *bt in skuView.subviews) {
        if (![bt isKindOfClass:[AMDButton class]]) {
            continue ;
        }
        
        // 如果是选中的按钮
        if ([selectSkuBt isEqual:bt]) {
            // 选中的按钮
            continue ;
        }
        
        // 临时重组
        NSString *optionname = [optionMoel.optionKey stringByAppendingString:bt.titleLabel.text];
        [tempSelectOptions addObject:optionname];
        
        // 从本地组合中查询是否含有这个组合
        BOOL isexist = NO;
        NSString *concatname = [[tempSelectOptions sortedArrayUsingSelector:@selector(compare:)] componentsJoinedByString:@";"];
        // 是否存在当前的拼装组合
        isexist = [_allSkuCombineKeys containsObject:concatname];
        
        
        // 做库存判断(在含有本地组合的情况下)
        if (isexist) {
            AYEOptionQuantityModel *optionModel = _allSkuCombinateResault[concatname];
            // 没有库存情况下设置按钮不可用
            if (optionModel.quantity_setting.intValue == 1 && optionModel.quantity.intValue == 0) {
                isexist = NO;
            }
        }
        
        // 设置按钮样式
        NSInteger type = isexist?1:0;
        [self setOptionButtonState:type sender:bt];
        
        // 循环结束移除上个元素
        [tempSelectOptions removeObject:[tempSelectOptions lastObject]];
    }
}


// 设置某块SKu属性区域的按钮被选中逻辑处理
- (void)setSelectSkuButton:(AMDButton *)sender
//                    select:(BOOL)selectd
{
    // 父视图
    UIView *skuView = [sender getBindValueForKey:kBindParentView];
    AMDSupplyProductOptionModel *optionModel = [skuView getBindValueForKey:KBindSender];
    
    
    // 取消之前的选中色 和 之前的逻辑
    AMDButton *oldbt = [skuView getBindValueForKey:kBindSkuOption];
    if ([oldbt isKindOfClass:[AMDButton class]]) {
        // 取消之前选中的按钮 颜色和描边 不是当前按钮的情况下
        if (![sender isEqual:oldbt]) {
            // 移除的选中文字
            NSString *oldoptionName = [optionModel.optionKey stringByAppendingString:oldbt.titleLabel.text];
            [_currentSelectOptions removeObject:oldoptionName];
            
            
            oldbt.selected = NO;
            [self setOptionButtonState:1 sender:oldbt];
        }
    }
    
    // 当前按钮的文本
    NSString *newoptionname = [optionModel.optionKey stringByAppendingString:sender.titleLabel.text];
    if (!sender.isSelected) {
        // 不是选中状态
        // 添加SkuView
        if (![_currentSelectSkuViews containsObject:skuView]) {
            [_currentSelectSkuViews addObject:skuView];
        }
        
        // 添加选择的标题名称
        [_currentSelectOptions addObject:newoptionname];
    }
    else {
        // 移除SkuView
        [_currentSelectSkuViews removeObject:skuView];
        //
        [_currentSelectOptions removeObject:newoptionname];
    }
    
    // 设置按钮和描边选中色
    [sender setSelected:!sender.isSelected];
    [self setOptionButtonState:sender.isSelected?2:1 sender:sender];
    
    // 绑定或取消 当前按钮
    [skuView bindValue:sender.isSelected?sender:nil forKey:kBindSkuOption];
    
    
    return;
    // 添加选中的颜色
    
    
    // 取消之前所选按钮的选中效果
    /*AMDButton *oldbt = [skuView getBindValueForKey:kBindSkuOption];
    if ([oldbt isKindOfClass:[AMDButton class]]) {
        // 取消选中色
        [self setOptionButtonState:1 sender:oldbt];
        
        // 移除旧状态
        NSString *oldoptionName = [optionModel.optionKey stringByAppendingString:oldbt.titleLabel.text];
        [_currentSelectOptions removeObject:oldoptionName];
        
        // 取消状态
        oldbt.selected = NO;
        [skuView bindValue:nil forKey:kBindSkuOption];
    }
    
    // 绑定当前选中的效果
    if (selectd) {
        // 增加选中色
        [self setOptionButtonState:2 sender:sender];
        
        sender.selected = YES;
        [skuView bindValue:sender forKey:kBindSkuOption];
    }
    
    // 逻辑处理
    NSString *optionname = [optionModel.optionKey stringByAppendingString:sender.titleLabel.text];
    if (selectd) {
        // 添加SkuView
        if (![_currentSelectSkuViews containsObject:skuView]) {
            [_currentSelectSkuViews addObject:skuView];
        }
        
        // 添加选择的标题名称
        [_currentSelectOptions addObject:optionname];
    }
    else {
        // 移除绑定的上一个选中按钮
        [skuView bindValue:nil forKey:kBindSkuOption];
        // 移除SkuView
        [_currentSelectSkuViews removeObject:skuView];
        //
        [_currentSelectOptions removeObject:optionname];
    }*/
}


// 选中了所有的规格 进行设置价格和库存UI的相关操作
- (void)adjustPriceAndQuality
{
    // 尚未选择完成
    if (_currentSelectSkuViews.count != _currentProductModel.product_option_arr.count) {
        _selectSupplySkuModel = nil;
        return;
    }
    
    // 所有规格已选
    NSArray *arry = [_currentSelectOptions sortedArrayUsingSelector:@selector(compare:)];
    NSString *concatName = [arry componentsJoinedByString:@";"];
    
    // 获取当前的sku
    AMDSupplySkuModel *skuModel = [_allSkuOptionValues valueForKey:concatName];
    _selectSupplySkuModel = skuModel;
    
    if ([_delegate respondsToSelector:@selector(skuView:selectSku:)]) {
        [_delegate skuView:self selectSku:skuModel];
    }
}




#pragma mark - 多Sku组合算法
/*首先初始化，将数组前n个元素置1，表示第一个组合为前n个数。
 然后从左到右扫描数组元素值的“10”组合，找到第一个“10”组合后将其变为“01”组合；
 同时将其左边的所有“1”全部移动到数组的最左端。
 当第一个“1”移动到数组的m-n的位置，即n个“1”全部移动到最右端时，就得到了最后一个组合。*/
// 组合算法 从m中获取n个元素
- (NSArray *)flagsFromTotal:(NSInteger)m count:(NSInteger)n
{
    // 首先初始化，将数组前n个元素置1，表示第一个组合为前n个数。
    NSMutableArray *nArry = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i<m; i++) {
        [nArry addObject:@(i<n?1:0)];
    }
    
    if (m == n) {
        return @[nArry];
    }
    
    NSMutableArray *resault = [[NSMutableArray alloc]init];
    // 全排第一次
    [resault addObject:[nArry copy]];
    
    BOOL isend = false;
    //    int i = m-1;  //初始化的时候
    //然后从左到右扫描数组元素值的“10”组合，找到第一个“10”组合后将其变为“01”组合
    while (!isend) {
        // 从后往前走--一遍循环结束
        NSInteger leftTotal1 = 0;      //左侧的1的数量
        for (NSInteger i = 0; i < m-1; i++) {
            if ([nArry[i] intValue] == 1 && [nArry[i+1] intValue] == 0) {
                // 然后左侧的所有的1 移到最左侧
                for (NSInteger j = 0; j<i; j++) {
                    nArry[j] = @(j<leftTotal1?1:0);
                }
                
                // 找到第一个 10组合 变成 01
                [nArry exchangeObjectAtIndex:i withObjectAtIndex:i+1];
                [resault addObject:[nArry copy]];
                
                // 当第一个“1”移动到数组的m-n的位置，即n个“1”全部移动到最右端时，就得到了最后一个组合。
                if ([nArry indexOfObject:@1] == m-n) {
                    isend = true;
                }
                
                break;  //一次循环结束--可以重新执行了
            }
            
            // 左侧多少个1
            if ([nArry[i] intValue] == 1) {
                leftTotal1++;
            }
        }
    }
    
    return resault;
}


// 获取所有可能的sku 字段
/*['10'],
 ['20','21','22','23','24'],
 ['30','31','32','33','34','35','36','37','38'],
 ['40']
 ];*/
- (NSDictionary *)getAllSkuOptionKeys
{
    if (_allSkuOptionValues == nil) {
        _allSkuOptionValues = [[NSMutableDictionary alloc]init];
    }
    //
    for (NSInteger i =0; i<_currentProductModel.sku_arr.count; i++) {
        AMDSupplySkuModel *skuModel = _currentProductModel.sku_arr[i];
        NSString *value = [skuModel allOptionValue];
        [_allSkuOptionValues setObject:skuModel forKey:value];
    }
    return _allSkuOptionValues;
}


// 从一组元素中中生成所有可能的长度的集合
- (NSArray *)arryCombineFromSource:(NSArray *)source
{
    if (source.count == 0) return nil;
    
    NSMutableArray *resault = [[NSMutableArray alloc]init];
    for (NSInteger i = 1; i <= source.count; i++) {
        NSArray *arry = [self flagsFromTotal:source.count count:i];
        
        // 按照1的位置取出相应的元素[[1,0],[1],[0,1]]
        for (NSInteger j = 0; j<arry.count; j++) {
            NSMutableArray *value = [[NSMutableArray alloc]init];
            NSArray *arryj = arry[j];
            for (NSInteger k = 0;k<[arryj count]; k++) {
                if ([arry[j][k] intValue] == 1) {
                    [value addObject:source[k]];
                }
            }
            [resault addObject:[value mutableCopy]];
        }
    }
    return resault;
}


// 初始化得到结果集
- (void)initSkus
{
    @autoreleasepool {
        // 根据现有的sku 字段 去重新排列可能有的所有情况
        NSDictionary *optionDict = [self getAllSkuOptionKeys];
        NSArray *keys = [optionDict allKeys];
        for (NSInteger i = 0; i<keys.count; i++) {
            NSString *skuKey = keys[i];
            // 内容
            AMDSupplySkuModel *model = _allSkuOptionValues[skuKey];
            AYEOptionQuantityModel *optionModel = [[AYEOptionQuantityModel alloc]init];
            optionModel.optionValue = [model allOptionValue];
            optionModel.quantity = model.quantity;
            optionModel.quantity_setting = model.quantity_setting;
            
            NSArray *skuKeysAttrs = [skuKey componentsSeparatedByString:@";"];
            
            // 将商品规格属性排列(按ASII码排列)
            skuKeysAttrs = [skuKeysAttrs sortedArrayUsingSelector:@selector(compare:)];
            
            // 对每个SKU信息key属性值进行拆分组合
            // 并把结果集放入到集合
            NSArray *flagArry = [self arryCombineFromSource:skuKeysAttrs];
            for (NSInteger i =0; i < flagArry.count; i++) {
                NSArray *flag = flagArry[i];
                [self addSkuResaultWithKey:flag model:optionModel];
            }
        }
        
        // 处理相应的键值
        self.allSkuCombineKeys = [_allSkuCombinateResault allKeys];
    }
}


// 将组合的key存到结果集里面
- (void)addSkuResaultWithKey:(NSArray *)keys
                       model:(AYEOptionQuantityModel *)optionModel
{
    //@[@"红色",@"34",@"L"]----红色;34;L
    NSString *key = [keys componentsJoinedByString:@";"];
    if ([_allSkuCombinateResault.allKeys containsObject:key]) {
        AYEOptionQuantityModel *model = [_allSkuCombinateResault[key] mutableCopy];
        model.quantity_setting = @(optionModel.quantity_setting.intValue==1 && model.quantity_setting.intValue==1);
        model.quantity = @(model.quantity.integerValue+optionModel.quantity.integerValue);
        [_allSkuCombinateResault setObject:model forKey:key];
    }
    else {
        [_allSkuCombinateResault setObject:optionModel forKey:key];
    }
}


@end





#pragma mark - 实体类
@implementation AYEOptionQuantityModel

- (void)deallc
{
    self.optionValue = nil;
    self.quantity = nil;
    self.quantity_setting = nil;
}


#pragma mark NSMutableCopying和NSCopying
- (id)mutableCopyWithZone:(nullable NSZone *)zone
{
    typeof(self) typeself = [[[self class] allocWithZone:zone]init];
    typeself.optionValue = self.optionValue;
    typeself.quantity = self.quantity;
    typeself.quantity_setting = self.quantity_setting;
    return typeself;
}


- (id)copyWithZone:(nullable NSZone *)zone
{
    return [self mutableCopyWithZone:zone];
}



@end
















