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
    return  @{};
//    return @{@"code"    : @"code",
//             @"message" : @"message",
//             @"success" : @"success"};
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
    return [NSValueTransformer valueTransformerForName:key];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _code= 200;
        _message = nil;
        _success = 1;
    }
    return self;
}

- (instancetype)initWithCode:(int)code
                          message:(NSString *)message
                          success:(int)success
{
    self = [super init];
    if (self) {
        _code = code;
        _message = message;
        _success = success;
    }
    return self;
}


@end
