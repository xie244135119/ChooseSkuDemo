//
//  AASRegionChoiceView.m
//  AppAmountStore
//
//  Created by SunSet on 14-10-30.
//  Copyright (c) 2014年 SunSet. All rights reserved.
//

#import "AASRegionChoiceView.h"
#import "SSGlobalVar.h"

@interface AASRegionChoiceView() <UIPickerViewDataSource,UIPickerViewDelegate>
{
//    __weak UIButton *_cancelBt;     //取消按钮
//    __weak UIButton *_commitBt;     //提交按钮
}
@property(nonatomic,weak) UIPickerView *pickerView;                 //选择器

@property(nonatomic,strong) __block NSDictionary *regionSourceDict;             //数据源

@property(nonatomic,strong) NSArray *provincesSource;                   //所有的省份
@property(nonatomic,strong) NSMutableArray *selectCitiesSource;                //选中显示的城市
@property(nonatomic,strong) NSMutableArray *selectRegionSource;                //选中城市的区域
@end

@implementation AASRegionChoiceView

- (void)dealloc
{
    self.regionSourceDict = nil;
    self.provincesSource = nil;
    self.selectCitiesSource = nil;
    self.selectRegionSource = nil;
}

- (id)init
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    if (self = [super initWithFrame:CGRectMake(0, 0, width, 162)]) {
        [self initView];
    }
    return self;
}

//视图加载
- (void)initView
{
    self.backgroundColor = SSColorWithRGB(246, 246, 246, 1);
    // pickerView
    UIPickerView *pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 162)];
    //用于自定义pickview大小
    pickerView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [self addSubview:pickerView];
    _pickerView = pickerView;
    
}


//默认的地理区域选择
- (NSDictionary *)defaultRegionChoice
{
    NSInteger selectone = 0;
    NSInteger selecttwo = 0;
    NSInteger selectthree = 0;
    NSDictionary *provice = self.provincesSource[selectone];
    NSDictionary *city = self.selectCitiesSource[selecttwo];
    //防止数组越界 例如海外海外
    NSDictionary *region = self.selectRegionSource.count > selectthree?_selectRegionSource[selectthree]:nil;
    NSMutableString *resaultstr = [[NSMutableString alloc]initWithFormat:@"%@-%@",provice[@"name"],city[@"name"]];
    NSMutableString *resaultid = [[NSMutableString alloc]initWithFormat:@"%@;%@",provice[@"zip_code"],city[@"zip_code"]];
    
    NSMutableDictionary *resault = [[NSMutableDictionary alloc]initWithObjectsAndKeys:resaultid,@"location_ids",resaultstr,@"location",provice[@"name"],@"province",city[@"name"],@"city",nil];
    //
    if (region) {
        [resaultstr appendFormat:@"-%@",region[@"name"]];
        [resaultid appendFormat:@";%@",region[@"zip_code"]];
        [resault setObject:region[@"name"] forKey:@"district"];
    }
    return resault;
}

// 根据省市区的名称 滑动到指定的区域
- (void)scrollByNameWithProvince:(NSString *)province city:(NSString *)city district:(NSString *)district
{
    [self scrollToWithProvince:province city:city district:district equalKey:@"name"];
}

// 滑动到指定的地方
- (void)scrollToWithProvince:(NSString *)provincecode city:(NSString *)citycode district:(NSString *)districtcode
{
    [self scrollToWithProvince:provincecode city:citycode district:districtcode equalKey:@"zip_code"];
}

- (void)scrollToWithProvince:(NSString *)provincecode city:(NSString *)citycode district:(NSString *)districtcode equalKey:(NSString *)key
{
    // 获取当前省份所在位置
    NSInteger provinceindex = -1;
    for (NSDictionary *province in self.provincesSource) {
        if ([provincecode isEqualToString:province[key]]) {
            provinceindex = [_provincesSource indexOfObject:province];
            break;
        }
    }
    if (provinceindex == -1) {
        return;
    }
    
    [_pickerView selectRow:provinceindex inComponent:0 animated:NO];
    [self pickerView:_pickerView didSelectRow:provinceindex inComponent:0];
    
    // 获取当前城市所在位置
    NSInteger cityindex = -1;
    for (NSDictionary *city in _selectCitiesSource) {
        if ([citycode isEqualToString:city[key]]) {
            cityindex = [_selectCitiesSource indexOfObject:city];
            break;
        }
    }
    if (cityindex > -1) {
        [_pickerView selectRow:cityindex inComponent:1 animated:NO];
        [self pickerView:_pickerView didSelectRow:cityindex inComponent:1];
    }
    
    // 获取当前所在区
    NSInteger districtindex = -1;
    for (NSDictionary *district in _selectRegionSource) {
        if ([districtcode isEqualToString:district[key]]) {
            districtindex = [_selectRegionSource indexOfObject:district];
            break;
        }
    }
    if (districtindex > -1) {
        [_pickerView selectRow:districtindex inComponent:2 animated:NO];
        [self pickerView:_pickerView didSelectRow:districtindex inComponent:2];
    }
}



