//
//  AMDErrorLogTool.m
//  AppMicroDistribution
//
//  Created by SunSet on 16/9/23.
//  Copyright © 2016年 SunSet. All rights reserved.
//

#import "SSErrorLogTool.h"
#import <UIKit/UIDevice.h>

static SSErrorLogTool *UIC = nil;

@interface SSErrorLogTool()

@property(nonatomic, copy) NSString *filePath;          //文件地址
@end

@implementation SSErrorLogTool

+ (id)shareLogTool
{
    //确保创建单例只被执行一次。
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIC = [SSErrorLogTool new];
        //自己建立一个线程
//        UIC.concurrentWriteFileQueue = dispatch_queue_create("人家是写文件的线程自定义队列", DISPATCH_QUEUE_CONCURRENT);
        [UIC userInfoWithUID:[[self class] description]];
    });
    return UIC;
}



- (BOOL)createFileWithUID:(NSString*)UID
{
    // 文件存储的路径，
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentDirectory = [paths objectAtIndex:0];
//    NSLog(@"%@",documentDirectory);
    
    NSFileManager *manager = [NSFileManager defaultManager];
    // 路径下的所有文件名
    
    NSArray *filePathArr = [manager contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/",documentDirectory] error:nil];
//    NSLog(@"arr = %@",filePathArr);
    //    用UID 匹配文件 如果已经有了某个用户的日志，那么就返回这个用户的文件路径，不创建新的。
    for (NSString * file in filePathArr) {
        if ([file rangeOfString:[NSString stringWithFormat:@"%@_",UID]].location != NSNotFound) {
            //            已经有了文件，
            //UIC.filePath 当前操作的文件的路径
            UIC.filePath = [NSString stringWithFormat:@"%@/%@",documentDirectory,file];
            return YES;
        }
    }
    
    //首次创建文件名
    NSString *testPath = [NSString stringWithFormat:@"%@/%@_%@_%@%@",documentDirectory,UID,@"设备号",@"时间戳",@".txt"];
    
    BOOL ifFileExist = [manager fileExistsAtPath:testPath];
    BOOL success = NO;
    if (ifFileExist) {
        NSLog(@"文件已经存在");
        UIC.filePath = testPath;
        return YES;
    }else{
        NSLog(@"文件不存在");
        success = [manager createFileAtPath:testPath contents:nil attributes:nil];
    }
    
    if (!success) {
        NSLog(@"创建文件不成功");
        UIC.filePath = nil;
        //        错误判断+++
    }else{
        NSLog(@"创建文件成功");
        UIC.filePath = testPath;
    }
    
    return NO;
}


- (void)writeMessageToFileWithJsonStr:(NSDictionary*)dic
{
    if (!UIC.filePath) {
        NSLog(@"文件路径错误，写不进去");
        return;
    }
    
    if (dic == nil) {
        NSLog(@" 没有内容存储 ");
        return;
    }
    
    if (![NSJSONSerialization isValidJSONObject:dic]) {
        NSLog(@"不合法的json对象");
        return;
    }
    
    NSFileHandle *file = [NSFileHandle fileHandleForUpdatingAtPath:UIC.filePath];
    // 字典转JSON
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:kNilOptions error:&error];
    NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *jsonStr = [json stringByAppendingString:@",\n"];
    
    // 在文件的末尾添加内容。如果想在开始写 [file seekToFileOffset:0];
    [file seekToEndOfFile];
    NSData *strData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    [file writeData:strData ];
}



- (void)deleteUserInfoFile
{
//    dispatch_barrier_async(kGCDGlobal, ^{
        NSFileManager *manager = [NSFileManager defaultManager];
        BOOL deleSuccess = [manager removeItemAtPath:UIC.filePath error:nil];
        if (deleSuccess) {
            NSLog(@"删除文件成功");
        }else{
            NSLog(@"删除文件不成功");
        }
//    });
    
}


- (NSString *)logText
{
    if (!UIC.filePath) {
        return @"文件路径不存在";
    }
    
    NSString *text = [[NSString alloc]initWithContentsOfFile:UIC.filePath encoding:4 error:nil];
    return text;
}



- (void)userInfoWithUID:(NSString*)UID
{
    //添加写操作到自定义队列，当稍后执行时，这将是队列中唯一执行的条目。这个Block永远不会同时和其他Block一起在队列中执行
//    dispatch_barrier_async(kGCDGlobal, ^{
        // 创建文件
        BOOL hasCreated = [UIC createFileWithUID:UID];
        
        // 存储设备信息
        if (!hasCreated) {
            NSDictionary *dic = @{
                                  @"Device":@{
                                          @"uid":UID,//
                                          @"name":[UIDevice currentDevice].name,
                                          @"model":[UIDevice currentDevice].model,
                                          @"os":[UIDevice currentDevice].systemName,
                                          @"tag":@"AppStore",
                                          @"version":[UIDevice currentDevice].systemVersion
                                          }
                                  };
            // 写入本地文件
            [self writeMessageToFileWithJsonStr:dic];
            
            
            // 存储App信息
            NSString *appversion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            NSDictionary *app = @{@"app":@"wdwd",@"appVersion":appversion};
            [self writeMessageToFileWithJsonStr:app];
        }
//    });
}



@end

















