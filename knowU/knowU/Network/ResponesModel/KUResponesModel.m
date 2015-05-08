//
//  KUResponesModel.m
//  knowU
//
//  Created by HanJiatong on 15/5/8.
//  Copyright (c) 2015年 HanJiatong. All rights reserved.
//

#import "KUResponesModel.h"

@implementation KUResponesModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"code"    : @"code",
             @"message" : @"message",
             @"success" : @"success"};
}

@end
