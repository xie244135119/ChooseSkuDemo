//
//  AFHTTPSessionManager+NSHttpCategory.m
//  AMDNetworkService
//
//  Created by SunSet on 2017/7/25.
//  Copyright © 2017年 SunSet. All rights reserved.
//

#import "AFHTTPSessionManager+NSHttpCategory.h"

//NS_ASSUME_NONNULL_BEGIN

@implementation AFHTTPSessionManager (NSHttpCategory)



- (NSURLSessionDataTask *)GET_AMD:(NSString *)URLString
                                parameters:(nullable id)parameters
                                   success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                   failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error, id))failure
{
    NSURLSessionDataTask *dataTask = [self amd_dataTaskWithHTTPMethod:@"GET"
                                                            URLString:URLString
                                                           parameters:parameters
                                                       uploadProgress:nil
                                                     downloadProgress:nil
                                                              success:success
                                                              failure:failure];
    
    [dataTask resume];
    
    return dataTask;
}


- (nullable NSURLSessionDataTask *)POST_AMD:(NSString *)URLString
                                 parameters:(nullable id)parameters
                                    success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                    failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error, id))failure
{
    NSURLSessionDataTask *dataTask = [self amd_dataTaskWithHTTPMethod:@"POST"
                                                            URLString:URLString
                                                           parameters:parameters
                                                       uploadProgress:nil
                                                     downloadProgress:nil
                                                              success:success
                                                              failure:failure];
    
    [dataTask resume];
    
    return dataTask;
}


- (nullable NSURLSessionDataTask *)PUT_AMD:(NSString *)URLString
                                parameters:(nullable id)parameters
                                   success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                   failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error, id))failure
{
    NSURLSessionDataTask *dataTask = [self amd_dataTaskWithHTTPMethod:@"PUT"
                                                            URLString:URLString
                                                           parameters:parameters
                                                       uploadProgress:nil
                                                     downloadProgress:nil
                                                              success:success
                                                              failure:failure];
    
    [dataTask resume];
    
    return dataTask;
}


- (nullable NSURLSessionDataTask *)DELETE_AMD:(NSString *)URLString
                                   parameters:(nullable id)parameters
                                      success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                      failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error, id))failure
{
    NSURLSessionDataTask *dataTask = [self amd_dataTaskWithHTTPMethod:@"DELETE"
                                                            URLString:URLString
                                                           parameters:parameters
                                                       uploadProgress:nil
                                                     downloadProgress:nil
                                                              success:success
                                                              failure:failure];
    
    [dataTask resume];
    
    return dataTask;
}



#pragma mark - private api
- (NSURLSessionDataTask *)amd_dataTaskWithHTTPMethod:(NSString *)method
                                           URLString:(NSString *)URLString
                                          parameters:(id)parameters
                                      uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgress
                                    downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                                             success:(void (^)(NSURLSessionDataTask *, id))success
                                             failure:(void (^)(NSURLSessionDataTask *, NSError *, id))failure
{
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:&serializationError];
    if (serializationError) {
        if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError, nil);
            });
#pragma clang diagnostic pop
        }
        
        return nil;
    }
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self dataTaskWithRequest:request
                          uploadProgress:uploadProgress
                        downloadProgress:downloadProgress
                       completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
                           if (error) {
                               if (failure) {
                                   failure(dataTask, error, responseObject);
                               }
                           } else {
                               if (success) {
                                   success(dataTask, responseObject);
                               }
                           }
                       }];
    
    return dataTask;
}




@end

//NS_ASSUME_NONNULL_BEGIN



