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
@interface KUHTTPDataSource : NSObject

+ (instancetype)manager;

/** GET*/
- (AFHTTPRequestOperation *)HTTPGET:(NSString *)URLString
                         parameters:(id)parameters
                         modelClass:(Class)modelClass
                            success:(void (^)(AFHTTPRequestOperation *, KUBaseModel *))successBlock
                            failure:(void (^)(NSError *error))failureBlock;

/** POST no image*/
- (AFHTTPRequestOperation *)HTTPPOST:(NSString *)URLString
                          parameters:(id)parameters
                          modelClass:(Class)modelClass
                             success:(void (^)(AFHTTPRequestOperation *, KUBaseModel *))successBlock
                             failure:(void (^)(NSError *error))failureBlock;


/** POST have image*/
- (AFHTTPRequestOperation *)HTTPPOSTWithImage:(NSString *)URLString
                                   parameters:(id)parameters
                                        image:(UIImage *)image
                                     fileName:(NSString *)fileName
                                         type:(NSString *)type
                                   modelClass:(Class)modelClass
                                      success:(void (^)(AFHTTPRequestOperation *, KUBaseModel *))successBlock
                                      failure:(void (^)(NSError *error))failureBlock;

/** PUT*/
- (AFHTTPRequestOperation *)HTTPPUT:(NSString *)URLString
                         parameters:(id)parameters
                         modelClass:(Class)modelClass
                            success:(void (^)(AFHTTPRequestOperation *, KUBaseModel *))successBlock
                            failure:(void (^)(NSError *error))failureBlock;

@end
