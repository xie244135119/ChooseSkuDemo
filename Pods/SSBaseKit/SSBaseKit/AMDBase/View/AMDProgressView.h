//
//  AMDProgressView.h
//  AppMicroDistribution
//
//  Created by Fuerte on 16/9/8.
//  Copyright © 2016年 SunSet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMDProgressView : UIView


/** 进度条中的颜色 */
@property(nonatomic, strong, nullable) UIColor* progressTintColor;
/** 正常的颜色 */
@property(nonatomic, strong, nullable) UIColor* trackTintColor;

/** 进度 */
@property(nonatomic) float progress;


- (void)setProgress:(float)progress animated:(BOOL)animated NS_AVAILABLE_IOS(5_0);

@end













