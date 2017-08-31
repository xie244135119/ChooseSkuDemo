//
//  AYEActionSheetView.m
//  AppMicroDistribution
//
//  Created by leo on 16/4/1.
//  Copyright © 2016年 SunSet. All rights reserved.
//

#import "AYEActionSheetView.h"
#import "AYESheetCell.h"
#import "SSGlobalVar.h"

#define kFooterHeight 10
#define kCellHeight 50
#define kBackColorAlpha 0.6

@interface AYEActionSheetView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *arr;
@property (nonatomic) CGFloat tableViewHeight;
@property (nonatomic) BOOL hasDestructive;
@end

@implementation AYEActionSheetView
@synthesize barFont = _barFont;

- (instancetype)initWithdelegate:(id<AYEActionSheetViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles args:(va_list)argList
{
    self = [super init];
    if (self) {
        [self setup];
        NSMutableArray *mutableArr = [NSMutableArray array];
        {
            NSMutableArray *titles_arr = [NSMutableArray new];
            if (destructiveButtonTitle.length > 0) {
                self.hasDestructive = YES;
                [titles_arr addObject:destructiveButtonTitle];
            }
            if (otherButtonTitles) {
                [titles_arr addObject:otherButtonTitles];
                NSString *title;
                while ((title = va_arg(argList, NSString *))) {
                    [titles_arr addObject:title];
                }
            }
            [mutableArr addObject:[titles_arr copy]];
        }
        !(cancelButtonTitle.length > 0) ?: [mutableArr addObject:@[cancelButtonTitle]];
        self.arr = [mutableArr copy];
        for (id obj in self.arr) {
            if ([obj isKindOfClass:[NSArray class]]) {
                self.tableViewHeight += [obj count] * kCellHeight + kFooterHeight;
            }
        }
        self.tableViewHeight -= kFooterHeight;
        _delegate = delegate;
    }
    return self;
}

- (instancetype)initWithdelegate:(id<AYEActionSheetViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    self = [super init];
    if (self) {
        [self setup];
        NSMutableArray *mutableArr = [NSMutableArray array];
        {
            va_list titles;
            va_start(titles, otherButtonTitles);
            NSMutableArray *titles_arr = [NSMutableArray new];
            if (destructiveButtonTitle.length > 0) {
                self.hasDestructive = YES;
                [titles_arr addObject:destructiveButtonTitle];
            }
            if (otherButtonTitles) {
                [titles_arr addObject:otherButtonTitles];
                NSString *title;
                while ((title = va_arg(titles, NSString *))) {
                    [titles_arr addObject:title];
                }
            }
            va_end(titles);
            [mutableArr addObject:[titles_arr copy]];
        }
        !(cancelButtonTitle.length > 0) ?: [mutableArr addObject:@[cancelButtonTitle]];
        self.arr = [mutableArr copy];
        for (id obj in self.arr) {
            if ([obj isKindOfClass:[NSArray class]]) {
                self.tableViewHeight += [obj count] * kCellHeight + kFooterHeight;
            }
        }
        self.tableViewHeight -= kFooterHeight;
        _delegate = delegate;
    }
    return self;
}

- (void)setup {
    [self addTarget:self action:@selector(DidTap:) forControlEvents:UIControlEventTouchUpInside];
    UITableView *tab = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView = tab;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    //    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AYESheetCell class]) bundle:nil] forCellReuseIdentifier:@"sheetCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tableView];
}

- (void)DidTap:(UITapGestureRecognizer *)sender {
    [self dismiss];
}

- (void)showInView:(UIView *)view
{
    if (view && view != self.superview) {
        if (self.superview) {
            [self removeFromSuperview];
        }
        [view addSubview:self];
        self.frame = view.frame;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        self.tableView.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), self.tableViewHeight);
        [self show];
    }
}

- (void)show {
    CGFloat y = self.tableView.frame.origin.y;
    if (y <= CGRectGetHeight(self.frame) - self.tableViewHeight) {
        return;
    } else {
        [self.tableView reloadData];
        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:kBackColorAlpha];
                             self.tableView.frame = CGRectMake(0, CGRectGetHeight(self.frame) - self.tableViewHeight, CGRectGetWidth(self.frame), self.tableViewHeight);
                         } completion:nil];
    }
}

- (void)dismiss {
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
                         //                         self.tableView.alpha = 0;
                         self.tableView.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), self.tableViewHeight);
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}




#pragma mark - SET
- (void)setBarFont:(UIFont *)barFont
{
    if (_barFont != barFont) {
        _barFont = barFont;
        
        if (barFont != nil) {
            [_tableView reloadData];
        }
    }
}

- (UIFont *)barFont
{
    if (_barFont == nil) {
        return SSFontWithName(@"", 17);
    }
    return _barFont;
}





#pragma mark - Table view data source and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arr[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellider = @"sheetCell";
    AYESheetCell *cell = [tableView dequeueReusableCellWithIdentifier:cellider];
    if (cell == nil) {
        cell = [[AYESheetCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellider];
    }
    cell.sheetTitle_label.text = self.arr[indexPath.section][indexPath.row];
    //    cell.sheetTitle_label.font = SSFontWithName(@"", 17);
    cell.sheetTitle_label.font = self.barFont;
    if (indexPath.section == 0 && indexPath.row == 0 && self.hasDestructive) {
        cell.sheetTitle_label.textColor = [UIColor colorWithRed:1.0 green:0.3216 blue:0.2118 alpha:1.0];
    } else {
        cell.sheetTitle_label.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == self.arr.count - 1) {
        return CGFLOAT_MIN;
    }
    return kFooterHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(AYEActionSheetView:DidTapWithTitle:)]) {
        [self.delegate AYEActionSheetView:self DidTapWithTitle:self.arr[indexPath.section][indexPath.row]];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(AYEActionSheetView:DidTapWithIndex:)]) {
        NSInteger index = NSNotFound;
        if (self.hasDestructive && indexPath.section == 0 && indexPath.row == 0) {
            index = -1;
        } else if (indexPath.section == 1 && indexPath.row == 0) {
            index = 0;
        } else {
            if (self.hasDestructive) {
                index = indexPath.row;
            } else{
                index = indexPath.row + 1;
            }
        }
        [self.delegate AYEActionSheetView:self DidTapWithIndex:index];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(AYEActionSheetView:willDismissWithIndex:)]) {
        NSInteger index = NSNotFound;
        if (self.hasDestructive && indexPath.section == 0 && indexPath.row == 0) {
            index = -1;
        } else if (indexPath.section == 1 && indexPath.row == 0) {
            index = 0;
        } else {
            if (self.hasDestructive) {
                index = indexPath.row;
            } else{
                index = indexPath.row + 1;
            }
        }
        [self.delegate AYEActionSheetView:self willDismissWithIndex:index];
    }
    [self dismiss];
}

@end








































