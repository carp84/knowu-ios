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
    return @{@"code"    : @"code",
             @"message" : @"message",
             @"success" : @"success"};
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
    return [NSValueTransformer valueTransformerForName:key];
}

@end
