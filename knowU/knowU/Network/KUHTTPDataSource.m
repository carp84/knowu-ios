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
#import "NSString+Addition.h"
#import "CONSTS.h"
#import "KUBaseModel.h"

static const int successCode = 200;

//先判断success，再查看错误码；可以认为只有success的时候才会返回200，其他都是错误码

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
        self.operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
//        self.operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        [self.operationManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
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
    WEAKSELF;
    return [self.operationManager GET:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [weakSelf parseSuccessResponse:responseObject operation:operation modelClass:modelClass success:success failure:failure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        KUBaseModel *baseModel = [[KUBaseModel alloc] initWithCode:error.code message:error.localizedFailureReason success:0];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (failure) {
                failure(operation, baseModel);
            }
        });
    }];
}

#pragma mark- POST no image
- (AFHTTPRequestOperation *)POSTClient:(NSString *)URLString
                            parameters:(id)parameters
                            modelClass:(Class)modelClass
                               success:(KUSuccessBlock)success
                               failure:(KUFailureBlock)failure{
    WEAKSELF;
    return [self.operationManager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [weakSelf parseSuccessResponse:responseObject operation:operation modelClass:modelClass success:success failure:failure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        KUBaseModel *baseModel = [[KUBaseModel alloc] initWithCode:error.code message:error.description success:0];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (failure) {
                failure(operation, baseModel);
            }
        });
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
    WEAKSELF;
    return [self.operationManager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 1.0) name:@"pic" fileName:fileName mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [weakSelf parseSuccessResponse:responseObject operation:operation modelClass:modelClass success:success failure:failure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        KUBaseModel *baseModel = [[KUBaseModel alloc] initWithCode:error.code message:error.localizedFailureReason success:0];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (failure) {
                failure(operation, baseModel);
            }
        });
    }];
}

#pragma mark- PUT
- (AFHTTPRequestOperation *)PUTClient:(NSString *)URLString
                           parameters:(id)parameters
                           modelClass:(Class)modelClass
                              success:(KUSuccessBlock)success
                              failure:(KUFailureBlock)failure{
    WEAKSELF;
    return [self.operationManager PUT:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [weakSelf parseSuccessResponse:responseObject operation:operation modelClass:modelClass success:success failure:failure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        KUBaseModel *baseModel = [[KUBaseModel alloc] initWithCode:error.code message:error.localizedFailureReason success:0];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (failure) {
                failure(operation, baseModel);
            }
        });
    }];
}

-(void)parseSuccessResponse:(id)responseObject
                  operation:(AFHTTPRequestOperation *)operation
                 modelClass:(Class)modelClass
                    success:(KUSuccessBlock)success
                    failure:(KUFailureBlock)failure {
    if ([self isRequestOperationValid:responseObject]) {
        KUBaseModel *baseModel = [MTLJSONAdapter modelOfClass:modelClass
                                                   fromJSONDictionary:responseObject error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (baseModel) {
                if (success) {
                    success(operation, baseModel);
                }
            }
            else {
                if (failure) {
                    failure(operation, baseModel);
                }
            }
        });
    }
    else {
        KUBaseModel *baseModel = [[KUBaseModel alloc] initWithCode:[responseObject[@"code"] intValue] message:responseObject[@"message"] success:[responseObject[@"success"] intValue]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (failure) {
                failure(operation, baseModel);
            }
        });
       
    }
}

#pragma mark - Internal helpers
- (BOOL)isRequestOperationValid:(id)responseObject {
    
    if (1 == [responseObject[@"success"] intValue] && successCode == [responseObject[@"code"] intValue]) {
        return YES;
    }
    return NO;
}

@end
