//
//  NSString+UTF8.m
//  knowU
//
//  Created by HanJiatong on 15/4/28.
//  Copyright (c) 2015年 HanJiatong. All rights reserved.
//

#import "NSString+UTF8.h"

@implementation NSString (UTF8)

- (NSString *)UTF8Encode {
    
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)self, (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]", NULL,  kCFStringEncodingUTF8));
}

@end
