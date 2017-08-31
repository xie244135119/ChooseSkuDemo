//
//  AMDCopyLabel.h
//  AppMicroDistribution
//  复制视图
//  Created by SunSet on 15-5-20.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMDCopyLabel : UILabel


@property(nonatomic, weak) UIView *responderView;           //自定义响应视图
@property(nonatomic, copy) NSString *customCopyStr;         //自定义复制文本串
//@property(nonatomic, copy) NSString *copyStr;               //复制的字符串
//@property(nonatomic,  )

// 支持复制功能--需要先配置responderView
- (void)supportCopyFunction;



// 文字自动换行显示 返回最高的宽高

/** 行间距默认为 3 */
- (CGSize)calculateSize;

/**
 *  加入行间距计算文字高度
 *
 *  @param lineSpace 行间距
 *
 *  @return 返回文字的 size
 */
- (CGSize)calculateSizeWithLineSpace:(CGFloat)lineSpace;


@end
