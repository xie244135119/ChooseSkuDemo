//
//  AMDImageView.h
//  AppMicroDistribution
//
//  Created by SunSet on 2017/5/10.
//  Copyright © 2017年 SunSet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMDImageView : UIImageView


/**
 根据图片地址设置图片
 
 @param url url
 @param placeHolder 占位图
 */
- (void)setImageWithUrl:(NSURL *)url
            placeHolder:(UIImage *)placeHolder;
- (void)setImageWithUrl:(NSURL *)url
            placeHolder:(UIImage *)placeHolder
             completion:(void (^)(UIImage *, NSError *))completion;


/**
 根据本地图片路径设置图片
 
 @param path 本地图片路径
 @param placeHolder 占位图
 */
- (void)setImageWithPath:(NSString *)path
             placeHolder:(UIImage *)placeHolder;
- (void)setImageWithPath:(NSURL *)url
             placeHolder:(UIImage *)placeHolder
              completion:(void (^)(UIImage *, NSError *))completion;



@end




