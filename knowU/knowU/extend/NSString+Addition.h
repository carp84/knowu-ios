//
//  NSString+Addition.h
//  knowU
//
//  Created by HanJiatong on 15/5/8.
//  Copyright (c) 2015年 HanJiatong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Addition)

-(NSString *)MD5;

/** string转utf8*/
- (NSString *)UTF8Encode;

/** 验证是否为有效电话*/
- (BOOL) validateCell;

/** 验证是否为有效邮箱*/
- (BOOL) validateEmail;

@end
