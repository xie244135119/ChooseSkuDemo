//
//  AMDImageView.m
//  AppMicroDistribution
//
//  Created by SunSet on 2017/5/10.
//  Copyright © 2017年 SunSet. All rights reserved.
//

#import "AMDImageView.h"

@implementation AMDImageView

- (void)setImageWithUrl:(NSURL *)url placeHolder:(UIImage *)placeHolder
{
    // 实现主项目实现
    self.image = placeHolder;
}


- (void)setImageWithUrl:(NSURL *)url
            placeHolder:(UIImage *)placeHolder
             completion:(void (^)(UIImage *, NSError *))completion
{
    // 实现主项目实现
    self.image = placeHolder;
}



- (void)setImageWithUrl:(NSURL *)url
            placeHolder:(UIImage *)placeHolder
                success:(void (^)(UIImage *))success
                   fail:(void (^)(NSError *))fail
{
    // 主项目实现
    self.image = placeHolder;
}




- (void)setImageWithPath:(NSString *)path
             placeHolder:(UIImage *)placeHolder
{
    // 实现主项目实现
    self.image = placeHolder;
}

- (void)setImageWithPath:(NSURL *)url
             placeHolder:(UIImage *)placeHolder
              completion:(void (^)(UIImage *, NSError *))completion
{
    // 实现主项目实现
    self.image = placeHolder;
}

- (void)setImageWithPath:(NSURL *)url
             placeHolder:(UIImage *)placeHolder
                 success:(void (^)(UIImage *))success
                    fail:(void (^)(NSError *))fail
{
    self.image = placeHolder;
}



@end




