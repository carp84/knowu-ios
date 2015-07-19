//
//  KUHTTPClient.m
//  knowU
//
//  Created by HanJiatong on 15/5/8.
//  Copyright (c) 2015年 HanJiatong. All rights reserved.
//

#import "KUHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "KUHTTPDataSource.h"
#import "DefaultURL.h"
#import "NSString+Addition.h"
#import "KULoginDayModel.h"
#import "KUPetTypeModel.h"

static KUHTTPClient *client;

@interface KUHTTPClient () {
    KUHTTPDataSource *dataSource;
}

@end

@implementation KUHTTPClient

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[KUHTTPClient alloc] init];
    });
    return client;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        dataSource = [[KUHTTPDataSource alloc] init];
    }
    return self;
}

#pragma mark- 合并基本的URL
- (NSString *)URLWithPath:(NSString *)url path:(NSString *)path {
    return [url stringByAppendingPathComponent:path];
}

/**
 *
 *  注册
 *
 *  @param mail 邮箱地址
 *  @param password 密码
 *  @param success    success description
 *  @param failure    failure description
 *
 *  @return return value description
 */

- (AFHTTPRequestOperation *)registerWithUID:(NSString *)UID
                                       mail:(NSString *)mail
                                   password:(NSString *)password
                                    success:(KUSuccessBlock)success
                                    failure:(KUFailureBlock)failure{
    
//    [[dictionary objectForKey:@"url"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
//    NSString *url = [self URLWithPath:[DefaultURL manager].registerURL path:[NSString stringWithFormat:@"?userId=%@&emailAddress=%@&password=%@", [UID UTF8Encode], [mail UTF8Encode], [password MD5]]];
    return [dataSource POSTClient:[DefaultURL manager].registerURL
                       parameters:@{@"userId" : UID,
                                    @"emailAddress" : mail,
                                    @"password" : [password MD5]}
                       modelClass:[KUBaseModel class]
                          success:success failure:failure];
}

/**
 *
 *  登录
 *
 *  @param UID 用户id
 *  @param password 密码
 *  @param success    success description
 *  @param failure    failure description
 *
 *  @return return value description
 */

- (AFHTTPRequestOperation *)loginWithUID:(NSString *)UID
                                password:(NSString *)password
                                 success:(KUSuccessBlock)success
                                 failure:(KUFailureBlock)failure {
//    NSString *url = [self URLWithPath:[DefaultURL manager].loginURL path:[NSString stringWithFormat:@"?userId=%@&password=%@",[UID UTF8Encode], [password MD5]]];
    
    return [dataSource POSTClient:[DefaultURL manager].loginURL
                      parameters:@{@"userId" : UID,
                                   @"password" : [password MD5]}
                       modelClass:[KUBaseModel class]
                          success:success failure:failure];
}

/**
 *
 *  填写用户信息
 *
 *  @param UID 用户id
 *  @param password 密码
 *  @param userInfo 用户资料
 *  @param success    success description
 *  @param failure    failure description
 *
 *  @return return value description
 */

- (AFHTTPRequestOperation *)fillUserInfoWithUID:(NSString *)UID
                                       password:(NSString *)password
                                       userInfo:(NSDictionary *)userInfo
                                        success:(KUSuccessBlock)success
                                        failure:(KUFailureBlock)failure {
    NSString *url = [self URLWithPath:[DefaultURL manager].fillInUserInfoURL path:[NSString stringWithFormat:@"?userId=%@&password=%@",[UID UTF8Encode], [password MD5]]];
    
    return [dataSource POSTClient:url
                       parameters:userInfo
                       modelClass:[KUBaseModel class]
                          success:success failure:failure];
    
}

/**
 *
 *  上传用户轨迹
 *
 *  @param UID 用户id
 *  @param traceInfo 轨迹信息
 *  @param success    success description
 *  @param failure    failure description
 *
 *  @return return value description
 */

- (AFHTTPRequestOperation *)uploadTraceWithUID:(NSString *)UID
                                     traceInfo:(NSDictionary *)traceInfo
                                       success:(KUSuccessBlock)success
                                       failure:(KUFailureBlock)failure {
    NSString *url = [self URLWithPath:[DefaultURL manager].traceInfoURL path:[NSString stringWithFormat:@"?userId=%@",[UID UTF8Encode]]];
    
    return [dataSource POSTClient:url
                       parameters:traceInfo
                       modelClass:[KUBaseModel class]
                          success:success failure:failure];
    
}

/**
 *
 *  获取已登录天数
 *
 *  @param UID 用户id
 *  @param traceInfo 轨迹信息
 *  @param success    success description
 *  @param failure    failure description
 *
 *  @return return value description
 */

- (AFHTTPRequestOperation *)loginDayWithUID:(NSString *)UID
                                    success:(KUSuccessBlock)success
                                    failure:(KUFailureBlock)failure{
    NSString *url = [self URLWithPath:[DefaultURL manager].loginDayURL path:[NSString stringWithFormat:@"?userId=%@",[UID UTF8Encode]]];
    
    return [dataSource GETClient:url
                      parameters:nil
                      modelClass:[KULoginDayModel class]
                         success:success failure:failure];
}

/**
 *
 *  获取宠物类型
 *
 *  @param UID 用户id
 *  @param success    success description
 *  @param failure    failure description
 *
 *  @return return value description
 */

- (AFHTTPRequestOperation *)petTypeWithUID:(NSString *)UID
                                   success:(KUSuccessBlock)success
                                   failure:(KUFailureBlock)failure{
    NSString *url = [self URLWithPath:[DefaultURL manager].petTypeURL path:[NSString stringWithFormat:@"?userId=%@",[UID UTF8Encode]]];
    
    return [dataSource GETClient:url
                      parameters:nil
                      modelClass:[KUPetTypeModel class]
                         success:success failure:failure];
}

@end
