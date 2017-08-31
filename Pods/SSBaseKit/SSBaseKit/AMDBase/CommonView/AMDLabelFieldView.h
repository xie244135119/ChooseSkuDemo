//
//  AMDLabelFieldView.h
//  AppMicroDistribution
//  左侧label 右侧field
//  Created by SunSet on 15-5-20.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SSBaseKit/AMDTextField.h>

@interface AMDLabelFieldView : UIControl<UITextFieldDelegate>


@property(nonatomic,weak) UILabel *titleLabel;          //标题
@property(nonatomic,weak) AMDTextField *textField;       //详细内容
@property(nonatomic) BOOL rightArrowShow;             //右箭头展示



//父视图---注：当父视图为滑动视图的时候可用,默认不可用
@property(nonatomic,weak) UIScrollView *parentScrollView;

// 实例化
- (id)initWithFrame:(CGRect)frame title:(NSString *)title;



@end



