//
//  KUHTTPDataSource.h
//  knowU
//
//  Created by HanJiatong on 15/4/26.
//  Copyright (c) 2015年 HanJiatong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class AFHTTPRequestOperation;
@class KUBaseModel;

typedef void (^KUSuccessBlock)(AFHTTPRequestOperation *operation, KUBaseModel *model);
typedef void (^KUFailureBlock)(AFHTTPRequestOperation *operation, KUBaseModel *model);

@interface KUHTTPDataSource : NSObject

+ (instancetype)manager;

/**
 *  GET
 *
 *  @param URLString  URL
 *  @param parameters parameters description
 *  @param modelClass 期望返回的response 类型，当response期望为nil的时候，需要给basemodel值
 *  @param success    success description
 *  @param failure    failure description
 *
 *  @return return value description
 */

- (AFHTTPRequestOperation *)GETClient:(NSString *)URLString
                           parameters:(id)parameters
                           modelClass:(Class)modelClass
                              success:(KUSuccessBlock)success
                              failure:(KUFailureBlock)failure;

/**
 *  POST no image
 *
 *  @param URLString  URL
 *  @param parameters parameters description
 *  @param modelClass 期望返回的response 类型，当response期望为nil的时候，需要给basemodel值
 *  @param success    success description
 *  @param failure    failure description
 *
 *  @return return value description
 */

- (AFHTTPRequestOperation *)POSTClient:(NSString *)URLString
                            parameters:(id)parameters
                            modelClass:(Class)modelClass
                               success:(KUSuccessBlock)success
                               failure:(KUFailureBlock)failureBlock;

/**
 *  POST have image
 *
 *  @param URLString  URL
 *  @param parameters parameters description
 *  @param image      上传的图片
 *  @param fileName   图片保存在服务器上的名称
 *  @param modelClass 期望返回的response 类型，当response期望为nil的时候，需要给basemodel值
 *  @param success    success description
 *  @param failure    failure description
 *
 *  @return return value description
 */

- (AFHTTPRequestOperation *)POSTClientWithImage:(NSString *)URLString
                                     parameters:(id)parameters
                                          image:(UIImage *)image
                                       fileName:(NSString *)fileName
                                     modelClass:(Class)modelClass
                                        success:(KUSuccessBlock)success
                                        failure:(KUFailureBlock)failureBlock;

/**
 *  PUT
 *
 *  @param URLString  URL
 *  @param parameters parameters description
 *  @param modelClass 期望返回的response 类型，当response期望为nil的时候，需要给basemodel值
 *  @param success    success description
 *  @param failure    failure description
 *
 *  @return return value description
 */

- (AFHTTPRequestOperation *)PUTClient:(NSString *)URLString
                         parameters:(id)parameters
                         modelClass:(Class)modelClass
                            success:(KUSuccessBlock)success
                            failure:(KUFailureBlock)failureBlock;

@end
