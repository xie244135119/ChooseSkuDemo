//
//  AFHTTPSessionManager+NSHttpCategory.h
//  AMDNetworkService
//
//  Created by SunSet on 2017/7/25.
//  Copyright © 2017年 SunSet. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@interface AFHTTPSessionManager (NSHttpCategory)



- (nullable NSURLSessionDataTask *)GET_AMD:(NSString *)URLString
                                parameters:(nullable id)parameters
                                   success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                   failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error, id responseObject))failure;


- (nullable NSURLSessionDataTask *)POST_AMD:(NSString *)URLString
                                 parameters:(nullable id)parameters
                                    success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                    failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error, id responseObject))failure;

- (nullable NSURLSessionDataTask *)PUT_AMD:(NSString *)URLString
                                parameters:(nullable id)parameters
                                   success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                   failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error, id))failure;

- (nullable NSURLSessionDataTask *)DELETE_AMD:(NSString *)URLString
                                   parameters:(nullable id)parameters
                                      success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                      failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error, id responseObject))failure;



@end



NS_ASSUME_NONNULL_END










