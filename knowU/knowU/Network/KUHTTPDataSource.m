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

static const NSTimeInterval TIME_OUT_INTERVAL = 60;
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
- (AFHTTPRequestOperation *)HTTPGET:(NSString *)URLString
                     parameters:(id)parameters
                     modelClass:(Class)modelClass
                        success:(void (^)(AFHTTPRequestOperation *, KUBaseModel *))successBlock
                        failure:(void (^)(NSError *error))failureBlock{
    return [self.operationManager GET:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        KUBaseModel *model = [MTLJSONAdapter modelOfClass:modelClass
                                       fromJSONDictionary:responseObject[@"data"] error:nil];
        if (successBlock) {
            successBlock(operation, model);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

#pragma mark- POST no image
- (AFHTTPRequestOperation *)HTTPPOST:(NSString *)URLString
                      parameters:(id)parameters
                      modelClass:(Class)modelClass
                         success:(void (^)(AFHTTPRequestOperation *, KUBaseModel *))successBlock
                         failure:(void (^)(NSError *error))failureBlock{
    return [self.operationManager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        KUBaseModel *model = [MTLJSONAdapter modelOfClass:modelClass
                                       fromJSONDictionary:responseObject[@"data"] error:nil];
        if (successBlock) {
            successBlock(operation, model);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

#pragma mark- POST image
- (AFHTTPRequestOperation *)HTTPPOSTWithImage:(NSString *)URLString
                               parameters:(id)parameters
                                    image:(UIImage *)image
                                 fileName:(NSString *)fileName
                                     type:(NSString *)type
                               modelClass:(Class)modelClass
                                  success:(void (^)(AFHTTPRequestOperation *, KUBaseModel *))successBlock
                                  failure:(void (^)(NSError *error))failureBlock{
    return [self.operationManager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 1.0) name:@"pic" fileName:fileName mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        KUBaseModel *model = [MTLJSONAdapter modelOfClass:modelClass
                                       fromJSONDictionary:responseObject[@"data"] error:nil];
        if (successBlock) {
            successBlock(operation, model);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

#pragma mark- PUT
- (AFHTTPRequestOperation *)HTTPPUT:(NSString *)URLString
                     parameters:(id)parameters
                     modelClass:(Class)modelClass
                        success:(void (^)(AFHTTPRequestOperation *, KUBaseModel *))successBlock
                        failure:(void (^)(NSError *error))failureBlock{
    return [self.operationManager PUT:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        KUBaseModel *model = [MTLJSONAdapter modelOfClass:modelClass
                                       fromJSONDictionary:responseObject[@"data"] error:nil];
        if (successBlock) {
            successBlock(operation, model);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}
@end
