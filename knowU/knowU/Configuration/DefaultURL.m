//
//  DefaultURL.m
//  knowU
//
//  Created by HanJiatong on 15/5/8.
//  Copyright (c) 2015年 HanJiatong. All rights reserved.
//

#import "DefaultURL.h"

static DefaultURL *url;

@interface DefaultURL ()

@property (nonatomic, copy) NSString *baseURL;

@end

@implementation DefaultURL

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        url = [[DefaultURL alloc] init];
    });
    return url;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.baseURL = @"http://123.57.226.226:8080/knowu/core/";
        
        _registerURL = [self baseURLWithPath:@"registerUser"];
        _loginURL = [self baseURLWithPath:@"login"];
        _fillInUserInfoURL = [self baseURLWithPath:@"completeUserInfo"];
        _traceInfoURL = [self baseURLWithPath:@"uploadTrace"];
        _loginDayURL = [self baseURLWithPath:@"getLoginDays"];
        _petTypeURL = [self baseURLWithPath:@"getPetType"];
    }
    return self;
}

- (NSString *)baseURLWithPath:(NSString *)path {
    return [self.baseURL stringByAppendingString:path];
}

@end
