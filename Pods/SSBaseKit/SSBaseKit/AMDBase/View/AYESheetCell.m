//
//  AYESheetCell.m
//  AppMicroDistribution
//
//  Created by leo on 16/4/1.
//  Copyright © 2016年 SunSet. All rights reserved.
//

#import "AYESheetCell.h"
#import "SSGlobalVar.h"
#import "AMDLineView.h"

@implementation AYESheetCell

- (void)awakeFromNib {
    [super awakeFromNib];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 添加label
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = 50;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, height)];
        label.textColor = SSColorWithRGB(0, 0, 0, 0);
        label.font = SSFontWithName(@"", 16);
        label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label];
        _sheetTitle_label = label;
        
        AMDLineView *line = [[AMDLineView alloc]initWithFrame:CGRectMake(0, height-0.5, width, 0.5) Color:SSLineColor];
        [self.contentView addSubview:line];
    }
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (animated) {
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.contentView.backgroundColor = selected ? SSLineColor : [UIColor whiteColor];
                         }];
    } else {
        self.contentView.backgroundColor = selected ? SSLineColor : [UIColor whiteColor];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (animated) {
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.contentView.backgroundColor = highlighted ? SSLineColor : [UIColor whiteColor];
                         }];
    } else {
        self.contentView.backgroundColor = highlighted ? SSLineColor : [UIColor whiteColor];
    }
}

@end
