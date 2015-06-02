//
//  KUHTTPClient.h
//  knowU
//
//  Created by HanJiatong on 15/5/8.
//  Copyright (c) 2015年 HanJiatong. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AFHTTPRequestOperation;

@class KUBaseModel;

typedef void (^KUSuccessBlock)(AFHTTPRequestOperation *operation, KUBaseModel *model);
typedef void (^KUFailureBlock)(AFHTTPRequestOperation *operation, KUBaseModel *model);

@interface KUHTTPClient : NSObject

+ (instancetype)manager;

/**
 *
 *  注册
 *
 *  @param UID 用户id
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
                                    failure:(KUFailureBlock)failure;

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
                                failure:(KUFailureBlock)failure;

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
                                     failure:(KUFailureBlock)failure;

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
                                       failure:(KUFailureBlock)failure;

/**
 *
 *  获取已登录天数
 *
 *  @param UID 用户id
 *  @param success    success description
 *  @param failure    failure description
 *
 *  @return return value description
 */

- (AFHTTPRequestOperation *)loginDayWithUID:(NSString *)UID
                                    success:(KUSuccessBlock)success
                                    failure:(KUFailureBlock)failure;

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
                                   failure:(KUFailureBlock)failure;

@end