#pragma mark - 按钮事件
- (void)clickAction:(UIButton *)sender
{
    //    if (sender.tag == 1) {
    NSInteger selectone = [_pickerView selectedRowInComponent:0];
    NSInteger selecttwo = [_pickerView selectedRowInComponent:1];
    NSInteger selectthree = [_pickerView selectedRowInComponent:2];
    NSDictionary *provice = _provincesSource.count > selectone?_provincesSource[selectone]:nil;
    NSDictionary *city = _selectCitiesSource.count > selecttwo ? _selectCitiesSource[selecttwo]:nil;
    if (provice == nil || city == nil) {
        return ;
    }
    //防止数组越界 例如海外海外
    NSDictionary *region = _selectRegionSource.count > selectthree?_selectRegionSource[selectthree]:nil;
    NSMutableString *resaultstr = [[NSMutableString alloc]initWithFormat:@"%@-%@",provice[@"name"],city[@"name"]];
    NSMutableString *resaultid = [[NSMutableString alloc]initWithFormat:@"%@;%@",provice[@"zip_code"],city[@"zip_code"]];
    
    NSMutableDictionary *resault = [[NSMutableDictionary alloc]initWithObjectsAndKeys:resaultid,@"location_ids",resaultstr,@"location",provice[@"name"],@"province",city[@"name"],@"city",nil];
    //
    if (region) {
        [resaultstr appendFormat:@"-%@",region[@"name"]];
        [resaultid appendFormat:@";%@",region[@"zip_code"]];
        [resault setObject:region[@"name"] forKey:@"district"];
    }
    
    if ([_delegate respondsToSelector:@selector(choiceType:resault:)]) {
        [_delegate choiceType:1 resault:resault];
    }
}


#pragma mark - GET方法--赋值操作
- (NSDictionary *)regionSourceDict
{
    if (_regionSourceDict == nil) {
        /*NSString *urlpath = [NSHomeDirectory() stringByAppendingString:@"/Documents/RegionCacheProperty.plist"];
        _regionSourceDict = [[NSDictionary alloc]initWithContentsOfFile:urlpath];
        
        // 如果本地尚未缓存 就用项目中的文件临时处理
        if (_regionSourceDict.allKeys.count == 0) {
            NSString *tempurlpath = GetFilePath(@"RegionCacheProperty.plist");
            _regionSourceDict = [[NSDictionary alloc]initWithContentsOfFile:tempurlpath];
        }*/
        
        // 获取数据源
//        if ([_dataSource respondsToSelector:@selector(getRegionChoiceSourceCompletion:)]) {
//            [_dataSource getRegionChoiceSourceCompletion:^(NSDictionary *source) {
//                _regionSourceDict = source;
//            }];
//        }
        if ([_dataSource respondsToSelector:@selector(regionChoiceSource)]) {
            _regionSourceDict = [_dataSource regionChoiceSource];
        }
    }
    return _regionSourceDict;
}

- (NSArray *)provincesSource
{
    if (_provincesSource == nil) {
        NSArray *provinces = self.regionSourceDict[@"provinces"];
        _provincesSource = [[NSArray alloc]initWithArray:provinces];
    }
    return _provincesSource;
}

//选中显示的城市---默认是第一个城市
- (NSMutableArray *)selectCitiesSource
{
    if (_selectCitiesSource == nil) {
        if (self.provincesSource.count == 0) {
            return nil;
        }
        NSDictionary *provice = self.provincesSource[0];
        NSString *divisionCode = provice[@"zip_code"];
        _selectCitiesSource = [[NSMutableArray alloc]initWithArray:_regionSourceDict[divisionCode]];
    }
    return _selectCitiesSource;
}

// 选择城市的区域---默认是第一个城市的区
- (NSMutableArray *)selectRegionSource
{
    if (_selectRegionSource == nil) {
        if (self.selectCitiesSource.count == 0) {
            return nil;
        }
        NSDictionary *city = self.selectCitiesSource[0];
        NSString *divisionCode = city[@"zip_code"];
        _selectRegionSource = [[NSMutableArray alloc]initWithArray:_regionSourceDict[divisionCode]];
    }
    return _selectRegionSource;
}

// 根据省份获取
//- (NSString *)zipCodePathWithProvince:(NSString *)provincestr city:(NSString *)city district:(NSString *)district
//{
//    for (NSDictionary *province in self.provincesSource) {
//        
//    }
//}


#pragma mark - UIPickerViewDataSource
//
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

//
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:{//省份
            return self.provincesSource.count;
        }
            break;
        case 1:{//城市
            return self.selectCitiesSource.count;
        }
        case 2:{//区域
            return self.selectRegionSource.count;
        }
            break;
        default:
            break;
    }
    return 1;
}




#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:{    //省份
            NSDictionary *item = _provincesSource[row];
            return item[@"name"];
        }
            break;
        case 1:{    //城市
            NSDictionary *city = _selectCitiesSource[row];
            return city[@"name"];
        }
        case 2:{    //区(县)
            NSDictionary *region = _selectRegionSource[row];
            return region[@"name"];
        }
            break;
        default:
            break;
    }
    return @"请选择";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:{//选择省份
            //更新城市
            NSDictionary *provice = _provincesSource.count>row ? _provincesSource[row]:nil;
            if (provice == nil)  return;
            
            NSArray *cities = _regionSourceDict[provice[@"zip_code"]];
            [_selectCitiesSource removeAllObjects];
            [_selectCitiesSource addObjectsFromArray:cities];
            [pickerView reloadComponent:1];
            
            //更新区域
            NSDictionary *city = cities.count>0 ? cities[0]:nil;
            if (city == nil)  return;

            NSArray *regisons = _regionSourceDict[city[@"zip_code"]];
            [_selectRegionSource removeAllObjects];
            [_selectRegionSource addObjectsFromArray:regisons];
            [pickerView reloadComponent:2];
        }
            break;
        case 1:{//选择城市
            NSDictionary *city = _selectCitiesSource.count>row ? _selectCitiesSource[row]:nil;
            if (city == nil)  return ;
            NSArray *regisons = _regionSourceDict[city[@"zip_code"]];
            [_selectRegionSource removeAllObjects];
            [_selectRegionSource addObjectsFromArray:regisons];
            [pickerView reloadComponent:2];
        }
            break;
            
        default:
            break;
    }
    
    //更新数据源
    [self clickAction:nil];
}




@end








