//
//  UIColor+Addition.m
//  knowU
//
//  Created by HanJiatong on 15/5/15.
//  Copyright (c) 2015年 HanJiatong. All rights reserved.
//

#import "UIColor+Addition.h"

#define UIColorFromRGB(rgbValue)[UIColor colorWithRed:((float)((rgbValue&0xFF0000)>>16))/255.0 green:((float)((rgbValue&0xFF00)>>8))/255.0 blue:((float)(rgbValue&0xFF))/255.0 alpha:1.0]

#define UIColorFromRGBA(rgbValue, alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 blue:((float)(rgbValue & 0x0000FF))/255.0 alpha:alphaValue]

@implementation UIColor (Addition)

+ (UIColor *)homepageGrayLine{
    return UIColorFromRGBA(0x227397, 0.65);
}

+ (UIColor *)colorFromRGB:(int)rgbValue alpha:(CGFloat)alpha{
    return UIColorFromRGBA(rgbValue, alpha);
}

+ (UIColor *)placeholderColor {
    return UIColorFromRGB(0xc0d5dd);
}

@end
