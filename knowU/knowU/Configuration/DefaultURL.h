//
//  DefaultURL.h
//  knowU
//
//  Created by HanJiatong on 15/5/8.
//  Copyright (c) 2015年 HanJiatong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DefaultURL : NSObject

/** 注册*/
@property (nonatomic, copy, readonly) NSString *registerURL;

/** 登录*/
@property (nonatomic, copy, readonly) NSString *loginURL;

/** 填写用户资料*/
@property (nonatomic, copy, readonly) NSString *fillInUserInfoURL;

/** 轨迹信息*/
@property (nonatomic, copy, readonly) NSString *traceInfoURL;

/** 登录天数*/
@property (nonatomic, copy, readonly) NSString *loginDayURL;

/** 宠物类型*/
@property (nonatomic, copy, readonly) NSString *petTypeURL;

+ (instancetype)manager;

@end
