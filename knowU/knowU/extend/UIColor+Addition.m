//
//  UIColor+Addition.m
//  knowU
//
//  Created by HanJiatong on 15/5/15.
//  Copyright (c) 2015年 HanJiatong. All rights reserved.
//

#import "UIColor+Addition.h"

@implementation UIColor (Addition)

+ (UIColor *)homepageGrayLine{
    return [self ColorFromRGB:0x227397 alpha:0.65];
}

+ (UIColor *)ColorFromRGB:(int)rgbValue alpha:(CGFloat)alpha{
    return [UIColor colorWithRed:((float)((rgbValue&0xFF0000)>>16))/255.0 green:((float)((rgbValue&0xFF00)>>8))/255.0 blue:((float)(rgbValue&0xFF))/255.0 alpha:alpha];
}

@end
