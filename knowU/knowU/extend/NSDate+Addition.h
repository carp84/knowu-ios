//
//  NSDate+Addition.h
//  knowU
//
//  Created by HanJiatong on 15/5/16.
//  Copyright (c) 2015年 HanJiatong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Addition)

- (NSString *)convertStringWithFormat:(NSString *)format;

+ (BOOL)dateIsYesterdayWithInterval:(NSTimeInterval)interval;

- (NSInteger)weekdayWithDate;

/** 是否可以上传数据*/
- (BOOL)isCanUpdate:(NSDate *)date;
@end
