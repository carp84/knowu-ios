//
//  KUHTTPDataSource.m
//  knowU
//
//  Created by HanJiatong on 15/4/26.
//  Copyright (c) 2015年 HanJiatong. All rights reserved.
//

#import "KUHTTPDataSource.h"
#import <AFHTTPRequestOperationManager.h>
#import "KUBaseModel.h"
#import "MTLJSONAdapter.h"
#import "NSString+UTF8.h"
#import "CONSTS.h"

static const NSInteger MAX_CONCURRENT_HTTP_REQUEST_COUNT = 3;

static KUHTTPDataSource *httpDataSource;

@interface KUHTTPDataSource ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *operationManager;

@end

@implementation KUHTTPDataSource

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpDataSource = [[KUHTTPDataSource alloc] init];
    });
    return httpDataSource;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.operationManager = [AFHTTPRequestOperationManager manager];
        [self.operationManager.operationQueue setMaxConcurrentOperationCount:MAX_CONCURRENT_HTTP_REQUEST_COUNT];
        self.operationManager.completionQueue = dispatch_queue_create("afmanager.completion.queue", DISPATCH_QUEUE_SERIAL);
        [self.operationManager.requestSerializer setTimeoutInterval:TIME_OUT_INTERVAL];
    }
    return self;
}

- (void)uploadLocationInfo
{
    
}

#pragma mark- GET
- (AFHTTPRequestOperation *)GETClient:(NSString *)URLString
                           parameters:(id)parameters
                           modelClass:(Class)modelClass
                              success:(KUSuccessBlock)success
                              failure:(KUFailureBlock)failure{
    return [self.operationManager GET:[URLString UTF8Encode] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        KUBaseModel *model = [MTLJSONAdapter modelOfClass:modelClass
                                       fromJSONDictionary:responseObject[@"data"] error:nil];
        if (success) {
            success(operation, model);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

#pragma mark- POST no image
- (AFHTTPRequestOperation *)POSTClient:(NSString *)URLString
                            parameters:(id)parameters
                            modelClass:(Class)modelClass
                               success:(KUSuccessBlock)success
                               failure:(KUFailureBlock)failure{
    return [self.operationManager POST:[URLString UTF8Encode] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        KUBaseModel *model = [MTLJSONAdapter modelOfClass:modelClass
                                       fromJSONDictionary:responseObject[@"data"] error:nil];
        if (success) {
            success(operation, model);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

#pragma mark- POST image
- (AFHTTPRequestOperation *)POSTClientWithImage:(NSString *)URLString
                                     parameters:(id)parameters
                                          image:(UIImage *)image
                                       fileName:(NSString *)fileName
                                     modelClass:(Class)modelClass
                                        success:(KUSuccessBlock)success
                                        failure:(KUFailureBlock)failure{
    return [self.operationManager POST:[URLString UTF8Encode] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 1.0) name:@"pic" fileName:fileName mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        KUBaseModel *model = [MTLJSONAdapter modelOfClass:modelClass
                                       fromJSONDictionary:responseObject[@"data"] error:nil];
        if (success) {
            success(operation, model);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

#pragma mark- PUT
- (AFHTTPRequestOperation *)PUTClient:(NSString *)URLString
                           parameters:(id)parameters
                           modelClass:(Class)modelClass
                              success:(KUSuccessBlock)success
                              failure:(KUFailureBlock)failure{
    return [self.operationManager PUT:[URLString UTF8Encode] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        KUBaseModel *model = [MTLJSONAdapter modelOfClass:modelClass
                                       fromJSONDictionary:responseObject[@"data"] error:nil];
        if (success) {
            success(operation, model);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}
@end
