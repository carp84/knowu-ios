//
//  NSDate+Addition.m
//  knowU
//
//  Created by HanJiatong on 15/5/16.
//  Copyright (c) 2015年 HanJiatong. All rights reserved.
//

#import "NSDate+Addition.h"

@implementation NSDate (Addition)

- (NSString *)convertString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    return [dateFormatter stringFromDate:self];
}


@end
