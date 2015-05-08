//
//  KUBaseModel.m
//  knowU
//
//  Created by HanJiatong on 15/4/27.
//  Copyright (c) 2015年 HanJiatong. All rights reserved.
//

#import "KUBaseModel.h"

@implementation KUBaseModel

/**
 *  子类必须重写该方法。
 */
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{};
}

- (instancetype)initWithSuccess:(BOOL)success
                        message:(NSString *)message {
    self = [super init];
    if (self) {
        _success = success;
        _message = message;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _success = YES;
        _message = nil;
    }
    return self;
}

@end
