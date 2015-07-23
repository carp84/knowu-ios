//
//  NSString+Addition.m
//  knowU
//
//  Created by HanJiatong on 15/5/8.
//  Copyright (c) 2015年 HanJiatong. All rights reserved.
//

#import "NSString+Addition.h"
#import <CommonCrypto/CommonHMAC.h>

@implementation NSString (Addition)

-(NSString *)MD5
{
    const char *cStr = [self UTF8String];
    unsigned char result[32];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],result[8], result[9], result[10], result[11],result[12], result[13], result[14], result[15]];
}

- (NSString *)UTF8Encode {
    
    return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)self, (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]", NULL,  kCFStringEncodingUTF8));
}

- (BOOL) validateCell
{
    NSString *cellRegex = @"^1\\d{10}$";
    NSPredicate *cellTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", cellRegex];
    return [cellTest evaluateWithObject:self];
}

#pragma mark- 验证是否为正确邮箱地址
- (BOOL) validateEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:self];
}

/** 验证用户名*/
- (BOOL) validateUserName{
    NSString *emailRegex = @"^[0-9a-zA-Z_]+$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:self];
}


@end
