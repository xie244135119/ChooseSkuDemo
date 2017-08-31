//
//  AMDErrorLogTool.h
//  AppMicroDistribution
//
//  Created by SunSet on 16/9/23.
//  Copyright © 2016年 SunSet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSErrorLogTool : NSObject

+ (id)shareLogTool;

/** 写入到本地日志文件 */
- (void)writeMessageToFileWithJsonStr:(NSDictionary*)dic;

/** 删除文件 */
- (void)deleteUserInfoFile;

/** 初次创建文件的时候存储 */
- (void)userInfoWithUID:(NSString*)UID;

/** 所有日志 */
- (NSString *)logText;


@end


/*
 •   程序进入后台模式时，立即上传缓存的日志文件
 •   按照时间，以每小时的频率进行数据上报
 •   日志文件小于30KB时，不进行上报
 •   上报成功后，清除已上传成功的日志文件
 •   特殊上报策略——客户端启动触发的事件，实时上报
 */

/*
 •  日志记录内容:
 1, 网络请求错误日志
 •
 •
 •
 */
